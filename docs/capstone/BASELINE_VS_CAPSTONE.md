# Baseline vs Capstone increment

This note exists so graders can see what shipped as a real product versus what is being executed as the MSSE Capstone.

## Baseline (already shipped — not claimed as the three sprints)

These capabilities exist in production at [clivora.io](https://clivora.io) and on Google Play (`org.codcrafters.clivora`):

- Freelancer and client accounts (Supabase Auth, Google sign-in)
- CRM: clients, projects, invoices, expenses, quotes, timesheets
- Android offline CRM (Drift SQLite) with a sync outbox to Supabase
- CLIVORA Connect: jobs, talent, proposals, mutual accept before email reveal
- Messaging, meetings (Jitsi links), public invoice share pages (`/i/[token]`)
- Free / Pro / Pro Plus gates; Android Play Billing; web manual checkout
- Admin console, feature flags, vault share links
- Ask AI API route (LLM + CRM aggregates; embeddings table exists but RAG is incomplete)
- GitHub Actions: Flutter analyze/test; web typecheck/lint/build; tag-based Play artifacts
- Hostinger Node deployment for the web app

## Capstone increment (the work Quantic is grading)

| Sprint | Goal | Evidence |
|---|---|---|
| 1 | Make the repo grader-ready: README links, design/testing doc, board, secrets gitignore, more unit tests, `npm test` in CI | This `docs/capstone/` folder, CI workflow, Issues/Project |
| 2 | Treat CLIVORA as an AI system: embed CRM on write, retrieve in Ask AI, document evals and human-in-the-loop | Ask AI + `crm_embeddings` work, eval notes |
| 3 | One reliable demo loop and sprint/final recordings | Demo script + 15–20 min video |

## What Capstone will not do

- Rewrite the product into microservices
- Activate live Stripe/escrow as if payments were complete
- Submit internal research PDFs as the design document (graders get [DESIGN_AND_TESTING.md](./DESIGN_AND_TESTING.md) instead)
