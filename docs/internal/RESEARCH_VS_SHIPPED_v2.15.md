# Research vs shipped (v2.15)

Maps deep-research-report (4) and the Ranking/Trust/Growth roadmap against the live CLIVORA codebase.
**Do not re-open items marked Done.**

## Corrections to report (4)

| Report claim | Reality |
|--------------|---------|
| Auth is Firebase / NextAuth | **Supabase Auth** (web + Flutter) |
| No escrow / formal proposals | **connect_milestones**, **connect_proposals**, **connect_escrow_ledger** exist |
| No video | **Jitsi** meeting links (`meeting_links`) |
| AI not implemented | Ask AI widget + `crm_embeddings` table (RAG still stub) |
| Offline sync “unclear” | Drift SQLite + generalized conflict records |

## Roadmap status

| Item | Status |
|------|--------|
| Connect reviews on talent cards + reputation sort | **Done (2.14)** |
| Profile completeness | **Done (2.14)** |
| Google Play payments profile docs | **Done (2.14)** |
| Payment reminder Edge Function | **Done (2.15)** `send-invoice-reminders` |
| Web referral UI | **Done (2.15)** `/app/referrals` |
| Promo codes on checkout | **Done (2.15)** (activate codes in DB) |
| Proposal accept → kickoff milestone | **Done (2.15)** |
| Live Hub KPIs | **Done (2.15)** |
| Android sort picker + entity conflict UI | **Done (2.15)** |
| Stripe live + Customer Portal | **Ops** — stubs ready; needs `STRIPE_*` secrets |
| Escrow fund via Stripe Connect | **Ops** — ledger ready; needs Connect Express |
| Google OAuth branding | **Ops** — Google Cloud consent screen |
| Meilisearch production | **Ops** — helper exists; needs host/key + wire-up |
| Real RAG embed-on-write | Later (needs LLM API) |
| Typing indicators / full i18n / team ACL | Later |

## Do not vendor

Keycloak, Rocket.Chat, Discourse, Twenty, Kill Bill as platforms — borrow patterns only; keep Supabase + Flutter + Next.js.
