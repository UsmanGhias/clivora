# PR-03 Remediation Evidence

**Date:** 2026-07-14  
**Status:** Remediations applied (live DB + web code) · residual negative/role-matrix tests **TO VERIFY**  
**Rule:** File paths only — no secrets, env values, or exploit steps

---

## Scope (this wave)

Server-side Connect Pro Plus enforcement, CRM free-plan caps, admin read-path honesty (AAL + live metrics), Odoo status clarity. Canonical Connect credit numbers (R-01) and Vercel author gate (R-02) are **out of scope** here.

---

## Mitigations (verified in repo / applied live)

| Risk / issue | Status | Evidence (paths) |
| --- | --- | --- |
| R-17 Connect SECURITY DEFINER RPC Pro Plus bypass | **MITIGATED** | `supabase/migrations/20260714_connect_require_pro_plus.sql` — `connect_require_pro_plus()`; called from `connect_spend_credits`, `connect_submit_proposal`, `connect_send_request`, `connect_publish_need`, `connect_publish_profile` |
| R-18 CRM free caps UI-only | **MITIGATED** | `supabase/migrations/20260714_crm_free_plan_caps.sql` — triggers on `crm_customers` / `crm_projects` / `crm_invoices` (3 / 5 / 10-per-month); `crm_plan_is_paid()` |
| R-16 Profiles privileged self-update | **MITIGATED** (earlier) | `profiles_guard_privileged_columns` (live 2026-07-14); see `14-risk-register.md` |
| Admin `/api/admin/platform` 503 when MFA AAL lookup fails | **FIXED** (read path) | `web/src/lib/admin-auth.ts` — on `requireAal2=false`, AAL lookup failure → treat as `aal1` (mutations still require AAL2 via `requireAdminRequest`) |
| Admin overview/settings demo metrics | **FIXED** | `web/src/app/admin/(dashboard)/overview/page.tsx`, `web/src/app/admin/(dashboard)/settings/page.tsx`, `web/src/components/admin/AdminDataProvider.tsx`, `web/src/components/dashboard/EarningsLineChart.tsx` — live snapshot + `site.appVersion`; no demo curves / fake storage / fake “Local cache” version |
| Odoo status opaque / empty admin | **MITIGATED** (status UX) | `web/src/app/api/integrations/odoo/sync-contacts/route.ts` GET returns `configured` / `source` / `missing` / `envPresence`; UI: `web/src/components/app/OdooSyncButton.tsx`, admin shell consumers |

---

## Residual verification (required before GO)

- Negative tests: Free/Pro user cannot call Connect write RPCs; Free user hits CRM insert caps; Pro/Pro Plus/admin bypass caps as designed.
- Confirm `requireAdmin({ requireAal2: true })` still fails closed when AAL is not `aal2`.
- Runtime role × plan matrix (Batch B/C) still **TO VERIFY**.

---

## Related docs

- Risk status: `14-risk-register.md` (R-16–R-18)
- Backend detail: `06-backend-database-rls-audit.md`
- Billing/entitlements note: `08-billing-entitlements.md`
- Gate: `15-release-go-no-go.md` — still **NO-GO**
