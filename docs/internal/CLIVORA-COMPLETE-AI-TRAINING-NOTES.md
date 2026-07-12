# CLIVORA Complete Project Knowledge Base (AI Training Notes)

**Document purpose:** Train a local AI (Cursor / ChatGPT / Claude / custom RAG) on everything CLIVORA is, what we built, what we planned, what is left, and how to keep improving without redoing finished work or violating architecture locks.

**Last updated:** 12 July 2026  
**Owner:** Usman Ghias (CODCrafters) · `iusmanghias@gmail.com` · `usmanghias1@gmail.com`  
**Company site:** https://codcrafters.org  
**Product site:** https://clivora.codcrafters.org  
**Primary repo:** https://github.com/UsmanGhias/clivora  
**Web mirror:** https://github.com/UsmanGhias/clivora-web  
**Working branch:** `cursor/pro-plus-web-v2-7-1-d928` (base: `main`)  
**App version:** Flutter `2.16.0+73` · Web `2.16.0`  
**Supabase project:** `jtzjwgovqczlccyeujhq` (CODCrafters)  
**Vercel project:** `prj_AZuWTky7AXfyzaLkvnwK1beieGSE` · domain `clivora.codcrafters.org`  
**Cloud agent archive:** https://cursor.com/agents/bc-04b4d32d-7603-4032-ab80-b5c985e2b249  

**Companion docs (read with this file):**
- `docs/internal/LOCALHOST_HANDOFF.md` — clone + local run
- `docs/internal/RESEARCH_CONNECT_MARKETPLACE_MAP.md` — 30+ marketplace features Done/Partial/Later
- `docs/internal/RESEARCH_VS_SHIPPED_v2.15.md` — research corrections
- `docs/internal/research-uploads/` — original research files user provided
- `docs/internal/GOOGLE_PLAY_PAYMENTS_ACCOUNT.md` — Play merchant IDs
- `docs/internal/VERCEL_ENV_SETUP.md` — env vars
- `docs/internal/INVOICE_REMINDERS.md` — reminder cron

---

## How to use this document to train your AI

1. Paste this entire file into Cursor **Project Rules** / `.cursor/rules` / custom instructions, **or**
2. Add it to a local RAG corpus with the companion docs above, **or**
3. Start every coding chat with: “Read `docs/internal/CLIVORA-COMPLETE-AI-TRAINING-NOTES.md` and do not reopen Done items.”

**Hard rules for any AI assistant working on CLIVORA:**
- Do **not** re-implement finished trust/reviews/escrow ledger / invoice reminders / Hub KPIs as if missing.
- Auth is **Supabase**, not Firebase or NextAuth.
- Do **not** vendor/host Keycloak, Rocket.Chat, Discourse, Twenty CRM, Kill Bill, Chatwoot-as-platform.
- Monetization: Pro **$9**, Pro Plus **$19**; Connect contact/post = Pro Plus; **$0 platform commission** on deals.
- Prefer improving existing Flutter + Next.js + Supabase codepaths.
- Never put merchant IDs or Play payments account IDs into app runtime code.
- No user-facing em-dashes (`—`) in new copy (stripped in v2.16).

---

# PART A — What CLIVORA is (complete product description)

## A1. One-sentence pitch

CLIVORA is a **cloud-first business operating system** for freelancers and clients: private Connect marketplace + CRM + projects + invoices + messaging + meetings + AI helpers, on **Android (Flutter)** and **Web (Next.js)**, one Supabase account.

## A2. Unique selling points (USP)

| USP | Meaning |
|-----|---------|
| **Business OS, not only a marketplace** | After match, work continues in the same CRM (clients, projects, invoices). |
| **$0 platform fee on deals** | Unlike Upwork/Fiverr commissions or Connect tokens; monetize via subscription. |
| **Private contact** | Emails unlock only after **mutual accept** of a Connect request. |
| **Offline-first Android** | Drift SQLite + sync outbox; works without network, syncs to Supabase. |
| **Role-aware UX** | Freelancer vs Client themes, hubs, and nav. |
| **Trust layer** | Ratings, reviews, profile completeness, milestones, escrow **ledger** (funding deferred). |

## A3. Competitor positioning (from research you provided)

| Platform | Model | CLIVORA response |
|----------|-------|------------------|
| **Upwork** | Proposals (“Connects” paid), escrow, ~10% freelancer fee + client fee | Unlimited proposals with Pro Plus; $0 platform fee; private contact |
| **Fiverr** | Gig packages, ~20% seller commission | Service listings exist as Connect profiles; not gig-fee model |
| **Freelancer.com** | Bidding + contests, layered fees | Bidding/proposals yes; contests **Later** |
| **Toptal** | Pre-screened elite matching | CLIVORA is open browse + trust signals (ratings, verified, Top Rated) |
| **Jobbers-style** | Zero commission, credits | Closest philosophically: subscription instead of credits |

## A4. User roles

1. **Freelancer** — CRM, Hub, invoices, Connect talent listing, proposals, team (Pro).
2. **Client** — client hub, shared projects/invoices, Connect job posts, hire flow.
3. **Admin** — admin console: users, moderation, plan grants, escrow release tools.
4. **Guest** — can **browse** Connect on web without login; Buy Pro Plus CTA for unlimited contact/post.

## A5. Subscription plans

| Plan | Price | Key unlocks |
|------|-------|-------------|
| Free | $0 | Limited CRM; **browse** Connect |
| Pro | **$9/mo** | Unlimited CRM tools, AI insights (app), team collab, timesheets, etc. |
| Pro Plus | **$19/mo** | Everything in Pro + **Connect contact, post, proposals**, unlimited marketplace access |

**Android:** Google Play Billing product IDs in `lib/core/constants/billing_products.dart`  
**Web:** `/pro` JazzCash/manual (+ Stripe checkout/portal stubs when keys present)  
**Promo:** `CLIVORA15` (15% off, max 50 uses) · Referrals at `/app/referrals`

### Play Billing SKUs (must be Active in Play Console)

| Product ID | Plan |
|------------|------|
| `clivora_pro_freelancer_monthly` | Pro |
| `clivora_pro_client_monthly` | Pro |
| `clivora_pro_plus_freelancer_monthly` | Pro Plus |
| `clivora_pro_plus_client_monthly` | Pro Plus |

### Google Play payments account (Console only — not in APK)

| Field | Value |
|-------|--------|
| Payments account ID | `7504-8568-3035-6197` |
| Payments profile ID | `0631-4490-8359` |
| Merchant ID | `821322956506296398` |
| Country | Pakistan (PK) |
| Business | CODCrafters |
| Name | Muhammad Usman Khan |
| Upload SHA-1 (reference) | `96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36` |

---

# PART B — Architecture (locked)

```
┌─────────────────┐     ┌──────────────────┐
│ Flutter Android │────▶│ Drift SQLite     │  offline + outbox
│ 2.16.0+73       │     │ conflict UI      │
└────────┬────────┘     └──────────────────┘
         │
         ▼
┌─────────────────┐
│    Supabase     │  Auth · Postgres · RLS · Edge Functions · Storage · Cron
│ jtzjwgovqczlccyeujhq
└────────┬────────┘
         ▲
┌────────┴────────┐
│ Next.js 15 Web  │  App Router · Vercel · clivora.codcrafters.org
│ 2.16.0          │
└─────────────────┘
```

### Stack details

| Layer | Choice |
|-------|--------|
| Mobile | Flutter, Riverpod, Drift, GoRouter, Play Billing, FCM |
| Web | Next.js 15, React 19, Tailwind, Framer Motion, Supabase SSR |
| Backend | Supabase Postgres + RLS + Edge Functions (Deno) |
| Auth | Supabase Auth (email/password + Google OAuth) |
| Video | Jitsi meeting links |
| Docs | Custom Markdown `web/content/docs` (Nextra optional later) |
| Search | Postgres `ilike` now; Meilisearch helper later |
| Email | Resend (invoice reminders) |

### Do-not-vendor list (patterns only)

Keycloak, Ory, Rocket.Chat, Mattermost, Discourse, Twenty, Monica, Kill Bill, Lago, Chatwoot (as hosted product), Sharetribe full fork.

---

# PART C — Feature surface (what exists today)

## C1. Flutter mobile (`lib/features/`)

| Area | Screens / capability |
|------|----------------------|
| Auth / onboarding | Signup, login, Google, account type freelancer/client, email verify |
| Freelancer Hub | `/more` tool grid (Money, Business Tools, Connect promo, AI, Team…) |
| Client Hub | Client-specific hub and portal screens |
| CRM | Customers/clients, projects, tasks, notes, pipeline/kanban |
| Money | Invoices, quotes, expenses, products, purchase orders, credits |
| Connect | Marketplace talent/jobs/inbox, listing, need post, detail sheets (v2.16) |
| Messages | Freelancer + client message screens (hybrid local/cloud) |
| Meetings | Jitsi |
| Team | Invites, accept → project share (improved v2.16) |
| AI | Local offline insights (`ai_assistant_service`) — not cloud LLM chat |
| Subscription | Upgrade / Play Billing / referrals |
| Admin | Admin console |
| Settings | Security, biometrics, backup |
| Sync | Outbox + conflict resolution dialogs (v2.15) |

## C2. Web (`web/src/app/`)

| Route area | Purpose |
|------------|---------|
| `/` marketing | Hero, Connect pitch, pricing CTAs (hero redesigned v2.16) |
| `/connect` | Public marketplace Talent / Jobs / Inbox |
| `/connect/manage` | Pro Plus listing / job CRUD |
| `/pro` | Checkout, promo codes, JazzCash/manual, Stripe stubs |
| `/app/*` | Hub, clients, projects, invoices, messages, timesheets, meetings, support, referrals, account |
| `/docs` | Public help center (Markdown catalog) |
| `/admin` | Admin tools |
| Legal | privacy, terms, cookies, data-safety, delete-account |

## C3. Connect marketplace (core workflows)

1. **Browse** talent profiles and open jobs (guest + free OK on web).  
2. **Filter** by skills, category chips, sort Featured / Top rated / Newest / Rate.  
3. **Contact / Apply** requires Pro Plus (guests → signup → `/pro?plan=pro_plus`).  
4. **Connect request** stored; emails hidden until accept.  
5. **Accept** reveals emails; may kick off **milestone**; reviews/proposals via ConnectTrust.  
6. Continue relationship in **CRM messages / projects / invoices**.

### Key tables (Supabase)

`profiles`, `connect_profiles`, `connect_needs`, `connect_requests`, `connect_reviews`, `connect_proposals`, `connect_milestones`, `connect_escrow_ledger`, `client_messages`, `crm_embeddings`, `team_invites`, invoices (+ reminder columns), promo/referral tables.

### Key code paths

| Platform | Path |
|----------|------|
| Web board | `web/src/components/connect/ConnectBoard.tsx` |
| Web trust | `web/src/components/connect/ConnectTrust.tsx` |
| Web guest CTA | `web/src/components/connect/ConnectActions.tsx` |
| Flutter Connect | `lib/features/marketplace/connect_marketplace_screen.dart` |
| Flutter service | `lib/core/services/marketplace/connect_marketplace_service.dart` |
| Ask AI API | `web/src/app/api/ai/ask/route.ts` |
| Reminders | `supabase/functions/send-invoice-reminders/` |

---

# PART D — What we were doing (story of the work)

## D1. Mission of the cloud / recent sessions

Build and polish CLIVORA as an **Uber-for-freelancers + business OS**: trust, marketplace, growth loops, ops automation, then a large **UX + research-driven Connect improvement pass**, then **hand off to localhost** so you own the codebase on your PC and can train local AI.

## D2. Chronological arc (high level)

| Phase | Version | What happened |
|-------|---------|---------------|
| Foundation / Play | ~2.7–2.13 | Play Store builds, Connect v2/v3, role-aware web, docs site, kanban, trust APIs |
| Trust & reputation | **2.14** | Reviews on cards, reputation sort, completeness, Play payments docs, Features PDF |
| Growth & ops | **2.15** | Invoice reminders + daily cron, CLIVORA15 promo, referrals UI, proposal→milestone, Hub KPIs, Android sort/conflicts, Stripe portal stub, status PDF |
| Marketplace UX + USP | **2.16** | Em-dash purge, hero redesign, guest Buy Pro Plus, categories/Top Rated, Ask AI fallback, mobile Connect detail, web messages, Hub icons, team share fix, research map |
| Handoff | Jul 12 | `LOCALHOST_HANDOFF.md`, research uploads in repo, this training notes doc |

## D3. Problems you explicitly asked to fix (and outcomes)

| Your ask | Outcome |
|----------|---------|
| Publish APK/AAB + Features PDF like Play releases | Releases `v2.13`, `v2.15`, `v2.16` with direct download links |
| Status write-up + PDF on GitHub | `CLIVORA-Status-Done-and-Next-v2.15.pdf` on release |
| Explain Play merchant IDs | Documented; **not** in app code |
| Apply deep research carefully without redoing Done work | `RESEARCH_VS_SHIPPED` + gap plan → v2.15 |
| Activate promo, cron, check Vercel/Supabase low-cost | Promo live; cron scheduled; Vercel env must be pasted by you |
| Remove all em-dashes | Purged ~300+ user-facing hits in v2.16 |
| Fix marketing hero (messy / overlapping) | Redesigned one-composition hero + $0 fee USP |
| Guest Buy Pro for unlimited Connect | Browse free; Buy Pro Plus CTA for contact/post |
| AI not working | LLM if `OPENAI_API_KEY`; else download-app CTA; Flutter local AI polished |
| Improve Connect mobile jobs/descriptions | Detail bottom sheets, multi-line cards, categories |
| Fix web messages client/freelancer | Role-aware compose, unread filter, clearer threads |
| Hub-style icons elsewhere | Web Hub icon wells |
| Improve team collab mobile | Accept invite links project share; status subtitles |
| Fold Upwork/Fiverr/30+ requirements into plan | `RESEARCH_CONNECT_MARKETPLACE_MAP.md` + implemented slice |
| Move everything to localhost | Git push + handoff doc + research copies |

## D4. Research sources you found / shared

| Source | Use |
|--------|-----|
| Deep research reports 2, 3, 4 | OSS maps, UI roadmap, 15 areas (correct stale claims) |
| Ranking/Trust/Growth UX roadmap | P0–P4 priorities for v2.14–2.15 |
| Marketplace competitor brief (chat) | Upwork/Fiverr/Freelancer/Toptal + 30+ functional requirements + UX |
| Features & Improvements PDF/MD | Product inventory for AI discussion |
| Report (5) from Downloads | **Never received by agent** — add manually if you still have it |

**Important:** Report 4 wrongly claimed no escrow/proposals/video and Firebase auth. Reality is Supabase + proposals/milestones/ledger + Jitsi. Always prefer codebase + `RESEARCH_VS_SHIPPED`.

---

# PART E — Current plan (what we are improving / building toward)

## E1. Product strategy (locked)

1. Stay a **subscription business OS** with a private marketplace, not a commission marketplace.  
2. **Browse free → upgrade for action** (Pro Plus for Connect write actions).  
3. Ship trust and workflow depth before hosting heavy third-party platforms.  
4. Keep Android offline-first and web as marketing + cloud CRM companion.  
5. Local development is now primary; cloud agent was for burst shipping.

## E2. Improvement themes (active)

| Theme | Status | Focus |
|-------|--------|-------|
| Connect discovery & trust UX | **In progress / Partial** | Categories, detail, badges, zero-fee copy |
| Messaging parity | **Partial** | Web usable; realtime/attachments Later |
| AI usefulness | **Partial** | Keys + embed pipeline; app offline OK |
| Ops completion | **Manual** | Vercel secrets, OAuth branding, Play AAB track |
| Docs DX | **Partial** | Custom docs OK; search/Nextra Later |
| Team ACL | **Partial** | Share on accept done; finer permissions Later |
| Escrow money movement | **Deferred** | Ledger UI only until Stripe Connect compliance |

## E3. Priority backlog (for your local AI to execute)

### P0 — Finish ops (no new platforms)

- [ ] Google OAuth consent: App name = **CLIVORA**
- [ ] Vercel: set `SUPABASE_SERVICE_ROLE_KEY`
- [ ] E2E test invoice reminder email (Resend secrets on Edge Functions)
- [ ] Play Console: 4 SKUs Active + upload `clivora-2.16.0.aab`
- [ ] Merge working branch → `main` when stable

### P1 — High-leverage product (stay in-stack)

- [ ] Client **needs-action** dashboard (overdue invoices, pending proposals, disputed milestones)
- [ ] Connect **portfolio gallery** on profiles
- [ ] Saved searches + email alerts (cloud, not only local prefs)
- [ ] Recurring invoices on web
- [ ] Dispute ↔ support tickets bridge
- [ ] Wire `OPENAI_API_KEY` + real RAG embed-on-write for Ask AI
- [ ] Stronger Connect mobile proposals/milestones UI parity with web ConnectTrust

### P2 — Scale / polish

- [ ] Meilisearch when catalog search feels slow
- [ ] Docs search (Pagefind/FlexSearch) or Fumadocs/Nextra if docs > ~20–30 pages
- [ ] Typing indicators / richer realtime chat (still not Rocket.Chat)
- [ ] Optional Chatwoot **widget** for support only
- [ ] Urdu / i18n
- [ ] Accessibility pass (ARIA, keyboard)
- [ ] SEO for marketing pages

### P3 — Deferred intentionally

- Live Stripe Connect escrow funding / Express onboarding
- Contests (Freelancer.com style)
- Work Diary screenshots for hourly contracts
- Crypto / Solana escrow
- iOS App Store
- Discourse community / hosted team chat platforms

---

# PART F — 30+ Connect requirements map (summary)

Full table: `docs/internal/RESEARCH_CONNECT_MARKETPLACE_MAP.md`

**Done examples:** accounts/roles, browse-before-signup, search/sort, job posts, proposals, unlimited bids (subscription model), proposal→milestone, reviews/Top Rated, Hub KPIs, invoice reminders, zero-fee differentiator copy, guest Buy Pro Plus funnel.

**Partial examples:** categories, saved searches, messaging realtime, admin moderation, team ACL, web Ask AI, Stripe portal.

**Later examples:** contests, job attachments, Meilisearch, Chatwoot host, portfolio gallery, Urdu, Nextra, live escrow funding.

---

# PART G — Version history cheat sheet

| Tag / version | Highlights |
|---------------|------------|
| `v2.13.0-playstore` | APK/AAB, OAuth docs, features PDF |
| `v2.14` | Reputation, trust cards, Play payments docs |
| `v2.15.0-playstore` | Reminders, promo, referrals, Hub KPIs, conflicts, status PDF |
| `v2.16.0-playstore` | Hero, em-dash purge, Connect UX, AI fallback, messages, Hub icons, team share |

### Download links (2.16)

- Release: https://github.com/UsmanGhias/clivora/releases/tag/v2.16.0-playstore  
- APK: https://github.com/UsmanGhias/clivora/releases/download/v2.16.0-playstore/clivora-2.16.0.apk  
- AAB: https://github.com/UsmanGhias/clivora/releases/download/v2.16.0-playstore/clivora-2.16.0.aab  

---

# PART H — Localhost working setup (for AI context)

You have moved primary work to **localhost**. Source of truth is GitHub branch `cursor/pro-plus-web-v2-7-1-d928`.

```bash
git clone https://github.com/UsmanGhias/clivora.git
cd clivora
git checkout cursor/pro-plus-web-v2-7-1-d928

# Flutter
flutter pub get && flutter run

# Web
cd web && cp .env.example .env.local
# add SUPABASE_SERVICE_ROLE_KEY and optional OPENAI_API_KEY / STRIPE_*
npm install && npm run dev
```

Web deploy mirror: `bash web/push-to-clivora-web.sh`  
Signed Android builds need gitignored `android/key.properties` + `android/clivora-upload-keystore.jks`.

---

# PART I — Environment & secrets checklist

| Name | Where | Required? |
|------|-------|-----------|
| `NEXT_PUBLIC_SUPABASE_URL` | web `.env.local` / Vercel | Yes (in `.env.example`) |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | web / Vercel | Yes |
| `SUPABASE_SERVICE_ROLE_KEY` | web server + Vercel + some Edge | Yes for admin/AI embeddings |
| `RESEND_API_KEY` / `RESEND_FROM` | Supabase Edge secrets | Yes for reminders |
| `OPENAI_API_KEY` or `ANTHROPIC_API_KEY` | web | Optional (Ask AI cloud) |
| `STRIPE_*` | web | Optional (cards/portal) |
| `MEILI_HOST` / `MEILI_KEY` | web | Optional later |
| Play keystore passwords | `android/key.properties` | For release signing |

---

# PART J — Design / copy guidelines (for UI work)

From product + your frontend rules used in cloud work:

- Brand **CLIVORA** must be hero-level on marketing; one composition first viewport.
- Hero: brand + one headline + one sentence + one CTA group + full-bleed atmosphere; no card clutter in hero.
- Avoid generic purple/cream AI-slop themes; keep existing teal/navy CLIVORA tokens.
- Emphasize **$0 platform fee** and private contact in Connect marketing.
- No new user-facing em-dashes; middots (`·`) OK in CTAs.
- Icons: use Hub-style icon wells sparingly where they aid scanning (Hub, empty states).

---

# PART K — Testing smoke list (before you ship next build)

1. Marketing hero desktop + mobile readable.  
2. `/connect` as guest: browse works; Buy Pro Plus CTA visible; contact redirects to signup→pro.  
3. Pro Plus: send request, accept, see email + milestone/trust UI.  
4. Hub KPIs load; Ask AI either answers or shows download-app.  
5. Web messages send/reply/unread as freelancer and as client.  
6. Flutter Connect job/talent detail sheet; team invite accept shares project.  
7. `rg '—' web/src web/content lib` → no user-facing leftovers.  
8. Invoice reminder cron still healthy in Supabase (or document if paused).

---

# PART L — Prompt templates for your local AI

### L1. Start-of-session system prompt (copy/paste)

```
You are working on CLIVORA (CODCrafters): Flutter + Next.js + Supabase business OS
with private Connect marketplace. Version ~2.16. Read
docs/internal/CLIVORA-COMPLETE-AI-TRAINING-NOTES.md and
RESEARCH_CONNECT_MARKETPLACE_MAP.md. Do not redo Done items (reviews, reminders,
Hub KPIs, escrow ledger UI, em-dash purge, hero redesign). Auth=Supabase.
Do not vendor Keycloak/Rocket.Chat/Discourse/Kill Bill. Connect: browse free,
contact/post=Pro Plus, $0 platform fee USP. Prefer small focused diffs.
```

### L2. Implementation task prompt

```
Implement [FEATURE] on [web|flutter|both]. Follow existing patterns in
[file paths]. Update RESEARCH_CONNECT_MARKETPLACE_MAP status if needed.
No em-dashes in UI copy. Keep Pro $9 / Pro Plus $19 gating consistent.
```

### L3. Research-driven gap prompt

```
Using RESEARCH_CONNECT_MARKETPLACE_MAP and PART E backlog, pick the highest
P1 item not Done, propose a short plan against current files, then implement
only that item.
```

---

# PART M — What is left (honest remaining work)

### Must-do soon (blocks “production complete” feeling)
Ops secrets, OAuth branding, Play AAB upload, reminder E2E proof.

### Product gaps users will feel
Portfolio on profiles, richer realtime messaging, cloud saved searches, web recurring invoices, stronger AI when keyed, client needs-action home.

### Strategic bets (only when ready)
Stripe Connect live escrow money movement, Meilisearch, i18n Urdu, iOS, optional support widget.

### Explicitly out of scope for now
Rebuilding auth on Keycloak/NextAuth, replacing messaging with Rocket.Chat, hosting Discourse, forking Twenty/Kill Bill, commission-based Connect tokens.

---

# PART N — File index for deeper reading

| Path | Why |
|------|-----|
| `docs/internal/LOCALHOST_HANDOFF.md` | Move to PC |
| `docs/internal/CLIVORA-COMPLETE-AI-TRAINING-NOTES.md` | This file |
| `docs/internal/RESEARCH_CONNECT_MARKETPLACE_MAP.md` | Marketplace feature matrix |
| `docs/internal/RESEARCH_VS_SHIPPED_v2.15.md` | Research corrections |
| `docs/internal/research-uploads/*` | Original research dumps |
| `docs/internal/CLIVORA-Roadmap-Ranking-Trust-Growth-UX.md` | Ranking roadmap |
| `docs/internal/CLIVORA-Features-and-Improvements.md` | Features inventory |
| `docs/internal/GOOGLE_PLAY_PAYMENTS_ACCOUNT.md` | Merchant IDs |
| `docs/internal/VERCEL_ENV_SETUP.md` | Env |
| `docs/internal/INVOICE_REMINDERS.md` | Cron/reminders |
| `web/content/docs/*` | Public help center |
| `supabase/migrations/*` | Schema history |
| `lib/core/constants/plan_features.dart` | Feature gates |
| `web/src/lib/plan.ts` | Web plan helpers |
| `web/src/lib/site.ts` | Brand + pricing constants |

---

# PART O — One-page executive summary

CLIVORA is CODCrafters’ freelancer/client **business OS** with a **private, zero-commission Connect marketplace**, sold via **Pro ($9)** and **Pro Plus ($19)**. Stack is **Flutter + Next.js + Supabase**. Through cloud work we shipped trust (2.14), growth/ops (2.15), and marketplace UX/USP polish (2.16), published APK/AAB releases, and documented everything for **localhost**. Research from Upwork/Fiverr-style requirements is mapped; many items are Done, several Partial, and money-moving escrow / Meilisearch / i18n / contests remain Later. Your job on localhost is to finish **P0 ops**, then **P1 product gaps**, while training AI on this document so assistants never reinvent the architecture or reopen finished work.

---

*End of CLIVORA Complete Project Knowledge Base. Keep this file updated when you merge major features: bump version section, move backlog items from Later → Done, and never delete the architecture locks.*
