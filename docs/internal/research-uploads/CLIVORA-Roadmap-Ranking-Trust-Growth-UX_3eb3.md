# CLIVORA v2.13 — Roadmap Ranking, Trust & Growth Research, UI/UX Plan

**Companion to:** CLIVORA-Repo-Research-and-Cursor-Instructions.md
**Source:** CLIVORA-Features-and-Improvements.pdf (v2.13.0)

This answers your own brief's prompt template directly: ranked P0–P4 ideas, top 5 with schema/eng detail, security risks, pricing packaging — plus new open-source research aimed at trust, conversion, and home page/dashboard UX, since v2.13 shows you're much further along than the v2.10 brief suggested.

---

## 1. What's actually shipped — the real picture

Reading v2.13 against v2.10, CLIVORA has moved from "CRM with a marketplace bolted on" to a genuinely two-sided platform with real infrastructure most competitors' MVPs don't have yet:

- **Escrow ledger + admin release API already exists** — this is the single hardest part of a trust-based marketplace and you have the data model for it.
- **Reviews, proposals, and milestone status machine are live** — the core "hire with confidence" loop is built.
- **Offline sync has generalized conflict records**, not just invoice-specific handling — this is ahead of where most "offline-first" apps get to.
- **AI foundation (pgvector + `crm_embeddings` + Ask AI widget) is wired**, just not fully "real RAG" yet.
- **Messaging has threads + read receipts already** — the P4 item "typing indicators + media gallery" is genuinely the *last 10%*, not core functionality.

This changes the ranking math versus a "greenfield" reading of the brief: several P1/P2 items are **finishing touches on existing infrastructure**, not new builds. That's the good news — it means your top 5 next moves are cheaper than they look.

---

## 2. Ranked by Impact × (1/Effort) — next 4 sprints

Scoring: Impact 1–5 (revenue/trust/retention effect), Effort 1–5 (5 = multi-week), Score = Impact ÷ Effort.

| Rank | Idea | Impact | Effort | Score | Sprint |
|---|---|---|---|---|---|
| 1 | **Payment reminder Edge Function cron** | 4 | 1 | 4.0 | 1 |
| 2 | **Stripe live web subscriptions + Customer Portal** | 5 | 2 | 2.5 | 1 |
| 3 | **Connect reviews shown on public talent cards** | 4 | 2 | 2.0 | 1 |
| 4 | **Google OAuth branding fix** | 3 | 1 | 3.0 | 1 |
| 5 | **Escrow fund via Stripe Connect / payment intent** | 5 | 3 | 1.7 | 2 |
| 6 | **Conflict-resolution UI for all CRM entities** | 4 | 3 | 1.3 | 2 |
| 7 | **Proposals → contract → milestone auto-create** | 4 | 2 | 2.0 | 2 |
| 8 | **Meilisearch live index + facets in production** | 3 | 2 | 1.5 | 2 |
| 9 | **Real RAG: embed on write (not just stub)** | 4 | 2 | 2.0 | 3 |
| 10 | **Verified badge workflow end-to-end** | 4 | 2 | 2.0 | 3 |
| 11 | **Client branded portal (logo/colors)** | 3 | 2 | 1.5 | 3 |
| 12 | **Saved searches + email alerts** | 3 | 2 | 1.5 | 3 |
| 13 | **Team seats complete (invite → accept → ACL)** | 3 | 3 | 1.0 | 4 |
| 14 | **Recurring invoices parity on web** | 3 | 2 | 1.5 | 4 |
| 15 | **Typing indicators + media gallery** | 2 | 2 | 1.0 | 4 |
| 16 | **i18n (UR/EN)** | 3 | 3 | 1.0 | 4+ |
| 17 | **Custom field builder UI (Twenty-style)** | 3 | 4 | 0.75 | Later |
| 18 | **Multi-currency tax rules** | 3 | 4 | 0.75 | Later |
| 19 | **Legal e-sign** | 3 | 3 | 1.0 | Later |
| 20 | **Changelog/blog for SEO** | 2 | 2 | 1.0 | Ongoing |

**Reasoning for #1–#3 as sprint-1 priorities:** they're all cheap (existing fields already support them — `reminder_sent_at`, `next_reminder_at`, and your reviews table already exist) and they directly hit trust + revenue, which is what you asked to prioritize.

---

## 3. Top 5 — engineering detail

### 1. Payment reminder Edge Function cron
- **Work split:** Supabase only (no Flutter/web changes needed for v1).
- **Schema:** None — `reminder_sent_at`/`next_reminder_at` already exist on invoices per your PDF.
- **Build:** A `pg_cron`-scheduled Supabase Edge Function that queries overdue invoices where `next_reminder_at <= now()`, sends via Resend/SendGrid, then updates both fields. Reuse your existing `automation_run_log` for observability.
- **Acceptance tests:** Invoice due date passes → reminder email sent within 1hr of cron run → `reminder_sent_at` updated → no duplicate sends on next cron tick → client marking invoice paid stops further reminders.

### 2. Stripe live web subscriptions + Customer Portal
- **Work split:** Web (Next.js) + Supabase (webhook Edge Function). No Flutter change (Android stays on Play Billing per your existing "no re-pay when already Pro" logic).
- **Schema:** Add `stripe_customer_id`, `stripe_subscription_id`, `stripe_price_id` to your existing `subscriptions` table (don't create a new table).
- **Build:** Activate the Stripe Checkout + webhook stubs you already have with real `STRIPE_*` secrets; add a "Manage Billing" button that opens the Stripe Customer Portal (self-serve cancel/upgrade — you don't build this UI yourself, Stripe hosts it).
- **Acceptance tests:** Web user subscribes via Stripe Checkout → plan gates unlock within seconds of webhook → Customer Portal allows self-serve cancel → cancel correctly downgrades plan gates → existing Play Store subscribers on Android are unaffected.

### 3. Connect reviews shown on public talent cards
- **Work split:** Web (Connect board UI) — reviews data already exists per your PDF.
- **Schema:** None — reviews (1–5) already implemented. Add an aggregate `avg_rating`/`review_count` materialized view or trigger-maintained columns on `connect_profiles` for fast card rendering (avoid a live JOIN on every board load).
- **Build:** Star rating + review count badge on every talent card in the public board; link to a reviews tab on the profile page.
- **Acceptance tests:** New freelancer with 0 reviews shows "New" badge instead of 0 stars (avoid looking broken); rating updates on card within seconds of a new review; board sort-by-rating works.

### 4. Google OAuth branding fix
- **Work split:** Google Cloud Console config + Supabase Auth dashboard — no code.
- **Build:** Complete OAuth consent screen verification with CLIVORA app name/logo (your PDF's §6 already lists this as a checklist item — this is a config task, not a dev task).
- **Acceptance tests:** Google sign-in screen shows "Sign in to CLIVORA" not "...to xxxx.supabase.co".

### 5. Escrow fund via Stripe Connect / payment intent
- **Work split:** Web (client funds escrow) + Supabase (ledger update on webhook) + Flutter (freelancer sees "funded" status).
- **Schema:** Add `stripe_payment_intent_id` and `funded_at` to your existing escrow ledger table.
- **Build:** Client clicks "Fund milestone" → Stripe PaymentIntent created (destination charge to freelancer's Connect account, platform fee taken) → webhook confirms → escrow ledger status flips to `funded` → your existing admin release API triggers the actual payout on milestone approval.
- **Acceptance tests:** Client funds a milestone → freelancer sees funded status in real time → admin release triggers payout to freelancer's connected Stripe account → platform fee correctly deducted → refund path works if a milestone is disputed/rejected before release.
- **Reference:** Stripe's own official sample [`stripe-archive/stripe-demo-connect-kavholm-marketplace`](https://github.com/stripe/stripe-demo-connect-kavholm-marketplace) and the current [`stripe-sample-global-marketplace`](https://github.com/auchenberg/stripe-sample-global-marketplace) show the exact "buyer funds → seller onboarded via Connect Express → platform routes funds → platform takes a cut" flow you need — read these for the PaymentIntent + Connect Express onboarding pattern, don't copy the demo's LowDB storage layer (you already have Postgres).

---

## 4. Security & compliance risks to flag before shipping

| Area | Risk | Mitigation |
|---|---|---|
| **Escrow** | Handling client funds without proper custody puts you in money-transmitter territory in many jurisdictions. | Use Stripe Connect's destination charges/separate charges-and-transfers so **Stripe holds the funds**, not your Supabase database — your ledger should mirror Stripe's state, never be the source of truth for actual money. |
| **OAuth branding** | Low risk, but an unverified OAuth consent screen can get flagged/rate-limited by Google at scale. | Complete Google's verification process before high-volume launch. |
| **PII in Connect profiles/reviews** | Freelancer/client emails only reveal after mutual accept — make sure this is enforced by RLS, not just UI logic. | Add a Postgres RLS policy test: query `connect_profiles` email field directly as an unrelated authenticated user and confirm it's null/hidden until acceptance, not just hidden in the UI. |
| **Service role key** | Your env checklist correctly notes `SUPABASE_SERVICE_ROLE_KEY` is server-only — confirm no Edge Function accidentally logs it, and that it's excluded from any client bundle. | Add a CI check (grep for the key pattern in build output) before each deploy. |
| **Webhook secrets** | Stripe and automation webhooks (`AUTOMATION_WEBHOOK_SECRET`, `STRIPE_WEBHOOK_SECRET`) must verify signatures, not just presence of a secret in the payload. | Confirm your Edge Functions use Stripe's signature verification helper, not a manual string compare. |
| **Reminder cron / email sending** | Sending payment reminders on every cron tick without dedup risks spamming clients and looking unprofessional (a trust problem, not just a technical bug). | The idempotency check in the acceptance test above (§3.1) is not optional — a client getting 5 reminder emails in an hour will complain publicly. |

---

## 5. Pricing packaging after these ship

Based on what genuinely differentiates each tier once escrow, reviews, and reminders are live:

| Feature | Free | Pro ($9/mo) | Pro Plus ($19/mo) |
|---|---|---|---|
| CRM (clients/projects/invoices, limited count) | ✅ (capped) | ✅ (uncapped) | ✅ |
| Offline sync | ✅ | ✅ | ✅ |
| Payment reminders | ❌ (manual only) | ✅ automated | ✅ automated |
| Recurring invoices | ❌ | ✅ | ✅ |
| Stripe subscriptions/Customer Portal | — (platform feature) | — | — |
| Connect: browse only | ✅ | ✅ | ✅ |
| Connect: post jobs/profile, contact reveal | ❌ | ❌ | ✅ |
| Connect: escrow milestones | ❌ | ❌ | ✅ |
| Verified badge | ❌ | Available (paid add-on or Pro Plus only) | ✅ |
| AI Ask (RAG) | ❌ | ✅ capped queries/mo | ✅ higher cap |
| Branded client portal | ❌ | ❌ | ✅ (white-label is a strong Plus-only lever) |
| Team seats | ❌ | ❌ | ✅ (agency plan add-on) |

**Recommendation:** keep escrow + verified badge + branded portal as the clearest Pro→Pro Plus upgrade triggers — they're the three features that make a freelancer look *more credible to clients*, which is the actual purchase motivation for Plus, more than feature count.

---

## 6. New open-source research: trust, growth, discounts, and UI/UX

### 6.1 Trust & reviews (marketplace credibility vs. Upwork/Fiverr)
Since your escrow + reviews system already exists, the remaining gap is **surfacing trust signals** the way Upwork/Fiverr do (badges, response time, completion rate, verified identity). No single OSS repo does this well — it's a UX/data-presentation problem more than a code problem. Recommended trust signals to add to talent cards, in priority order:
1. Star rating + review count (you have the data — see §3.3 above)
2. "Responds within X hours" (derivable from your existing `client_messages` `read_at`/reply timestamps)
3. Job completion rate (derivable from your milestone status machine)
4. Verified badge (already on your roadmap)
5. "Member since" date (basic but proven trust signal on every major marketplace)

### 6.2 Referral & discount system
| Repository | Stars/status | License | Match | Difficulty | Notes |
|---|---|---|---|---|---|
| [Refferq/Refferq](https://github.com/Refferq/Refferq) | New, active | MIT | 8 | Medium | Next.js + Prisma affiliate/referral platform — closest stack match to your web app. Study its commission-rule and payout-approval data model (`PENDING`→`ACTIVE` affiliate states) and re-implement natively against your `subscriptions`/`connect_profiles` tables rather than running it as a separate app, so referral credit can plug directly into your existing plan-gate logic. |
| [prajwalnayak7/Coupon-Management-System](https://github.com/prajwalnayak7/Coupon-Management-System) | Small | Open source | 5 | Easy | Simple reference for a coupon/discount-code data model (code, % or fixed, expiry, usage cap) — good enough as a schema reference for a `promo_codes` table gating your Stripe Checkout session creation. |
| Reflio | Smaller, EU-focused | Open source | 5 | Medium | Alternative referral-platform reference if Refferq's Prisma setup doesn't fit; broadly the same pattern. |

**Recommended build (native, not a separate app):** a `promo_codes` table (code, discount type, %, max uses, expiry, applies_to plan) checked at Stripe Checkout session creation via `discounts: [{coupon: ...}]`, plus a `referrals` table (referrer_user_id, referred_user_id, reward_type, status) that grants a free month or Connect credit on the referred user's first paid conversion. This is a 1–2 week build, not a new subsystem.

### 6.3 Home page & dashboard UI/UX
| Repository | Stars | License | Match | Difficulty | Notes |
|---|---|---|---|---|---|
| [Kiranism/next-shadcn-dashboard-starter](https://github.com/Kiranism/next-shadcn-dashboard-starter) | ~6,000+ | MIT | 8 | Easy | Next.js + shadcn/ui dashboard with exactly the layout patterns CLIVORA's web `/app` needs: sidebar + KPI cards + charts (Recharts, which you already use) + command-palette search (`kbar`) + notification center + kanban. Use its **layout structure and component patterns**, not a wholesale swap of your existing admin. |
| [shadcnstore/shadcn-dashboard-landing-template](https://github.com/shadcnstore/shadcn-dashboard-landing-template) | Newer | MIT | 7 | Easy | Pairs a conversion-focused **landing page** with a dashboard in one template — useful reference for redesigning your marketing home page (`clivora.codcrafters.org`) with proper hero/social-proof/pricing/testimonial sections side-by-side with the dashboard it links to. |
| Tremor (dashboard component library) | ~3,000+ | Apache 2.0 | 6 | Easy | Drop-in KPI cards, progress bars, and chart primitives — a lighter-weight alternative to redesigning charts from scratch if you want a quick visual upgrade to the web dashboard's stats section. |

**Concrete home page recommendations** (based on what converts on competitor sites and the templates above):
1. **Above the fold:** one clear headline (what CLIVORA is, in one sentence) + one primary CTA ("Start Free") — not two competing CTAs.
2. **Social proof band immediately below the fold:** even a handful of real freelancer testimonials/logos beats none — this is what visitors distrust most about a new marketplace.
3. **"How it works" 3-step visual** (Sign up → Post/Browse → Get paid safely via escrow) — your escrow system is a genuine differentiator vs. many small competitors and deserves a hero-level callout, not a buried feature bullet.
4. **Pricing table above the fold on the pricing page**, not after scrolling — Free/Pro/Pro Plus with the Plus column visually emphasized as "Most Popular" since that's your highest-margin tier.
5. **Live counters if honest** (e.g. "X freelancers, Y projects completed") — powerful trust signal, but only ship this once the numbers are real and updating automatically from Supabase, never hardcoded (a stale/fake counter is worse than no counter).

**Concrete dashboard recommendations:**
1. Freelancer dashboard home should answer 3 questions at a glance: *What's overdue? What needs my action today (proposals/messages)? How much did I earn this month?* — KPI cards for these three, above everything else.
2. Client dashboard home should show: shared projects status, any pending approvals, and outstanding invoices to pay — mirror the freelancer's "what needs action" pattern for the other side of the marketplace.
3. Admin dashboard should surface **moderation queue depth** and **escrow-funds-awaiting-release** as the top two cards — these are the two places money/trust risk accumulates if ignored.
4. Use consistent card/chart primitives (Tremor or the shadcn starter's chart components) across all three dashboards so freelancer, client, and admin views feel like one coherent product, not three separately-built screens — this "100% sync" feeling you asked about is mostly a design-system consistency problem, not a data problem, since your backend already unifies everything through Supabase.

### 6.4 Growth loop summary
The fastest path to "million-dollar trajectory" growth, given what's already built, in order:
1. Ship the reviews-on-cards + verified badge (trust) — this is what gets a *second* client to trust the platform after the first one had a good experience.
2. Ship referrals (Refferq pattern) — turns satisfied freelancers into your cheapest acquisition channel, since freelancers already talk to other freelancers.
3. Ship the escrow-first home page messaging — "safer than Upwork" is a real, defensible claim once escrow is live, and should be your primary marketing angle against the two giants named in your own brief.
4. Only then invest in i18n/custom fields/multi-currency — real growth levers, but they compound an existing user base rather than create one.

---

## 7. What NOT to change (per your own instruction)

Per your brief's own prompt template: do not suggest replacing Supabase with Keycloak/Rocket.Chat/Discourse. Everything recommended above is either (a) a config/data-model change within your existing Supabase+Next.js+Flutter stack, or (b) a pattern borrowed from an MIT/Apache-licensed repo and re-implemented natively — no new backend platform is proposed anywhere in this document.
