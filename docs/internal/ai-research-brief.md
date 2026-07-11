# CLIVORA — AI Research Brief for GitHub Repo Matching

**Purpose of this document:** Give this entire brief to an AI assistant (ChatGPT, Claude, Cursor, etc.) and ask it to search GitHub for open-source projects that already implement one or more CLIVORA features. The goal is to find repos you can learn from, fork patterns from, or integrate ideas into CLIVORA.

**Product:** CLIVORA — cloud-first business OS for freelancers + private marketplace (Connect)  
**Live:** https://clivora.codcrafters.org  
**Repos:** https://github.com/UsmanGhias/clivora (Flutter) · https://github.com/UsmanGhias/clivora-web (Next.js)  
**Version:** 2.10.7  
**Author:** Usman Ghias / CODCrafters

---

## How to use this brief (copy-paste prompt for your AI)

```
You are researching GitHub repositories to help improve CLIVORA (freelancer CRM + private marketplace).

Read the full brief below. For each FEATURE AREA:
1. Search GitHub for mature open-source repos (prefer: active commits, 500+ stars, clear license, Flutter OR Next.js OR Supabase stack where possible).
2. List top 5–10 repos per area with: repo URL, stars, license, which CLIVORA feature it matches, and 2–3 sentences on what we could borrow.
3. Note integration difficulty: Easy (drop-in pattern) / Medium (adapt code) / Hard (different stack).
4. Flag any repo that combines MULTIPLE CLIVORA areas (highest value).
5. Exclude abandoned projects (no commits in 18+ months) unless uniquely relevant.

Output a ranked table: Feature → Repo → Stars → Match score 1–10 → Notes.
```

---

## What CLIVORA is (simple summary)

CLIVORA is **two things in one product**:

1. **Business OS (CRM)** — freelancers manage clients, projects, invoices, expenses, tasks, messages. Works **offline on Android** and **online on web**, synced through **Supabase**.
2. **CLIVORA Connect** — a **private marketplace** (like Upwork/Fiverr but safer): browse talent and jobs, send contact requests, emails unlock only after both sides accept. Requires **Pro Plus** plan.

There are **two user types**: **Freelancer** (full CRM) and **Client** (portal to view shared work). One email cannot switch between types.

**Pricing:** Free (limits) · Pro $9/mo · Pro Plus $19/mo (includes Connect).

---

## Feature areas to match on GitHub

For each area below: **what CLIVORA does today**, **what we want to improve**, and **GitHub search keywords**.

---

### 1. Freelancer CRM (core)

**What we have:** Clients, projects, invoices, expenses, notes, tasks, quotes, products, dashboard stats. Local SQLite on Android + cloud `crm_*` tables on Supabase. Web CRUD for clients/projects/invoices.

**What to improve:** Better UX, kanban projects, CRM pipelines, contact enrichment, duplicate detection, import/export.

**Search keywords:**
`flutter crm offline`, `freelancer crm app`, `invoice crm supabase`, `small business crm flutter`, `drift sqlite crm`, `nextjs crm dashboard`

**Compare against:** Twenty CRM, EspoCRM (patterns), Monica HQ (contacts), Invoice Ninja (invoicing).

---

### 2. Invoicing & payments

**What we have:** Invoice builder, line items, share links (`invoice_shares`), payment confirmation, recurring invoices (app), PDF generation (app), public token page `/i/[token]`.

**What to improve:** Stripe/PayPal integration, payment reminders, partial payments UI, multi-currency, tax lines, invoice templates marketplace.

**Search keywords:**
`flutter invoice pdf`, `invoice ninja flutter`, `supabase invoicing`, `nextjs invoice generator`, `open source invoicing react`

**Compare against:** Invoice Ninja, Crater App, SolidInvoice, Invoicen.

---

### 3. Offline-first sync (critical differentiator)

**What we have:** Drift SQLite, sync outbox, conflict handling for invoices, pull on sign-in, `local_id` mapping to cloud rows.

**What to improve:** Robust conflict UI, CRDT or version vectors, background sync, sync status per entity.

**Search keywords:**
`flutter offline first sync`, `drift supabase sync`, `sqlite cloud sync flutter`, `powersync dart`, `electric sql flutter`, `replicache flutter`

**Compare against:** PowerSync, ElectricSQL, WatermelonDB, Realm sync patterns.

---

### 4. CLIVORA Connect — private marketplace

**What we have:** `connect_profiles`, `connect_need_posts`, `connect_requests`, browse/search/filter, inbox accept/decline, email reveal after accept, Pro Plus gate, admin moderation.

**What to improve:** Reviews/ratings, escrow, milestones, proposals, saved searches, video intro, skill tests, agency teams, dispute flow — compete with Upwork/Fiverr.

**Search keywords:**
`freelance marketplace open source`, `upwork clone github`, `fiverr clone react`, `talent marketplace supabase`, `job board nextjs`, `gig economy platform flutter`

**Compare against:** Cal.com (booking patterns), NewPipe irrelevant; look for `lancer`, `worksome` clones, `microlancer`, open job boards with messaging.

---

### 5. Client portal

**What we have:** Client account type, slate theme, shared projects/invoices/quotes, client messages, activity feed, client tasks.

**What to improve:** Branded portal per freelancer, client approval workflows, e-sign, file upload portal.

**Search keywords:**
`client portal freelancer`, `customer portal nextjs`, `invoice client dashboard`, `white label client portal`

---

### 6. Messaging & chat

**What we have:** `client_messages`, Supabase realtime, image attachments, chat blocks, freelancer/client separate UIs.

**What to improve:** Threads, read receipts, typing indicators, file gallery, in-app voice notes.

**Search keywords:**
`supabase chat flutter`, `flutter chat realtime`, `nextjs supabase messaging`, `stream chat alternative open source`

---

### 7. Auth, roles & multi-tenant patterns

**What we have:** Supabase auth, Google OAuth, `account_type` locked, admin role, blocked/restricted flags, RLS policies.

**What to improve:** Org/team accounts, SSO, 2FA, audit logs UI.

**Search keywords:**
`supabase rls multi tenant`, `flutter supabase auth`, `nextjs supabase ssr roles`, `row level security patterns`

---

### 8. Subscriptions & billing

**What we have:** Google Play billing (Flutter), manual web checkout, `pro_payment_requests`, `subscriptions` table, plan gates in app + web.

**What to improve:** Stripe subscriptions on web, unified billing portal, usage-based pricing.

**Search keywords:**
`flutter in_app_purchase subscription`, `supabase stripe subscription`, `nextjs pricing stripe`, `revenuecat open source alternative`

---

### 9. Admin panel & moderation

**What we have:** Web admin: users, block/restrict, grant Pro/Plus, payment approval, Connect moderation, stats, events sync.

**What to improve:** Better analytics, impersonation, feature flags UI, bulk operations.

**Search keywords:**
`nextjs admin dashboard supabase`, `react admin panel supabase`, `open source admin tailwind`, `refine dev supabase`

**Compare against:** Refine, React-Admin, AdminJS with Supabase adapter.

---

### 10. Time tracking & projects

**What we have:** Project time entries, milestones, billable-to-invoice (app).

**What to improve:** Timer widget, timesheet approval, Harvest/Toggl integration.

**Search keywords:**
`flutter time tracking`, `open source toggl clone`, `project time tracker supabase`

---

### 11. Reports & analytics

**What we have:** Basic reports free, export Pro, analytics dashboard, `clivora_events`.

**What to improve:** Custom report builder, charts library, revenue forecasting.

**Search keywords:**
`flutter analytics dashboard`, `business intelligence react dashboard`, `metabase embed alternative`

---

### 12. AI assistant (app)

**What we have:** Template-based local insights from CRM data (Pro gate), not full LLM chat yet.

**What to improve:** RAG over client data, invoice draft AI, proposal writer, Connect profile optimizer.

**Search keywords:**
`flutter llm chat local`, `supabase pgvector rag`, `nextjs ai chat documents`, `open source copilot crm`

---

### 13. Automations & workflows

**What we have:** Overdue follow-up, welcome, weekly summary automations, `automation_run_log`.

**What to improve:** Visual workflow builder (Zapier-like), webhooks, n8n integration.

**Search keywords:**
`open source workflow automation`, `n8n self hosted`, `trigger action flutter`, `temporal workflow ui`

---

### 14. File vault & attachments

**What we have:** File attachments table, vault Pro, chat image storage policies.

**What to improve:** E2E encryption, S3-compatible storage, document OCR.

**Search keywords:**
`flutter file manager encrypted`, `supabase storage flutter`, `nextjs upload supabase storage`

---

### 15. Marketing website & docs

**What we have:** Next.js landing, pricing, FAQ, `/docs` site, SEO, Play Store CTAs.

**What to improve:** Blog, changelog, interactive demos, i18n.

**Search keywords:**
`nextjs saas landing template`, `documentation site nextjs`, `nextra docs`, `mintlify alternative open source`

---

## Tech stack constraints (prefer matching stacks)

| Layer | CLIVORA uses |
|-------|----------------|
| Mobile | Flutter 3.x, Dart, Riverpod, Drift |
| Web | Next.js 15, React 19, TypeScript, Tailwind |
| Backend | Supabase (Postgres, Auth, Realtime, Storage) |
| Deploy | Vercel (web), Google Play (Android) |

**Priority when ranking repos:**
1. Same stack (Flutter or Next.js + Supabase)  
2. MIT / Apache 2.0 / BSD license  
3. Active maintenance  
4. Feature overlap score  

---

## CLIVORA files to inspect (for AI with repo access)

```
lib/routing/app_router.dart
lib/core/constants/plan_limits.dart
lib/data/database/tables.dart
lib/core/services/marketplace/connect_marketplace_service.dart
lib/core/cloud/cloud_crm_repository.dart
web/src/app/connect/page.tsx
web/src/components/connect/ConnectBoard.tsx
web/src/lib/crm/api.ts
supabase/migrations/
```

---

## Output format requested from AI

For each feature area, produce:

```markdown
## [Feature area name]

| Rank | Repository | Stars | License | Match (1-10) | Difficulty | What to borrow |
|------|------------|-------|---------|--------------|------------|----------------|
| 1 | ... | ... | MIT | 9 | Medium | ... |
```

Then a **Top 10 overall** list of repos that cover the most CLIVORA surface area.

---

## Success criteria

Research is successful if you end with:

1. At least **3 strong repo candidates per major area** (CRM, invoicing, marketplace, offline sync).  
2. At least **5 repos** that combine marketplace + messaging or CRM + invoicing.  
3. Clear **next steps**: which repo to spike first, estimated effort, license risk.  

---

## Non-goals

- Do not recommend illegal scrapers or ToS-violating Upwork/Fiverr bots.  
- Do not recommend repos with no license.  
- Prefer self-hostable / OSS over SaaS-only APIs unless integration is trivial.

---

## Contact

Product owner: Usman Ghias — iusmanghias@gmail.com  
Company: CODCrafters — https://codcrafters.org

*End of AI Research Brief — CLIVORA v2.10.7*
