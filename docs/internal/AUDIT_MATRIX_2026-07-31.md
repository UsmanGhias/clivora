# CLIVORA audit matrix — 2026-07-31 (Phase 0 / Phase 1 P0)

**Branch:** `staging` only  
**Supabase project:** Clivora `jtzjwgovqczlccyeujhq` (ACTIVE_HEALTHY, Postgres 17.6)  
**Rule:** Do **not** apply SQL to production until an explicit promotion gate. Migration file is staged in-repo only.

## Confirmed advisor snapshot (read-only, 2026-07-31)

### Security (116)

| Lint | Count | Notes |
|------|------:|-------|
| `anon_security_definer_function_executable` | 48 | Includes admin secrets, Connect, CRM triggers, home summaries |
| `authenticated_security_definer_function_executable` | 59 | Overlaps; do not mass-revoke |
| `function_search_path_mutable` | 3 | `crm_reject_stale_update`, `crm_invoice_payment_status`, `invoice_shares_sync_total_minor` |
| `public_bucket_allows_listing` | 2 | `avatars`, `portfolio-thumbs` |
| `rls_policy_always_true` | 1 | `pro_payment_requests_insert_anon` |
| `rls_enabled_no_policy` | 2 | Separate follow-up |
| `auth_leaked_password_protection` | 1 | Enable HaveIBeenPwned in Auth settings (dashboard) |

### Performance (180)

| Lint | Count | Notes |
|------|------:|-------|
| `duplicate_index` | 1 | `automation_webhook_queue_idem_uidx` ≡ `automation_webhook_queue_idempotency_key_uidx` |
| `auth_rls_initplan` / FK / unused index | many | Not P0 this pass |

## Remote migration versions (schema_migrations)

Latest applied remote version: `20260725142122`. Full list ends through that stamp (63 versions). Local repo also has named files under `supabase/migrations/` including Phase 0–9 and Connect auto-approve work.

**Unapplied (this pass, git only):** `20260731_audit_p0_payment_storage_search_path.sql`

## P0 work in this staging pass

1. Replace client `pro_payment_requests` insert with authenticated API + service-role write; migration drops `pro_payment_requests_insert_anon`.
2. `SET search_path = public` on the three mutable functions; drop shorter duplicate idempotency index.
3. Narrow storage SELECT on public media buckets; add owner SELECT.
4. Revoke `anon`/`authenticated`/`PUBLIC` EXECUTE on `admin_get_integration_secret` / `admin_upsert_integration_secret`; revoke `anon` on `admin_dashboard_summary`. Callers use service-role table access after admin checks.
5. Fail-closed Supabase env outside local development.

## Staging test accounts (emails only — create in staging DB later)

- `freelancer.free@example.test`
- `freelancer.pro@example.test`
- `freelancer.proplus@example.test`
- `client.free@example.test`
- `client.pro@example.test`
- `admin.aal1@example.test`
- `admin.aal2@example.test`
- Second freelancer + second client for IDOR

Never commit passwords, service-role keys, or payment secrets.

## RPC classification stub (`SECURITY DEFINER`, public)

| Function | Anon EXEC | Intended caller | Class | Action this pass |
|----------|-----------|-----------------|-------|------------------|
| `admin_get_integration_secret` | yes | server after admin | server-only | revoke anon+authenticated |
| `admin_upsert_integration_secret` | yes | server after admin | server-only | revoke anon+authenticated |
| `admin_dashboard_summary` | yes | authenticated admin UI | admin | revoke anon only |
| `grant_pro_by_email` / `grant_admin_by_email` | no | authenticated admin | admin | leave; later AAL2 audit |
| Connect `*_proposal` / `*_request` / publish / credits | yes | authenticated participants | authenticated | inventory only — do not mass revoke |
| CRM `crm_enforce_*` / triggers | yes | triggers | trigger | inventory; search_path fixed for three listed |
| `invoke_invoice_reminders` | yes | cron/service | server-only | later revoke |
| `handle_new_user` | no | auth trigger | trigger | leave |
| `vault_lookup_share_by_token` | yes | public share token | public-read | review later |
| Home summaries / messaging | yes | authenticated | authenticated | review later |

Full Connect ownership predicates remain a Phase 1A follow-up.

## Promotion checklist (staging → production)

1. Deploy web (API + checkout + secret readers) to staging; smoke Pro + admin Odoo secret save.
2. Confirm `SUPABASE_SERVICE_ROLE_KEY` on Hostinger staging and live.
3. Apply `20260731_audit_p0_payment_storage_search_path.sql` only after web is live (order: **web first, then SQL**).
4. Re-run security/performance advisors; confirm payment always-true and public listing lints gone for targeted items.
5. Two-user IDOR + payment spam attempt (anon insert must fail).
6. Only then promote web `staging` → `main` / live Hostinger.

## Staging verification checklist

- [ ] `npm run typecheck` / `lint` / `build` on `web/`
- [ ] Public pages 200 on staging.clivora.io
- [ ] Manual Pro payment uses `/api/pro/payment-requests`
- [ ] Middleware remains pass-through (intentional; Hostinger 503 recovery)
