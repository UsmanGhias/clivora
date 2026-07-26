# Supabase Auth email via Hostinger (contact@clivora.io)

Password reset / confirm emails are sent by **Supabase Auth SMTP**, not by the Next.js app and not by Resend.

## 1) Create mailbox

Hostinger → Emails → create **`contact@clivora.io`** (or `noreply@clivora.io`) and set a strong password.

## 2) Supabase → Authentication → SMTP Settings

Enable custom SMTP:

| Field | Value |
|-------|--------|
| Sender email | `contact@clivora.io` |
| Sender name | `CLIVORA` |
| Host | `smtp.hostinger.com` |
| Port | `465` (SSL) |
| Username | `contact@clivora.io` |
| Password | mailbox password |

Save. Send a test reset from `https://clivora.io/auth/reset-password`.

## 3) Auth URL Configuration

| Field | Value |
|-------|--------|
| Site URL | `https://clivora.io` |
| Redirect URLs | `https://clivora.io/**` |
| | `https://clivora.io/auth/callback` |
| | `https://clivora.io/auth/reset-password` |

## 4) Edge Function product emails (invites / reminders)

Already use Hostinger SMTP secrets:

```
SMTP_HOST=smtp.hostinger.com
SMTP_PORT=465
SMTP_USER=contact@clivora.io
SMTP_PASS=<mailbox password>
SMTP_FROM=CLIVORA <contact@clivora.io>
```

Do **not** set `RESEND_*`.

## 5) If reset “does nothing”

1. Confirm SMTP saved (step 2)
2. Confirm redirect allowlist includes `/auth/reset-password`
3. Check spam
4. Open the link on `clivora.io` (not localhost)
5. After clicking the email link you should land on **Set new password**
