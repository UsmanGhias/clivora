# System Architecture and Testing Specification

**Product:** CLIVORA Freelancer OS  
**Platform Architecture:** Flutter Mobile (Android) + Next.js 15 Web Platform  
**Repository:** https://github.com/UsmanGhias/clivora  
**Web Repository:** https://github.com/UsmanGhias/clivora-web  
**Live Platform:** https://clivora.io  
**Lead Architect:** [Usman Ghias](https://usmanghias.co.uk)  

This document explains the architecture decisions, data synchronization models, security invariants, and automated testing methods across CLIVORA.

## 1. System context

CLIVORA operates as a unified platform across two client environments and a shared cloud backend:

- **Web**: Next.js 15 App Router (`clivora-web`), deployed on Hostinger Node.js infrastructure at `clivora.io`.
- **Android**: Flutter application (`lib/`), published on Google Play as `org.codcrafters.clivora`.
- **Backend**: Supabase (PostgreSQL 15+, Auth, Storage, Edge Functions). PostgreSQL serves as the definitive system of record.

Freelancers run CRM and invoicing operations. Clients source talent on CLIVORA Connect and track shared delivery. Contact emails remain hidden until both parties accept a Connect request. Platform fees on negotiated direct work are $0, with clients paying freelancers directly against issued invoices.

Ask AI provides contextual intelligence: an authenticated API route answering queries from indexed CRM data and operational knowledge using retrieval-augmented generation (RAG) over vector embeddings.

## 2. Architecture decisions and patterns

### 2.1 Feature-first modular structure

Flutter code is organized by domain feature (`lib/features/invoices`, `projects`, `marketplace`, etc.) alongside core infrastructure in `core/` (auth, cloud repositories, sync engine) and local persistence in `data/` (Drift SQLite database). Web follows identical domain separation: App Router route groups for `/app` (workspace), `/connect` (marketplace), `/admin`, and `/api`.

**Rationale**: A comprehensive business OS contains distinct bounded workflows. Domain encapsulation prevents invoice operations from coupling to marketplace logic and maintains clean testing boundaries.

### 2.2 Repository pattern

Direct database queries are never scattered across UI widgets or components. Flutter utilizes dedicated repositories (`CloudCrmRepository`, `CloudInvoiceRepository`). Web employs domain libraries in `src/lib/crm/`, `connect.ts`, and authenticated server Supabase clients.

**Rationale**: Identical business rules and entitlement constraints must execute consistently on both mobile and web clients. Centralized repositories keep queries, data transformations, and permission checks consistent.

### 2.3 Offline-first transactional outbox (Android)

Android persists CRM and business records locally via **Drift** (type-safe SQLite). Mutations intended for the cloud route through a **sync outbox** (`sync_outbox_entries`): pending operations write to local SQLite first, then flush in chronological sequence when network connectivity is verified. Conflicted operations follow deterministic conflict resolution policies, and permanently failed entries are preserved for diagnostic review.

**Rationale**: Freelancers operate on intermittent cellular networks. Local persistence with a durable transactional outbox provides fault tolerance superior to cloud-dependent applications.

### 2.4 Cloud authorization: PostgreSQL Row Level Security (RLS)

Supabase **Row Level Security (RLS)** provides the foundational authorization boundary. Sensitive profile columns (role, account tier, permission flags) are enforced via PostgreSQL database triggers to prevent client privilege escalation. Vault share links resolve strictly against owner-scoped storage records rather than trusting client-provided file paths.

**Rationale**: Both client applications are untrusted execution environments. Enforcing security policies directly at the PostgreSQL data tier prevents unauthorized access regardless of client-side implementation.

### 2.5 Server-side web session (Backend-for-Frontend)

The Next.js web application utilizes `@supabase/ssr` with HttpOnly cookie sessions. React Server Components verify user profiles and enforce route access before page rendering. API endpoints for sensitive tasks (AI reasoning, admin operations, vault access) execute strictly in Node.js server environments.

**Rationale**: Authentication tokens and third-party API credentials (LLM providers, payment gateways, service role secrets) must never leak into client-side bundles or mobile binaries.

### 2.6 Dual-write money representation (Integer minor units)

Financial amounts on invoices are stored simultaneously as decimal currencies and integer minor units (`total_minor`, `subtotal_minor`). Currency conversion utilities are tested against floating-point edge cases.

**Rationale**: Floating-point rounding anomalies in financial calculations create audit failures. Integer minor units provide mathematical precision across all currency calculations.

### 2.7 Entitlement policies

Usage policies across subscription tiers are defined as pure functions in `plan-gates.ts` on web and mirrored in Flutter `PlanLimits`. Write access to marketplace connect flows requires verified Pro Plus accounts.

**Rationale**: Access limits must exist as deterministic policy rules rather than superficial UI conditional checks.

### 2.8 CI/CD automated validation

GitHub Actions automated workflows execute on pushes to `main` and pull requests:

- Flutter: `flutter analyze` and `flutter test`
- Web: `npm run typecheck`, `npm run lint`, `npm test`, `npm run build`
- Android releases: Version-tagged pushes trigger automated APK and AAB build jobs with signature verification.

## 3. Deployment architecture and infrastructure

| Layer | Environment | Characteristics |
|---|---|---|
| **Web Platform** | Hostinger Node.js Runtime | Next.js 15 SSR with automated deployment, caching, and health monitors |
| **Database & Auth** | Supabase Enterprise Cloud | Managed PostgreSQL, connection pooling (PgBouncer), RLS policies, and encrypted storage |
| **Mobile Client** | Google Play Store | Android AAB distribution with Play Integrity verification |
| **DNS & Edge** | Cloudflare / Hostinger DNS | SSL termination, DDoS mitigation, and HTTP/2 transport |

## 4. Testing framework

### 4.1 Automated mobile tests (Flutter)

| Suite | Verified behavior | Testing strategy |
|---|---|---|
| `test/database_test.dart` | Local SQLite insertions, queries, and customer counts | In-memory SQLite (`NativeDatabase.memory`) |
| `test/sync_outbox_service_test.dart` | Outbox schema transitions, error states, and payload serialization | Unit tests on `AppDatabase.forTesting` |
| `test/widget_test.dart` | Initial boot lifecycle and base application tree | Flutter widget test |
| `test/notification_deep_link_test.dart` | Deep link route parsing and payload redirection | Unit and route verification |

### 4.2 Automated web tests (Vitest)

| Suite | Verified behavior | Testing strategy |
|---|---|---|
| `src/lib/money.test.ts` | Currency minor unit conversion and dual-write logic | Vitest unit tests |
| `src/lib/plan.test.ts` | Plan tier validation and permission predicates | Vitest unit tests |
| `src/lib/plan-gates.test.ts` | Tier quota enforcement and monthly limits | Vitest unit tests |
| `src/lib/crm-rag.test.ts` | Embedding chunk formatting and query sanitization | Vitest unit tests |

### 4.3 Database security invariants (`supabase/tests/security_invariants.sql`)

A suite of catalog-level SQL assertions enforcing production database invariants:

1. No table is readable anonymously without explicit caller identity filters.
2. Trigger functions are inaccessible via public PostgREST RPC endpoints.
3. Automated cron routines cannot be triggered by arbitrary client calls.
4. Every `SECURITY DEFINER` function explicitly pins its `search_path`.
5. Row Level Security is active on every table within the `public` schema.
6. Vault share expiration and quota checks are enforced directly in PostgreSQL.
7. Promotional code redemption limits are checked atomically in SQL.

Run database assertions:
```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/tests/security_invariants.sql
```

### 4.4 Static code quality gates

- Flutter: `flutter analyze` with zero warnings allowed.
- Web: TypeScript strict mode (`tsc --noEmit`) and ESLint zero warning policy.

## 5. Verification commands

```bash
# Android / Flutter
flutter analyze
flutter test

# Web platform
cd clivora-web
npm run typecheck
npm run lint
npm test
npm run build
```
