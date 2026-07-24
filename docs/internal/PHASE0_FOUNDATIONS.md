# Phase 0 foundations — contracts & rollback

**Applied:** `phase0_foundations_smemaster_program` (live) + repo stub `20260724_phase0_foundations.sql`

## Implemented

| Item | Detail |
|------|--------|
| `quote_shares` RLS | Select/write/client-update mirroring `invoice_shares` |
| Job states | `automation_webhook_queue` statuses + `idempotency_key`, `next_attempt_at` |
| `idempotency_keys` | Per-owner scope+key uniqueness |
| `audit_events` + `write_audit_event()` | Actor-scoped select; security-definer insert |
| Money dual-write | `*_minor` bigint on `crm_invoices`, `invoice_shares`, `quote_shares` |
| Vault tables | `vault_share_links`, `vault_attachments` (flag `vault_cloud` OFF) |
| Feature flags | New domain flags default **OFF** except `phase0_foundations` + `money_minor_units_dual_write` |

## Sync

- Web/Android keep writing numeric totals; also write `*_minor` when dual-write flag on.
- Vault cloud UI remains disabled until `vault_cloud` enabled.
- `automation_webhook_queue` owner RLS: select/insert/update for `owner_uid = auth.uid()` (+ admin).

## Rollback

1. Disable flags in `app_feature_flags`.
2. Stop writing `*_minor` in clients (columns may remain).
3. Do **not** drop `quote_shares` policies if clients already rely on them.
4. Vault tables can stay empty with flag off.

## Gates (Phase 0)

- Gate 1–3: migration applied; RLS present on new tables; quote_shares selectable by parties.
- Domain product features remain disabled until later phases + admin enablement.
