# Billing & Entitlements — PR-03 note

**Date:** 2026-07-14  
**Status:** Partial remediation · R-01 still OPEN  
**Rule:** No secrets; product numbers cited only where verified in SQL

---

## Server enforcement (applied)

| Entitlement | Enforcement | Migration / code |
| --- | --- | --- |
| Connect writes (spend / submit / send / publish) | Pro Plus or admin via `connect_require_pro_plus()` inside SECURITY DEFINER RPCs | `supabase/migrations/20260714_connect_require_pro_plus.sql` |
| CRM Free caps | Triggers: 3 clients, 5 projects, 10 invoices/month (UTC month); Pro / Pro Plus / admin skip | `supabase/migrations/20260714_crm_free_plan_caps.sql` |
| UI gates (defense in depth) | Unchanged client checks | `web/src/lib/plan-gates.ts` |

---

## Still open

| Item | Risk | Note |
| --- | --- | --- |
| Canonical Connect credit allowances/costs across docs | **R-01** | Live SQL remains Free 5 / Pro 30 / Pro Plus 100; costs 1/1/3 — product docs still conflict; owner sign-off required |
| Stripe optional path | **R-10** | Env-gated; not enabled as part of PR-03 |
| `pro_payment_requests` open insert | **R-19** | Unrelated to Connect/CRM caps; still OPEN |

---

## Residual tests

- Free user RPC → `PRO_PLUS_REQUIRED`
- Free user CRM insert past cap → `FREE_PLAN_*_LIMIT`
- Credit spend still requires eligibility + balance (existing paths)
