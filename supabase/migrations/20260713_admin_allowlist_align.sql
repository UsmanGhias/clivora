-- Align SQL admin allowlist with app admin_config.dart (iusmanghias@gmail.com).
create or replace function public.is_allowlisted_admin(p_email text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select lower(trim(coalesce(p_email, ''))) in (
    'admin@codcrafters.org',
    'usmanghias1@gmail.com',
    'iusmanghias@gmail.com'
  );
$$;
