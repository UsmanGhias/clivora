# CLIVORA — Complete Work Inventory (Done Features)

**Purpose:** Single searchable reference of everything already built across **Flutter app**, **Next.js web**, and **clivora-web**, so you can invent *new* features and working scenarios without redoing finished work.

| Field | Value |
|-------|--------|
| **Generated** | 16 July 2026 |
| **Primary repo** | https://github.com/UsmanGhias/clivora |
| **Web deploy mirror** | https://github.com/UsmanGhias/clivora-web |
| **Live product** | https://clivora.codcrafters.org |
| **Company** | CODCrafters |
| **Flutter version (local)** | `2.19.0+76` (`pubspec.yaml`) |
| **Web package version** | `2.19.0` (`web/package.json`) |
| **Working branch (local)** | `cursor/pro-plus-web-v2-7-1-d928` |
| **Latest Play tags seen** | `v2.19.0-playstore`, `v2.20.0-playstore` |
| **Supabase** | `jtzjwgovqczlccyeujhq` |
| **Auth** | **Supabase Auth only** (not Firebase / NextAuth) |

**How this doc was built:** local clone inventory of `lib/features/`, `web/src/app/`, `supabase/migrations/`, git history, and internal docs (`CLIVORA-COMPLETE-AI-TRAINING-NOTES.md`, Connect marketplace map, Features 20/21–40, Status v2.15, changelog). No separate Graphify artifact was found in the repo; knowledge was reconstructed from those sources + code layout.

**Companion docs (deeper detail):**
- `docs/internal/CLIVORA-COMPLETE-AI-TRAINING-NOTES.md`
- `docs/internal/RESEARCH_CONNECT_MARKETPLACE_MAP.md`
- `docs/internal/RESEARCH_VS_SHIPPED_v2.15.md`
- `docs/internal/CLIVORA-Features-and-Improvements.md` (+ PDF)
- `docs/FEATURES_20_CONNECT.md` · `docs/FEATURES_21_40.md`
- `web/content/docs/changelog.md`
- `docs/internal/LOCALHOST_HANDOFF.md`

---

## 1. Product in one page

CLIVORA is a **business operating system** for freelancers and clients:

1. **CRM / workspace** — clients, projects, invoices, tasks, expenses, notes, quotes, POs, vendors  
2. **CLIVORA Connect** — private marketplace (browse free; contact/post = Pro Plus; **$0 platform fee**)  
3. **Client portal** — shared projects, invoices, messages, contracts  
4. **One account** — Android (offline-first) + Web (cloud) on Supabase  

| Plan | Price | Unlock summary |
|------|-------|----------------|
| Free | $0 | Limited CRM; **browse** Connect |
| Pro | $9 / mo | Unlimited CRM tools, AI insights (app), team, timesheets, etc. |
| Pro Plus | $19 / mo | Pro + Connect contact, post, proposals, marketplace write actions |

**Android Play SKUs:** `clivora_pro_*_monthly`, `clivora_pro_plus_*_monthly` (freelancer + client).

---

## 2. Repository map

| Repo | Role | What lives there |
|------|------|------------------|
| **UsmanGhias/clivora** | **Source of truth** | Flutter Android app + full `web/` (Next.js product + marketing + admin) + Supabase migrations/functions |
| **UsmanGhias/clivora-web** | **Vercel deploy mirror** | Synced from `web/` via `web/push-to-clivora-web.sh` (force-push sync). Older local copy may be marketing/admin-only; treat GitHub + `Clivora/web` as current |

**Do not confuse:** early `clivora-web` marketing README (codcrafters.org) vs live app at **clivora.codcrafters.org**.

---

## 3. Stack (locked)

| Layer | Choice |
|-------|--------|
| Mobile | Flutter, Riverpod, Drift (SQLite), GoRouter, Google Sign-In, Play Billing, local notifications, secure storage, biometrics |
| Web | Next.js 15 App Router, React 19, Tailwind, Supabase SSR, Recharts / dashboards |
| Backend | Supabase Auth, Postgres + RLS, Realtime, Storage, Edge Functions, Cron |
| Deploy | Vercel (`clivora.codcrafters.org`), Google Play |
| Video | Jitsi meeting links |
| Email | Resend (invoice reminders) |
| Search | Postgres `ilike` now; Meilisearch helper later |
| AI | Flutter local heuristics + web `/api/ai/ask` (LLM if keyed, else CTA) |

**Do not vendor as platforms:** Keycloak, Rocket.Chat, Discourse, Twenty CRM, Kill Bill, Sharetribe full fork. Borrow patterns only.

---

## 4. Flutter Android — modules already implemented

Folder: `lib/features/`

| Module | Done capabilities (working scenarios) |
|--------|----------------------------------------|
| **auth / splash / onboarding** | Email/password, Google Sign-In, freelancer vs client role lock, soft email verify, splash routing, first-run tour slides |
| **dashboard** | Stats cards, quick actions, search entry, skeletons, coach marks (first-time), pull-to-refresh |
| **customers** | Client CRM CRUD, plan limits (Free) |
| **projects** | Projects CRUD, status, pipeline/kanban parity path, time tracker screen (per-user timer scope intended) |
| **tasks** | Tasks CRUD, due dates, local scheduled reminders |
| **invoices** | Builder, statuses (incl. partial), PDF, client share sync, payment confirmation flows, recurring (Android) |
| **quotes / products / expenses / credits / purchase_orders / vendors** | Money & purchasing workspace tools |
| **notes** | Notes module |
| **calendar** | Month grid + day events from tasks / project deadlines / invoice dues / reminders |
| **messages** | Freelancer + client messaging (hybrid local/cloud), attachments metadata |
| **notifications** | Local + cloud alerts, badge/unread flows |
| **marketplace (Connect)** | Talent / jobs / inbox, filters, sort, detail sheets, Pro Plus gates, reviews path |
| **reviews** | Connect reviews surface |
| **client** | Client portal: projects, invoices, contracts, tasks, activity/updates |
| **team** | Invites; accept → project share (ACL finer permissions still Partial) |
| **analytics / reports** | Metrics, charts; advanced trends Pro-gated |
| **subscription / pro** | Upgrade, Play Billing, Pro/Pro Plus, referrals entry |
| **settings / profile / more (Hub)** | Hub tool grid, security, backup, branding, language preference (EN/UR foundation) |
| **admin** | In-app admin console (CodCrafters) |
| **search** | Global search across CRM entities |
| **onboarding** | 4-slide first-run; Lottie asset on sync slide |

### Cross-cutting mobile services (done)

| Service area | Status |
|--------------|--------|
| Drift SQLite offline CRM | Done |
| Sync outbox + connectivity bar + auto-sync | Done |
| Conflict resolution dialogs (projects/clients/invoices) | Done (v2.15+) |
| Cloud CRM backup/restore | Done |
| Play in-app update prompt | Done |
| Biometric lock + secure storage | Done (device-dependent) |
| Local notifications + task reminders | Done |
| Telemetry / crash hooks (local + Firebase-ready) | Foundation |
| CI: `flutter analyze` + `flutter test` | Done |
| Linux desktop target scaffold | Present; needs system deps (`libsecret`/GTK) — not primary test path |

---

## 5. Web app (`web/`) — routes already implemented

### 5.1 Marketing & legal

| Route | Purpose |
|-------|---------|
| `/` | Landing / hero / Connect USP ($0 fee) |
| `/connect` | Public marketplace board |
| `/pro` | Checkout, promo codes, JazzCash/manual, Stripe stubs |
| `/docs` | Public help center (Markdown) |
| `/about` `/contact` `/support` | Company / help |
| `/privacy` `/terms` `/cookies` `/data-safety` `/delete-account` | Play / GDPR / legal |

### 5.2 Authenticated workspace `/app/*`

| Route | Done |
|-------|------|
| `/app/hub` | Live KPIs, icon wells, Ask AI entry |
| `/app/clients` `/projects` `/invoices` `/tasks` | Cloud CRM CRUD |
| `/app/messages` | Role-aware threads, unread, Slack-style polish |
| `/app/timesheets` | LiveTimer + save to CRM |
| `/app/meetings` | Jitsi room links |
| `/app/support` | Support tickets |
| `/app/referrals` | Refer & Earn |
| `/app/connect` `/proposals` `/reviews` | Marketplace workspace |
| `/app/team` | Team invites |
| `/app/analytics` `/activity` `/notifications` | Insights & activity |
| `/app/payments/*` | Transactions, methods, payouts surfaces |
| `/app/earnings` `/bookmarks` `/settings` `/account` | Account & prefs |
| Auth | `/login` `/signup` `/auth/callback` reset-password |

### 5.3 Admin (`/admin/*`) — mockup-aligned panel (recent)

Overview, users, freelancers, clients, projects, invoices, jobs, proposals, connect, escrow, payouts, payments, subscriptions, transactions, disputes, support, reports, audit, events, settings, feature flags, moderation APIs.

### 5.4 APIs already present

| API | Purpose |
|-----|---------|
| `/api/admin/*` | Stats, sync, grant-pro, moderation, marketplace, escrow, feature-flags, payment-requests, platform |
| `/api/ai/ask` | Ask AI (Pro-gated; LLM if keyed) |
| `/api/stripe/checkout` `/portal` `/webhook` | Stripe stubs → activate with secrets |
| `/api/vault/share` | Signed vault share links |
| `/api/automations/webhook` | n8n / automation bridge |

### 5.5 Role UX (done)

- Freelancer teal vs client slate themes  
- Pixel-aligned freelancer + client dashboards / portals (recent commits)  
- Smart App CTA (install / open Android)  
- Guest Connect browse + Buy Pro Plus funnel  

---

## 6. clivora-web (deploy mirror) — historically done

From `ADMIN.md` + early commits (still relevant for ops):

| Area | Done |
|------|------|
| Marketing site pages | Home, legal, support, about, contact |
| Admin login + tabs | Overview, Users, Audit, Events (evolved into fuller admin in `web/`) |
| Sync API | `POST /api/admin/sync` with `X-Admin-Sync-Key` |
| Stats API | `GET /api/admin/stats` |
| Supabase profiles / events | When service role configured |
| Contrast / Vercel build fixes | Done in earlier iterations |

**Note:** Prefer inspecting **`Clivora/web`** for the full product; push to `clivora-web` with `bash web/push-to-clivora-web.sh` when deploying.

---

## 7. Supabase / data layer — shipped schema themes

Migrations under `supabase/migrations/` (samples of what exists):

| Theme | Examples |
|-------|----------|
| Auth / roles / privacy | Strict roles, Google profile fix, security hardening |
| Sharing | Invoice shares, quote shares, expiry |
| Subscriptions / referrals / team | Plans, referrals, team invites, Pro Plus payment requests |
| Connect + CRM backup | Connect tables + cloud backup |
| Cloud CRM | `crm_*` tables, conflict records |
| Trust | Reviews, proposals, milestones, escrow ledger, reputation |
| Ops | Promo codes, invoice reminders cron, Connect credits |
| Access polish | Client time entries, bookmarks, avatar URL |

**Key tables (conceptual):**  
`profiles`, `connect_profiles`, `connect_needs`, `connect_requests`, `connect_reviews`, `connect_proposals`, `connect_milestones`, `connect_escrow_ledger`, `client_messages`, `crm_*`, `crm_embeddings`, `team_invites`, promo/referral, invoice reminder columns.

**Edge:** `send-invoice-reminders` (Resend + idempotent scheduling).

---

## 8. Version / release arc (cheat sheet)

| Version / tag | What shipped |
|---------------|--------------|
| **~2.5–2.6** | Onboarding, skeletons, offline bar, biometrics, notifications, coach marks, Urdu foundation, sync outbox, CI |
| **2.7–2.10** | Play builds, Connect marketplace foundation, cloud CRM web, role themes, email verify soft gate |
| **2.11–2.13** | Offline sync/conflicts, kanban, messaging upgrades, admin flags, escrow tools, timesheets, Jitsi, support tickets, Ask AI, vault shares, help `/docs`, Features PDF |
| **2.14** | Reviews on cards, reputation sort, profile completeness, Play payments docs |
| **2.15** | Invoice reminder Edge Function, referrals UI, promo codes, proposal→milestone, Hub KPIs, Android sort + conflict UI, Stripe portal stub, Status PDF |
| **2.16** | Hero redesign, $0 fee USP, guest Buy Pro Plus, categories/Top Rated, Ask AI fallback, Connect mobile detail, messages polish, Hub icons, team share fix, em-dash purge |
| **2.18–2.19** | Connect credits wiring, role dashboards, secure stabilization, release signing harden, workspace UX polish, mockup-aligned freelancer/client UIs, timesheet LiveTimer, full admin panel rebuild |
| **2.20 tag** | Present on GitHub tags (verify release assets on GitHub Releases) |

**Example download pattern:**  
`https://github.com/UsmanGhias/clivora/releases/tag/v2.16.0-playstore`  
(APK/AAB/PDFs attached per release.)

---

## 9. Features 1–40 research checklist (status = Implemented in earlier docs)

Summarized from `docs/FEATURES_20_CONNECT.md` + `FEATURES_21_40.md`:

| # | Feature | Status |
|---|---------|--------|
| 1–20 | Play update, cloud backup, Connect marketplace, anonymous requests, Pro Plus checkout, Hub redesign, dark contrast, admin moderation, backup reminder, verified badge, skills/rates, mutual accept→CRM, need posts, Connect inbox, plan badges, offline update UX, backup encryption, admin grant Plus, Connect analytics, role views | **Implemented** |
| 21–40 | Play Billing only in-app, Pro/Pro Plus product IDs, purchase/restore/cancel, verify→pro_plus, Play-safe web copy, Hub consistency, inbox filters, role tabs, salted password hashes, subscription status, live Play prices, admin Plus, mutual accept, backup reminder, web moderation, navy Hub card | **Implemented** |

---

## 10. Connect marketplace map — Done vs Partial vs Later

Full table: `docs/internal/RESEARCH_CONNECT_MARKETPLACE_MAP.md`

### Done (do not re-open as “missing”)

- Accounts + roles; browse before signup  
- Search / skill filters / sort (Featured, Top rated, Newest, Rate)  
- Job posts; proposals + status  
- Subscription unlimited bids model + credits wiring  
- Proposal accept → kickoff milestone  
- Reviews + Top Rated badge rules  
- Hub KPIs; invoice reminders cron  
- Zero-fee differentiator copy; guest Buy Pro Plus funnel  
- Escrow **ledger** + admin release UI  

### Partial (good place for *new* scenarios)

- Category taxonomy depth  
- Saved searches (mobile local only → need cloud + alerts)  
- Messaging realtime / attachments gallery  
- Admin moderation depth  
- Team ACL (beyond share-on-accept)  
- Web Ask AI when no LLM key  
- Stripe Customer Portal (stubs need secrets)  
- Email verify / GDPR polish  

### Later / deferred (intentional)

- Contests; job attachments; portfolio gallery  
- Meilisearch production  
- Live Stripe Connect escrow **funding**  
- Chatwoot host / Discourse / Work Diary screenshots  
- Full Urdu i18n; Nextra docs migration; crypto escrow; iOS  

---

## 11. Research corrections (avoid wrong assumptions)

| Wrong claim (old research) | Reality |
|----------------------------|---------|
| Auth is Firebase / NextAuth | **Supabase Auth** |
| No escrow / proposals | Tables + UI exist; live money fund deferred |
| No video | **Jitsi** meeting links |
| AI not implemented | Ask AI + local insights; RAG still stub |
| Offline sync unclear | Drift + outbox + conflict records |

---

## 12. Working scenarios already covered (use as regression + inspiration baseline)

Use these as “already works” acceptance paths. New features should extend, not duplicate.

### A. Freelancer CRM (Android + Web)

1. Sign up / Google login as freelancer → Hub / dashboard  
2. Add client → project → task → invoice → PDF / share  
3. Track time on a project (one active timer **per user**)  
4. Offline edit → reconnect → outbox sync / conflict dialog  
5. Cloud backup / restore after reinstall  

### B. Client portal

1. Client login → portal home  
2. View shared projects / invoices / pay confirm  
3. Messages / contracts / activity updates  

### C. Connect marketplace

1. Guest browses talent/jobs → cannot contact → Buy Pro Plus CTA  
2. Pro Plus posts need / listing → send request (anonymous)  
3. Accept → emails revealed → milestone/review path  
4. Continue in CRM messages / invoices  

### D. Billing

1. Android: purchase Pro / Pro Plus via Play; restore; manage subscription  
2. Web: `/pro` manual / promo / referral; Stripe when secrets set  
3. Admin grant plan from admin panel  

### E. Ops / admin

1. Admin login → users, Connect moderation, escrow release tools, events/audit  
2. Mobile app sync events to web admin API  
3. Daily invoice reminder Edge Function (Resend)  

### F. Trust & growth

1. Reviews show on talent cards; Top Rated sort  
2. Profile completeness scoring  
3. Referrals page + promo code on checkout  

---

## 13. Best places to invent **new** features (gaps)

Prioritized for ideation (not redoing Done):

### P0 — Ops polish (not new product)

- Google OAuth consent branding = **CLIVORA**  
- Vercel `SUPABASE_SERVICE_ROLE_KEY` + Stripe/Resend secrets verification  
- Play Console SKUs Active + continuous AAB  
- Reminder email E2E proof  

### P1 — High-leverage product ideas

- Client **needs-action** home (overdue invoices, pending proposals, disputed milestones)  
- Connect **portfolio gallery**  
- Cloud **saved searches + email alerts**  
- Recurring invoices **on web**  
- Dispute ↔ support ticket bridge  
- Real RAG embed-on-write for Ask AI  
- Stronger mobile proposals/milestones parity with web ConnectTrust  
- Calendar day selection sync + richer activity feed (shipped base; UX still soft)  

### P2 — Scale / polish

- Meilisearch; docs search; typing indicators; optional Chatwoot **widget** only  
- Full Urdu; a11y; SEO blog/changelog  

### P3 — Strategic / deferred

- Live Stripe Connect escrow funding  
- Contests; Work Diary; iOS  

---

## 14. Hard rules for future work (from training notes)

1. Do **not** re-implement Done trust/reviews/reminders/Hub KPIs/escrow ledger/em-dash purge as if missing.  
2. Auth stays **Supabase**.  
3. Do **not** host Keycloak / Rocket.Chat / Discourse / Kill Bill as platforms.  
4. Monetization: Pro **$9**, Pro Plus **$19**; Connect write = Pro Plus; **$0 platform commission**.  
5. Prefer improving existing Flutter + Next.js + Supabase paths.  
6. No merchant IDs in runtime app code.  
7. No user-facing em-dashes (`—`) in new copy.  

---

## 15. Quick local commands

```bash
# Flutter
cd /path/to/clivora
export PATH="$HOME/flutter/bin:$PATH"
flutter pub get
flutter run   # Android device preferred

# Web
cd web
cp .env.example .env.local   # add secrets
npm install && npm run dev

# Push web to clivora-web (deploy mirror)
bash web/push-to-clivora-web.sh
```

---

## 16. File index (start here when researching)

| Need | Path |
|------|------|
| Full AI knowledge base | `docs/internal/CLIVORA-COMPLETE-AI-TRAINING-NOTES.md` |
| Connect Done/Partial/Later | `docs/internal/RESEARCH_CONNECT_MARKETPLACE_MAP.md` |
| Research vs shipped | `docs/internal/RESEARCH_VS_SHIPPED_v2.15.md` |
| Features + improvement PDF source | `docs/internal/CLIVORA-Features-and-Improvements.md` |
| Public changelog | `web/content/docs/changelog.md` |
| Localhost handoff | `docs/internal/LOCALHOST_HANDOFF.md` |
| Flutter features | `lib/features/*` |
| Web routes | `web/src/app/*` |
| DB migrations | `supabase/migrations/*` |

---

*End of inventory — CLIVORA Done Work · CODCrafters · Jul 2026*  
*Use this MD to search for gaps; mark any new ship as Done in the Connect map / changelog so future agents do not redo it.*
