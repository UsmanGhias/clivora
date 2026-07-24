# Schema drift & reproducibility (DB-001)

**Status:** RESOLVED for SMEMaster phase migrations (2026-07-25 export).

**Source:** Live Supabase project introspected via `user-supabase` MCP
(`information_schema`, `pg_constraint`, `pg_indexes`, `pg_policies`, `pg_get_functiondef`).

## What was wrong

Six committed migrations were **comment-only stubs** — they described SQL applied live
through the Supabase MCP but contained no runnable DDL, so a clean database could not
reproduce production SMEMaster objects.

## Files written (stubs replaced)

| File | Live migration name | Contents |
|------|---------------------|----------|
| `20260724_phase0_foundations.sql` | `phase0_foundations_smemaster_program` | `idempotency_keys`, `audit_events`, `write_audit_event()`, vault tables, `*_minor` columns, queue column/check/index additions, `quote_shares` RLS, phase-0 RLS + flags |
| `20260724_phase1_crm_enrichment.sql` | `phase1_crm_enrichment` | CRM enrichment tables, `crm_customers` additive columns + FKs, `crm_recompute_lead_score()`, RLS, flags |
| `20260724_phases_2_9_program.sql` | `phases_2_9_smemaster_program` | `workspace_tasks`, `calendar_events`, `crm_sync_conflicts`, campaigns stack, `automation_rules`, `ai_suggestions`, `crm_find_duplicate_customers()`, RLS, flags |
| `20260724_automation_queue_rls.sql` | `phase0_queue_rls_owner_policies` | Owner-scoped select/insert/update policies on `automation_webhook_queue` |
| `20260725_protect_profiles_privileged.sql` | `protect_profiles_privileged_columns` | `profiles_protect_privileged_columns()` + `profiles_protect_privileged_columns_trg` |
| `20260725_vault_share_public_lookup.sql` | `vault_share_public_lookup` | `vault_lookup_share_by_token()` + anon/authenticated grants |
| `20260725_invoice_shares_total_minor_dual_write.sql` | `invoice_shares_total_minor_dual_write` | Backfill + trigger syncing `total_minor` from `total`; unique idempotency index on queue |

A consolidated reference also exists at `20260725_smemaster_full_schema.sql`.

## Exported objects (all present live)

### Tables (19)

`idempotency_keys`, `audit_events`, `vault_share_links`, `vault_attachments`,
`crm_companies`, `crm_tags`, `crm_groups`, `crm_customer_tags`, `crm_customer_groups`,
`crm_activities`, `crm_segments`, `workspace_tasks`, `calendar_events`, `crm_sync_conflicts`,
`campaigns`, `campaign_blocks`, `campaign_templates`, `automation_rules`, `ai_suggestions`

### Functions (5)

`write_audit_event`, `crm_recompute_lead_score`, `crm_find_duplicate_customers`,
`profiles_protect_privileged_columns`, `vault_lookup_share_by_token`

### Additive columns

| Table | Columns |
|-------|---------|
| `crm_customers` | `company_id`, `lead_score`, `next_action`, `next_action_at`, `duplicate_of` |
| `crm_invoices` | `subtotal_minor`, `tax_minor`, `discount_minor`, `total_minor`, `amount_paid_minor` |
| `invoice_shares` | `total_minor` |
| `quote_shares` | `total_minor`, `subtotal_minor` |
| `automation_webhook_queue` | `next_attempt_at`, `permanently_failed_at`, `idempotency_key`, `owner_uid` + status check |

### RLS policies (22 policy names)

| Table | Policies |
|-------|----------|
| `idempotency_keys` | `idempotency_keys_owner` |
| `audit_events` | `audit_events_admin_select` |
| `vault_share_links` | `vault_share_owner` |
| `vault_attachments` | `vault_attachments_owner` |
| `crm_companies` | `crm_companies_owner` |
| `crm_tags` | `crm_tags_owner` |
| `crm_groups` | `crm_groups_owner` |
| `crm_customer_tags` | `crm_customer_tags_owner` |
| `crm_customer_groups` | `crm_customer_groups_owner` |
| `crm_activities` | `crm_activities_owner` |
| `crm_segments` | `crm_segments_owner` |
| `workspace_tasks` | `workspace_tasks_owner` |
| `calendar_events` | `calendar_events_owner` |
| `crm_sync_conflicts` | `crm_sync_conflicts_owner` |
| `campaigns` | `campaigns_owner` |
| `campaign_blocks` | `campaign_blocks_owner` |
| `campaign_templates` | `campaign_templates_owner` |
| `automation_rules` | `automation_rules_owner` |
| `ai_suggestions` | `ai_suggestions_owner` |
| `automation_webhook_queue` | `automation_webhook_queue_select`, `_insert`, `_update` |
| `quote_shares` | `quote_shares_select`, `quote_shares_write`, `quote_shares_client_update` |

### Triggers on `profiles`

| Trigger | Function | Exported? |
|---------|----------|-----------|
| `profiles_protect_privileged_columns_trg` | `profiles_protect_privileged_columns()` | **Yes** (SMEMaster migration) |
| `profiles_guard_privileged_columns` | `profiles_guard_privileged_columns()` | No — pre-existing (`20260714115705`) |
| `profiles_lock_account_type` | `lock_profile_account_type()` | No — pre-existing |

### Indexes & constraints

All PK, FK, UNIQUE, CHECK constraints and non-PK indexes for the 19 tables were exported.
Notable partial index: `automation_webhook_queue_idem_uidx` on `(idempotency_key) WHERE idempotency_key IS NOT NULL`.

## Not exported / out of scope

| Object | Reason |
|--------|--------|
| `profiles_guard_privileged_columns` trigger + function | Pre-existing migration `profiles_guard_privileged_columns`; not part of SMEMaster phase export |
| `profiles_lock_account_type` trigger + `lock_profile_account_type()` | Pre-existing; separate concern |
| `app_feature_flags.enabled` live values | Migrations register keys with `enabled = false` only; live enablement (`phase0_foundations=true`, `money_minor_units_dual_write=true`) is runtime state — see `docs/audit/flag-truth.md` |
| `automation_webhook_queue` base table DDL | Created in `20260711_phase2_connect_trust.sql`; phase-0 only adds columns/constraints |
| `write_audit_event` explicit GRANT/REVOKE | Live grants EXECUTE to anon/authenticated/service_role via default; not duplicated in migration |
| `service_role` queue bypass | No client DELETE policy on queue (service role only); matches live |
| Data backfills for `*_minor` columns | Schema-only export; no customer data or conversion logic |
| `flag_001_disable_unverified_domains` migration body | Applied live (`20260724212953`); not part of these six stub files |

## Remaining TODO

- [ ] Run full migration chain against clean local Supabase (`supabase db reset`) and capture schema fingerprint.
- [ ] Diff fingerprint against production; investigate any delta.
- [ ] Add CI drift check comparing repo migrations to live introspection.
- [ ] Test upgrade from last Play/web production baseline (not just clean install).
