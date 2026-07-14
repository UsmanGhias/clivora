-- QA Bug Wave: cold client invite + chat_blocks RLS

create or replace function public.client_invite_freelancer(
  p_freelancer_email text,
  p_message text default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_from uuid := auth.uid();
  v_from_email text;
  v_from_name text;
  v_to_email text := lower(trim(p_freelancer_email));
  v_to_uid uuid;
  v_body text;
  v_msg_id uuid;
begin
  if v_from is null then
    raise exception 'Sign in required';
  end if;
  if v_to_email is null or position('@' in v_to_email) = 0 then
    raise exception 'Enter a valid freelancer email';
  end if;

  select lower(email), coalesce(nullif(trim(name), ''), split_part(email, '@', 1))
    into v_from_email, v_from_name
  from public.profiles
  where id = v_from;

  if v_from_email is null then
    raise exception 'Profile required';
  end if;
  if v_to_email = v_from_email then
    raise exception 'Enter your freelancer''s email, not your own';
  end if;

  select id into v_to_uid from public.profiles where lower(email) = v_to_email limit 1;

  v_body := coalesce(nullif(trim(p_message), ''),
    format(
      'Hi,%s%s (%s) would like to work with you on CLIVORA.%sPlease share a project with their email so they can view progress, invoices, and messages.%sOpen CLIVORA and share a project using: %s',
      E'\n\n', v_from_name, v_from_email, E'\n\n', E'\n\n', v_from_email
    )
  );

  -- Bypass require_message_link for first-time client→freelancer invite only.
  perform set_config('app.bypass_message_link', '1', true);

  insert into public.client_messages (
    from_uid, to_uid, from_email, to_email, subject, body, is_read
  ) values (
    v_from, v_to_uid, v_from_email, v_to_email,
    format('[Link Request] %s wants to connect', v_from_name),
    v_body,
    false
  )
  returning id into v_msg_id;

  perform set_config('app.bypass_message_link', '0', true);

  if v_to_uid is not null then
    insert into public.notifications (user_uid, from_uid, title, body, kind, is_read)
    values (
      v_to_uid,
      v_from,
      'New client connection request',
      format('%s wants to link with you on CLIVORA', v_from_name),
      'invite',
      false
    );
  end if;

  return jsonb_build_object(
    'ok', true,
    'message_id', v_msg_id,
    'to_uid', v_to_uid,
    'to_email', v_to_email
  );
end;
$$;

revoke all on function public.client_invite_freelancer(text, text) from public;
grant execute on function public.client_invite_freelancer(text, text) to authenticated;

create or replace function public.require_message_link()
returns trigger
language plpgsql
set search_path to 'public'
as $function$
begin
  if current_setting('app.bypass_message_link', true) = '1' then
    return new;
  end if;
  if public.is_admin() then return new; end if;
  if exists (
    select 1 from public.project_shares ps
    where (ps.freelancer_uid = new.from_uid and lower(ps.client_email) = lower(new.to_email))
       or (ps.client_uid = new.from_uid and lower(ps.freelancer_email) = lower(new.from_email))
  ) then return new; end if;
  if exists (
    select 1 from public.client_messages cm
    where (cm.from_uid = new.from_uid and lower(cm.to_email) = lower(new.to_email))
       or (cm.to_uid = new.from_uid and lower(cm.from_email) = lower(new.from_email))
       or (cm.from_uid = new.to_uid and lower(cm.to_email) = lower(new.from_email))
       or (lower(cm.to_email) = lower(new.from_email) and cm.from_uid = new.from_uid)
  ) then return new; end if;
  if exists (
    select 1 from public.invoice_shares inv
    where (inv.freelancer_uid = new.from_uid and lower(inv.client_email) = lower(new.to_email))
       or (inv.client_uid = new.from_uid and lower(inv.freelancer_email) = lower(new.from_email))
  ) then return new; end if;
  if new.to_uid is not null and exists (
    select 1 from public.connect_requests r
    where r.status = 'accepted'
      and ((r.from_user_id = new.from_uid and r.to_user_id = new.to_uid)
        or (r.to_user_id = new.from_uid and r.from_user_id = new.to_uid))
  ) then return new; end if;
  if exists (
    select 1 from public.connect_requests r
    join public.profiles p on p.id = case
      when r.from_user_id = new.from_uid then r.to_user_id
      when r.to_user_id = new.from_uid then r.from_user_id
      else null end
    where r.status = 'accepted' and lower(p.email) = lower(new.to_email)
  ) then return new; end if;
  if new.to_uid is not null and exists (
    select 1 from public.connect_proposals pr
    where pr.status = 'accepted'
      and ((pr.from_user_id = new.from_uid and pr.to_user_id = new.to_uid)
        or (pr.to_user_id = new.from_uid and pr.from_user_id = new.to_uid))
  ) then return new; end if;
  raise exception 'You can only message linked contacts after Connect accept or a shared project.';
end;
$function$;

alter table public.chat_blocks enable row level security;

drop policy if exists chat_blocks_select_own on public.chat_blocks;
create policy chat_blocks_select_own on public.chat_blocks
  for select to authenticated
  using (blocker_uid = auth.uid() or blocked_uid = auth.uid());

drop policy if exists chat_blocks_insert_own on public.chat_blocks;
create policy chat_blocks_insert_own on public.chat_blocks
  for insert to authenticated
  with check (blocker_uid = auth.uid());

drop policy if exists chat_blocks_delete_own on public.chat_blocks;
create policy chat_blocks_delete_own on public.chat_blocks
  for delete to authenticated
  using (blocker_uid = auth.uid());
