# CLIVORA Production Readiness — Audit Plan

**Status:** Phase 1 **accepted** (documentation baseline) · Phase 2 / **PR-02 in progress** (Auth, roles, restrictions, admin, RLS)  
**Graphify:** **Not installed** — `graphify-out/` absent in repo (gap per `AGENTS.md` mandate)  
**Updated:** 2026-07-14 (PR-02 code + live DB inspection)

## Prerequisites

| Item | Status |
| --- | --- |
| Read `AGENTS.md`, product docs, web-android contracts | Done (baseline docs) |
| Install / refresh Graphify knowledge graph | **GAP — not done** (PR-01) |
| Staging Supabase with migration replay | TO VERIFY — live prod policies inspected; repo migration stub risk noted in `06` |
| CI web build + Android release build | TO VERIFY |

## Phase status

| Phase | Scope | Status |
| --- | --- | --- |
| Phase 1 | Inventory, journeys, role matrix, risk register, GO/NO-GO skeleton | **Accepted** — docs `00`–`03`, `14`, `15` |
| Phase 2 / PR-02 | Auth, roles, restrictions, admin, RLS, entitlements | **In progress** — `04` (auth excerpt), `06`, `09` written; remediation not started |
| Later | Batches C–I, PR-03–PR-10 | Not started |

## Proposed verification batches

Execute in order; record commands, outputs, and screenshots in an evidence folder (not created yet).

### Batch A — Inventory & graph (PR-01)

- Install Graphify per `AGENTS.md`; generate `graphify-out/`.
- Cross-check graph edges against `01-system-inventory.md` (routes, tables, RPC callers).
- Flag INFERRED vs EXTRACTED relationships; verify risky inferences in code.

### Batch B — Auth, roles, RLS (PR-02 / PR-09) — **ACTIVE**

- Guest redirect, login/signup, blocked/restricted account paths (web + Android).
- RLS matrix: anonymous, owner, participant, admin sessions on `profiles`, `crm_*`, `connect_*`, `client_messages`.
- Admin route protection (`web/src/app/admin/`, `web/src/app/api/admin/*`).
- **Progress:** Code + live policy inspection complete → `06-backend-database-rls-audit.md`, `09-security-privacy-audit.md`. Runtime role-matrix tests still TO VERIFY.

### Batch C — Plans & Connect credits (PR-02)

- Owner decision on canonical credit allowances and action costs.
- Align `docs/product/plans-and-entitlements.md`, `web/content/docs/connect.md`, Supabase RPCs (`connect_publish_*`, `connect_send_request`, `connect_submit_proposal`), `web/src/lib/plan-gates.ts`, Android plan gates.
- Parallel credit spend / idempotency scenarios.
- **Note:** Live SQL allowances (5/30/100) and costs (1/1/3) inspected; product docs still conflict (R-01). RPC Pro Plus gap recorded as R-16.

### Batch D — CRM & offline sync (PR-09)

- Web CRM CRUD against `crm_*` tables.
- Android Drift cache + `supabase_sync_service` outbox; reconnect conflict behavior.
- **Known gap (internal audit 2026-07-13):** mobile time tracking local-only vs `crm_time_entries` — TO VERIFY.

### Batch E — Messaging, shares, billing (PR-08)

- Messages (`client_messages`), notifications, invoice share `/i/[token]`.
- Android Play Billing; web `/pro` manual path; Stripe routes (`web/src/app/api/stripe/*`) when `STRIPE_ENABLED`.
- Pro payment requests (`pro_payment_requests`) — open anon insert found (R-18).

### Batch F — Connect marketplace (PR-02)

- Browse (all signed-in), publish/contact (Pro Plus + credits), privacy until mutual accept.
- Freelancer one open need; client job posting wording.
- Admin moderation surfaces (read-only vs actionable — TO VERIFY).
- **Note:** Live SELECT policies gate others’ listings on `is_pro_plus()` — product browse rule TO VERIFY.

### Batch G — UI hotfixes (PR-04, PR-05, PR-06)

- Web settings layout (freelancer/client tabs, responsive grid).
- Header avatar sync (`UserAvatar`, `profiles.avatar_url` migration `20260713_profiles_avatar_url.sql`).
- Mobile hub truncation (Flutter `more_screen`, `client_hub_screen`; web `/app/hub`).

### Batch H — Integrations (PR-07, PR-08)

- Meetings: Jitsi room creation (`MeetingsClient.tsx`, `meeting_links` table).
- Google Calendar OAuth — currently stubbed; full sync TO VERIFY.
- Odoo — **not wired**; meeting prep docs only (`docs/meeting/`).

### Batch I — Deploy & release hygiene (PR-03, PR-10)

- Git author `Usman Ghias <usmanghias1@gmail.com>` for Vercel deploys (`docs/runbooks/releases.md`).
- Vercel READY state; Android signing + tag release workflow.
- Compile GO/NO-GO evidence packet.

## Out of scope for Phase 1 / current Phase 2 docs pass

- Enabling live escrow money movement.
- Odoo ERP integration implementation.
- Marketing copy or pricing changes without owner approval.
- Publishing Play Store builds without explicit authorization.
- Implementing remediations in this documentation-only pass.

## Evidence standard

Per `AGENTS.md` Definition of Done: exact commands, pass/fail, platform matrix (web desktop, responsive, Android online/offline). Mark **code inspection only** where runtime tests were not run. Live DB reads via Supabase MCP are labeled as such in `06` / `09`.
