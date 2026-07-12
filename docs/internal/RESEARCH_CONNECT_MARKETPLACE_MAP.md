# CLIVORA Connect marketplace map (research → product)

Maps the 30+ marketplace requirements (competitor brief + internal v2.15 status) to shipped code.

**USP:** $0 platform fees on negotiated rates. Monthly Connect credits with Pro Plus (100/mo). No Upwork-style Connect tokens.

| Area | Capability | Status | Notes |
|------|------------|--------|-------|
| Accounts | Email + Google signup, roles | Done | Supabase Auth |
| Accounts | Browse before full registration | Done | Web guest browse + Buy Pro Plus CTA |
| Categories | Service taxonomy filters | Partial | Category chips (keyword match) web + mobile |
| Discovery | Search, skill filters, sort | Done | Featured / rating / newest / rate |
| Discovery | Save searches | Partial | Mobile local saved |
| Discovery | Meilisearch typo-tolerant | Later | Helper exists |
| Jobs | Client job posts | Done | Manage + Connect board |
| Jobs | Contests | Later | — |
| Jobs | Attachments on posts | Later | — |
| Proposals | Submit + status | Done | Web ConnectTrust + mobile detail |
| Proposals | Monthly credits (subscription) | Done | Product rule + microcopy |
| Messaging | CRM messages web + mobile | Partial | Role-aware web inbox improved |
| Messaging | Realtime + Chatwoot | Later | App-first live chat |
| Contracts | Proposal → milestone | Done | Kickoff on accept |
| Escrow | Ledger + admin release | Done | Live Stripe fund deferred |
| Time | Timesheets | Done | CRM / Hub |
| Payments | Invoices + reminders | Done | Daily cron |
| Payments | Stripe Customer Portal | Stub | Needs STRIPE_* secrets |
| Reviews | Dual reviews + Top Rated | Done | Badge when ≥4.5 & n≥3 |
| Profiles | Portfolio gallery | Later | Manage listing exists |
| Dashboard | Hub KPIs + icons | Done | Web Hub icon wells |
| Admin | Moderation | Partial | Admin console |
| Security | Email verify, GDPR pages | Partial | — |
| i18n | Urdu | Later | — |
| Docs | Help center | Done | Custom `/docs` (Nextra later) |
| AI | Ask AI web | Partial | LLM if keyed else download-app |
| AI | Flutter offline insights | Done | Local heuristics |
| Team | Invites + project share | Partial | Accept links project share |
| Differentiator | Zero fee messaging | Done | Hero + Connect copy |

## Deferred intentionally
Full Stripe Connect escrow funding, Chatwoot host, Discourse/community, Work Diary screenshots, Nextra migration, crypto escrow, contests, guest money checkout.
