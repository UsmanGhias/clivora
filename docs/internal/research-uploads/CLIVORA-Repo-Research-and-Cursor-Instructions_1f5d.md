# CLIVORA — Open-Source Pattern Research & Cursor Build Instructions

**Prepared for:** Usman Ghias / CODCrafters
**Purpose:** Identify mature open-source repos whose *patterns* (not code copy-paste) can accelerate CLIVORA's roadmap, then hand Cursor a clean, safe set of build instructions.

---

## ⚠️ Read this first — a security/business issue in your brief

Before the research: your brief is currently published at public URLs —
`/docs/ai-research-brief` and `/docs/CLIVORA-AI-Research-Brief.pdf` — and it lists your **internal file paths** (`lib/core/services/marketplace/connect_marketplace_service.dart`, `supabase/migrations/`, etc.), your **exact database table names**, your **pricing gates**, and your **full competitive roadmap** (what you're missing vs. Upwork/Fiverr).

CLIVORA is a closed, commercial product — not an open-source project — so this page should **not be public**. Anyone (including competitors) can currently read it and see exactly where your product is weak and what you plan to build next.

**Instruction to give Cursor (do this first, before anything else below):**
> Remove `/docs/ai-research-brief` and `/docs/CLIVORA-AI-Research-Brief.pdf` from all public routes and sitemaps. Do not delete the source content — move it to a private, authenticated internal-docs area (e.g. `/internal/` behind Supabase auth + an `is_admin` check, or simply out of the `web/public` and `web/src/app/docs` folders entirely and into a private repo/Notion). Add a `noindex` meta tag and a redirect (301 to `/docs`) for the old public URL in case it's already indexed by Google. Confirm no internal file paths, table names, or service names appear anywhere under `/docs` going forward — public docs should only ever describe *what a user can do*, never *how the code does it*.

Everything else in `/docs` (`/docs`, `/docs/user-guide`, `/docs/connect`) is fine to keep public — that's genuine user-facing help content.

---

## How to read the tables below

- **Match (1–10):** how directly the repo's pattern maps to a CLIVORA feature gap.
- **Difficulty:** Easy = drop-in pattern/config, adapt in days. Medium = re-implement the pattern in your stack, adapt in 1–3 weeks. Hard = different stack/architecture, treat as reference only.
- **Borrow, don't fork:** In every case below, the recommendation is to study the repo's *data model, UX flow, or architecture pattern* and re-implement it natively in Flutter/Next.js/Supabase — not to import their code wholesale (license and stack mismatch in most cases).

---

## 1. Freelancer CRM (core)

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | [twentyhq/twenty](https://github.com/twentyhq/twenty) | ~45,000 | AGPL-3.0 | 9 | Medium | Twenty's object/field model (custom objects, custom fields, pipeline "kanban" views on any entity) is the best modern reference for CRM data modeling. Study how they let any table become a kanban-able, filterable, sortable "object" — apply this pattern to your `crm_*` tables for a pipeline view of Projects. |
| 2 | EspoCRM | ~4,000 | GPL-3.0 | 6 | Hard | Zero-code custom-field/entity admin UI — useful reference for a future "let freelancers add their own CRM fields" feature. PHP stack, so architecture-only reference. |
| 3 | Krayin CRM | ~2,000 | MIT | 6 | Hard | MIT-licensed sales-pipeline UI patterns (drag-and-drop deal stages) and AI-assisted note/email drafting — good UX reference, Laravel stack so pattern-only. |
| 4 | Monica (personal CRM) | ~22,000 | AGPL-3.0 | 5 | Medium | Contact "life events" timeline and relationship notes UX — useful for enriching your client contact detail page beyond basic fields. |

**Borrow priority:** Twenty's pipeline/kanban-on-any-entity pattern, applied to your existing `crm_*` Supabase tables.

---

## 2. Invoicing & payments

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | [invoiceninja/invoiceninja](https://github.com/invoiceninja/invoiceninja) | ~9,000 | Elastic License 2.0 (source-available, **not** OSI open source) | 9 | Medium | Deepest invoicing feature set that exists in OSS: recurring invoices, partial payments, multi-currency, tax-line handling, PDF template system, client portal payment page. Study the *data model* (line items, tax rules, payment allocations) — do not copy code due to license. |
| 2 | [SolidInvoice/SolidInvoice](https://github.com/SolidInvoice/SolidInvoice) | ~2,000 | MIT | 8 | Medium | MIT-licensed, so safest to actually read/adapt code snippets from. Clean recurring-billing and Stripe/PayPal payment-reminder scheduling logic — good template for your `pro_payment_requests`/recurring invoice automation. |
| 3 | [crater-invoice-inc/crater](https://github.com/crater-invoice-inc/crater) | ~7,500 | AGPL-3.0 | 7 | Medium | Ships **both web (Laravel/Vue) and mobile (React Native)** apps for invoicing/expenses — good reference for keeping your mobile and web invoice builders in feature parity. |
| 4 | InvoicePlane | ~2,300 | MIT | 6 | Easy | Simple, well-documented invoice-template system (multiple PDF themes) — good starting point for your "invoice templates marketplace" improvement item. |

**Borrow priority:** SolidInvoice's Stripe/PayPal + reminder scheduling pattern (MIT, safest to reference directly) + Invoice Ninja's tax-line/multi-currency data model (read-only reference, Elastic license).

---

## 3. Offline-first sync (your #1 differentiator — protect and strengthen this)

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | PowerSync (Open Edition) | Source-available | FSL → Apache 2.0 after 2yr | 9 | Medium | <cite index="7-1">PowerSync now has official Flutter SDK support</cite> and, per its self-hosted release, can run against your own Supabase Postgres. It's the most production-tested Postgres↔SQLite sync engine for Flutter. Even if you don't adopt it wholesale, its **sync rules** concept (server-defined "which rows does this device get") is a strong upgrade path from your current pull-on-sign-in model. |
| 2 | ElectricSQL (Dart client) | Open source | Apache 2.0 | 8 | Medium | <cite index="3-1">The Dart Electric client is built on top of the Drift typed interface and integrates with Drift's stream queries for real-time sync updates</cite> — directly compatible with your existing Drift schema. Worth a spike since it requires the least rewrite of your current `lib/data/database/tables.dart`. |
| 3 | Mr-Pepe/syncable | Smaller/niche | Open source | 7 | Easy–Medium | Purpose-built for exactly your stack (Flutter + Drift + Supabase). <cite index="7-1">It resolves conflicts by rejecting incoming updates with an older `updated_at` timestamp than what's already in the backend</cite> — a clean, minimal last-write-wins pattern you could adopt directly for entities that don't need CRDT-level merging (e.g. tasks, notes). Also solves the Supabase realtime-connection-limit problem via device-presence tracking, which you'll hit as Connect grows. |
| 4 | sqliteai/sqlite-sync | Newer | Open source | 6 | Hard | CRDT-based, <cite index="2-1">syncs automatically with SQLite Cloud, PostgreSQL, and Supabase with no conflicts and no data loss</cite>, and <cite index="2-1">supports row-level security so each client only syncs its own authorized rows</cite> — interesting for a future "true CRDT, zero-conflict" rewrite, but a bigger architectural leap than the others. |

**Borrow priority:** Adopt Mr-Pepe/syncable's conflict-rejection trigger pattern immediately (cheap, matches your stack exactly) for entities beyond invoices; evaluate PowerSync or ElectricSQL as a 2026 roadmap item for a proper conflict-resolution UI.

---

## 4. CLIVORA Connect — private marketplace (weakest OSS coverage — expect to build most of this yourselves)

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | Cal.com | ~35,000 | AGPL-3.0 | 6 | Medium | Not a marketplace, but the **best OSS reference for a two-sided "request → accept → reveal contact" flow**, since that's exactly what booking/scheduling is. Study their availability + booking-request state machine and adapt it to your `connect_requests` accept/decline/email-reveal flow. |
| 2 | Documenso | ~9,000 | AGPL-3.0 | 5 | Medium | Best OSS e-signature/document-workflow reference — directly useful once you add contracts/proposals to Connect (milestone agreements, NDAs before contact reveal). |
| 3 | Getlancer Suite (bidding/quote/jobs modules) | Smaller, dual-licensed | OSL-3.0/Commercial | 4 | Hard | AngularJS, largely unmaintained-feeling stack, but the **module split itself is a useful mental model**: bidding marketplace vs. quote marketplace vs. job board vs. portfolio marketplace are four distinct UX patterns. Confirms Connect is closer to a "bidding + portfolio" hybrid. |
| 4 | Chatwoot (see also §6) | ~34,000 | MIT | 5 | Medium | Their agent-routing/assignment engine is a good reference for a future "match freelancer to job" auto-routing feature in Connect. |

**Reality check:** there is no mature, well-starred, MIT/Apache, Flutter-or-Next.js "Upwork clone" repo — the ones on GitHub topics (`upwork-clone`, `fiverr-clone`) are mostly unmaintained student projects or paid marketplace scripts (Getlancer, Yo!Gigs) that aren't OSI-licensed. **This is actually good news competitively** — it means Connect's reviews/ratings/escrow/milestones/proposals system is genuine whitespace where you can't shortcut with someone else's repo. Budget real engineering time here rather than searching for more repos.

---

## 5. Client portal

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | Documenso | ~9,000 | AGPL-3.0 | 6 | Medium | E-sign + approval-workflow UX for client sign-off on quotes/deliverables. |
| 2 | Crater (client-facing invoice view) | ~7,500 | AGPL-3.0 | 6 | Easy | Public token-based invoice view pattern — close to your existing `/i/[token]` page; compare their approach to file/attachment display on that page. |
| 3 | Chatwoot (widget theming) | ~34,000 | MIT | 5 | Medium | Per-account branding/theming system — reference for "branded portal per freelancer." |

---

## 6. Messaging & chat

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | [chatwoot/chatwoot](https://github.com/chatwoot/chatwoot) | ~34,000 | MIT | 8 | Hard (Rails/Vue, different stack) | Full reference architecture for **read receipts, typing indicators, file/media galleries, and threaded conversations** — the exact upgrades your brief lists as wanted. Pattern-only since it's Ruby on Rails, but the data model (conversations → messages → attachments → read markers) maps cleanly onto a new Supabase schema. |
| 2 | supabase-community/flutter-chat | Reference sample | MIT | 7 | Easy | <cite index="39-1">Demonstrates Supabase realtime with Flutter, including row-level-security patterns for 1-to-1 chat rooms</cite> — closest match to your exact stack (`client_messages` + Supabase Realtime), directly adaptable for threads/read-receipts. |
| 3 | Stream Chat Flutter SDK (proprietary, but docs/patterns are public) | N/A | Commercial (reference only) | 5 | Reference only | Good UX reference for voice-note and typing-indicator components even though it's not something you'd install (adds vendor cost); replicate the *UI pattern*, not the SDK. |

---

## 7. Auth, roles & multi-tenant patterns

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | Mr-Pepe/syncable (RLS examples) | Smaller | Open source | 7 | Easy | Clean example RLS policies for per-user data isolation on Supabase, directly transferable to your `crm_*` and `connect_*` tables. |
| 2 | ra-supabase (marmelab) | Mid-size | MIT | 6 | Easy | Ready-made Supabase authProvider with OAuth callback wiring — reference for a future SSO/org-account rollout on the web admin. |
| 3 | Twenty (workspace/role model) | ~45,000 | AGPL-3.0 | 6 | Medium | Multi-workspace + role/permission model, useful once you add "agency teams" to Connect (item #4 on your improvement list). |

---

## 8. Subscriptions & billing

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | SolidInvoice (recurring billing engine) | ~2,000 | MIT | 7 | Medium | Cleanest MIT-licensed reference for Stripe subscription lifecycle (create, upgrade, dunning/reminders) — apply to your planned "Stripe subscriptions on web" item. |
| 2 | Invoice Ninja (payment-gateway abstraction layer) | ~9,000 | Elastic 2.0 | 6 | Hard (license) | Study (don't copy) how they abstract multiple payment gateways behind one interface — useful if you add PayPal alongside Stripe. |

---

## 9. Admin panel & moderation

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | [refinedev/refine](https://github.com/refinedev/refine) | ~30,000 | MIT | 9 | Easy | <cite index="48-1">Headless React framework purpose-built for admin panels/internal tools with a first-class Supabase data provider, auto-generated CRUD UIs, and out-of-the-box real-time support</cite> — the single best fit for rebuilding your Next.js web admin (users, block/restrict, Connect moderation, payment approval) faster and with less boilerplate. |
| 2 | ra-supabase / react-admin | ~20,000+ (react-admin) | MIT | 7 | Easy | <cite index="50-1">Integrates seamlessly with Supabase — authentication, permissions, CRUD API, and realtime all work out of the box</cite>. A solid alternative to Refine if you want a more opinionated, faster-to-ship admin UI. |

**Borrow priority:** This is your **highest-ROI, lowest-risk win** on the whole list — Refine + its Supabase provider is MIT, matches your exact stack (Next.js + Supabase), and can replace hand-rolled admin CRUD screens directly.

---

## 10. Time tracking & projects

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | Kimai | ~3,500 | AGPL-3.0 | 7 | Hard (PHP) | Mature timesheet-approval and billable-rate-per-project model — the best reference for your "timesheet approval" improvement item. |
| 2 | Crater (time entries → invoice) | ~7,500 | AGPL-3.0 | 6 | Medium | Direct pattern for "billable time entry converts to invoice line item," which you already partially have — compare their conversion UX. |

---

## 11. Reports & analytics

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | Metabase (embedding patterns, not self-host) | ~40,000 | AGPL-3.0 | 5 | Hard | Reference only for embedded-BI patterns; too heavy to self-host inside a mobile-first product — better to build lightweight charts natively with a charting library than embed Metabase. |
| 2 | Recharts / Chart.js (libraries, not apps) | N/A | MIT | 8 | Easy | For the actual "custom report builder" feature, a charting library on the Next.js web admin (Recharts) is more practical than any full BI tool. |

---

## 12. AI assistant (app)

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | Supabase pgvector + Edge Functions RAG pattern (official Supabase docs/examples) | Reference | MIT/Apache | 8 | Medium | The standard "embed your Postgres rows with pgvector, query via Edge Function" pattern is a near-perfect fit since you're already on Supabase — this is how to turn your "template-based local insights" into real RAG over CRM data without adding new infrastructure. |
| 2 | Twenty (AI/MCP layer) | ~45,000 | AGPL-3.0 | 5 | Hard | Reference for exposing CRM data to an LLM via a structured tool/MCP layer — relevant once you want a chat-style AI assistant inside CLIVORA itself, not just insights. |

---

## 13. Automations & workflows

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | [n8n-io/n8n](https://github.com/n8n-io/n8n) | <cite index="60-1">~196,000 stars, among the top 50 most-starred projects on GitHub</cite> | Sustainable Use License (source-available) | 9 | Easy (integrate, don't fork) | <cite index="59-1">Fair-code workflow automation platform with native AI capabilities, combining visual building with custom code, self-host or cloud, and 400+ integrations</cite>. Rather than building a Zapier-like visual builder from scratch (your improvement item), **self-host n8n and trigger it via webhooks from your Supabase Edge Functions** — this is by far the fastest path to "visual workflow builder + webhooks," and Documenso already ships an official n8n node if you add e-signing. |

**Borrow priority:** Don't rebuild a workflow engine — integrate n8n as an automation backend behind your existing `automation_run_log`.

---

## 14. File vault & attachments

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | Supabase Storage (native, already your backend) | N/A | Apache 2.0 | 8 | Easy | You already have this — the improvement is policy/config, not a new repo: enable S3-compatible bucket policies + signed URLs for time-limited sharing, which Supabase Storage supports natively. |
| 2 | Documenso (document workflow) | ~9,000 | AGPL-3.0 | 5 | Medium | Reference for OCR/document-processing pipeline if you add scanned-receipt OCR to expenses. |

---

## 15. Marketing website & docs

| Rank | Repository | Stars (approx) | License | Match | Difficulty | What to borrow |
|---|---|---|---|---|---|---|
| 1 | Nextra | ~12,000 | MIT | 7 | Easy | Clean Next.js docs-site framework — good fit for rebuilding `/docs` **as a genuinely public-safe, user-only help center** once the research brief is removed (see the security note at the top of this document). |
| 2 | Fumadocs | Newer, growing | MIT | 6 | Easy | Modern alternative to Nextra/Mintlify if you want more out-of-the-box design polish for the public docs/changelog. |

---

## Repos that cover multiple CLIVORA areas (highest value)

| Repository | Areas covered | Why it's high-leverage |
|---|---|---|
| **Twenty** (twentyhq/twenty) | CRM, Auth/roles, AI/MCP | Best single reference for your core data model, pipeline UX, and future AI-over-CRM-data feature. |
| **Chatwoot** | Messaging, Client portal, Connect (routing) | One architecture teaches you conversations+attachments+read-receipts (messaging), branded per-account theming (client portal), and agent-assignment routing (Connect matching). |
| **n8n** | Automations, Invoicing (payment reminders), Connect (notifications), AI assistant (agent workflows) | A single self-hosted integration unlocks four of your "what to improve" bullets at once. |
| **Refine + Supabase provider** | Admin panel, Reports/analytics (dashboards), Auth/roles (permissions) | Fastest, lowest-risk rebuild of your entire web admin surface. |
| **Documenso** | Connect (contracts before reveal), Client portal (e-sign/approval), File vault (document workflow) | E-signature is a recurring gap across three of your feature areas — solve it once, reuse everywhere. |

---

## Cursor build instructions (copy this whole section into Cursor)

> **Context for Cursor:** CLIVORA is a closed-source, commercial Business OS for freelancers (Flutter mobile + Next.js/Supabase web). We are NOT open-sourcing it and we are NOT copying code from any GitHub repo verbatim — the repos below are studied for their *data models and UX patterns only*, then re-implemented natively in our stack (Flutter 3.x/Dart/Riverpod/Drift on mobile, Next.js 15/React 19/TypeScript/Tailwind + Supabase on web). Do not import, vendor, or reference any third-party repo's source code directly in this codebase.
>
> **Priority order for this sprint cycle:**
> 1. **Admin panel rebuild** — adopt Refine's Supabase data-provider pattern (`@refinedev/supabase`) to replace hand-rolled CRUD screens in `web/src/app/` for user management, Connect moderation, and payment approval. This is MIT-licensed and lowest-risk.
> 2. **Offline sync hardening** — implement the last-write-wins conflict trigger pattern (reject incoming updates with an older `updated_at`) across all `crm_*` and `connect_*` tables in `supabase/migrations/`, not just invoices. Add a per-entity `sync_status` column so the UI can show pending/synced/conflict state.
> 3. **Messaging upgrade** — extend `client_messages` schema to support: threads (`parent_message_id`), read receipts (`read_by` array or join table), and a file-gallery view. Reuse the existing Supabase Realtime channel, don't add a new provider.
> 4. **Workflow automation** — stand up a self-hosted n8n instance, expose a Supabase Edge Function webhook that n8n can call, and route `automation_run_log` events (overdue follow-up, welcome, weekly summary) through it instead of hardcoded logic, so non-engineers can edit automation flows visually later.
> 5. **AI assistant v1** — add a pgvector column to relevant `crm_*` tables, write a Supabase Edge Function that embeds new rows on insert/update, and build a simple RAG query function ("ask a question about this client's history") behind the existing Pro-tier AI gate in `lib/core/constants/plan_limits.dart`.
> 6. **Connect trust layer** — design (from scratch — no good OSS reference exists) a reviews/ratings table + milestone/proposal schema for `connect_requests`, taking UX cues from Cal.com's request→accept state machine for the acceptance flow specifically.
>
> **Documentation task (do this alongside the above):**
> Remove `/docs/ai-research-brief` and `/docs/CLIVORA-AI-Research-Brief.pdf` from all public routes, the sitemap, and any nav links in `web/src/app/docs/`. Move that content to a private/internal location outside the public docs folder. Rebuild `/docs` to contain **only end-user-facing content**: how to create an invoice, how Connect works, how to invite a client, billing/plan FAQs. No file paths, table names, service names, internal roadmaps, or competitor-comparison strategy should appear anywhere under a public URL. Add `noindex` + a redirect from the old public research-brief URL.

---

## Success criteria check

- ✅ 3+ strong candidates per major area (CRM, invoicing, offline sync all have 3–4 above).
- ⚠️ Marketplace area has fewer strong direct-match repos than the others — flagged above as genuine competitive whitespace rather than a research gap.
- ✅ 5+ repos combine multiple areas (table above lists 5: Twenty, Chatwoot, n8n, Refine, Documenso).
- ✅ Next steps, effort, and license risk called out per repo.

**Next step recommendation:** Start with #1 (Refine admin rebuild) and #4 (n8n integration) — both are MIT/Sustainable-Use-licensed, match your exact stack, and can each be spiked in under a week.
