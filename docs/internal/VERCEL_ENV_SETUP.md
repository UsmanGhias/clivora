# Vercel environment variables (CLIVORA web)

Project: `prj_AZuWTky7AXfyzaLkvnwK1beieGSE` (`clivora`)  
Team: `team_v88LcOy4ITTAodxJ1t9wfFip`  
Domain: `clivora.codcrafters.org`

The Vercel MCP in this agent **cannot write env secrets** (no env-set tool / no CLI token in the run).  
Public Supabase URL + anon already fall back in code.

## Required for admin / grants / escrow APIs

| Name | Notes |
|------|--------|
| `SUPABASE_URL` | `https://jtzjwgovqczlccyeujhq.supabase.co` |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase → Settings → API → `service_role` (**server only**) |
| `NEXT_PUBLIC_SUPABASE_URL` | Same URL (public) |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Anon / publishable key (public) |

## Low-cost billing (recommended default)

Keep **Google Play** (Android) + **JazzCash/manual** (web `/pro`) as primary — no Stripe fees until you need cards.

| Name | Required? | Notes |
|------|-----------|--------|
| `STRIPE_SECRET_KEY` | Optional | Enables `/api/stripe/checkout` + `/api/stripe/portal` |
| `STRIPE_WEBHOOK_SECRET` | Optional | Webhook signature check |
| `STRIPE_PRICE_PRO` / `STRIPE_PRICE_PRO_PLUS` | Optional | Stripe Price IDs when using Checkout |

**Do not enable Stripe Connect escrow until you have a Stripe account + compliance plan** — ledger/status UI already works without moving money.

## Skip for cost (unless needed)

| Name | Why skip |
|------|----------|
| `MEILI_HOST` / `MEILI_KEY` | Postgres `ilike` search is enough at current scale |
| `N8N_WEBHOOK_URL` | Only if you run n8n |

## Supabase (already applied by agent)

- Promo `CLIVORA15` **active** (15% · max 50 uses)
- Daily cron `clivora-invoice-reminders-daily` at **08:00 UTC**
- Edge Function `send-invoice-reminders` ACTIVE
- Vault secret `invoice_reminders_cron_secret`

Confirm Resend secrets on the Edge Function: `RESEND_API_KEY`, `RESEND_FROM`.

## Supabase Auth (Dashboard)

- Site URL: `https://clivora.codcrafters.org`
- Redirect URLs: `https://clivora.codcrafters.org/**`
