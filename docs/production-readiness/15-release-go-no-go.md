# CLIVORA Release GO / NO-GO Gate

**Decision:** **NO-GO** — production release not approved  
**Date:** 2026-07-14  
**Reason:** Phase 2 / PR-02 in progress; Critical/High auth & RLS risks verified (R-16–R-20); Connect credits owner decision still open (R-01); evidence packet incomplete

---

## Gate criteria (all required for GO)

| # | Criterion | Status |
| --- | --- | --- |
| G-01 | Audit batches A–I executed with recorded evidence | ❌ Partial — Batch B docs started (`04`, `06`, `09`); runtime matrices pending |
| G-02 | Connect credits canonical spec signed by owner | ❌ OPEN (R-01) |
| G-03 | Critical journeys pass on web + Android (02-user-journeys.md) | ⏳ TO VERIFY |
| G-04 | Role × plan matrix matches server enforcement | ❌ Fail — CRM UI-only; Connect RPC Pro Plus gap (R-17, R-18) |
| G-05 | No critical/high risks open without acceptance | ❌ R-16 Critical + multiple High OPEN |
| G-06 | Web Vercel deploy READY with correct git author | ⏳ TO VERIFY |
| G-07 | Android release build + signing verified | ⏳ TO VERIFY |
| G-08 | Escrow/milestone copy does not imply live fund custody | ⏳ TO VERIFY |
| G-09 | Graphify baseline refreshed | ❌ Not installed |
| G-10 | Docs match verified behavior | ⏳ In progress (`00a`, `04`, `06`, `09`, `14`, `15`) |

**Verdict:** **NO-GO** until G-01–G-10 satisfied and owner approves.

---

## Phase progress snapshot

| Phase | Status |
| --- | --- |
| Phase 1 (inventory / journeys / matrix / risks) | **Accepted** |
| Phase 2 / PR-02 (auth, roles, RLS) | **In progress** — inspection findings recorded; remediations not shipped |
| PR-01, PR-03–PR-10 | Not started / out of band as noted |

---

## Proposed work packages (PR-01 .. PR-10)

Bounded PRs for audit remediation.

| PR | Title | Scope | Risks addressed | Depends on |
| --- | --- | --- | --- | --- |
| **PR-01** | Graphify install + baseline graph | Install Graphify; generate `graphify-out/`; reconcile with `01-system-inventory.md` | R-09 | — |
| **PR-02** | Connect credits + entitlement server alignment | Owner credit decision; harden Connect RPCs (Pro Plus); CRM server caps or product change; docs | R-01, R-17, R-18 | Owner sign-off |
| **PR-03** | Vercel deploy identity + CI evidence | Git author hook/docs; web `build` + `typecheck` + `lint` in CI; deploy checklist | R-02 | — |
| **PR-04** | Web settings UI layout fix | `FreelancerSettingsPanel`, `ClientSettingsPanel` responsive nav/content grid | R-07 | — |
| **PR-05** | Header avatar sync | Profile upload → `profiles.avatar_url` → `UserAvatar` in `AppShell`; Android parity | R-03 | Migration applied |
| **PR-06** | Mobile hub truncation fix | Flutter `more_screen`, `client_hub_screen`; web `/app/hub` overflow on small viewports | R-08 | — |
| **PR-07** | Meetings + Google Calendar | Jitsi room flow hardening; Calendar OAuth or honest degraded UX | R-04 | — |
| **PR-08** | Stripe optional billing path | Env-gated checkout/portal/webhook; reconciliation; keep `/pro` manual fallback | R-10 | Owner approval to enable |
| **PR-09** | Security + promo + RLS tests | Profile privileged-column lock; chat storage private; payment-request insert harden; RLS matrix tests; promo; time-entry sync | R-12, R-14–R-21 | PR-02 for credit tests |
| **PR-10** | Release evidence + GO/NO-GO packet | Run audit batches; fill `02-user-journeys.md`; update risk register; owner review | All | PR-01–PR-09 as needed |

---

## Suggested merge order

```
PR-09 (security hotfixes: R-16, R-19, R-20) ──┬── PR-02 (credits + RPC/CRM entitlements)
PR-01 (graph) ────────────────────────────────┤
PR-03 (deploy) ─┬── PR-04, PR-05, PR-06 (UI) ── PR-07, PR-08
                └────────────────────────────── PR-10 (gate)
```

Security hotfixes for R-16 / R-19 / R-20 should precede broad Connect enablement. Hotfixes **PR-04, PR-05, PR-06** may land in parallel if out-of-band work already in progress.

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
