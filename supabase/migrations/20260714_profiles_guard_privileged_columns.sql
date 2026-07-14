-- Harden profiles: users must not self-elevate plan or unblock themselves via own-row UPDATE.
-- Additive only — does not edit prior migrations.

create or replace function public.profiles_guard_privileged_columns()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  -- Service role / bypass is not used for client updates; still allow admin role changes via admin tools.
  if tg_op = 'UPDATE' and auth.uid() is not null and auth.uid() = old.id then
    if exists (
      select 1 from public.profiles p
      where p.id = auth.uid()
        and (p.role = 'admin' or p.account_type = 'admin')
    ) then
      return new;
    end if;

    -- Non-admins cannot change billing / restriction / role fields on their own row.
    new.subscription_plan := old.subscription_plan;
    new.is_blocked := old.is_blocked;
    new.is_restricted := old.is_restricted;
    if to_jsonb(new) ? 'role' then
      new.role := old.role;
    end if;
    if to_jsonb(new) ? 'account_type' then
      new.account_type := old.account_type;
    end if;
    if to_jsonb(new) ? 'is_admin' then
      -- keep legacy column immutable for self-updates if present
      begin
        new.is_admin := old.is_admin;
      exception when undefined_column then
        null;
      end;
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists profiles_guard_privileged_columns on public.profiles;
create trigger profiles_guard_privileged_columns
  before update on public.profiles
  for each row
  execute function public.profiles_guard_privileged_columns();
