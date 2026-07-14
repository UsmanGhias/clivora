-- PR-04-C/D: realtime ACL, chat attachment privacy, Connect-aware messaging helpers

-- ——— 1) Chat attachments: private + participant-scoped read ———
update storage.buckets
set public = false
where id = 'chat-attachments';

drop policy if exists "chat_attachments_public_read" on storage.objects;
drop policy if exists chat_attachments_public_read on storage.objects;
drop policy if exists "chat_attachments_auth_read" on storage.objects;
drop policy if exists chat_attachments_auth_read on storage.objects;
drop policy if exists "chat_attachments_participant_read" on storage.objects;
drop policy if exists chat_attachments_participant_read on storage.objects;

create policy chat_attachments_participant_read
  on storage.objects for select to authenticated
  using (
    bucket_id = 'chat-attachments'
    and (
      (storage.foldername(name))[1] = auth.uid()::text
      or exists (
        select 1
        from public.client_messages cm
        where (
          (cm.from_uid = auth.uid() and cm.to_uid::text = (storage.foldername(name))[1])
          or (cm.to_uid = auth.uid() and cm.from_uid::text = (storage.foldername(name))[1])
          or (
            lower(cm.to_email) = lower(public.my_email())
            and cm.from_uid::text = (storage.foldername(name))[1]
          )
        )
      )
    )
  );

-- Reassert write policies (own folder only)
drop policy if exists "chat_attachments_auth_insert" on storage.objects;
drop policy if exists chat_attachments_auth_insert on storage.objects;
create policy chat_attachments_auth_insert
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'chat-attachments'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "chat_attachments_auth_update" on storage.objects;
drop policy if exists chat_attachments_auth_update on storage.objects;
create policy chat_attachments_auth_update
  on storage.objects for update to authenticated
  using (
    bucket_id = 'chat-attachments'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "chat_attachments_auth_delete" on storage.objects;
drop policy if exists chat_attachments_auth_delete on storage.objects;
create policy chat_attachments_auth_delete
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'chat-attachments'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- ——— 2) Realtime: full replica identity for filtered UPDATE events ———
alter table public.client_messages replica identity full;

-- Ensure publication includes messages
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and tablename = 'client_messages'
  ) then
    execute 'alter publication supabase_realtime add table public.client_messages';
  end if;
exception when others then
  null;
end $$;

-- ——— 3) uid_for_linked_email: include Connect accept / hired proposals ———
create or replace function public.uid_for_linked_email(p_email text)
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select p.id
  from public.profiles p
  where lower(p.email) = lower(trim(p_email))
    and (
      public.is_admin()
      or exists (
        select 1 from public.project_shares ps
        where ps.freelancer_uid = auth.uid()
          and lower(ps.client_email) = lower(trim(p_email))
      )
      or exists (
        select 1 from public.project_shares ps
        where ps.client_uid = auth.uid()
          and lower(ps.freelancer_email) = lower(trim(p_email))
      )
      or exists (
        select 1 from public.invoice_shares inv
        where inv.freelancer_uid = auth.uid()
          and lower(inv.client_email) = lower(trim(p_email))
      )
      or exists (
        select 1 from public.invoice_shares inv
        where inv.client_uid = auth.uid()
          and lower(inv.freelancer_email) = lower(trim(p_email))
      )
      or exists (
        select 1 from public.client_messages m
        where m.from_uid = auth.uid()
          and lower(m.to_email) = lower(trim(p_email))
      )
      or exists (
        select 1 from public.connect_requests r
        where r.status = 'accepted'
          and (
            (r.from_user_id = auth.uid() and r.to_user_id = p.id)
            or (r.to_user_id = auth.uid() and r.from_user_id = p.id)
          )
      )
      or exists (
        select 1 from public.connect_proposals pr
        where pr.status = 'accepted'
          and (
            (pr.from_user_id = auth.uid() and pr.to_user_id = p.id)
            or (pr.to_user_id = auth.uid() and pr.from_user_id = p.id)
          )
      )
    )
  limit 1;
$$;

revoke all on function public.uid_for_linked_email(text) from public;
grant execute on function public.uid_for_linked_email(text) to authenticated;

-- ——— 4) Unread message count (to_uid + to_email) ———
create or replace function public.unread_message_count()
returns integer
language sql
stable
security definer
set search_path = public
as $$
  select count(*)::int
  from public.client_messages
  where coalesce(is_read, false) = false
    and read_at is null
    and from_uid is distinct from auth.uid()
    and (
      to_uid = auth.uid()
      or lower(to_email) = lower(public.my_email())
    );
$$;

revoke all on function public.unread_message_count() from public;
grant execute on function public.unread_message_count() to authenticated;

-- ——— 5) Allowed message peers (emails) for client ACL alignment ———
create or replace function public.message_allowed_peer_emails()
returns table (peer_email text)
language sql
stable
security definer
set search_path = public
as $$
  with peers as (
    select lower(ps.client_email) as email
    from public.project_shares ps
    where ps.freelancer_uid = auth.uid() and coalesce(ps.client_email, '') <> ''
    union
    select lower(ps.freelancer_email)
    from public.project_shares ps
    where ps.client_uid = auth.uid() and coalesce(ps.freelancer_email, '') <> ''
    union
    select lower(inv.client_email)
    from public.invoice_shares inv
    where inv.freelancer_uid = auth.uid() and coalesce(inv.client_email, '') <> ''
    union
    select lower(inv.freelancer_email)
    from public.invoice_shares inv
    where inv.client_uid = auth.uid() and coalesce(inv.freelancer_email, '') <> ''
    union
    select lower(p.email)
    from public.connect_requests r
    join public.profiles p on p.id = case
      when r.from_user_id = auth.uid() then r.to_user_id
      when r.to_user_id = auth.uid() then r.from_user_id
      else null
    end
    where r.status = 'accepted' and coalesce(p.email, '') <> ''
    union
    select lower(p.email)
    from public.connect_proposals pr
    join public.profiles p on p.id = case
      when pr.from_user_id = auth.uid() then pr.to_user_id
      when pr.to_user_id = auth.uid() then pr.from_user_id
      else null
    end
    where pr.status = 'accepted' and coalesce(p.email, '') <> ''
  )
  select distinct email from peers where email is not null and email <> '';
$$;

revoke all on function public.message_allowed_peer_emails() from public;
grant execute on function public.message_allowed_peer_emails() to authenticated;
