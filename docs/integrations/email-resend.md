# CLIVORA email delivery (Resend-first)

Transactional product email uses the Supabase Edge Function `send-clivora-email` with **Resend**.

## Preferred secrets (dashboard only)

| Secret | Where | Purpose |
|--------|--------|---------|
| `RESEND_API_KEY` | Supabase Edge Function secrets | Send branded HTML mail |
| `RESEND_FROM` | Supabase Edge Function secrets | From address (verify domain for production) |

Never commit these values. Never put them in Flutter, `NEXT_PUBLIC_*`, or chat.

## Password reset

- Auth reset emails are sent by **Supabase Auth** (configure Auth SMTP in the dashboard if needed).
- All clients must use website redirect: `https://clivora.codcrafters.org/auth/reset-password`
  - Web: `web/src/app/(auth)/auth/reset-password/page.tsx`
  - Android: `kPasswordResetRedirectUrl` in `admin_config.dart` / `supabase_auth_helper.dart`
  - Admin console: `AdminCloudRepository.sendPasswordReset` passes the same `redirectTo`
- The Edge `password_reset` purpose is a branded notice only; it does not replace the Auth token email.

## Optional Gmail SMTP

Gmail app passwords are **optional** for Auth SMTP only. Store them exclusively in the Supabase Auth SMTP settings UI. If an app password was exposed in chat, rotate it immediately after setup. Prefer Resend + verified domain for product mail.

## Related docs

- `docs/SUPABASE_CONFIG_v2.6.6.md`
- `docs/internal/VERCEL_ENV_SETUP.md`
- `docs/internal/INVOICE_REMINDERS.md`
