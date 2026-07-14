# CLIVORA Release GO / NO-GO Gate

**Decision:** **NO-GO** — production release not approved  
**Date:** 2026-07-14  
**Reason:** Phase 1 audit incomplete; evidence packet empty; open product decision on Connect credits

---

## Gate criteria (all required for GO)

| # | Criterion | Status |
| --- | --- | --- |
| G-01 | Audit batches A–I executed with recorded evidence | ❌ Not started |
| G-02 | Connect credits canonical spec signed by owner | ❌ OPEN (R-01) |
| G-03 | Critical journeys pass on web + Android (02-user-journeys.md) | ⏳ TO VERIFY |
| G-04 | Role × plan matrix matches server enforcement | ⏳ TO VERIFY |
| G-05 | No critical/high risks open without acceptance | ❌ Multiple OPEN |
| G-06 | Web Vercel deploy READY with correct git author | ⏳ TO VERIFY |
| G-07 | Android release build + signing verified | ⏳ TO VERIFY |
| G-08 | Escrow/milestone copy does not imply live fund custody | ⏳ TO VERIFY |
| G-09 | Graphify baseline refreshed | ❌ Not installed |
| G-10 | Docs match verified behavior | ⏳ In progress (this folder) |

**Verdict:** **NO-GO** until G-01–G-10 satisfied and owner approves.

---

## Proposed work packages (PR-01 .. PR-10)

Bounded PRs for audit remediation. Scope is implementation-ready but **not started** in this baseline pass.

| PR | Title | Scope | Risks addressed | Depends on |
| --- | --- | --- | --- | --- |
| **PR-01** | Graphify install + baseline graph | Install Graphify; generate `graphify-out/`; reconcile with `01-system-inventory.md` | R-09 | — |
| **PR-02** | Connect credits canonical spec | Owner decision; update `plans-and-entitlements.md`, RPCs, `connect-credits.ts`, Android gates, public docs | R-01 | Owner sign-off |
| **PR-03** | Vercel deploy identity + CI evidence | Git author hook/docs; web `build` + `typecheck` + `lint` in CI; deploy checklist | R-02 | — |
| **PR-04** | Web settings UI layout fix | `FreelancerSettingsPanel`, `ClientSettingsPanel` responsive nav/content grid | R-07 | — |
| **PR-05** | Header avatar sync | Profile upload → `profiles.avatar_url` → `UserAvatar` in `AppShell`; Android parity | R-03 | Migration applied |
| **PR-06** | Mobile hub truncation fix | Flutter `more_screen`, `client_hub_screen`; web `/app/hub` overflow on small viewports | R-08 | — |
| **PR-07** | Meetings + Google Calendar | Jitsi room flow hardening; Calendar OAuth or honest degraded UX | R-04 | — |
| **PR-08** | Stripe optional billing path | Env-gated checkout/portal/webhook; reconciliation; keep `/pro` manual fallback | R-10 | Owner approval to enable |
| **PR-09** | Security + promo + RLS tests | RLS role-matrix tests; Play promo redemption; time-entry sync verification | R-12, R-14, R-15 | PR-02 for credit tests |
| **PR-10** | Release evidence + GO/NO-GO packet | Run audit batches; fill `02-user-journeys.md`; update risk register; owner review | All | PR-01–PR-09 as needed |

---

## Suggested merge order

```
PR-01 (graph) ──┬── PR-02 (credits) ── PR-09 (security tests)
                │
PR-03 (deploy) ─┼── PR-04, PR-05, PR-06 (UI hotfixes) ── PR-07, PR-08
                │
                └────────────────────────────── PR-10 (gate)
```

Hotfixes **PR-04, PR-05, PR-06** may land in parallel with audit if out-of-band work already in progress.

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
