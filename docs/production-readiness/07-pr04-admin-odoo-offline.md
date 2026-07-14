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
6. **Two-way Odoo** — pull + push with `odoo_partner_id`; simplified pull domain (fixes Odoo Server Error on complex `email!=false` domains); partial success warnings on two-way.
7. **Connect messaging** — `require_message_link` allows accepted Connect requests / hired proposals; `connect_peer_contact` RPC reveals email only after accept; messages compose uses it.
8. **Job / need posting** — `connect_publish_need` allows freelancers (one open need) and clients.
9. **Proposals CRUD** — Hire / Shortlist / Decline wired via RPCs; accept creates engagement request + reveals contacts for messaging.
10. **Jobs invisible after post** — publish set `pending` but RLS only showed `approved`; now publishes as `approved` (admin can Hide). Draft status allowed in check constraint.
11. **Hire from shortlisted** — `connect_accept_proposal` accepts pending/shortlisted/viewed.
12. **Connect request accept** — `connect_respond_request` RPC sets `revealed_at`; web + Flutter use it.
13. **Messaging privacy** — Message CTA only after hire/accept; freelancer cannot see client contact beforehand; `connect_peer_contact` gates email.
14. **Admin Connect/Jobs CRUD** — Approve / Hide / Verify wired to `/api/admin/marketplace`; field mapping uses `budget_band` / `moderation_status` / `is_open`.

## Residual / next

| ID | Item | Status |
| --- | --- | --- |
| PR-04-A | Admin live snapshot deploy | **Done** |
| PR-04-B | Odoo two-way Contacts | **Done** (Contacts app only) |
| PR-04-C | Android sync outbox + conflict evidence | Not started |
| PR-04-D | Realtime channel ACL / chat attachment RLS residual | Open |
| PR-04-E | Runtime matrix tests (client post job → freelancer apply → hire → message) | TO VERIFY after deploy |

## Commands

```bash
# After deploy, signed-in admin session:
curl -sS -b '...' https://clivora.codcrafters.org/api/admin/platform | jq '.overview,.source'
curl -sS -b '...' https://clivora.codcrafters.org/api/integrations/odoo/sync-contacts | jq '{configured,ready,authOk,source,envPresence}'
```
