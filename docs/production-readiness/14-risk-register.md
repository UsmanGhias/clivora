# CLIVORA Risk Register

**Status:** Phase 2 / PR-03 remediations · 2026-07-14  
**Review cadence:** Update after each audit batch and before GO/NO-GO  
**Evidence:** `05-pr03-remediation-evidence.md`, `08-billing-entitlements.md`

| ID | Risk | Category | Likelihood | Impact | Mitigation / work package | Owner | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| R-01 | **Connect credit docs conflict** — allowances and action costs differ across product docs, public docs, release notes, and stabilization notes. Live SQL uses Free 5 / Pro 30 / Pro Plus 100 and costs 1/1/3 | Product / billing | High | High | Owner canonical spec; align docs, web, Android, tests ([PR-02](15-release-go-no-go.md)) | Product owner | **OPEN** |
| R-02 | **Vercel deploy author email** — commits with non-allowlisted author (e.g. `usman@codcrafters.org`) can block Vercel production deploys | DevOps | Medium | High | Enforce `Usman Ghias <usmanghias1@gmail.com>` per `AGENTS.md`, `docs/runbooks/releases.md` (Batch I / deploy hygiene) | Engineering | **OPEN** |
| R-03 | **Header avatar sync** — `profiles.avatar_url` added in migration `20260713_profiles_avatar_url.sql`; web `UserAvatar` / `AppShell` may not reflect updates consistently across surfaces | UX / data | Medium | Medium | Verify upload → profile row → header refresh on web and Android ([PR-05](15-release-go-no-go.md)) | Frontend | **OPEN** |
| R-04 | **Google Calendar OAuth not live** — `MeetingsClient.tsx` shows stub messaging; users may expect two-way sync | Integrations | High | Medium | Complete OAuth wiring or clarify UX copy; manual Jitsi fallback documented ([PR-07](15-release-go-no-go.md)) | Engineering | **OPEN** |
| R-05 | **Escrow disabled but surfaced** — `connect_escrow_ledger`, admin escrow pages, and milestone “funded” labels may imply money held when live movement is off | Compliance / trust | Medium | High | Keep tracking-only labels; audit copy on web, admin, Connect; no enablement without compliance sign-off | Product + legal | **OPEN** |
| R-06 | **Odoo partial** — Contacts sync API exists; full ERP not wired. Status GET now reports configured/source/missing | Scope / expectations | Low | Medium | Avoid marketing “full Odoo” claims; status UX clarified in PR-03 (`05`) | Product | **MONITOR** — Contacts sync + status clarity; full ERP still not in scope |
| R-07 | **Settings layout bug** — concurrent hotfix on `FreelancerSettingsPanel` / `ClientSettingsPanel`; responsive tab layout may break on some viewports | UX | Medium | Medium | Visual QA on settings routes; fix grid/nav ([PR-04](15-release-go-no-go.md)) | Frontend | **OPEN** |
| R-08 | **Mobile hub truncation** — command-center text/layout in Flutter `more_screen`, `client_hub_screen` and web `/app/hub` may clip on small screens | UX / mobile | Medium | Medium | Test small devices; fix overflow ([PR-06](15-release-go-no-go.md)) | Mobile + web | **OPEN** |
| R-09 | **Graphify not installed** — no `graphify-out/`; impact analysis relies on manual exploration | Process | High | Medium | Install Graphify per `AGENTS.md` ([PR-01](15-release-go-no-go.md)) | Engineering | **OPEN** |
| R-10 | **Stripe optional path** — checkout/portal/webhook code exists; misconfiguration could charge or fail silently | Payments | Medium | High | Fail-closed env gates; reconciliation tests before enablement ([PR-08](15-release-go-no-go.md)) | Payments | **OPEN** |
| R-11 | **Android/web version skew** — `web/package.json` `2.20.0` vs `pubspec.yaml` `3.8.0+80` | Release | Medium | Low | Document intentional versioning; verify feature parity matrix | Release mgr | **MONITOR** |
| R-12 | **Mobile time sync gap** — prior audit: local SQLite time tracking may not sync to `crm_time_entries` | Data integrity | Medium | Medium | Verify in Batch D; fix or document intentional difference | Mobile | **TO VERIFY** |
| R-13 | **Admin surfaces honesty** — overview/settings previously showed demo charts / fake storage / fake cache version | Ops | Medium | Low | Live snapshot + `site.appVersion` ([PR-03](05-pr03-remediation-evidence.md)); export/save still TO VERIFY | Admin | **MITIGATED** (metrics honesty) — export/settings-save still TO VERIFY |
| R-14 | **Play Store promo hotfix** — `promo_codes` and v215 migrations in flight; billing edge cases | Payments | Medium | Medium | Test promo redemption with Play Billing ([PR-09](15-release-go-no-go.md)) | Mobile | **OPEN** |
| R-15 | **RLS / auth regression** — large migration surface; role matrix not fully automated; Connect policies live but stubbed in repo `017` | Security | High | High | Staging replay + RLS tests; codify remote policies into migrations ([PR-09](15-release-go-no-go.md)); see `06` | Security | **OPEN** (partially verified) |
| R-16 | **Profiles privileged self-update** — `profiles_update_own` + trigger that does not lock `subscription_plan` / `is_blocked` / `is_restricted` | Security | High | Critical | Column-protecting trigger or revoke update on privileged columns; regression test ([PR-09](15-release-go-no-go.md)) | Security | **MITIGATED** — `profiles_guard_privileged_columns` applied 2026-07-14 (verify with negative test still open) |
| R-17 | **Connect RPC Pro Plus bypass** — SECURITY DEFINER publish/contact/proposal RPCs spend credits without `is_pro_plus()`; table RLS Pro Plus not applied inside definer | Security / billing | High | High | Enforce plan inside RPCs; keep RLS ([PR-03](05-pr03-remediation-evidence.md)) | Backend | **MITIGATED** — `20260714_connect_require_pro_plus.sql` applied live (negative/role-matrix tests still open) |
| R-18 | **CRM free caps UI-only** — `plan-gates.ts` only; `crm_*` RLS has no count/plan limits | Billing / abuse | High | High | Server triggers ([PR-03](05-pr03-remediation-evidence.md) / `08-billing-entitlements.md`) | Backend + Product | **MITIGATED** — `20260714_crm_free_plan_caps.sql` applied live (cap verification tests still open) |
| R-19 | **Open `pro_payment_requests` insert** — anon+authenticated `WITH CHECK (true)` | Security / abuse | High | Medium | Require auth + ownership fields; rate-limit; drop anon insert | Backend | **OPEN** — verified (advisor) |
| R-20 | **Chat attachments public read** — `chat_attachments_public_read` still live; advisor public listing | Privacy | High | High | Re-apply private bucket policies from `010_chat_storage_private.sql`; remove public SELECT | Backend | **OPEN** — verified live |
| R-21 | **Android restricted-state gap** — blocked handled on login; `is_restricted` not clearly gated on client beyond server credit eligibility | Security / product | Medium | Medium | Mirror web Connect restricted UX; verify routes | Mobile | **TO VERIFY** |

---

## Risk acceptance rules (release gate)

- **No GO** while R-01 unresolved if Connect write paths ship to production.
- **No GO** while R-05 copy implies held funds without compliance approval.
- **No GO** on web deploy if R-02 blocks Vercel (author or build failure).
- **No GO** while R-16 / R-17 / R-18 remediations lack negative-test evidence (mitigated in SQL; verification still open).
- **No GO** while R-19 or R-20 remain unmitigated (High auth/privacy).
- **No GO** while R-20 public chat media listing remains (privacy).

---

## Escalation

| Severity | Examples | Action |
| --- | --- | --- |
| Critical | Data leak, auth bypass, plan self-escalation (R-16 residual) | Stop release; hotfix branch |
| High | R-01, R-05, R-15, R-19–R-20 confirmed; R-17/R-18 verification fail | Block GO/NO-GO |
| Medium | R-03–R-08, R-10, R-21 | Fix in planned PR or document workaround |
| Low | R-11, R-13 residual | Monitor; document |

No secrets, exploit steps, or internal security implementation details belong in this register.
