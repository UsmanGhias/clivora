# CLIVORA Production Readiness — Executive Summary

**Status:** AUDIT IN PROGRESS · Phase 1 accepted · PR-03 remediations applied (residual tests open)  
**Prepared:** 2026-07-14  
**Product baseline:** Web `2.20.0` (package.json) · Android `3.8.1+81` (pubspec.yaml)  
**GO/NO-GO:** **NO-GO** — R-16–R-18 mitigated in SQL; R-01/R-19/R-20 and verification tests still block

## Purpose

Phase 1 establishes an evidence-backed inventory, journey checklist, permission matrix, risk register, and release gate. No production release decision is made in this pass.

## Scope

| Surface | Location | Notes |
| --- | --- | --- |
| Web app | `web/` (Next.js 15) | Deployed via `UsmanGhias/clivora-web` → Vercel |
| Android app | `lib/`, `android/` (Flutter) | Package `org.codcrafters.clivora` |
| Admin console | `web/src/app/admin/` | Same Next.js deploy; privileged routes |
| Database | `supabase/migrations/` (33 files) | Supabase Postgres + RLS |
| Docs | `docs/`, `web/content/docs/` | Product + public docs |

## Concurrent hotfixes (shipped on branch; not full audit sign-off)

Shipped in commit `5b946f8` / web mirror `99fcd14` — still require QA evidence in later batches:

- **Settings Account layout** — plan box stacked under profile (no overlap)
- **Play Store promo** — marketing homepage section (`PlayStorePromoSection`)
- **Android home** — 3 KPI cards; duplicate secondary stats removed; Hub width/aspect improved
- **Odoo** — Contacts-only sync API (env secrets required; no new Odoo apps)
- **Release artifacts** — `clivora-3.8.1.apk` / `.aab` under `/opt/cursor/artifacts`

## Phase 1 deliverables (this folder)

| Doc | Purpose |
| --- | --- |
| `00a-audit-plan.md` | Proposed verification batches |
| `01-system-inventory.md` | Apps, routes, tables, services |
| `02-user-journeys.md` | Persona journey checklist (TO VERIFY) |
| `03-role-plan-permission-matrix.md` | Plans × roles × actions |
| `05-pr03-remediation-evidence.md` | PR-03 path-only evidence (R-16–R-18, admin honesty) |
| `08-billing-entitlements.md` | Connect Pro Plus + CRM free caps note |
| `14-risk-register.md` | Risks and owners |
| `15-release-go-no-go.md` | Release gate + work packages PR-01..PR-10 |

## Known blockers (preliminary)

1. **Connect credits** — published docs disagree on allowances and costs ([OPEN PRODUCT DECISION](03-role-plan-permission-matrix.md)) — **R-01**.
2. **Graphify** — `graphify-out/` not present; knowledge graph not installed ([gap](00a-audit-plan.md)).
3. **Escrow** — schema exists; live money movement disabled per product policy.
4. **Stripe web billing** — API routes present; enablement optional / env-gated.
5. **Google Calendar OAuth** — UI stubbed; not fully live (`MeetingsClient.tsx`).
6. **R-19 / R-20** — open payment-request insert; chat attachments public read (see `09`).

## Verification stance

- Inventory items are **filesystem-derived** (routes, migrations, package versions).
- Journey pass/fail is **TO VERIFY** unless cited from a dated internal audit with explicit evidence.
- No fabricated test results, user counts, or revenue claims.

## Next steps

1. Execute audit batches in `00a-audit-plan.md`.
2. Resolve Connect credits canonical spec with owner sign-off.
3. Complete PR-01..PR-10 work packages in `15-release-go-no-go.md`.
4. Re-run GO/NO-GO gate with evidence packet.
