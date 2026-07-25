# CLIVORA email delivery (Hostinger SMTP)

Transactional product email uses the Supabase Edge Function `send-clivora-email` with **Hostinger SMTP** (`contact@clivora.io`). Resend is not used.

## Secrets (dashboard only)

| Secret | Where | Purpose |
|--------|--------|---------|
| `SMTP_HOST` | Edge Function secrets | `smtp.hostinger.com` |
| `SMTP_PORT` | Edge Function secrets | `465` |
| `SMTP_USER` | Edge Function secrets | `contact@clivora.io` |
| `SMTP_PASS` | Edge Function secrets | mailbox password |
| `SMTP_FROM` | Edge Function secrets | `CLIVORA <contact@clivora.io>` |

Never commit these values. Never put them in Flutter or `NEXT_PUBLIC_*`.

## Password reset

- Auth reset emails are sent by **Supabase Auth** (configure Auth SMTP with the same Hostinger values).
- All clients must use website redirect: `https://clivora.io/auth/reset-password`

## Related docs

- `docs/integrations/email-hostinger-smtp.md`
- `docs/HOSTINGER_ENV_EXACT.md`
- `docs/SUPABASE_CONFIG_v2.6.6.md`
