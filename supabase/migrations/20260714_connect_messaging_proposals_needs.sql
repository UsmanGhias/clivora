-- PR-04 Connect marketplace: messaging after accept, freelancer needs, proposal accept → engagement

-- ——— 1) Peer contact helper (email only after accepted Connect request) ———
create or replace function public.connect_peer_contact(p_peer_id uuid)
returns table (peer_id uuid, email text, name text)
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if auth.uid() is null or p_peer_id is null or p_peer_id = auth.uid() then
    return;
  end if;
  return query
  select p.id, p.email, p.name
  from public.profiles p
  where p.id = p_peer_id
    and exists (
      select 1
      from public.connect_requests r
      where r.status = 'accepted'
        and (
          (r.from_user_id = auth.uid() and r.to_user_id = p_peer_id)
          or (r.to_user_id = auth.uid() and r.from_user_id = p_peer_id)
        )
    );
end;
$$;

revoke all on function public.connect_peer_contact(uuid) from public;
grant execute on function public.connect_peer_contact(uuid) to authenticated;

-- ——— 2) Message link guard: allow messaging after Connect accept / proposal hire ———
create or replace function public.require_message_link()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if public.is_admin() then
    return new;
  end if;

  if exists (
    select 1 from public.project_shares ps
    where (ps.freelancer_uid = new.from_uid and lower(ps.client_email) = lower(new.to_email))
       or (ps.client_uid = new.from_uid and lower(ps.freelancer_email) = lower(new.from_email))
  ) then
    return new;
  end if;

  if exists (
    select 1 from public.client_messages cm
    where (cm.from_uid = new.from_uid and lower(cm.to_email) = lower(new.to_email))
       or (cm.to_uid = new.from_uid and lower(cm.from_email) = lower(new.from_email))
       or (cm.from_uid = new.to_uid and lower(cm.to_email) = lower(new.from_email))
       or (lower(cm.to_email) = lower(new.from_email) and cm.from_uid = new.from_uid)
  ) then
    return new;
  end if;

  if exists (
    select 1 from public.invoice_shares inv
    where (inv.freelancer_uid = new.from_uid and lower(inv.client_email) = lower(new.to_email))
       or (inv.client_uid = new.from_uid and lower(inv.freelancer_email) = lower(new.from_email))
  ) then
    return new;
  end if;

  -- Connect: accepted contact request between parties
  if new.to_uid is not null and exists (
    select 1 from public.connect_requests r
    where r.status = 'accepted'
      and (
        (r.from_user_id = new.from_uid and r.to_user_id = new.to_uid)
        or (r.to_user_id = new.from_uid and r.from_user_id = new.to_uid)
      )
  ) then
    return new;
  end if;

  if exists (
    select 1
    from public.connect_requests r
    join public.profiles p on p.id = case
      when r.from_user_id = new.from_uid then r.to_user_id
      when r.to_user_id = new.from_uid then r.from_user_id
      else null
    end
    where r.status = 'accepted'
      and lower(p.email) = lower(new.to_email)
  ) then
    return new;
  end if;

  -- Hired via proposal acceptance
  if new.to_uid is not null and exists (
    select 1 from public.connect_proposals pr
    where pr.status = 'accepted'
      and (
        (pr.from_user_id = new.from_uid and pr.to_user_id = new.to_uid)
        or (pr.to_user_id = new.from_uid and pr.from_user_id = new.to_uid)
      )
  ) then
    return new;
  end if;

  raise exception 'You can only message linked contacts after Connect accept or a shared project.';
end;
$$;

drop trigger if exists client_messages_link_guard on public.client_messages;
create trigger client_messages_link_guard
  before insert on public.client_messages
  for each row execute function public.require_message_link();

-- Ensure message RLS policies exist
drop policy if exists messages_select on public.client_messages;
create policy messages_select on public.client_messages
  for select to authenticated using (
    public.is_admin()
    or from_uid = auth.uid()
    or to_uid = auth.uid()
    or to_email = public.my_email()
  );

drop policy if exists messages_insert on public.client_messages;
create policy messages_insert on public.client_messages
  for insert to authenticated with check (
    from_uid = auth.uid()
    and (
      public.is_admin()
      or to_uid is not null
      or to_email <> ''
    )
  );

drop policy if exists messages_update on public.client_messages;
create policy messages_update on public.client_messages
  for update to authenticated using (
    public.is_admin()
    or to_uid = auth.uid()
    or to_email = public.my_email()
  );

-- ——— 3) Freelancers may publish one open need (clients unlimited open jobs) ———
create or replace function public.connect_publish_need(
  p_title text, p_summary text, p_skills text[], p_budget_band text)
returns uuid language plpgsql security definer set search_path = public
as $$
declare
  v_id uuid := gen_random_uuid();
  v_type text;
  v_open integer;
begin
  perform public.connect_require_pro_plus();

  select account_type into v_type from public.profiles where id = auth.uid();
  if v_type is null or v_type not in ('client', 'admin', 'freelancer') then
    raise exception 'ACTION_NOT_ALLOWED';
  end if;

  if v_type = 'freelancer' then
    select count(*)::int into v_open
    from public.connect_need_posts
    where client_user_id = auth.uid()
      and is_open = true
      and coalesce(moderation_status, '') not in ('draft', 'rejected', 'archived');
    if v_open >= 1 then
      raise exception 'ACTION_NOT_ALLOWED';
    end if;
  end if;

  perform public.connect_spend_credits('publish_need', 'connect_need', v_id, 'publish_need:' || v_id::text);
  insert into public.connect_need_posts
    (id, client_user_id, title, summary, skills, budget_band, is_open, moderation_status)
  values (
    v_id,
    auth.uid(),
    left(coalesce(p_title, ''), 200),
    coalesce(p_summary, ''),
    coalesce(p_skills, '{}'),
    left(coalesce(p_budget_band, ''), 120),
    true,
    'approved'
  );
  return v_id;
end;
$$;

-- ——— 4) Accept proposal → create engagement request + reveal contacts ———
drop function if exists public.connect_accept_proposal(uuid);

create or replace function public.connect_accept_proposal(p_proposal_id uuid)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_p public.connect_proposals;
  v_req uuid;
begin
  select * into v_p from public.connect_proposals where id = p_proposal_id for update;
  if not found or v_p.to_user_id <> auth.uid() or v_p.status not in ('pending', 'shortlisted', 'viewed') then
    raise exception 'ACTION_NOT_ALLOWED';
  end if;

  update public.connect_proposals
    set status = 'accepted', updated_at = now()
    where id = p_proposal_id;

  -- Create engagement request so messaging + milestones have a parent link
  v_req := gen_random_uuid();
  insert into public.connect_requests
    (id, from_user_id, to_user_id, target_need_id, message, status, revealed_at)
  values (
    v_req,
    v_p.from_user_id,
    v_p.to_user_id,
    v_p.need_id,
    coalesce(v_p.message, 'Hired via proposal'),
    'accepted',
    now()
  );

  return v_req;
end;
$$;

create or replace function public.connect_decline_proposal(p_proposal_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.connect_proposals
    set status = 'declined', updated_at = now()
    where id = p_proposal_id
      and to_user_id = auth.uid()
      and status in ('pending', 'shortlisted', 'viewed');
  if not found then
    raise exception 'ACTION_NOT_ALLOWED';
  end if;
end;
$$;

create or replace function public.connect_shortlist_proposal(p_proposal_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.connect_proposals
    set status = 'shortlisted', updated_at = now()
    where id = p_proposal_id
      and to_user_id = auth.uid()
      and status in ('pending', 'viewed');
  if not found then
    raise exception 'ACTION_NOT_ALLOWED';
  end if;
end;
$$;

revoke all on function public.connect_accept_proposal(uuid) from public;
revoke all on function public.connect_decline_proposal(uuid) from public;
revoke all on function public.connect_shortlist_proposal(uuid) from public;
grant execute on function public.connect_accept_proposal(uuid) to authenticated;
grant execute on function public.connect_decline_proposal(uuid) to authenticated;
grant execute on function public.connect_shortlist_proposal(uuid) to authenticated;

-- ——— 5) Profile publish: keep display_title on conflict ———
create or replace function public.connect_publish_profile(
  p_headline text, p_bio text, p_skills text[], p_rate numeric)
returns uuid language plpgsql security definer set search_path = public
as $$
declare v_id uuid := auth.uid();
begin
  perform public.connect_require_pro_plus();
  if v_id is null or not exists (select 1 from public.profiles where id = v_id and account_type = 'freelancer') then
    raise exception 'ACTION_NOT_ALLOWED';
  end if;
  perform public.connect_spend_credits('publish_profile', 'connect_profile', v_id, 'publish_profile:' || v_id::text);
  insert into public.connect_profiles (user_id, display_title, headline, bio, skills, rate_band, is_listed)
    values (
      v_id,
      left(coalesce(p_headline, ''), 200),
      left(coalesce(p_headline, ''), 200),
      coalesce(p_bio, ''),
      coalesce(p_skills, '{}'),
      left(coalesce(p_rate, 0)::text, 80),
      true
    )
  on conflict (user_id) do update set
    display_title = excluded.display_title,
    headline = excluded.headline,
    bio = excluded.bio,
    skills = excluded.skills,
    rate_band = excluded.rate_band,
    is_listed = true,
    updated_at = now();
  return v_id;
end;
$$;
