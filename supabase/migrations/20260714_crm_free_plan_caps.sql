-- PR-03: Enforce Free plan CRM caps server-side (clients 3, projects 5, invoices/month 10).

create or replace function public.crm_plan_is_paid(p_uid uuid)
returns boolean
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if public.is_admin() then
    return true;
  end if;
  return exists (
    select 1 from public.profiles p
    where p.id = p_uid
      and coalesce(p.subscription_plan, 'free') in ('pro', 'pro_plus')
  );
end;
$$;

create or replace function public.crm_enforce_free_customer_cap()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_count integer;
begin
  if public.crm_plan_is_paid(new.owner_uid) then
    return new;
  end if;
  select count(*) into v_count from public.crm_customers where owner_uid = new.owner_uid;
  if tg_op = 'INSERT' and v_count >= 3 then
    raise exception 'FREE_PLAN_CLIENT_LIMIT';
  end if;
  return new;
end;
$$;

create or replace function public.crm_enforce_free_project_cap()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_count integer;
begin
  if public.crm_plan_is_paid(new.owner_uid) then
    return new;
  end if;
  select count(*) into v_count from public.crm_projects where owner_uid = new.owner_uid;
  if tg_op = 'INSERT' and v_count >= 5 then
    raise exception 'FREE_PLAN_PROJECT_LIMIT';
  end if;
  return new;
end;
$$;

create or replace function public.crm_enforce_free_invoice_cap()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_count integer;
  v_start timestamptz := date_trunc('month', timezone('utc', now())) at time zone 'utc';
  v_end timestamptz := (date_trunc('month', timezone('utc', now())) + interval '1 month') at time zone 'utc';
begin
  if public.crm_plan_is_paid(new.owner_uid) then
    return new;
  end if;
  select count(*) into v_count
  from public.crm_invoices
  where owner_uid = new.owner_uid
    and created_at >= v_start
    and created_at < v_end;
  if tg_op = 'INSERT' and v_count >= 10 then
    raise exception 'FREE_PLAN_INVOICE_LIMIT';
  end if;
  return new;
end;
$$;

drop trigger if exists crm_customers_free_cap on public.crm_customers;
create trigger crm_customers_free_cap
  before insert on public.crm_customers
  for each row execute function public.crm_enforce_free_customer_cap();

drop trigger if exists crm_projects_free_cap on public.crm_projects;
create trigger crm_projects_free_cap
  before insert on public.crm_projects
  for each row execute function public.crm_enforce_free_project_cap();

drop trigger if exists crm_invoices_free_cap on public.crm_invoices;
create trigger crm_invoices_free_cap
  before insert on public.crm_invoices
  for each row execute function public.crm_enforce_free_invoice_cap();
