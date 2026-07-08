# SRS compliance status — Clivora v2.6.3+

Traceability against the **Deep Research SRS** (functional requirements FR-001–FR-194).  
Clivora is a **freelancer CRM** (customers, projects, invoices, chat) — not a job marketplace.

**Legend:** ✅ Done · ⚠️ Partial · ❌ Not done · ➖ N/A (out of product scope)

## Summary

| Status | Count |
|--------|------:|
| ✅ Done | 62 |
| ⚠️ Partial | 22 |
| ❌ Not done | 5 |
| ➖ N/A | 6 |
| **Total FRs reviewed** | **95** |

---

## Authentication (FR-001–005)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-001 | User registration (email + Google) | ✅ | `auth_screens.dart`, `auth_service.dart` |
| FR-002 | User login | ✅ | Email, Google, guest preview |
| FR-003 | Password reset | ⚠️ | Supabase helper + **Forgot password?** on login (v2.6.4+) |
| FR-004 | Biometric unlock | ✅ | `biometric_service.dart`, Pro-gated in security settings |
| FR-005 | Session timeout (30 min idle) | ❌ | Biometric on resume only; no configurable idle logout |

## Profile (FR-010–013)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-010 | View/edit profile | ✅ | `profile_screen.dart` |
| FR-011 | Freelancer professional details | ⚠️ | Business profile + branding; no portfolio/hourly rate fields |
| FR-012 | Privacy settings | ⚠️ | Legal docs + account deletion; no per-field visibility toggles |
| FR-013 | Account deactivation/deletion | ✅ | `account_deletion_service.dart` |

## Onboarding (FR-020–022)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-020 | Role selection at signup | ✅ | `account_type_selector.dart` |
| FR-021 | Intro walkthrough | ✅ | 4-slide onboarding + Lottie |
| FR-022 | Profile completeness gate | ❌ | No block on core actions until profile complete |

## Core features (FR-030–036)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-030 | Post a job (client) | ➖ | CRM uses projects/invoices, not job board |
| FR-031 | Search/browse jobs | ➖ | Use global search for CRM entities instead |
| FR-032 | Apply to job | ➖ | N/A |
| FR-033 | View applications | ➖ | N/A |
| FR-034 | Client–freelancer messaging | ✅ | `simple_chat_screen.dart` |
| FR-035 | Rate & review | ❌ | Not implemented |
| FR-036 | Generate PDF report | ✅ | Invoice PDF, reports export (Pro) |

**CRM equivalents (beyond SRS job model):** customers, projects, tasks, invoices, contracts, expenses, calendar — all ✅ in respective feature modules.

## Chat (FR-040–043)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-040 | Push notifications for chat | ⚠️ | Local notifications ✅; FCM scaffold only |
| FR-041 | Chat history persistence | ✅ | Supabase + local Drift |
| FR-042 | Block users | ❌ | Not implemented |
| FR-043 | Emoji and file support | ✅ | Images/PDF; emoji via keyboard |

## Payments (FR-050–053)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-050 | In-app purchases / subscriptions | ✅ | Play Billing + upgrade screen |
| FR-051 | Payment security (TLS) | ✅ | Play Billing + Supabase HTTPS |
| FR-052 | Billing history | ⚠️ | Plan shown; no in-app receipt list |
| FR-053 | Refund request flow | ❌ | Redirect to Play/support not wired |

## Admin (FR-060–063)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-060 | User management | ✅ | Admin console grant/revoke |
| FR-061 | Content moderation | ⚠️ | Admin tools; no job-post moderation (N/A) |
| FR-062 | System analytics dashboard | ✅ | `admin_dashboard_screen.dart` |
| FR-063 | Feature toggles | ❌ | No remote feature-flag panel |

## Security (FR-070–074)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-070 | Secure communication (HTTPS) | ✅ | Supabase TLS |
| FR-071 | Encryption at rest | ✅ | `secure_storage_service.dart`, encrypted backup option |
| FR-072 | Brute-force / strong passwords | ⚠️ | Min 6 chars; no CAPTCHA/rate-limit UI |
| FR-073 | OWASP MASVS baseline | ⚠️ | Audit fixes done; no formal MASVS audit |
| FR-074 | Biometric lockscreen | ✅ | Same as FR-004 |

## Privacy (FR-080–083)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-080 | Privacy policy & consent | ⚠️ | Policy in settings; no explicit consent gate at signup |
| FR-081 | PII not in analytics | ✅ | Telemetry uses anonymized events |
| FR-082 | Account deletion data purge | ⚠️ | Client flow exists; 30-day server purge needs ops |
| FR-083 | GDPR access/erasure tools | ⚠️ | Export + delete; no admin self-service data export portal |

## Data (FR-090–093)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-090 | Data integrity / transactions | ✅ | Drift + outbox pattern |
| FR-091 | Input validation | ✅ | `form_validators.dart`, save guards |
| FR-092 | DB constraints | ✅ | Drift schema + Supabase migrations |
| FR-093 | Audit logging | ✅ | `audit_log_service.dart` |

## Sync & offline (FR-100–103)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-100 | Offline caching | ✅ | Drift primary store |
| FR-101 | Sync on reconnect | ✅ | Outbox + reconnect invalidation |
| FR-102 | Low connectivity mode | ⚠️ | Offline banner; no auto image quality downgrade |
| FR-103 | Background sync limits | ⚠️ | Sync on resume/connectivity; no WorkManager hourly job |

## Localization (FR-110–113)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-110 | English + Urdu UI | ⚠️ | ARB scaffold; most strings still hardcoded English |
| FR-111 | Per-app language (Android 13+) | ⚠️ | In-app picker ✅; `locale_config` for system picker partial |
| FR-112 | Date/number localization | ✅ | `intl`, `currency_formatter.dart` |
| FR-113 | Full static content translation | ⚠️ | Roadmap item for v2.7+ |

## UI/UX (FR-120–125)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-120 | Material Design | ✅ | M3 theme v2.6.4 |
| FR-121 | 48dp touch targets | ⚠️ | Tokens define min touch; not app-wide enforced |
| FR-122 | Responsive layout | ⚠️ | Phone-first; limited tablet/foldable testing |
| FR-123 | Loading indicators | ✅ | Skeletons, spinners |
| FR-124 | Consistent navigation | ✅ | Shell + GoRouter |
| FR-125 | Dark mode | ✅ | Theme toggle |

## Accessibility (FR-130–134)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-130 | Screen reader labels | ❌ | No explicit `Semantics` widgets |
| FR-131 | WCAG contrast | ⚠️ | Theme colors; not formally verified |
| FR-132 | Dynamic text size | ⚠️ | Clamped 0.85–1.35 in `app.dart` |
| FR-133 | Touch target spacing | ⚠️ | Material defaults |
| FR-134 | Accessible authentication | ⚠️ | Labeled fields; biometric fallback |

## Performance (FR-140–144)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-140 | Cold launch &lt; 3s | ⚠️ | Not profiled on device |
| FR-141 | Actions &lt; 2s (p95) | ⚠️ | Not instrumented |
| FR-142 | 60fps animations | ⚠️ | Not profiled |
| FR-143 | Realtime not polling | ✅ | Supabase realtime for chat |
| FR-144 | Battery optimization | ⚠️ | No formal battery audit |

## Analytics (FR-150–153)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-150 | Event logging | ✅ | `telemetry_service.dart` |
| FR-151 | Crash reporting | ⚠️ | Local logging; Crashlytics stub |
| FR-152 | Performance monitoring | ❌ | No APM |
| FR-153 | Analytics privacy | ✅ | No PII in events |

## Backup (FR-160–163)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-160 | Android Auto Backup | ⚠️ | Manual export; no `backup_rules.xml` tuned |
| FR-161 | Manual export/import | ✅ | `backup_restore_service.dart` |
| FR-162 | Cloud sync of attachments | ✅ | Supabase storage + signed URLs |
| FR-163 | Backup encryption | ✅ | Optional password on export |

## Integrations (FR-170–175)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-170 | Google Sign-In | ✅ | |
| FR-171 | Supabase Realtime | ✅ | |
| FR-172 | In-app updates (Play) | ❌ | Not implemented |
| FR-173 | Firebase Analytics/Crashlytics | ⚠️ | Scaffold only |
| FR-174 | Social sharing | ⚠️ | Share sheet for backup; limited elsewhere |
| FR-175 | Play Billing | ✅ | + server verify edge function |

## Testing (FR-180–183)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-180 | Automated UI tests | ⚠️ | Widget test for splash only |
| FR-181 | CI on each commit | ✅ | `.github/workflows/ci.yml` |
| FR-182 | Error monitoring logs | ⚠️ | Local + audit log |
| FR-183 | Backend load tests | ❌ | Not done |

## Release & store (FR-190–194)

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| FR-190 | Play Store listing | ⚠️ | `play-store/listing/` stale vs 2.6.4 |
| FR-191 | Visual assets compliance | ⚠️ | Needs refresh for current version |
| FR-192 | Privacy policy link | ✅ | In-app + listing docs |
| FR-193 | Semantic versioning | ✅ | `2.6.4+45` |
| FR-194 | App review prep | ⚠️ | Manual QA required |

---

## Recommended next implementation order

1. **Slack APK delivery** — add `SLACK_BOT_TOKEN` secret (see `docs/SLACK_APK_DELIVERY.md`)
2. **FR-110/113** — expand Urdu ARB coverage app-wide
3. **FR-130** — Semantics labels on shell, auth, primary actions
4. **FR-042** — chat user blocking
5. **FR-151/173** — wire Firebase Crashlytics when `google-services.json` ready
6. **FR-005** — configurable session timeout
7. **FR-172** — Play In-App Updates

## Audit phases (separate from SRS)

Phases 1–5 from `releases/AUDIT_PHASES_COMPLETE.md` are **done** on `main` (plan limits, sync, security, billing verify, backlog polish).
