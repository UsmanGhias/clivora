# CLIVORA Production Readiness — Audit Plan (Phase 1)

**Status:** Proposed · not executed in this pass  
**Graphify:** **Not installed** — `graphify-out/` absent in repo (gap per `AGENTS.md` mandate)

## Prerequisites

| Item | Status |
| --- | --- |
| Read `AGENTS.md`, product docs, web-android contracts | Done (baseline docs) |
| Install / refresh Graphify knowledge graph | **GAP — not done** |
| Staging Supabase with migration replay | TO VERIFY |
| CI web build + Android release build | TO VERIFY |

## Proposed verification batches

Execute in order; record commands, outputs, and screenshots in an evidence folder (not created yet).

### Batch A — Inventory & graph (PR-01)

- Install Graphify per `AGENTS.md`; generate `graphify-out/`.
- Cross-check graph edges against `01-system-inventory.md` (routes, tables, RPC callers).
- Flag INFERRED vs EXTRACTED relationships; verify risky inferences in code.

### Batch B — Auth, roles, RLS (PR-09)

- Guest redirect, login/signup, blocked/restricted account paths (web + Android).
- RLS matrix: anonymous, owner, participant, admin sessions on `profiles`, `crm_*`, `connect_*`, `client_messages`.
- Admin route protection (`web/src/app/admin/`, `web/src/app/api/admin/*`).

### Batch C — Plans & Connect credits (PR-02)

- Owner decision on canonical credit allowances and action costs.
- Align `docs/product/plans-and-entitlements.md`, `web/content/docs/connect.md`, Supabase RPCs (`connect_publish_*`, `connect_send_request`, `connect_submit_proposal`), `web/src/lib/plan-gates.ts`, Android plan gates.
- Parallel credit spend / idempotency scenarios.

### Batch D — CRM & offline sync (PR-09)

- Web CRM CRUD against `crm_*` tables.
- Android Drift cache + `supabase_sync_service` outbox; reconnect conflict behavior.
- **Known gap (internal audit 2026-07-13):** mobile time tracking local-only vs `crm_time_entries` — TO VERIFY.

### Batch E — Messaging, shares, billing (PR-08)

- Messages (`client_messages`), notifications, invoice share `/i/[token]`.
- Android Play Billing; web `/pro` manual path; Stripe routes (`web/src/app/api/stripe/*`) when `STRIPE_ENABLED`.
- Pro payment requests (`pro_payment_requests`).

### Batch F — Connect marketplace (PR-02)

- Browse (all signed-in), publish/contact (Pro Plus + credits), privacy until mutual accept.
- Freelancer one open need; client job posting wording.
- Admin moderation surfaces (read-only vs actionable — TO VERIFY).

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

## Out of scope for Phase 1

- Enabling live escrow money movement.
- Odoo ERP integration implementation.
- Marketing copy or pricing changes without owner approval.
- Publishing Play Store builds without explicit authorization.

## Evidence standard

Per `AGENTS.md` Definition of Done: exact commands, pass/fail, platform matrix (web desktop, responsive, Android online/offline). Mark **code inspection only** where runtime tests were not run.
