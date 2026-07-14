# CLIVORA User Journeys — Verification Checklist

**Status:** Phase 1 baseline · all items **TO VERIFY** unless noted  
**Legend:** ✅ Pass · ❌ Fail · ⏳ TO VERIFY · 🚫 N/A

No journey below has been executed in this audit pass. Prior internal audit (`docs/internal/CLIVORA-PLATFORM-AUDIT-2026-07-13.md`) claimed several web/Android flows work end-to-end — treat those as **unverified in this packet** until re-run with recorded evidence.

---

## Guest / unauthenticated

| Step | Web | Android | Status |
| --- | --- | --- | --- |
| Land on marketing homepage | `/` | Splash → marketing via store listing | ⏳ TO VERIFY |
| View pricing, features, docs | `/pricing`, `/features`, `/docs` | N/A or deep link | ⏳ TO VERIFY |
| Browse Connect (public) | `/connect` | Marketplace may require auth — TO VERIFY | ⏳ TO VERIFY |
| Sign up (email) | `/signup` | `/signup` | ⏳ TO VERIFY |
| Sign up (Google) | OAuth | Google Sign-In | ⏳ TO VERIFY |
| Log in | `/login` | `/login` | ⏳ TO VERIFY |
| Reset password | `/auth/reset-password` | TO VERIFY | ⏳ TO VERIFY |
| Unauthenticated `/app` redirects to login | 307 → `/login?next=/app` (claimed in 2026-07-13 audit) | Auth redirect in `app_router.dart` | ⏳ TO VERIFY |
| View public invoice share | `/i/[token]` | N/A | ⏳ TO VERIFY |

---

## Freelancer (active account)

| Step | Web route / surface | Android surface | Status |
| --- | --- | --- | --- |
| Dashboard / hub | `/app`, `/app/hub` | `dashboard_screen`, `more_screen` | ⏳ TO VERIFY |
| CRM: clients | `/app/clients` | `customers_screen` | ⏳ TO VERIFY |
| CRM: projects | `/app/projects` | `projects_screen` | ⏳ TO VERIFY |
| CRM: invoices | `/app/invoices` | `invoices_screen` | ⏳ TO VERIFY |
| CRM: tasks, timesheets | `/app/tasks`, `/app/timesheets` | `tasks_screen`, time tracker | ⏳ TO VERIFY |
| Plan gates (Free caps: 3/5/10) | `plan-gates.ts` | `plan_features.dart` | ⏳ TO VERIFY |
| Connect browse | `/connect`, `/app/connect` | `connect_marketplace_screen` | ⏳ TO VERIFY |
| Connect publish profile (Pro Plus + credits) | `/app/connect/manage` | `connect_listing_screen` | ⏳ TO VERIFY |
| Post a need (one open max) | Connect manage | `connect_need_screen` | ⏳ TO VERIFY |
| Proposals inbox | `/app/proposals` | TO VERIFY | ⏳ TO VERIFY |
| Messages | `/app/messages` | `freelancer_messages_screen` / chat | ⏳ TO VERIFY |
| Notifications | `/app/notifications` | `notifications_screen` | ⏳ TO VERIFY |
| Earnings / analytics | `/app/earnings`, `/app/analytics` | `analytics_dashboard_screen` | ⏳ TO VERIFY |
| Referrals | `/app/referrals` | `referral_screen` | ⏳ TO VERIFY |
| Team invites | `/app/team` | `team_screen`, `team_invites_screen` | ⏳ TO VERIFY |
| Meetings (Jitsi) | `/app/meetings` | TO VERIFY | ⏳ TO VERIFY |
| Settings / account | `/app/settings`, `/app/account` | `profile_screen`, settings screens | ⏳ TO VERIFY |
| Upgrade Pro / Pro Plus | `/pro` | `upgrade_screen`, Play Billing | ⏳ TO VERIFY |
| Offline create → sync | N/A (web online) | Drift outbox + `supabase_sync_service` | ⏳ TO VERIFY |
| Invoice public link generation | CRM invoice flow | `invoice_public_link_service` | ⏳ TO VERIFY |

---

## Client (active account)

| Step | Web route / surface | Android surface | Status |
| --- | --- | --- | --- |
| Client dashboard | `/app` (client layout) | `client_portal_screen` | ⏳ TO VERIFY |
| Client hub | Redirect from `/app/hub` → `/app/team` (code) | `client_hub_screen` | ⏳ TO VERIFY |
| Post a job (Pro Plus + credits) | Connect manage | `connect_need_screen` | ⏳ TO VERIFY |
| Browse talent | `/connect` | Connect marketplace | ⏳ TO VERIFY |
| Proposals inbox | `/app/proposals` | TO VERIFY | ⏳ TO VERIFY |
| Projects / shares | `/app/projects` | `client_project_detail` | ⏳ TO VERIFY |
| Invoices | `/app/invoices` | `client_invoices_screen` | ⏳ TO VERIFY |
| Payments navigation | `/app/payments/*` | `client_payments_screen` | ⏳ TO VERIFY |
| Messages | `/app/messages` | `client_messages_screen` | ⏳ TO VERIFY |
| Milestones / contracts | TO VERIFY | `client_milestones_screen`, `client_contracts_screen` | ⏳ TO VERIFY |
| Reports / activity | `/app/activity` | `client_activity_screen` | ⏳ TO VERIFY |
| Settings | `/app/settings` | `client_account_screen` | ⏳ TO VERIFY |
| Upgrade | `/pro` | Play Billing | ⏳ TO VERIFY |

---

## Admin (privileged)

| Step | Web | Android | Status |
| --- | --- | --- | --- |
| Admin login / gate | `/admin`, `admin-auth.ts` | `admin_console_screen` | ⏳ TO VERIFY |
| Overview metrics | `/admin/overview` | `admin_dashboard_screen` | ⏳ TO VERIFY |
| User / freelancer / client lists | `/admin/users`, etc. | Limited in-app admin | ⏳ TO VERIFY |
| Connect moderation | `/admin/connect` | TO VERIFY | ⏳ TO VERIFY |
| Subscriptions / grant Pro | `/admin/subscriptions`, API grant-pro | TO VERIFY | ⏳ TO VERIFY |
| Escrow view (tracking only) | `/admin/escrow` | N/A | ⏳ TO VERIFY |
| Audit log | `/admin/audit` | N/A | ⏳ TO VERIFY |
| MFA / AAL2 on sensitive APIs | `web/src/app/api/admin/*` | N/A | ⏳ TO VERIFY |

---

## Account states

| State | Expected behavior | Status |
| --- | --- | --- |
| **Active** | Full access per role + plan | ⏳ TO VERIFY |
| **Restricted** | Browse Connect; no publish/contact writes | ⏳ TO VERIFY |
| **Blocked** | Redirect `/blocked`; no protected surfaces | ⏳ TO VERIFY |

---

## Cross-platform parity checks

| Concern | Status |
| --- | --- |
| Same `profiles.subscription_plan` on web and Android | ⏳ TO VERIFY |
| Connect credit enforcement matches RPCs on both platforms | ⏳ TO VERIFY |
| Freelancer vs client wording (“Post a need” / “Post a job”) | ⏳ TO VERIFY |
| Contact privacy until mutual Connect accept | ⏳ TO VERIFY |
| Deep links: invoice share, Connect apply URLs preserved | ⏳ TO VERIFY |

---

## Known partial areas (from prior audit — re-verify)

| Area | Note | Status |
| --- | --- | --- |
| Dashboard charts | May use illustrative/demo curves | ⏳ TO VERIFY |
| Escrow funding | Tracking labels only; no live payment rail | ⏳ TO VERIFY (expected disabled) |
| Mobile time entries | May not sync to `crm_time_entries` | ⏳ TO VERIFY |
| Admin settings save | May be read-only / decorative | ⏳ TO VERIFY |
| Google Calendar sync | Stubbed on web meetings page | ⏳ TO VERIFY |

---

## Evidence required per journey

For each ⏳ item, record: platform, plan tier, account state, steps, expected vs actual, screenshot or CLI output, date, tester.
