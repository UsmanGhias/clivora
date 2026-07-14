# Security & Privacy Audit — Initial Findings (PR-02)

**Date:** 2026-07-14  
**Mode:** Code + live DB advisors (read-only)  
**Rule:** No secrets, no exploit recipes, no private user data in this document  
**Status:** Phase 2 findings + PR-03 remediations noted — expand in later batches  
**Related:** `05-pr03-remediation-evidence.md`, `08-billing-entitlements.md`

---

## Top verified issues

| ID | Severity | Finding | Evidence | Status |
| --- | --- | --- | --- | --- |
| S-01 | **Critical** | Own-row `profiles` UPDATE could change plan/moderation flags | Was: `lock_profile_account_type()` only; **now** `profiles_guard_privileged_columns` | **MITIGATED** (neg. test open) |
| S-02 | **High** | Connect SECURITY DEFINER write RPCs lacked Pro Plus | Was: `20260712_connect_credits.sql`; **now** `20260714_connect_require_pro_plus.sql` | **MITIGATED** (neg. test open) |
| S-03 | **High** | CRM free-tier limits UI-only | Was: `plan-gates.ts` only; **now** `20260714_crm_free_plan_caps.sql` | **MITIGATED** (cap test open) |
| S-04 | **High** | `pro_payment_requests` allows unrestricted INSERT for anon + authenticated | Live policy `pro_payment_requests_insert_anon`; advisor `rls_policy_always_true` | **OPEN** |
| S-05 | **High** | Chat attachments still have public SELECT policy (`chat_attachments_public_read`) | Live `storage.objects` policies; advisor `public_bucket_allows_listing` | **OPEN** |
| S-06 | **Medium** | Transactional email edge function: authenticated users can send allowlisted templates to arbitrary addresses | `supabase/functions/send-clivora-email/index.ts` | **OPEN** |
| S-07 | **Medium** | Large set of SECURITY DEFINER RPCs executable by `anon` (advisor); most check `auth.uid()` but grants should be least-privilege | Supabase security advisors 2026-07-14 | **OPEN** |
| S-08 | **Medium** | Connect / device_token / chat_block / backup RLS policies exist live but are missing or stubbed in repo migrations — staging replay drift risk | `017_clivora_connect_and_crm_backup.sql`, `20260710_phase_af_foundation.sql` | **OPEN** |
| S-09 | **Medium** | Leaked-password protection disabled in Auth | Advisor `auth_leaked_password_protection` | **OPEN** |
| S-10 | **Low** | Admin email allowlist duplicated in SQL + Flutter config — rotation / consistency risk | `007_production_security.sql`, `20260713_admin_allowlist_align.sql`, `lib/core/constants/admin_config.dart` | **OPEN** |

---

## Controls that look sound (verified)

- Admin API authorization via cookie session + profile role (`web/src/lib/admin-auth.ts`); service-role errors not returned to client.
- Admin mutating routes require AAL2 (`requireAdminRequest`); **PR-03:** read path tolerates AAL lookup failure when `requireAal2=false`.
- Middleware uses `getUser()` for protected routes.
- Push edge function restricts non-service callers to own `user_uid`.
- Play purchase verification requires user JWT before service-role plan update.
- `client_messages` participant policies present; CRM owner isolation present; CRM free caps server-side (PR-03).
- Connect write RPCs call `connect_require_pro_plus()` (PR-03).
- Android sign-in rejects blocked accounts (`lib/core/auth/auth_service.dart`).

---

## Privacy notes (non-exploit)

- Connect contact privacy after mutual accept remains **TO VERIFY** with a role-matrix test (email columns / views).
- Chat media: public listing policy contradicts intended private bucket (`010_chat_storage_private.sql`).
- Analytics / `clivora_events` insert constrained to own email or admin (`006_auth_security_fixes.sql`).

---

## Open product / security decisions

1. Should Free users browse Connect listings? Live SELECT policies require `is_pro_plus()` for others’ approved listings — may conflict with product “browse for all signed-in.”  
2. Canonical Connect credit numbers (also R-01).  
3. ~~Whether CRM free caps are hard product limits~~ → server-enforced in PR-03; confirm product copy matches.

---

## Next verification (PR-09)

- Staging RLS matrix: anon / free / pro_plus / restricted / blocked / admin on `profiles`, `crm_*`, `connect_*`, `client_messages`.  
- Confirm self-update of privileged profile columns is blocked (R-16).  
- Confirm Free user Connect write RPC and CRM cap rejections (R-17, R-18).  
- Confirm chat bucket non-public after policy fix.  
- Edge function JWT verification flags (`verify_jwt`) **TO VERIFY** in project dashboard.
