# CLIVORA Release GO / NO-GO Gate

**Decision:** **NO-GO** — production release not approved  
**Date:** 2026-07-14  
**Reason:** PR-03 remediations applied (R-16–R-18 mitigated in SQL) but residual negative tests open; High risks R-19/R-20 still OPEN; Connect credits owner decision still open (R-01); Graphify missing (R-09); evidence packet incomplete

---

## Gate criteria (all required for GO)

| # | Criterion | Status |
| --- | --- | --- |
| G-01 | Audit batches A–I executed with recorded evidence | ❌ Partial — Batch B/C docs + PR-03 evidence (`05`); runtime matrices pending |
| G-02 | Connect credits canonical spec signed by owner | ❌ OPEN (R-01) |
| G-03 | Critical journeys pass on web + Android (02-user-journeys.md) | ⏳ TO VERIFY |
| G-04 | Role × plan matrix matches server enforcement | ⏳ Partial — Connect RPC Pro Plus + CRM free caps **in SQL** (R-17, R-18); runtime matrix still TO VERIFY |
| G-05 | No critical/high risks open without acceptance | ❌ R-16–R-18 mitigated (tests open); R-01, R-19, R-20 High still OPEN |
| G-06 | Web Vercel deploy READY with correct git author | ⏳ TO VERIFY (R-02) |
| G-07 | Android release build + signing verified | ⏳ TO VERIFY |
| G-08 | Escrow/milestone copy does not imply live fund custody | ⏳ TO VERIFY |
| G-09 | Graphify baseline refreshed | ❌ Not installed |
| G-10 | Docs match verified behavior | ⏳ In progress (`00a`, `05`, `06`, `08`, `09`, `14`, `15`) |

**Verdict:** **NO-GO** until G-01–G-10 satisfied and owner approves.

### Gate notes (2026-07-14 PR-04 admin/Odoo)

- Root cause of Overview zeros: admin auth assert ignored shared Supabase fallbacks + platform REST selects used wrong column names.
- Fixes in `admin-auth.ts`, `admin-platform.ts`, Odoo sync route (platform-wide CRM → Contacts + credential PUT).
- Stored Odoo API key fails authenticate against `clivora.odoo.com` — owner must paste a fresh API key (Admin → Integrations) or update Vercel `ODOO_*`.
- Decision remains **NO-GO** until PR-04 deploy verified + High residuals closed.

### Gate notes (2026-07-14 PR-03)

- Admin read APIs no longer 503 when MFA AAL lookup fails with `requireAal2=false` (`web/src/lib/admin-auth.ts`).
- Admin overview/settings use live snapshot + `site.appVersion` (demo metrics removed).
- Odoo GET status fields clarify configuration without implying full ERP.
- Migrations applied live: `20260714_connect_require_pro_plus.sql`, `20260714_crm_free_plan_caps.sql`.

---

## Phase progress snapshot

| Phase | Status |
| --- | --- |
| Phase 1 (inventory / journeys / matrix / risks) | **Accepted** |
| Phase 2 / PR-02 (auth, roles, RLS inspection) | **Inspection complete** |
| PR-03 (server entitlements) | **Applied** — residual tests open |
| PR-04 (admin live data, Odoo, offline start) | **In progress** — code fixed; deploy + valid Odoo key pending |
| **PR-03** (Connect Pro Plus RPCs, CRM free caps, admin honesty) | **Applied** — residual verification tests open (`05`) |
| PR-01, PR-04–PR-10; Batch I (Vercel author R-02) | Not started / out of band as noted |

---

## Proposed work packages (PR-01 .. PR-10)

Bounded PRs for audit remediation.

| PR | Title | Scope | Risks addressed | Depends on |
| --- | --- | --- | --- | --- |
| **PR-01** | Graphify install + baseline graph | Install Graphify; generate `graphify-out/`; reconcile with `01-system-inventory.md` | R-09 | — |
| **PR-02** | Connect credits canonical alignment | Owner credit decision; align docs/web/Android/tests to live SQL numbers | R-01 | Owner sign-off |
| **PR-03** | Server entitlements + admin honesty | `connect_require_pro_plus`; CRM free-cap triggers; admin AAL read path; live admin metrics; Odoo status clarity | R-17, R-18, R-13 (partial), R-16 (earlier) | **Applied** — see `05`, `08`; tests open |
| **PR-04** | Web settings UI layout fix | `FreelancerSettingsPanel`, `ClientSettingsPanel` responsive nav/content grid | R-07 | — |
| **PR-05** | Header avatar sync | Profile upload → `profiles.avatar_url` → `UserAvatar` in `AppShell`; Android parity | R-03 | Migration applied |
| **PR-06** | Mobile hub truncation fix | Flutter `more_screen`, `client_hub_screen`; web `/app/hub` overflow on small viewports | R-08 | — |
| **PR-07** | Meetings + Google Calendar | Jitsi room flow hardening; Calendar OAuth or honest degraded UX | R-04 | — |
| **PR-08** | Stripe optional billing path | Env-gated checkout/portal/webhook; reconciliation; keep `/pro` manual fallback | R-10 | Owner approval to enable |
| **PR-09** | Security + promo + RLS tests | Chat storage private; payment-request insert harden; RLS matrix + negative tests for R-16–R-18; promo; time-entry sync | R-12, R-14–R-15, R-19–R-21 | PR-03 applied |
| **PR-10** | Release evidence + GO/NO-GO packet | Run audit batches; Vercel author (R-02); fill journeys; owner review | All | PR-01–PR-09 as needed |

---

## Suggested merge order

```
PR-09 (security: R-19, R-20 + negative tests for R-16–R-18) ──┬── PR-02 (canonical credits R-01)
PR-01 (graph) ────────────────────────────────────────────────┤
PR-03 (applied) ─┬── PR-04, PR-05, PR-06 (UI) ── PR-07, PR-08
                 └────────────────────────────── PR-10 (gate + R-02 deploy)
```

PR-03 entitlement remediations are **applied**. Remaining High blockers: R-01, R-19, R-20 (plus verification of R-16–R-18). Hotfixes **PR-04, PR-05, PR-06** may land in parallel if out-of-band work already in progress.

---

## Out-of-band work (track separately)

These streams are active concurrent to the audit; merge evidence into PR-10:

- Settings UI hotfix
- Play Store promo / `promo_codes`
- Mobile hub command-center polish

---

## GO decision record (template)

When audit completes, fill:

| Field | Value |
| --- | --- |
| Decision | GO / NO-GO / GO with conditions |
| Date | |
| Approver | |
| Web commit / Vercel deployment ID | |
| Android version + tag | |
| Migrations applied through | |
| Open risks accepted | |
| Rollback plan | `docs/runbooks/releases.md` |

---

## Rollback readiness (preliminary)

| Surface | Rollback | Verified |
| --- | --- | --- |
| Web | Vercel previous deployment / `clivora-web` revert | ⏳ TO VERIFY |
| Database | Forward-fix migration only (no edit applied migrations) | Policy documented |
| Android | Halt staged rollout; prior AAB if published | ⏳ TO VERIFY |

**Current decision: NO-GO.**
