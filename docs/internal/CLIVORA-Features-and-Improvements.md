# CLIVORA — Features Implemented & Improvement Roadmap

**For AI research / product discussion**  
**Product:** CLIVORA (Flutter Android + Next.js web + Supabase)  
**Version:** 2.13.0  
**Live web:** https://clivora.codcrafters.org  
**Company:** CODCrafters  

Give this PDF to your AI and ask: *“Rank the improvement ideas by user impact vs engineering effort for a freelancer OS + private marketplace. Propose a next sprint.”*

---

## 1. What CLIVORA is today

CLIVORA is a **business operating system** for freelancers and clients:

1. **CRM** — clients, projects, invoices, expenses, notes, tasks  
2. **CLIVORA Connect** — private marketplace (contact unlocks only after mutual accept)  
3. **Client portal** — shared work, invoices, messages  
4. **One account** — web + Android (offline CRM on Android)

**Plans:** Free (limits) · Pro $9/mo · Pro Plus $19/mo (Connect posting/contact)

---

## 2. Features already implemented (shipped)

### 2.1 Authentication & accounts
- Email/password + Google sign-in (web OAuth + Android native Google Sign-In)
- Freelancer vs Client account types (locked per email)
- Email verification soft gate
- Blocked / restricted account enforcement on web + app
- MFA guidance (TOTP via Supabase Auth) + biometric app lock (Pro, Android)

### 2.2 Freelancer CRM (Android primary, web cloud)
- Clients, projects, invoices, expenses, notes, products, quotes
- Offline SQLite (Drift) + sync outbox to Supabase `crm_*`
- Last-write-wins conflict triggers + generalized conflict records
- Project **pipeline / kanban** (web + Android)
- Partial payments / payment allocations + invoice status `partial`
- Tax lines field on cloud invoices
- Custom fields (JSONB) editor on web clients
- Time tracking (Android) + cloud timesheets with approve/reject (web)

### 2.3 Invoices & sharing
- Invoice builder, PDF (Android), public share link `/i/[token]`
- Recurring invoices (Android)
- Client payment confirmation flows
- Reminder fields (`reminder_sent_at`, `next_reminder_at`) ready for scheduler

### 2.4 CLIVORA Connect marketplace
- Public board: Talent / Jobs / Inbox
- Skill filters, sort, search (Postgres; Meilisearch helper when configured)
- Private Connect requests → accept → reveal email
- Profile manage + job posts (Pro Plus)
- **Reviews** (1–5), **proposals**, **milestones** status machine
- Escrow ledger + admin release API (fund/release path)
- Restricted users: browse only

### 2.5 Messaging
- Freelancer ↔ client cloud messages
- Threads (`parent_message_id`), read receipts (`read_at`), attachments metadata
- Web thread UI with reply + mark read

### 2.6 Web app & marketing
- Landing, Connect marketing, pricing, FAQ, help center `/docs`
- Authenticated `/app` CRM + Hub + Account
- Timesheets, Meetings (Jitsi room links), Support tickets
- Smart App CTA (install / open Android)
- Role themes: freelancer teal vs client slate

### 2.7 Billing
- Google Play Billing (Android Pro / Pro Plus)
- Web manual checkout (JazzCash / Easypaisa / bank)
- Stripe Checkout + webhook **stubs** (activate with `STRIPE_*` secrets)
- No re-pay when already Pro / Pro Plus

### 2.8 Admin
- Users: block / restrict
- Payment request approval → grant plan
- Connect moderation + auto-approve toggles
- Feature flags editor
- Escrow milestone release
- Stats / events / audit

### 2.9 AI & automations (foundation)
- Ask AI Hub widget + `/api/ai/ask` (Pro-gated; RAG stub over `crm_embeddings`)
- `pgvector` + `crm_embeddings` table ready
- n8n / automation webhook queue API
- Local Android AI insights (template-based)

### 2.10 Files & meetings
- Vault share links API (signed token + expiry)
- Meeting links stored as Jitsi URLs
- Chat attachment storage policies

---

## 3. Best improvements to discuss with AI (prioritized)

Score each idea for **impact**, **effort**, **risk**, and **monetization**.

### P0 — Trust & conversion (do next)
| Idea | Why it matters |
|------|----------------|
| Finish Google OAuth branding (CLIVORA name, not supabase.co) | First-session trust |
| Stripe live web subscriptions + Customer Portal | Global paid conversion |
| Connect reviews shown on public talent cards | Marketplace trust vs Upwork |
| Payment reminder Edge Function cron | Reduces unpaid invoices |
| Conflict-resolution UI for all CRM entities | Protect offline differentiator |

### P1 — Marketplace depth
| Idea | Why it matters |
|------|----------------|
| Escrow fund via Stripe Connect / payment intent | Real money protection |
| Proposals → contract → milestone auto-create | Smooth hire flow |
| Meilisearch live index + facets in production | Fast talent/job discovery |
| Saved searches + email alerts | Retention |
| Verified badge workflow end-to-end | Quality signal |

### P2 — CRM power
| Idea | Why it matters |
|------|----------------|
| Custom field builder UI (Twenty-style) | Agency flexibility |
| Recurring invoices parity on web | Desktop power users |
| Multi-currency tax rules | International freelancers |
| Client branded portal (logo/colors per freelancer) | White-label Plus |
| Team seats complete (invite → accept → ACL) | Agency plan |

### P3 — AI & automation
| Idea | Why it matters |
|------|----------------|
| Real RAG: embed clients/projects/invoices on write | Pro AI that feels magical |
| Invoice draft from chat / Connect brief | Time saved |
| Connect profile optimizer (skills + rate suggestions) | Better listings |
| Visual n8n recipes for overdue / welcome / weekly summary | Non-engineer ops |
| Proposal writer from job post | Win rate |

### P4 — Polish & platform
| Idea | Why it matters |
|------|----------------|
| Typing indicators + media gallery in chat | Modern messaging |
| Legal e-sign (hash + IP already stored) UX polish | Contracts |
| i18n (UR / EN) | Pakistan + global |
| Changelog / blog for SEO | Growth |
| Play AAB continuous release + crash reporting | Quality |

---

## 4. Prompt to paste into ChatGPT / Claude / Cursor

```
You are a product + eng advisor for CLIVORA (freelancer CRM + private marketplace).
Read the attached features PDF (v2.13).

1) Rank the P0–P4 improvement ideas by Impact × (1/Effort) for the next 4 sprints.
2) For the top 5, specify: Flutter vs Web vs Supabase work, schema changes, and acceptance tests.
3) Call out any security/compliance risks (escrow, OAuth branding, PII).
4) Propose pricing packaging: what stays Free / Pro / Pro Plus after these ships.
5) Do NOT suggest replacing Supabase with Keycloak/Rocket.Chat/Discourse — prefer native patterns.
```

---

## 5. Technical stack (for engineers)

| Layer | Stack |
|-------|--------|
| Mobile | Flutter, Riverpod, Drift, Google Sign-In, Play Billing |
| Web | Next.js 15, React 19, Tailwind, Recharts |
| Backend | Supabase Auth, Postgres RLS, Realtime, Storage, Edge Functions |
| Deploy | Vercel (`clivora.codcrafters.org`), Google Play |

Repos: `github.com/UsmanGhias/clivora` · `github.com/UsmanGhias/clivora-web`

---

## 6. Env vars checklist (production)

**Vercel (project `clivora`):**
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` (or publishable)
- `SUPABASE_SERVICE_ROLE_KEY` (server only — never public)
- Optional: `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `MEILI_HOST`, `MEILI_KEY`, `AUTOMATION_WEBHOOK_SECRET`, `N8N_WEBHOOK_URL`

**Supabase Auth Dashboard:** Site URL + Redirect allowlist → `https://clivora.codcrafters.org/**`

**Google Cloud:** OAuth consent App name = **CLIVORA**, publish app, logo + privacy/terms links.

---

*End of document — CLIVORA v2.13.0 · CODCrafters*
