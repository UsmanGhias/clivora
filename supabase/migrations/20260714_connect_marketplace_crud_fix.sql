-- PR-04 Connect marketplace CRUD: visibility, hire-from-shortlist, respond request RPC

-- ——— 0) Allow draft / rejected / archived moderation statuses ———
alter table public.connect_need_posts
  drop constraint if exists connect_need_posts_moderation_status_check;
alter table public.connect_need_posts
  add constraint connect_need_posts_moderation_status_check
  check (moderation_status = any (array[
    'pending'::text, 'approved'::text, 'hidden'::text,
    'draft'::text, 'rejected'::text, 'archived'::text
  ]));

alter table public.connect_profiles
  drop constraint if exists connect_profiles_moderation_status_check;
alter table public.connect_profiles
  add constraint connect_profiles_moderation_status_check
  check (moderation_status = any (array[
    'pending'::text, 'approved'::text, 'hidden'::text,
    'draft'::text, 'rejected'::text, 'archived'::text
  ]));

-- ——— 1) Discoverable moderation: approved (+ owner/admin) ———
drop policy if exists connect_needs_select on public.connect_need_posts;
create policy connect_needs_select on public.connect_need_posts
  for select to authenticated using (
    client_user_id = auth.uid()
    or (
      is_open = true
      and moderation_status = 'approved'
      and public.is_pro_plus()
    )
    or public.is_admin()
  );

drop policy if exists connect_profiles_select on public.connect_profiles;
create policy connect_profiles_select on public.connect_profiles
  for select to authenticated using (
    user_id = auth.uid()
    or (
      is_listed = true
      and moderation_status = 'approved'
      and public.is_pro_plus()
    )
    or public.is_admin()
  );

-- Promote listed/open pending rows so marketplace is usable immediately
update public.connect_need_posts
  set moderation_status = 'approved', updated_at = now()
  where is_open = true
    and coalesce(moderation_status, '') = 'pending';

update public.connect_profiles
  set moderation_status = 'approved', updated_at = now()
  where is_listed = true
    and coalesce(moderation_status, '') = 'pending';

-- ——— 2) Publish need: clients + freelancers (1 open), approved ———
create or replace function public.connect_publish_need(
  p_title text, p_summary text, p_skills text[], p_budget_band text)
returns uuid
language plpgsql
security definer
set search_path = public
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
      and coalesce(moderation_status, '') not in ('draft', 'rejected', 'archived', 'hidden');
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

-- ——— 3) Publish profile: keep display_title + approved ———
create or replace function public.connect_publish_profile(
  p_headline text, p_bio text, p_skills text[], p_rate numeric)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare v_id uuid := auth.uid();
begin
  perform public.connect_require_pro_plus();
  if v_id is null or not exists (
    select 1 from public.profiles where id = v_id and account_type = 'freelancer'
  ) then
    raise exception 'ACTION_NOT_ALLOWED';
  end if;
  perform public.connect_spend_credits(
    'publish_profile', 'connect_profile', v_id, 'publish_profile:' || v_id::text
  );
  insert into public.connect_profiles (
    user_id, display_title, headline, bio, skills, rate_band, is_listed, moderation_status
  ) values (
    v_id,
    left(coalesce(p_headline, ''), 200),
    left(coalesce(p_headline, ''), 200),
    coalesce(p_bio, ''),
    coalesce(p_skills, '{}'),
    left(coalesce(p_rate, 0)::text, 80),
    true,
    'approved'
  )
  on conflict (user_id) do update set
    display_title = excluded.display_title,
    headline = excluded.headline,
    bio = excluded.bio,
    skills = excluded.skills,
    rate_band = excluded.rate_band,
    is_listed = true,
    moderation_status = case
      when public.connect_profiles.moderation_status in ('hidden', 'rejected') then 'approved'
      when public.connect_profiles.moderation_status = 'approved'
        then public.connect_profiles.moderation_status
      else 'approved'
    end,
    updated_at = now();
  return v_id;
end;
$$;

-- ——— 4) Hire from pending / shortlisted / viewed ———
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
  if not found
     or v_p.to_user_id <> auth.uid()
     or v_p.status not in ('pending', 'shortlisted', 'viewed') then
    raise exception 'ACTION_NOT_ALLOWED';
  end if;

  update public.connect_proposals
    set status = 'accepted', updated_at = now()
    where id = p_proposal_id;

  select id into v_req
  from public.connect_requests
  where status = 'accepted'
    and (
      (from_user_id = v_p.from_user_id and to_user_id = v_p.to_user_id)
      or (from_user_id = v_p.to_user_id and to_user_id = v_p.from_user_id)
    )
  limit 1;

  if v_req is null then
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
  else
    update public.connect_requests
      set revealed_at = coalesce(revealed_at, now()), updated_at = now()
      where id = v_req;
  end if;

  return v_req;
end;
$$;

-- ——— 5) Accept / decline Connect requests (sets revealed_at) ———
create or replace function public.connect_respond_request(
  p_request_id uuid,
  p_accept boolean
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_req public.connect_requests;
begin
  if auth.uid() is null then
    raise exception 'AUTH_REQUIRED';
  end if;

  select * into v_req
  from public.connect_requests
  where id = p_request_id
  for update;

  if not found or v_req.to_user_id <> auth.uid() or v_req.status <> 'pending' then
    raise exception 'ACTION_NOT_ALLOWED';
  end if;

  if p_accept then
    update public.connect_requests
      set status = 'accepted',
          revealed_at = now(),
          updated_at = now()
      where id = p_request_id;
  else
    update public.connect_requests
      set status = 'declined',
          updated_at = now()
      where id = p_request_id;
  end if;
end;
$$;

revoke all on function public.connect_respond_request(uuid, boolean) from public;
grant execute on function public.connect_respond_request(uuid, boolean) to authenticated;

-- ——— 6) Freelancer withdraw own proposal ———
create or replace function public.connect_withdraw_proposal(p_proposal_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.connect_proposals
    set status = 'withdrawn', updated_at = now()
    where id = p_proposal_id
      and from_user_id = auth.uid()
      and status in ('pending', 'viewed', 'shortlisted');
  if not found then
    raise exception 'ACTION_NOT_ALLOWED';
  end if;
end;
$$;

revoke all on function public.connect_withdraw_proposal(uuid) from public;
grant execute on function public.connect_withdraw_proposal(uuid) to authenticated;

revoke all on function public.connect_accept_proposal(uuid) from public;
revoke all on function public.connect_decline_proposal(uuid) from public;
revoke all on function public.connect_shortlist_proposal(uuid) from public;
grant execute on function public.connect_accept_proposal(uuid) to authenticated;
grant execute on function public.connect_decline_proposal(uuid) to authenticated;
grant execute on function public.connect_shortlist_proposal(uuid) to authenticated;
