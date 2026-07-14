-- Freelancer bank / payout details for direct client→freelancer invoice payments.
-- CLIVORA subscription fee is separate; deal amounts are not escrowed by the platform.

create table if not exists public.freelancer_payout_accounts (
  user_id uuid primary key references auth.users(id) on delete cascade,
  account_name text not null default '',
  bank_name text not null default '',
  account_number text not null default '',
  iban text not null default '',
  swift text not null default '',
  country text not null default 'PK',
  currency text not null default 'USD',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.freelancer_payout_accounts enable row level security;

drop policy if exists freelancer_payout_accounts_owner on public.freelancer_payout_accounts;
create policy freelancer_payout_accounts_owner on public.freelancer_payout_accounts
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
