-- Unique local_id per owner so mobile time sessions upsert cleanly to web.
create unique index if not exists crm_time_entries_owner_local_uidx
  on public.crm_time_entries (owner_uid, local_id)
  where local_id is not null;
