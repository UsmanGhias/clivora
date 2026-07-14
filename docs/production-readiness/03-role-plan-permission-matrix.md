# Role × Plan × Permission Matrix

**Sources:** `docs/product/plans-and-entitlements.md`, `docs/product/role-permissions.md`, `web/content/docs/connect.md`, `web/content/docs/plans-and-billing.md`  
**Enforcement (code):** `web/src/lib/plan-gates.ts`, `web/src/lib/connect-credits.ts`, Supabase RPCs in `supabase/migrations/20260712_connect_credits.sql` and related  
**Status:** Draft baseline — server-side behavior **TO VERIFY** in audit batches

---

## Account types and states

| Dimension | Values | Rule |
| --- | --- | --- |
| `account_type` | `freelancer` \| `client` | One email → one locked type; no unsupported role-switch |
| `role` | includes `admin` for operators | Admin is privileged path; not a replacement for account_type |
| Account state | `active`, `restricted`, `blocked` | See behavior table below |

| State | Connect browse | Connect publish / contact / proposals | Protected app surfaces |
| --- | --- | --- | --- |
| Active | Yes (signed-in) | Per plan + credits (see below) | Yes |
| Restricted | Yes | **No** writes | Yes (except Connect writes) |
| Blocked | No | No | **No** — redirect blocked |

---

## CRM entitlements (locked caps — owner-confirmed baseline)

| Resource | Free | Pro | Pro Plus |
| --- | --- | --- | --- |
| Clients | 3 | Unlimited | Unlimited |
| Projects | 5 | Unlimited | Unlimited |
| Invoices / month | 10 | Unlimited | Unlimited |

**Source of truth:** `profiles.subscription_plan` (`free` \| `pro` \| `pro_plus`). Web and Android must read the same column.

---

## Connect actions matrix

Interim rule from `plans-and-entitlements.md` until credits reconciled:

| Action | Guest | Free (active) | Pro (active) | Pro Plus (active) | Restricted | Blocked |
| --- | --- | --- | --- | --- | --- | --- |
| Browse talent & jobs | Public `/connect` + signed-in | Yes | Yes | Yes | Yes | No |
| Connect inbox (accept/decline) | No | Signed-in | Signed-in | Signed-in | Read? **TO VERIFY** | No |
| Send request / proposal | No | RPC + plan gate | RPC + plan gate | RPC + credits | **No** | No |
| Publish freelancer profile | No | Pro Plus + credits | Pro Plus + credits | Pro Plus + credits | **No** | No |
| Post client job (“Post a job”) | No | Pro Plus + credits | Pro Plus + credits | Pro Plus + credits | **No** | No |
| Post freelancer need (“Post a need”) | No | Pro Plus + credits; **max 1 open** (web) | Same | Same | **No** | No |
| View contact email | No | After mutual accept | After mutual accept | After mutual accept | N/A | No |
| Milestones / reviews | No | After engagement | After engagement | After engagement | **TO VERIFY** | No |

**RPCs (non-exhaustive):** `connect_publish_*`, `connect_send_request`, `connect_submit_proposal` — enforce server-side.

---

## OPEN PRODUCT DECISION — Connect credits

Published materials **conflict**. Do not treat any single doc as canonical until owner signs off.

| Source | What it says |
| --- | --- |
| `docs/product/plans-and-entitlements.md` | Interim: publish/contact/proposals require **Pro Plus** + credit checks; **do not invent numbers** |
| `web/content/docs/connect.md` | Monthly allowances: Free **5**, Pro **30**, Pro Plus **100**; costs: contact **1**, proposal **1**, publish **3** |
| `docs/internal/CLIVORA-SECURE-STABILIZATION-UPDATE-2026-07-13.md` | Claims shipped: Free 5, Pro 30, Pro Plus 100 + grandfathering |
| `web/content/docs/plans-and-billing.md` | Pro Plus for Connect posting; credit detail lighter |
| `AGENTS.md` | Flags conflict across release notes vs Connect docs vs plans page |

**Action:** Owner picks one canonical credit policy → update RPCs / `connect_credit_*` tables → align web, Android, public docs, tests.

**Matrix impact:** Until resolved, all credit-gated cells are **TO VERIFY** at runtime.

---

## Portal feature access (by role)

### Freelancer portal

| Feature | Free | Pro | Pro Plus | Notes |
| --- | --- | --- | --- | --- |
| Dashboard / hub | Yes | Yes | Yes | |
| CRM (within caps) | Yes | Yes | Yes | |
| Advanced CRM / unlimited | No | Yes | Yes | |
| Messages, notifications | Yes | Yes | Yes | |
| Timesheets, earnings, analytics | Partial **TO VERIFY** | Yes | Yes | |
| Connect browse | Yes | Yes | Yes | |
| Connect write actions | Gated | Gated | Pro Plus + credits | See OPEN DECISION |
| Team, referrals, settings | Mostly yes **TO VERIFY** | Yes | Yes | |
| Ask AI | Beta **TO VERIFY** | Yes | Yes | |

### Client portal

| Feature | Free | Pro | Pro Plus | Notes |
| --- | --- | --- | --- | --- |
| Dashboard / projects / invoices | Yes (within caps) | Unlimited | Unlimited | |
| Post a job | No | No | Pro Plus + credits | Wording: “Post a job” |
| Browse talent, proposals | Yes | Yes | Yes | |
| Payments navigation | Yes | Yes | Yes | Escrow funding disabled |
| Messages, settings | Yes | Yes | Yes | |

### Admin

| Capability | Access | Notes |
| --- | --- | --- |
| User lists, moderation | Allowlisted admin | Never expose service-role in client |
| Grant Pro / admin | Super-admin RPCs | `grant_admin_by_email`, grant-pro API |
| Escrow ledger view | Admin dashboard | Tracking only; not live money movement |
| Fraud / ranking internals | Admin only | Not documented publicly |

---

## Billing channels

| Channel | Freelancer | Client | Status |
| --- | --- | --- | --- |
| Android Google Play | `clivora_pro_*`, `clivora_pro_plus_*` SKUs | Same pattern | ⏳ TO VERIFY |
| Web manual `/pro` | JazzCash, bank, etc. | Same | Claimed working (2026-07-13 audit) |
| Stripe checkout / portal | API routes exist | Same | Optional; env-gated **TO VERIFY** |

---

## Enforcement layers (verify alignment)

1. **UI gates** — `plan-gates.ts`, Android `plan_features.dart` / permissions  
2. **API / RPC** — Supabase functions on Connect and CRM mutations  
3. **RLS** — Row policies on `profiles`, `crm_*`, `connect_*`, `client_messages`  
4. **Account state** — blocked/restricted middleware and redirects  

Any mismatch between layers is a **release blocker** until documented as intentional.
