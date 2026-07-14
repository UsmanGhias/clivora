# PR-04 — Offline sync, realtime, and admin live-data hardening

**Status:** In progress (2026-07-14)  
**Depends on:** PR-03 remediations (`05-pr03-remediation-evidence.md`)

## Scope

| Area | Goal |
| --- | --- |
| Admin platform snapshot | Live Supabase service-role aggregates for migration overview |
| Odoo Contacts | Admin push of CRM customers using existing free Odoo apps only |
| Offline / outbox | Inspect Android `sync_outbox` + web reconnect paths (Batch D) |
| Realtime | Chat / notifications channels — no silent failures |

## Findings fixed this batch

1. **Admin `AUTH_UNAVAILABLE` (503)** — `assertSupabaseAuthConfig` required `NEXT_PUBLIC_SUPABASE_ANON_KEY` even when `@/lib/supabase-browser` already supplies working URL/anon fallbacks used by `createClient()`. Fixed to use the same exports.
2. **Empty admin lists despite DB rows** — `loadPlatformSnapshot` selected non-existent columns (`profiles.full_name`, `profiles.created_at`, `crm_projects.owner_user_id`, Connect field aliases, `app_feature_flags.value`, etc.). PostgREST returned 400 → empty arrays. Selects aligned to live schema; user list limit raised to 500.
3. **Fabricated overview metrics** — removed invented `newUsers`/`platformFee`/`totalPayouts` ratios; use real counts / milestone statuses.
4. **Odoo sync scope** — POST now pushes **all** `crm_customers` (service role) into Odoo Contacts; GET verifies auth; PUT lets admin save a verified API key into `admin_integration_secrets`.
5. **Migration export** — Admin Overview “Export full snapshot” downloads users, CRM, Connect, invoices, payments JSON.

## Live DB snapshot (evidence)

Queried project `jtzjwgovqczlccyeujhq` on 2026-07-14:

- `profiles`: **22** rows (admins include `usmanghias1@gmail.com`, `iusmanghias@gmail.com`)
- `crm_customers`: **9** rows across owners
- `admin_integration_secrets`: ODOO_* keys present
- Odoo host `https://clivora.odoo.com` / db `clivora` reachable (v19); **stored API key currently fails authenticate** → admin UI prompts for a fresh API key (Preferences → Account Security). Interactive passwords are not stored.

## Residual / next

| ID | Item | Status |
| --- | --- | --- |
| PR-04-A | Redeploy `clivora-web` with auth + schema fixes; confirm `/api/admin/platform` 200 with live counts | Pending deploy |
| PR-04-B | Paste working Odoo API key via Admin → Integrations (or Vercel `ODOO_*`) and run Sync | Blocked on valid key |
| PR-04-C | Android sync outbox + conflict evidence | Not started |
| PR-04-D | Realtime channel ACL / chat attachment RLS residual from risk register | Open |

## Commands

```bash
# After deploy, signed-in admin session:
curl -sS -b '...' https://clivora.codcrafters.org/api/admin/platform | jq '.overview,.source'
curl -sS -b '...' https://clivora.codcrafters.org/api/integrations/odoo/sync-contacts | jq '{configured,ready,authOk,source,envPresence}'
```
