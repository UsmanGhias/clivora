-- Link CLIVORA CRM customers to Odoo res.partner for two-way sync (Contacts app only).
alter table public.crm_customers
  add column if not exists odoo_partner_id bigint,
  add column if not exists odoo_synced_at timestamptz;

create unique index if not exists crm_customers_odoo_partner_id_uidx
  on public.crm_customers (odoo_partner_id)
  where odoo_partner_id is not null;

create index if not exists crm_customers_odoo_synced_at_idx
  on public.crm_customers (odoo_synced_at desc nulls last);

comment on column public.crm_customers.odoo_partner_id is 'Odoo res.partner id for bidirectional Contacts sync';
comment on column public.crm_customers.odoo_synced_at is 'Last successful Odoo Contacts sync timestamp';
