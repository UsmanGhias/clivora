# CLIVORA — Next builds (from deep research, prioritized)

Sanitized product priorities. No escrow rules, ranking weights, RLS, or secrets.

## Do next (highest trust / conversion)

1. **Web Stripe subscriptions + billing portal** — when ready; until then keep `/pro` manual path.
2. **Meilisearch-powered Connect discovery** — facets, typo tolerance, saved searches + alerts.
3. **Proposal → contract → milestone workroom** — hire flow clarity.
4. **Branded client portal approvals** — quotes / milestones / payment CTA.
5. **Admin audit + impersonation + moderation queues** — trust ops console.

## Already shipping / polished this pass

- Marketing trust section (globe + floating stats) with **reduced** social numbers.
- Homepage promise: Business OS + private Connect + offline Android.
- Android: freelancer command-center order (agenda/queue first), Connect trust strip, client unread message badge.

## Borrow OSS patterns (UX only — keep business logic proprietary)

Twenty · Invoice Ninja · Meilisearch · Chatwoot · React-Admin/Refine · Activepieces · Logto · Documenso · Vercel AI SDK

## Doc policy

| Layer | Include | Never include |
|-------|---------|---------------|
| Public / product | User flows, screenshots, FAQs | Secrets, RLS, fraud, ranking, escrow internals |
| Contractor (`docs/public-contractors`) | Routes, design tokens, public API shapes | Service role, admin bypasses, dispute heuristics |
| Internal (`docs/internal`) | Architecture, audits, roadmap | — (keep private) |
