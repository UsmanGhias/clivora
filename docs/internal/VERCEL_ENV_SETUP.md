# Vercel environment variables (CLIVORA web)

Project: `prj_AZuWTky7AXfyzaLkvnwK1beieGSE` (`clivora`)  
Team: `team_v88LcOy4ITTAodxJ1t9wfFip`  
Domain: `clivora.codcrafters.org`

The Vercel MCP connection in this agent **cannot write env secrets** (no env-set tool / no CLI token).  
Set these once in **Vercel → Project → Settings → Environment Variables** (Production + Preview):

| Name | Value | Notes |
|------|--------|--------|
| `NEXT_PUBLIC_SUPABASE_URL` | `https://jtzjwgovqczlccyeujhq.supabase.co` | Public |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | *(anon JWT from Supabase API settings)* | Public — also hardcoded as fallback in web |
| `SUPABASE_URL` | same as above | Server |
| `SUPABASE_SERVICE_ROLE_KEY` | *(service_role secret from Supabase)* | **Server only — never expose** |
| `STRIPE_SECRET_KEY` | optional | Enables Stripe checkout |
| `STRIPE_WEBHOOK_SECRET` | optional | Stripe webhooks |
| `MEILI_HOST` / `MEILI_KEY` | optional | Connect search |
| `AUTOMATION_WEBHOOK_SECRET` / `N8N_WEBHOOK_URL` | optional | Automations |

Public URL + anon already fall back in code so the site boots even before env is set.  
**Admin / grant-pro / escrow / Stripe webhooks need `SUPABASE_SERVICE_ROLE_KEY`.**

## Supabase Auth (Dashboard — MCP cannot edit)

Authentication → URL Configuration:

- Site URL: `https://clivora.codcrafters.org`
- Redirect URLs: `https://clivora.codcrafters.org/**`

## Google OAuth branding

See `docs/internal/GOOGLE_OAUTH_BRANDING.md` — set App name to **CLIVORA** and Publish.
