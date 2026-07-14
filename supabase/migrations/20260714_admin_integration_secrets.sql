-- Admin-only integration secrets (Odoo, etc.). No public/authenticated RLS policies —
-- access only via SECURITY DEFINER helpers that verify admin role.
create table if not exists public.admin_integration_secrets (
  key text primary key,
  value text not null,
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users (id)
);

alter table public.admin_integration_secrets enable row level security;

-- Intentionally no GRANT/policies for anon/authenticated — service role + definer RPCs only.
revoke all on table public.admin_integration_secrets from anon, authenticated;

create or replace function public.admin_get_integration_secret(p_key text)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v text;
begin
  if auth.uid() is null then
    raise exception 'not authorized';
  end if;
  if not exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and (p.role = 'admin' or p.account_type = 'admin')
      and coalesce(p.is_blocked, false) = false
      and coalesce(p.is_restricted, false) = false
  ) then
    raise exception 'not authorized';
  end if;

  select s.value into v
  from public.admin_integration_secrets s
  where s.key = p_key;

  return v;
end;
$$;

revoke all on function public.admin_get_integration_secret(text) from public;
grant execute on function public.admin_get_integration_secret(text) to authenticated;

create or replace function public.admin_upsert_integration_secret(p_key text, p_value text)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'not authorized';
  end if;
  if not exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and (p.role = 'admin' or p.account_type = 'admin')
      and coalesce(p.is_blocked, false) = false
      and coalesce(p.is_restricted, false) = false
  ) then
    raise exception 'not authorized';
  end if;

  insert into public.admin_integration_secrets (key, value, updated_at, updated_by)
  values (p_key, p_value, now(), auth.uid())
  on conflict (key) do update
    set value = excluded.value,
        updated_at = now(),
        updated_by = excluded.updated_by;
end;
$$;

revoke all on function public.admin_upsert_integration_secret(text, text) from public;
grant execute on function public.admin_upsert_integration_secret(text, text) to authenticated;
