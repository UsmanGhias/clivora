# CLIVORA Platform Audit — Early Access Status

**Date:** 2026-07-13  
**Web:** https://clivora.codcrafters.org (Vercel READY)  
**Android:** `org.codcrafters.clivora` · `2.20.0+77`  
**Supabase project:** `jtzjwgovqczlccyeujhq`

## Live database snapshot (real counts)

| Table | Rows |
|-------|------|
| profiles | 22 |
| crm_customers | 9 |
| crm_projects | 7 |
| crm_invoices | 3 |
| connect_profiles | 3 |
| connect_need_posts | 4 |
| client_messages | 81 |

These are early-access numbers. Marketing no longer invents “10K users” or revenue claims.

## Deployment & auth

| Check | Result |
|-------|--------|
| Homepage HTTPS | 200 |
| `/login` | 200 |
| `/app` unauthenticated | 307 → `/login?next=/app` |
| Supabase SQL | Reachable |
| Upload keystore | Present (`clivora-upload-keystore.jks`) |
| Release APK/AAB | Published `v2.20.0-playstore` |

## What works end-to-end (web)

- Email + Google auth, role-aware portals
- Freelancer/client dashboards fed by Supabase RPCs + CRM tables
- CRM: customers, projects, invoices, timesheets
- Connect: browse, publish, proposals, credits RPCs
- Messages (`client_messages`), notifications, referrals, team invites
- Public invoice share `/i/[token]`
- Pro manual payment requests; Ask AI with CRM fallback

## What works (Android)

- Offline-first CRM (Drift) + cloud sync for customers/projects/invoices
- Email/Google auth, Play Billing wiring, Connect (Pro Plus)
- Realtime messages, invoice shares, notifications/FCM

## Partial / honest labels required

| Area | Status |
|------|--------|
| Dashboard charts | Scaled demo curves — not historical series |
| Escrow / funded payments | Not a live payment rail on web |
| Stripe | Code present; disabled until `STRIPE_ENABLED` |
| Clivora AI | Beta / CRM fallback without LLM keys |
| Connect | Beta — small community |
| Admin charts/export/settings save | Mostly read-only / decorative |
| Mobile time tracking | Local SQLite; not synced to `crm_time_entries` |

## Marketing honesty (this release)

- Removed invented stats, fake company logos, fake job counts
- Homepage simplified (no dual-portal showcase)
- Feature cards labeled **Available now** / **Beta**
- Mock dashboards captioned: “Illustrative dashboard shown with sample data.”
- About page: real founder story + early-access positioning
- Pricing note: Android via Google Play; web billing later

## Install

- APK: https://github.com/UsmanGhias/clivora/releases/download/v2.20.0-playstore/clivora-2.20.0.apk
- AAB: https://github.com/UsmanGhias/clivora/releases/download/v2.20.0-playstore/clivora-2.20.0.aab
- Release: https://github.com/UsmanGhias/clivora/releases/tag/v2.20.0-playstore
