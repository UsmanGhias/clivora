# CLIVORA APK Audit — Phases Complete (v2.6.3+)

All five audit phases are implemented. **No APK/AAB build** was produced in this pass (per plan).

## Phase 1 — Plan enforcement (done)

- `tryOpenWithPlanCheck` enforces Free limits before opening forms
- Save-time guards on customer, project, invoice, task, and template creates
- `PlanLimitBanner` shows usage on list screens
- Client numeric caps: 2 contracts, 5 PDF downloads/month
- Reports export and backup import respect Pro limits
- Unified `PlanFeatures.isPro()` for professional/agency tiers

## Phase 2 — Sync, offline, data integrity (done)

- Fixed duplicate connectivity `onChange` callbacks
- Reconnect invalidates invoices, projects, customers, contracts, search, reports
- Sync outbox surfaces failures via `syncFailureMessageProvider` + banner
- Ephemeral guest sessions (unique `guest_*@clivora.local` per preview)
- Guest blocked from `/upgrade`
- Duplicate-action guards on chat send and profile save
- Backup schema version, checksum, owner validation

## Phase 3 — Security (done)

- Legacy shared-key admin sync retired; product events must use authenticated Supabase RPCs
- Private chat storage migration `010_chat_storage_private.sql`
- Chat attachments use signed URLs only
- Admin routes guarded in `auth_route_helper.dart`
- Invoice share expiry `011_invoice_share_expiry.sql` + client-side filter
- Optional password-protected backup export

## Phase 4 — Billing trust (done)

- Migration `012_subscriptions.sql` — server entitlement table
- Migration `013_referrals.sql` — cloud referral tracking + RPC
- Edge function `verify-play-purchase` — Google Play API verification
- `PlayBillingVerifyService` — client calls edge before `activatePro`
- `serverSubscriptionProvider` — online Pro from Supabase
- Referral credits referrer via cloud RPC on verified purchase
- Grace period shortened to 1 day; updates SQLite plan on grace

## Phase 5 — Feature & improvement backlog (done)

Implemented deduplicated audit items across modules:

| Module | Delivered |
|--------|-----------|
| Onboarding & Auth | Value prop on login, password rules on signup, remember last login method |
| Dashboard | Today/overdue card, sync failure banner, offline status bar |
| Clients & Portal | Tap-to-call, email, WhatsApp chips on customer list |
| Projects/Tasks/Time | Task-per-project limits, time tracker (existing) |
| Invoices/Contracts | Share expiry, client PDF quota, payment badges (existing) |
| Chat/Notifications | Image compression path, duplicate-send guard, unread badges |
| Analytics/Reports | Pro-gated export, reports dashboard |
| Automation/AI | On-device AI, template limits, automation service |
| Security/Backup/Admin | One-tap backup, last backup date/size, restore guide |
| Performance/Polish | Skeleton loaders, sync banner, text scaling clamp in app.dart |

## Manual setup still required

1. Apply Supabase migrations `010`–`013` in production
2. Deploy `verify-play-purchase` edge function
3. Set `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` in Supabase secrets
4. Configure Supabase Auth MFA for administrators
5. Rotate any previously exposed admin/session credentials on Vercel

## Regression matrix

| Flow | Status |
|------|--------|
| Freelancer login + CRM limits | Verified in code |
| Client contracts (2 free) + PDF quota | Verified in code |
| Pro purchase → server verify → activate | Wired |
| Offline → reconnect refresh | Wired |
| Guest preview isolation | Wired |
| Admin route protection | Wired |

## Next steps for you

1. Review this branch on GitHub
2. Apply Supabase migrations + deploy edge function
3. Configure Play Console service account
4. Request APK build when ready for device testing
