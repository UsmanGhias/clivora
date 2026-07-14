# CLIVORA Risk Register (Initial)

**Status:** Phase 1 baseline · 2026-07-14  
**Review cadence:** Update after each audit batch and before GO/NO-GO

| ID | Risk | Category | Likelihood | Impact | Mitigation / work package | Owner | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| R-01 | **Connect credit docs conflict** — allowances and action costs differ across product docs, public docs, release notes, and stabilization notes | Product / billing | High | High | Owner canonical spec; align RPCs, web, Android, tests ([PR-02](15-release-go-no-go.md)) | Product owner | **OPEN** |
| R-02 | **Vercel deploy author email** — commits with non-allowlisted author (e.g. `usman@codcrafters.org`) can block Vercel production deploys | DevOps | Medium | High | Enforce `Usman Ghias <usmanghias1@gmail.com>` per `AGENTS.md`, `docs/runbooks/releases.md` ([PR-03](15-release-go-no-go.md)) | Engineering | **OPEN** |
| R-03 | **Header avatar sync** — `profiles.avatar_url` added in migration `20260713_profiles_avatar_url.sql`; web `UserAvatar` / `AppShell` may not reflect updates consistently across surfaces | UX / data | Medium | Medium | Verify upload → profile row → header refresh on web and Android ([PR-05](15-release-go-no-go.md)) | Frontend | **OPEN** |
| R-04 | **Google Calendar OAuth not live** — `MeetingsClient.tsx` shows stub messaging; users may expect two-way sync | Integrations | High | Medium | Complete OAuth wiring or clarify UX copy; manual Jitsi fallback documented ([PR-07](15-release-go-no-go.md)) | Engineering | **OPEN** |
| R-05 | **Escrow disabled but surfaced** — `connect_escrow_ledger`, admin escrow pages, and milestone “funded” labels may imply money held when live movement is off | Compliance / trust | Medium | High | Keep tracking-only labels; audit copy on web, admin, Connect; no enablement without compliance sign-off | Product + legal | **OPEN** |
| R-06 | **Odoo not wired** — meeting prep docs exist (`docs/meeting/`); no ERP integration in codebase | Scope / expectations | Low | Medium | Document as planned; avoid marketing claims; separate project if pursued | Product | **OPEN** |
| R-07 | **Settings layout bug** — concurrent hotfix on `FreelancerSettingsPanel` / `ClientSettingsPanel`; responsive tab layout may break on some viewports | UX | Medium | Medium | Visual QA on settings routes; fix grid/nav ([PR-04](15-release-go-no-go.md)) | Frontend | **OPEN** |
| R-08 | **Mobile hub truncation** — command-center text/layout in Flutter `more_screen`, `client_hub_screen` and web `/app/hub` may clip on small screens | UX / mobile | Medium | Medium | Test small devices; fix overflow ([PR-06](15-release-go-no-go.md)) | Mobile + web | **OPEN** |
| R-09 | **Graphify not installed** — no `graphify-out/`; impact analysis relies on manual exploration | Process | High | Medium | Install Graphify per `AGENTS.md` ([PR-01](15-release-go-no-go.md)) | Engineering | **OPEN** |
| R-10 | **Stripe optional path** — checkout/portal/webhook code exists; misconfiguration could charge or fail silently | Payments | Medium | High | Fail-closed env gates; reconciliation tests before enablement ([PR-08](15-release-go-no-go.md)) | Payments | **OPEN** |
| R-11 | **Android/web version skew** — `web/package.json` `2.20.0` vs `pubspec.yaml` `3.8.0+80` | Release | Medium | Low | Document intentional versioning; verify feature parity matrix | Release mgr | **MONITOR** |
| R-12 | **Mobile time sync gap** — prior audit: local SQLite time tracking may not sync to `crm_time_entries` | Data integrity | Medium | Medium | Verify in Batch D; fix or document intentional difference | Mobile | **TO VERIFY** |
| R-13 | **Admin surfaces read-only** — charts, export, settings save may be decorative | Ops | Medium | Low | Label honestly in UI; prioritize audit/moderation queues per research priorities | Admin | **TO VERIFY** |
| R-14 | **Play Store promo hotfix** — `promo_codes` and v215 migrations in flight; billing edge cases | Payments | Medium | Medium | Test promo redemption with Play Billing ([PR-09](15-release-go-no-go.md)) | Mobile | **OPEN** |
| R-15 | **RLS / auth regression** — large migration surface; role matrix not fully automated | Security | Medium | High | Staging replay + RLS tests ([PR-09](15-release-go-no-go.md)) | Security | **TO VERIFY** |

---

## Risk acceptance rules (release gate)

- **No GO** while R-01 unresolved if Connect write paths ship to production.
- **No GO** while R-05 copy implies held funds without compliance approval.
- **No GO** on web deploy if R-02 blocks Vercel (author or build failure).

---

## Escalation

| Severity | Examples | Action |
| --- | --- | --- |
| Critical | Data leak, auth bypass, wrongful charges | Stop release; hotfix branch |
| High | R-01, R-05, R-15 confirmed | Block GO/NO-GO |
| Medium | R-03–R-08, R-10 | Fix in planned PR or document workaround |
| Low | R-11, R-13 | Monitor; document |

No secrets, exploit steps, or internal security implementation details belong in this register.
