# Backend / Database / RLS Audit (PR-02)

**Date:** 2026-07-14  
**Mode:** Code inspection + live Supabase project `Clivora` (read-only SQL / advisors)  
**Scope:** Auth roles, account restrictions, admin gates, RLS on critical tables, Connect credits, plan entitlements  
**Status:** Phase 2 / PR-02 in progress — findings below are verified unless marked **TO VERIFY**

---

## Summary verdict

RLS is **enabled** on sampled critical tables in production. Several **High/Critical** gaps remain: privileged profile columns are self-writable; Connect write RPCs are `SECURITY DEFINER` and do not re-check Pro Plus; CRM free-tier caps are UI-only; Connect base-table policies exist live but are **missing from repo migrations** (`017_*.sql` is a stub).

---

## Auth, roles, restrictions (web)

| Control | Evidence | Finding | Severity |
| --- | --- | --- | --- |
| Session middleware | `web/src/middleware.ts`, `web/src/lib/supabase/middleware.ts` | Protects `/app/*`, `/connect/manage`, `/admin/*`, auth pages. Uses `getUser()` (not `getSession()` alone). Unauthenticated → `/login`. | OK |
| Admin middleware | `web/src/lib/supabase/middleware.ts` | Requires `profiles.role = admin` **or** `account_type = admin`; rejects blocked/restricted. | OK (note dual admin signal) |
| Admin server gate | `web/src/lib/admin-auth.ts`, `web/src/app/admin/layout.tsx` | `requireAdmin()` reads own profile row; ignores request-body credentials. MFA: layout wraps `AdminMfaGate`; mutating APIs use `requireAdminRequest` → `requireAal2: true`. | OK |
| Blocked users | `web/src/app/app/layout.tsx`, `/blocked` | `/app/*` redirects blocked. Middleware does **not** check `is_blocked` for `/app` (layout does). `/connect` and `/pro` check in page/client code. | Medium — incomplete edge coverage |
| Restricted users | Connect UI + RPCs | UI blocks Connect writes; `connect_credit_eligible` rejects restricted/blocked. Middleware does not strip `/app` for restricted (by design). | OK for Connect; Android restricted **TO VERIFY** |
| Profile fallback | `web/src/lib/profile.ts` `getProfile()` | If no profile row, synthesizes free/unblocked profile from auth metadata — can mask missing rows. | Low |

---

## Plan entitlements (server vs UI)

| Cap / gate | UI / client | Server enforcement | Severity |
| --- | --- | --- | --- |
| CRM clients / projects / invoices | `web/src/lib/plan-gates.ts` on list pages | `crm_*` RLS is owner-only (`20260710_crm_cloud_tables.sql`); **no count/plan checks** | **High** — free caps bypassable via direct REST inserts |
| Connect Pro Plus (UI) | `isProPlus()` in Connect components | Live RLS on `connect_profiles` / `connect_need_posts` / `connect_requests` insert requires `is_pro_plus()` | Partial OK |
| Connect write RPCs | UI gates Pro Plus | `connect_publish_*`, `connect_send_request`, `connect_submit_proposal` in `20260712_connect_credits.sql` are **SECURITY DEFINER**; spend credits + eligibility only — **no `is_pro_plus()` / plan check** | **High** — RPC path can bypass table RLS Pro Plus gate |
| Connect credit allowances | Docs conflict (R-01) | Live SQL: Free **5**, Pro **30**, Pro Plus **100**; costs contact/proposal **1**, publish **3** (`connect_credit_allowance`, `connect_spend_credits`) | Medium — code has numbers; product docs still conflict |
| Android plan matrix | `lib/core/constants/plan_features.dart` | Client-side; cloud plan from `profiles.subscription_plan` | TO VERIFY parity with web |

Live `is_pro_plus()` (production): admin / allowlisted admin **or** `profiles.subscription_plan = 'pro_plus'`.

---

## Profiles RLS & privileged columns

**Live policies:** `profiles_select`, `profiles_insert_own`, `profiles_update_own` (authenticated).  
**Trigger:** `profiles_lock_account_type` → `lock_profile_account_type()`.

Verified trigger protects: `account_type` lock, non-allowlisted `role = admin`.  
**Does not protect:** `subscription_plan`, `is_blocked`, `is_restricted`, `block_reason` (and similar).

Combined with `profiles_update_own` (`id = auth.uid() OR is_admin()`), an authenticated user can update their own privileged columns unless additional DB privileges/triggers exist (**none found** in trigger list).

| Finding | Severity |
| --- | --- |
| Self-service update of `subscription_plan` / block flags via own-row UPDATE | **Critical** |
| Admin role self-assignment blocked for non-allowlisted emails | Mitigated |
| Admin allowlist hardcoded in SQL (`007_production_security.sql`, `20260713_admin_allowlist_align.sql`) | Medium (ops / rotation) |

---

## Critical table RLS matrix (sampled)

Checked live + migrations. Repo stub: `017_clivora_connect_and_crm_backup.sql` is `select 1;` — Connect/CRM-backup DDL+policies applied remotely, **not replayable from repo**.

| Table | RLS on | Policy shape (live) | Notes |
| --- | --- | --- | --- |
| `profiles` | Yes | Own + linked shares + admin | Privileged column gap above |
| `client_messages` | Yes | Participant / admin (`003_strict_roles_privacy.sql`) | OK shape |
| `crm_customers/projects/invoices` | Yes | Owner `owner_uid = auth.uid()` | No plan caps; no admin read via RLS (admin uses service role) |
| `connect_profiles` | Yes | Insert: own + `is_pro_plus()`; Select: own / listed+approved+pro_plus / admin | Select gate may block Free browse — product says browse for all signed-in (**TO VERIFY** UX path) |
| `connect_need_posts` | Yes | Similar Pro Plus insert + moderated select | Same |
| `connect_requests` | Yes | Insert: from self + `is_pro_plus()`; select parties/admin | Bypassed by SECURITY DEFINER RPCs |
| `connect_proposals` | Yes | Parties | Insert also via SECURITY DEFINER RPC |
| `connect_credit_*` | Yes | Owner/admin SELECT; writes via definer functions | OK |
| `device_tokens` / `chat_blocks` | Yes | Own-uid policies live | Policies **absent from repo** migrations (`20260710_phase_af_foundation.sql` enables RLS only) |
| `crm_cloud_backups` | Yes | Owner-scoped policies live | Not in repo SQL body |
| `pro_payment_requests` | Yes | **INSERT** for `anon`+`authenticated` with `WITH CHECK (true)` | **High** — unauthenticated spam/abuse of payment request table (advisor confirmed) |

Advisor also: RLS on / no policies for `_internal_secrets`, `automation_webhook_queue`, `quote_shares` (deny-all for non-service — usually OK).

---

## Edge functions

| Function | Path | Auth notes | Severity |
| --- | --- | --- | --- |
| `verify-play-purchase` | `supabase/functions/verify-play-purchase/` | Bearer user JWT; service role updates plan after Play verify | OK pattern |
| `send-push` | `supabase/functions/send-push/` | Service key **or** user JWT only for own `user_uid` | OK |
| `send-clivora-email` | `supabase/functions/send-clivora-email/` | Any authenticated user can send allowlisted purposes to arbitrary `to` (admin_notice gated) | **Medium** — email abuse / phishing risk |
| `send-invoice-reminders` | `supabase/functions/send-invoice-reminders/` | Cron-oriented | TO VERIFY invoke auth |

Many SECURITY DEFINER RPCs are executable by `anon` per advisor (calls fail without `auth.uid()`, but grants should be revoked from `anon`).

---

## Android auth (brief)

| Item | Evidence | Finding |
| --- | --- | --- |
| Auth helper | `lib/core/cloud/supabase_auth_helper.dart` | Email/Google; `finalize_account_type` RPC with profile upsert fallback |
| Blocked | `lib/core/auth/auth_service.dart` | On sign-in, fetches profile; if `is_blocked`, signs out with message | OK |
| Restricted | Grep | `is_restricted` fetched but **no** Android gate found beyond Connect credit eligibility server-side | **Medium** / TO VERIFY |
| Admin emails | `lib/core/constants/admin_config.dart` | Client allowlist; must stay aligned with SQL allowlist | Medium |

---

## Storage / privacy (related)

Live storage policies still include `chat_attachments_public_read` (`SELECT` for `public` on bucket). Migration `010_chat_storage_private.sql` intended private + auth read, but advisor reports public bucket listing — **High** privacy exposure for chat media URLs.

---

## Remediation priorities (no exploit steps)

1. **Critical:** Trigger or column privileges so non-admin cannot change `subscription_plan`, `is_blocked`, `is_restricted` (and related moderation fields).  
2. **High:** Add Pro Plus (and blocked/restricted) checks inside Connect SECURITY DEFINER write RPCs; keep RLS as defense-in-depth.  
3. **High:** Server-enforce CRM free caps (RPC/trigger) or accept unlimited free CRM in product docs.  
4. **High:** Tighten `pro_payment_requests` insert policy; remove anon open insert.  
5. **High:** Re-apply private chat-attachments policies; remove public listing.  
6. **Medium:** Codify Connect + device_tokens/chat_blocks/crm_cloud_backups policies into replayable migrations (replace stub `017`).  
7. **Medium:** Revoke `anon` EXECUTE on SECURITY DEFINER RPCs; restrict email edge function recipients/rate limits.

---

## Evidence commands / sources

- Repo: migrations under `supabase/migrations/`, web auth under `web/src/lib/admin-auth.ts`, `web/src/lib/supabase/middleware.ts`, `web/src/lib/plan-gates.ts`  
- Live: `pg_policies` / `pg_class.relrowsecurity` / `pg_get_functiondef` on project `jtzjwgovqczlccyeujhq`  
- Advisors: Supabase `get_advisors` type `security` (2026-07-14)
