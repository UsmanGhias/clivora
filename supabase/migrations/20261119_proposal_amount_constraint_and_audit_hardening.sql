-- 20261119_proposal_amount_constraint_and_audit_hardening.sql
-- Schema hardening: Enforce positive proposal bids, full-text job discovery indexing, and event payload validation.

-- 1. Enforce Proposal Amount Integrity
-- Update legacy or zero-bid test entries to 1 USD prior to applying constraint
update public.connect_proposals 
set amount = 1 
where amount <= 0 or amount is null;

do $$
begin
  if not exists (
    select 1 from pg_constraint 
    where conname = 'connect_proposals_positive_amount'
  ) then
    alter table public.connect_proposals 
      add constraint connect_proposals_positive_amount check (amount > 0);
  end if;
end $$;

-- 2. Optimize Job Discovery Layer with GIN Full-Text Search
create index if not exists idx_jobs_active_search 
on public.connect_jobs using gin (to_tsvector('english', title || ' ' || coalesce(description, ''))) 
where is_active = true or status = 'active';

-- 3. Audit Trail Payload Integrity
-- Drop empty events at database level and require valid payload
create or replace function public.reject_empty_events()
returns trigger as $$
begin
  if new.payload is null or trim(new.payload) = '' or new.payload = '{}' then
    return null; -- Silently drop unpopulated empty telemetry events
  end if;
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_reject_empty_events on public.clivora_events;
create trigger trg_reject_empty_events
  before insert on public.clivora_events
  for each row execute function public.reject_empty_events();

-- 4. Invoice Audit Timestamps
alter table public.crm_invoices 
add column if not exists updated_at timestamptz default now();


