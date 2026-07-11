# Architecture (technical overview)

High-level technical map for developers working on CLIVORA.

---

## Repositories

| Repo | Purpose |
|------|---------|
| [github.com/UsmanGhias/clivora](https://github.com/UsmanGhias/clivora) | Flutter Android app + Supabase migrations |
| [github.com/UsmanGhias/clivora-web](https://github.com/UsmanGhias/clivora-web) | Next.js marketing + web app |

**Production web:** `clivora.codcrafters.org`  
**Supabase project:** cloud Postgres + Auth + Realtime

---

## Stack

### Mobile
- Flutter, Riverpod, GoRouter  
- Drift (SQLite) offline database  
- Supabase Flutter client for auth + sync  

### Web
- Next.js 15, React 19, TypeScript, Tailwind  
- Supabase SSR (`@supabase/ssr`)  
- Deployed on Vercel  

### Backend
- Supabase Postgres with RLS  
- Edge: auth triggers, `handle_new_user()`  
- Storage: chat attachments (private policies)  

---

## Data layers

```
Android SQLite (offline)  ←→  Sync outbox  ←→  Supabase crm_* tables
Web browser             ←→  Direct API     ←→  Supabase crm_* tables
```

Connect, messages, profiles, subscriptions live in Supabase only (web + app clients).

---

## Key Supabase tables

| Area | Tables |
|------|--------|
| Identity | `profiles`, `subscriptions` |
| CRM cloud | `crm_customers`, `crm_projects`, `crm_invoices`, `crm_expenses`, `crm_notes` |
| Connect | `connect_profiles`, `connect_need_posts`, `connect_requests` |
| Portal | `invoice_shares`, `project_shares`, `quote_shares`, `client_messages` |
| Billing | `pro_payment_requests` |
| Admin | `clivora_events`, `app_settings` |

---

## Auth

- Email/password + Google OAuth  
- `profiles.account_type`: `freelancer` | `client` (locked after signup)  
- `profiles.role`: `admin` for panel access  
- `profiles.subscription_plan`: `free` | `pro` | `pro_plus`  
- `is_blocked`, `is_restricted` enforced on web middleware and app sign-in  

---

## Web routes (app)

| Route | Role |
|-------|------|
| `/app` | Dashboard |
| `/app/clients`, `/projects`, `/invoices` | Cloud CRM |
| `/connect`, `/connect/manage` | Marketplace |
| `/pro` | Checkout |
| `/admin` | Admin panel |
| `/blocked` | Blocked users |

---

## Plan gates

- Flutter: `lib/core/constants/plan_limits.dart`, `plan_features.dart`  
- Web: `web/src/lib/plan-gates.ts`, `plan.ts`  

---

## Migrations

SQL migrations live in `supabase/migrations/` on the main clivora repo. Apply via Supabase CLI or dashboard before relying on new tables in production.

---

## Version

Current web package version: see `web/package.json` and `web/src/lib/site.ts` (`appVersion`).
