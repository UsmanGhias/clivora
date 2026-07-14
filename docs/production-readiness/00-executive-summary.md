# CLIVORA Production Readiness — Executive Summary

**Status:** AUDIT IN PROGRESS · Phase 1 baseline  
**Prepared:** 2026-07-14  
**Product baseline:** Web `2.20.0` (package.json) · Android `3.8.0+80` (pubspec.yaml)  
**GO/NO-GO:** **Not yet determined** — audit batches incomplete

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

## Concurrent work (out of band)

The following hotfixes are in flight **outside** this audit baseline and are **not verified** here:

- **Settings UI** — web freelancer/client settings panels (`FreelancerSettingsPanel`, `ClientSettingsPanel`)
- **Play Store promo** — promo codes / billing surfaces (migrations `promo_codes`, `20260711_v215_*`)
- **Mobile hub** — web `/app/hub` and Flutter `more_screen` / `client_hub_screen` command-center layouts

Treat these as parallel streams; reconcile into the audit when merged.

## Phase 1 deliverables (this folder)

| Doc | Purpose |
| --- | --- |
| `00a-audit-plan.md` | Proposed verification batches |
| `01-system-inventory.md` | Apps, routes, tables, services |
| `02-user-journeys.md` | Persona journey checklist (TO VERIFY) |
| `03-role-plan-permission-matrix.md` | Plans × roles × actions |
| `14-risk-register.md` | Initial risks and owners |
| `15-release-go-no-go.md` | Release gate + work packages PR-01..PR-10 |

## Known blockers (preliminary)

1. **Connect credits** — published docs disagree on allowances and costs ([OPEN PRODUCT DECISION](03-role-plan-permission-matrix.md)).
2. **Graphify** — `graphify-out/` not present; knowledge graph not installed ([gap](00a-audit-plan.md)).
3. **Escrow** — schema exists; live money movement disabled per product policy.
4. **Stripe web billing** — API routes present; enablement optional / env-gated.
5. **Google Calendar OAuth** — UI stubbed; not fully live (`MeetingsClient.tsx`).

## Verification stance

- Inventory items are **filesystem-derived** (routes, migrations, package versions).
- Journey pass/fail is **TO VERIFY** unless cited from a dated internal audit with explicit evidence.
- No fabricated test results, user counts, or revenue claims.

## Next steps

1. Execute audit batches in `00a-audit-plan.md`.
2. Resolve Connect credits canonical spec with owner sign-off.
3. Complete PR-01..PR-10 work packages in `15-release-go-no-go.md`.
4. Re-run GO/NO-GO gate with evidence packet.
