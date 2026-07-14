# CLIVORA System Inventory

**Source:** Filesystem exploration at `/workspace` · 2026-07-14  
**Verification:** Structure confirmed from repo; runtime behavior **TO VERIFY**

## Applications

| App | Path | Stack | Version (file) | Deploy / distribution |
| --- | --- | --- | --- | --- |
| Web (freelancer + client portals) | `web/` | Next.js 15, React 19, Tailwind, Supabase SSR | `2.20.0` (`web/package.json`) | Vercel via `UsmanGhias/clivora-web` `main` |
| Android | `lib/`, `android/` | Flutter 3.x, Drift/SQLite, Riverpod, go_router | `3.8.0+80` (`pubspec.yaml`) | Google Play · `org.codcrafters.clivora` |
| Admin console | `web/src/app/admin/` | Same Next.js app | (shared web version) | Same Vercel deploy; privileged auth |

**Not a separate repo package:** single monorepo with `web/`, Flutter root, and `supabase/`.

## Key directories

| Path | Role |
| --- | --- |
| `web/src/app/` | Next.js App Router pages |
| `web/src/components/` | UI components (app, connect, admin, freelancer, client) |
| `web/src/lib/` | Shared TS (profile, plan-gates, connect, stripe, admin) |
| `web/src/app/api/` | Route handlers (admin, stripe, ai, vault, automations) |
| `web/content/docs/` | Public markdown docs rendered at `/docs` |
| `lib/features/` | Flutter feature screens (69 files under features) |
| `lib/core/` | Auth, cloud sync, services |
| `lib/data/` | Drift database, providers |
| `lib/routing/` | `app_router.dart`, `app_shell.dart` |
| `supabase/migrations/` | 33 SQL migration files |
| `docs/` | Product, architecture, runbooks, internal audits |

## Web routes

### Marketing & legal

| Route | File |
| --- | --- |
| `/` | `web/src/app/page.tsx` |
| `/about`, `/features`, `/pricing`, `/contact`, `/support` | respective `page.tsx` |
| `/for-freelancers`, `/for-clients` | respective `page.tsx` |
| `/terms`, `/privacy`, `/cookies`, `/data-safety`, `/delete-account` | respective `page.tsx` |
| `/docs`, `/docs/[slug]` | docs shell + markdown |
| `/pro` | Pro / Pro Plus checkout |

### Auth

| Route | File |
| --- | --- |
| `/login`, `/signup` | `web/src/app/(auth)/login/page.tsx`, `signup/page.tsx` |
| `/auth/reset-password` | `web/src/app/(auth)/auth/reset-password/page.tsx` |
| `/blocked` | `web/src/app/blocked/page.tsx` |

### Freelancer / client app (`/app/*`)

| Route | Purpose |
| --- | --- |
| `/app` | Dashboard entry |
| `/app/hub` | Freelancer command center |
| `/app/clients`, `/app/projects`, `/app/invoices`, `/app/tasks` | CRM |
| `/app/timesheets`, `/app/earnings`, `/app/analytics` | Operations |
| `/app/connect`, `/app/connect/apply`, `/app/connect/manage` | Connect |
| `/app/proposals`, `/app/messages`, `/app/notifications` | Workflow |
| `/app/meetings`, `/app/referrals`, `/app/reviews`, `/app/bookmarks` | Tools |
| `/app/team`, `/app/activity`, `/app/support` | Collaboration |
| `/app/payments`, `/app/payments/*` | Payments navigation |
| `/app/settings`, `/app/account` | Profile & settings |

### Connect (public + signed-in)

| Route | Purpose |
| --- | --- |
| `/connect` | Public marketplace browse |
| `/connect/manage` | Listing / job management |

### Public shares

| Route | Purpose |
| --- | --- |
| `/i/[token]` | Public invoice share |

### Admin (`/admin/*`)

| Route | Purpose |
| --- | --- |
| `/admin` | Admin entry |
| `/admin/overview` | Dashboard |
| `/admin/users`, `/admin/freelancers`, `/admin/clients` | User ops |
| `/admin/projects`, `/admin/jobs`, `/admin/proposals`, `/admin/invoices` | Work |
| `/admin/connect`, `/admin/payments`, `/admin/payouts`, `/admin/escrow` | Money (tracking) |
| `/admin/subscriptions`, `/admin/transactions` | Billing |
| `/admin/disputes`, `/admin/support`, `/admin/events` | Ops |
| `/admin/reports`, `/admin/audit`, `/admin/settings` | Governance |

### API routes (`web/src/app/api/`)

- `admin/*` — auth, stats, platform, escrow, moderation, feature-flags, grant-admin, grant-pro, sync, payment-requests, marketplace
- `stripe/*` — checkout, portal, webhook
- `ai/ask`, `automations/webhook`, `vault/share`

## Android feature map (Flutter)

Primary routes in `lib/routing/app_router.dart`; features under `lib/features/`:

- **Auth:** `auth/`, onboarding, splash
- **Freelancer:** dashboard, customers, projects, invoices, expenses, quotes, tasks, calendar, analytics, reports, search, credits, team, marketplace/connect
- **Client:** `client_*` screens (portal, hub, invoices, messages, milestones, payments, etc.)
- **Shared:** messages, notifications, profile, settings, subscription/upgrade, referrals
- **Admin:** `admin_dashboard_screen`, `admin_console_screen` (in-app; separate from web admin)

Offline: Drift DB in `lib/data/database/`; sync via `lib/core/cloud/supabase_sync_service.dart`, `lib/core/services/sync_outbox_service.dart`.

## Supabase migrations (33 files)

Listed by filename; table names extracted from `CREATE TABLE` statements and migration comments.

| Migration file | Notable objects |
| --- | --- |
| `001_clivora_schema.sql` | `profiles`, `client_messages`, `project_shares`, `clivora_events` |
| `002_notifications_client_tasks.sql` | `notifications`, `client_tasks` |
| `003_strict_roles_privacy.sql` | RLS / role hardening |
| `004_fix_google_auth_profile.sql` | Google auth profile fix |
| `005_invoice_shares.sql` | `invoice_shares` |
| `006_auth_security_fixes.sql` | Auth security |
| `007_production_security.sql` | Security policies, `email_send_log` |
| `008_chat_storage_policies.sql` | Storage policies |
| `009_audit_and_sync_indexes.sql` | Indexes |
| `010_chat_storage_private.sql` | Private chat storage |
| `011_invoice_share_expiry.sql` | Share expiry |
| `012_subscriptions.sql` | `subscriptions` |
| `013_referrals.sql` | `referral_codes`, `referral_redemptions` |
| `014_team_invites.sql` | `team_invites` |
| `015_admin_role_pro_fixes.sql` | Admin grant RPCs |
| `016_pro_plus_payment_requests.sql` | `pro_payment_requests` |
| `017_clivora_connect_and_crm_backup.sql` | `connect_profiles`, `connect_need_posts`, `connect_requests`, `crm_cloud_backups` |
| `20260709_quote_shares.sql` | `quote_shares` |
| `20260710_crm_cloud_tables.sql` | `crm_customers`, `crm_projects`, `crm_invoices`, `crm_expenses`, `crm_notes` |
| `20260710_admin_block_connect_auto_approve.sql` | `app_settings`, block/auto-approve |
| `20260710_phase_af_foundation.sql` | `device_tokens`, `chat_blocks`, `app_feature_flags`, `automation_run_log` |
| `20260711_phase1_foundation.sql` | `crm_payment_allocations` |
| `20260711_phase2_connect_trust.sql` | `connect_reviews`, `connect_proposals`, `connect_milestones`, `crm_time_entries`, `contract_signatures`, `meeting_links`, `support_tickets`, `automation_webhook_queue` |
| `20260711_phase3_ai_escrow.sql` | `connect_escrow_ledger`, `crm_embeddings`, `vault_share_links`, `stripe_customers`, `stripe_subscriptions` |
| `20260711_v214_connect_reputation_trust.sql` | Connect reputation, `promo_codes` |
| `20260711_v215_reminders_proposals_promo.sql` | Reminders, proposals, promo |
| `20260711_v215_ops_promo_cron.sql` | Ops cron |
| `20260712_connect_credits.sql` | `connect_credit_legacy_cohort`, `connect_credit_accounts`, `connect_credit_ledger` |
| `20260713_admin_allowlist_align.sql` | Admin allowlist |
| `20260713_client_time_entries_access.sql` | Client time entry access |
| `20260713_freelancer_bookmarks.sql` | `freelancer_bookmarks` |
| `20260713_profiles_avatar_url.sql` | `profiles.avatar_url` |
| `20260714_freelancer_payout_accounts.sql` | `freelancer_payout_accounts` |

**Note:** Views, RPCs, and policies exist beyond table names; full schema replay **TO VERIFY** on staging.

## External services

| Service | Usage | Status |
| --- | --- | --- |
| **Supabase** | Auth, Postgres, RLS, storage, RPCs | Primary backend · project ref in internal audit (`jtzjwgovqczlccyeujhq`) |
| **Vercel** | Web hosting | Production URL `clivora.codcrafters.org` (per internal audit) |
| **Google Play** | Android subscriptions, app distribution | Billing wired in app; publish requires owner approval |
| **Firebase / FCM** | Push (`firebase_messaging` in pubspec) | Android notifications |
| **Stripe** | Web checkout, portal, webhook (`web/src/app/api/stripe/*`) | **Optional** — disabled until `STRIPE_ENABLED` (per internal audit) |
| **Jitsi** | Video meetings (`MeetingsClient.tsx`, `meeting_links`) | Room creation in app; full calendar sync partial |
| **Google Calendar** | OAuth sync for meetings | **Not fully live** — UI indicates wiring in progress |
| **Odoo** | ERP / manufacturing (founder credentials meeting prep) | **Planned / not wired** — `docs/meeting/` only |

## Supporting assets & CI

- `.github/PULL_REQUEST_TEMPLATE.md` — PR template
- `docs/runbooks/releases.md` — web mirror + Android release process
- `docs/GOOGLE_PLAY_BILLING_SETUP.md`, `docs/PLAY_UPLOAD_SIGNING.md` — mobile release docs
- Android signing: `android/key.properties`, keystore references in internal audit

## Gaps

| Gap | Notes |
| --- | --- |
| Graphify (`graphify-out/`) | Not present |
| Meilisearch | Mentioned in research priorities; not found in web dependencies |
| Odoo integration | No code paths in `lib/` or `web/` |
