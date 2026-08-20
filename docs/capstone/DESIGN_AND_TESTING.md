# Design and testing document

**Product:** CLIVORA Freelancer OS  
**Capstone:** Quantic MSSE  
**Repository:** https://github.com/UsmanGhias/clivora  
**Live:** https://clivora.io  
**Author:** Usman Ghias (Product Owner)

This document is the handbook-required design and testing paper. It explains architecture decisions and testing methods used on CLIVORA, including why those choices were made.

## 1. System context

CLIVORA is one product with two clients and one cloud backend:

- **Web** — Next.js 15 App Router (`web/`), deployed as a Node.js app on Hostinger at `clivora.io`.
- **Android** — Flutter (`lib/`), published on Google Play as `org.codcrafters.clivora`.
- **Backend** — Supabase (PostgreSQL, Auth, Storage, Edge Functions). Postgres is the system of record.

Freelancers run CRM and invoicing. Clients hire on Connect and track shared work. Emails stay hidden until both sides accept a Connect request. Platform fee on negotiated deals is $0; clients pay freelancers directly against the invoice.

Ask AI is a Pro feature: a server route that answers from CRM context and product knowledge. Completing retrieval-augmented generation (RAG) over `crm_embeddings` is Capstone Sprint 2.

## 2. Architecture decisions and patterns

### 2.1 Modular / feature-first application structure

Flutter code is grouped by feature (`lib/features/invoices`, `projects`, `marketplace`, …) with shared `core/` (auth, cloud repositories, sync) and `data/` (Drift database). Web follows the same idea: App Router areas for `/app` (workspace), `/connect` (marketplace), `/admin`, and `/api`.

**Why:** A freelancer OS has many bounded workflows. Feature folders keep invoices from mixing with Connect, which matches how sprints and user stories are sliced.

### 2.2 Repository pattern

Cloud access is not scattered through widgets. Flutter uses repositories such as `CloudCrmRepository` and `CloudInvoiceRepository`. Web uses `web/src/lib/crm/`, `connect.ts`, and server Supabase clients.

**Why:** The same business rules must hold on web and Android. Repositories are the place to keep queries, mapping, and entitlement checks consistent.

### 2.3 Offline-first + sync outbox (Android)

Android persists CRM locally with **Drift** (type-safe SQLite). Changes that must reach the cloud go through a **sync outbox** (`sync_outbox_entries`): pending operations are stored, then flushed when online. Failed unknown kinds can be marked `permanently_failed` and retained for diagnosis. Conflict records exist for last-write-wins cases.

**Why:** Freelancers work on mobile networks. Local-first with an outbox is more reliable than “online only,” and it is a real differentiator versus a web-only CRM. Pattern: *transactional outbox* adapted to a mobile client.

### 2.4 Cloud authorization: row-level security

Supabase **Row Level Security (RLS)** is the authorization layer. Privileged profile columns (role, account type, plan flags) are protected by database triggers so a client cannot self-elevate. Vault share links resolve owner-scoped files rather than trusting a raw path from the caller.

**Why:** Both Flutter and Next.js are untrusted clients. Enforcing access in Postgres is safer than hiding buttons. Pattern: *authorization in the data layer*.

### 2.5 Server-side web session (BFF-style)

The Next.js app uses `@supabase/ssr` cookie sessions. Server Components load the profile and gate routes. API routes (Ask AI, admin, vault) run on the Node server, not in the browser.

**Why:** Session cookies and service-side secrets (LLM keys, service role) must not ship in the Android APK or the browser bundle. Pattern: *Backend-for-Frontend* for the web app.

### 2.6 Dual-write money (integer minor units)

Invoice amounts are stored as major-unit numbers **and** integer minor units (`total_minor`, etc.). Helpers live in `web/src/lib/money.ts` and are unit-tested.

**Why:** Floating-point currency bugs are unacceptable for invoices. Dual-write lets us migrate without a flag-day cutover. Pattern: *expand/contract* data migration.

### 2.7 Entitlement / plan gates

Free plan caps (3 clients, 5 projects, 10 invoices/month) are encoded in `plan-gates.ts` (web) and mirrored in Flutter `PlanLimits`. Pro Plus is required for Connect write/contact actions.

**Why:** Product rules must be testable functions, not only UI copy. Pattern: *policy objects* for entitlements.

### 2.8 CI/CD pipeline

GitHub Actions on `main` / `develop`:

- Flutter: `flutter analyze` + `flutter test`
- Web: `npm run typecheck`, `lint`, **`test`**, `build`
- Android release: tag `vX.Y.Z-playstore` builds signed APK/AAB

Web production is a Node process on Hostinger (not a static export). Android uses Google Play.

**Why:** Capstone and production both need repeatable quality gates. Pattern: *continuous integration* with artifacted mobile releases.

### 2.9 AI (current vs Capstone)

**Current:** `POST /api/ai/ask` loads CRM aggregates, optionally calls OpenAI or Anthropic, and falls back to honest offline tips if no LLM key is set. Structured suggestions are feature-flagged and require human review.

**Capstone Sprint 2 (shipped, fail-open):** Ask AI retrieves keyword/recent rows from `crm_embeddings` when present, otherwise keeps CRM aggregates. Indexing is **opt-in** (`POST /api/ai/index-crm`) so live invoice/client saves are unchanged. Eval set: [ASK_AI_EVAL.md](./ASK_AI_EVAL.md). Human review forbids `auto_pay` / `auto_publish`. The optional `match_crm_embeddings` SQL is in the repo and is **not** applied to production until a maintenance window.

**Why:** Aggregates are useful but shallow. RAG is the AI-engineering technique that grounds answers in the user’s own invoices and projects.

## 3. Recommended deployment and relative cost

| Option | What it would mean | Relative cost | Recommendation |
|---|---|---|---|
| **Current cloud (chosen)** | Hostinger Node for Next.js + Supabase cloud + Google Play hosting for Android | Low–moderate. Free/Pro Hostinger Node, Supabase free/pro tier, Play Console one-time + % on in-app purchases. No extra Kubernetes bill. | **Use this for Capstone and early production.** Matches a small SaaS, already live. |
| **Heavier public cloud** | Same app on AWS/GCP (ECS/Cloud Run + RDS + S3) | Higher ops time and usually higher monthly cost at this traffic level | Only if we outgrow Hostinger/Supabase limits. |
| **On-premises** | Customer-hosted Postgres + Node + sideloaded Android | High: hardware, TLS, backups, Play/enterprise MDM, 24/7 ops. Wrong fit for a two-sided marketplace (Connect needs a shared network). | **Not recommended** for CLIVORA’s marketplace. Could be offered later as a private CRM appliance for one agency, at much higher support cost. |

**Decision:** keep **cloud**. Marketplace matching, Google login, and Play Billing assume a shared internet service. On-prem would not reduce cost for this product; it would multiply it.

## 4. Testing implemented

### 4.1 Automated unit tests (Flutter)

| File | What it proves | Method |
|---|---|---|
| `test/database_test.dart` | Drift can insert/read customers and count invoices for a user | In-memory SQLite (`NativeDatabase.memory`) |
| `test/sync_outbox_service_test.dart` | Outbox schema, pending vs `permanently_failed`, payload migration | Unit tests on `AppDatabase.forTesting` |
| `test/widget_test.dart` | App boots to the CLIVORA splash | Widget test |
| `test/notification_deep_link_test.dart` | Notification deep links route correctly | Unit/widget |

**Why these methods:** Offline sync is the riskiest Android subsystem. In-memory Drift tests are fast and do not need a device or cloud credentials.

### 4.2 Automated unit tests (web)

| File | What it proves | Method |
|---|---|---|
| `web/src/lib/money.test.ts` | Minor-unit conversion and invoice dual-write fields | Vitest |
| `web/src/lib/plan.test.ts` | Pro / Pro Plus / client detection | Vitest |
| `web/src/lib/plan-gates.test.ts` | Free-plan create caps and UTC month invoice counting | Vitest |
| `web/src/lib/crm-rag.test.ts` | Chunk formatting, ilike sanitization, index text without inventing amounts | Vitest |

**Why:** Money and plan gates are pure functions with high blast radius. They are cheaper and more stable to unit-test than full UI.

### 4.3 Static analysis

- Flutter: `flutter analyze lib/`
- Web: TypeScript `tsc --noEmit` and ESLint `--max-warnings=0`

**Why:** Catch type and lint errors before they reach Hostinger or Play.

### 4.4 CI execution

On every push/PR to `main` or `develop`, GitHub Actions runs the Flutter and web jobs above, including `npm test`. Tag-driven Android jobs re-run analyze/test before signing.

**Why:** Tests that never run in CI do not count as engineering evidence.

### 4.5 Manual / exploratory testing (production)

- Public marketing pages and docs on `clivora.io`
- Authenticated freelancer and client workspaces
- Connect accept/decline and invoice public share links
- Android install from Play Store (offline CRM cache)

These are **not** a substitute for automation. They are used for release smoke checks.

### 4.6 Tests planned in remaining Capstone sprints (not yet complete)

| Gap | Planned method | Sprint |
|---|---|---|
| Web critical journeys (login, Connect accept, invoice share) | Playwright E2E against a staging/local stack | 1–3 |
| Outbox process-death / account-switch | Flutter integration tests | 1–2 |
| Ask AI grounded answers | Golden eval set (questions → expected citations) | 2 |

Internal risk `QA-001` (web E2E) remains open; Capstone Sprint 1 started closing the unit-test and CI gap.

## 5. How to run tests

```bash
# Android / Flutter
flutter test

# Web
cd web && npm test
```

## 6. Traceability

User stories for the Capstone increment are in [USER_STORIES.md](./USER_STORIES.md). Architecture choices above are implemented in `lib/`, `web/src/`, and `supabase/migrations/` as of the Capstone start (Flutter version `5.3.10` in `pubspec.yaml` / `web/src/lib/site.ts`).
