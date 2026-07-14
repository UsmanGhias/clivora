# Web Audit — Auth & Route Guards (PR-02 excerpt)

**Date:** 2026-07-14  
**Scope this pass:** Auth, admin, blocked/restricted route guards only  
**Full backend/RLS:** See `06-backend-database-rls-audit.md`  
**Status:** Initial findings from code inspection

---

## Middleware matcher

`web/src/middleware.ts` runs session update on:

- `/app/:path*`
- `/login`, `/signup`, `/auth/reset-password`
- `/connect/manage`
- `/admin/:path*`

**Not covered by middleware:** public `/connect`, `/pro`, most marketing routes, `/api/*` (API handlers must self-authorize).

---

## Findings

| ID | Severity | Finding | Evidence |
| --- | --- | --- | --- |
| W-01 | Medium | Blocked accounts: `/app` gated in `app/layout.tsx`, not in middleware; `/connect/manage` is middleware-authed but blocked check is client-side in Connect panels | `web/src/lib/supabase/middleware.ts`, `web/src/app/app/layout.tsx`, `ConnectManagePanel.tsx` |
| W-02 | Low | Admin layout: non-401/403 errors fall through to rendering children (login shell) | `web/src/app/admin/layout.tsx` |
| W-03 | OK | Admin pages require session + admin role; MFA gate on successful auth | `admin-auth.ts`, `AdminMfaGate.tsx` |
| W-04 | OK | Signed-in users hitting auth pages redirect to `/app` | middleware |
| W-05 | Low | CRM / Connect entitlement UI gates remain; **PR-03** added server enforcement (see `05`, `06`, `08`) — runtime matrix TO VERIFY | `plan-gates.ts`, `20260714_*.sql` |
| W-06 | Fixed | Admin read path: AAL lookup failure no longer 503s when `requireAal2=false` (was emptying admin platform UI) | `admin-auth.ts` |
| W-07 | Fixed | Admin overview/settings: removed demo chart curves / fake storage / fake cache version; live snapshot + `site.appVersion` | `admin/(dashboard)/overview`, `settings`, `AdminDataProvider.tsx` |

---

## Admin API surface (spot-check)

Routes under `web/src/app/api/admin/*` call `requireAdmin` / `requireAdminRequest` (AAL2 for mutations). Platform fetch uses service role only after admin check (`admin-platform.ts`, `admin-service.ts`). Odoo status GET: `api/integrations/odoo/sync-contacts/route.ts` returns `configured` / `source` / `missing` / `envPresence`.

---

## Follow-ups for full web audit (later)

- Settings layout / avatar (PR-04, PR-05)  
- Stripe env fail-closed behavior  
- Public invoice share `/i/[token]` auth model
