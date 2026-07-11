# Invoice payment reminders (v2.15)

Edge Function: `supabase/functions/send-invoice-reminders`

## Behavior

1. Selects `crm_invoices` where `next_reminder_at <= now()` and status in `sent|overdue|partial|unpaid`.
2. Resolves client email from `crm_customers`.
3. Sends branded email via Resend.
4. Sets `reminder_sent_at = now()`, `next_reminder_at = now() + 3 days` (idempotent — no spam on next tick).
5. Logs to `automation_run_log` with `automation_key = invoice_payment_reminder`.

## Deploy

```bash
supabase functions deploy send-invoice-reminders --project-ref jtzjwgovqczlccyeujhq
```

Secrets (already used by `send-clivora-email`):
- `RESEND_API_KEY`
- `RESEND_FROM`
- `SUPABASE_SERVICE_ROLE_KEY`
- Optional: `CRON_SECRET`

## Schedule (Supabase Dashboard → Edge Functions → Cron, or pg_net)

Invoke daily:

```
POST https://jtzjwgovqczlccyeujhq.supabase.co/functions/v1/send-invoice-reminders
Authorization: Bearer <CRON_SECRET or service_role>
```

Trigger also schedules `next_reminder_at` when invoices become `sent`/`overdue` (migration `20260711_v215_reminders_proposals_promo.sql`).
