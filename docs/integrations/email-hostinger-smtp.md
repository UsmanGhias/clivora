# CLIVORA email — Hostinger SMTP (Resend removed)

Transactional mail uses **Hostinger mailbox SMTP** via Edge Functions.

## Edge Function secrets

| Secret | Example |
|--------|---------|
| `SMTP_HOST` | `smtp.hostinger.com` |
| `SMTP_PORT` | `465` |
| `SMTP_USER` | `contact@clivora.io` |
| `SMTP_PASS` | mailbox password |
| `SMTP_FROM` | `CLIVORA <contact@clivora.io>` |

Remove: `RESEND_API_KEY`, `RESEND_FROM`.

## Auth emails (reset / confirm)

Configure **Supabase Auth → SMTP** with the same Hostinger SMTP values.

## Code

- `supabase/functions/_shared/smtp_send.ts`
- `supabase/functions/send-clivora-email/`
- `supabase/functions/send-invoice-reminders/`
