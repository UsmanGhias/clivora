# Invoice payment reminders (v2.15)

Edge Function: `send-invoice-reminders` (deployed, ACTIVE)  
Schedule: **daily 08:00 UTC** via `pg_cron` job `clivora-invoice-reminders-daily`  
Auth: Vault secret `invoice_reminders_cron_secret` → `Authorization: Bearer …`

## Low cost

- Runs **once per day** (not hourly)
- Batch size **40** invoices max per run
- Skips rows without client email; pushes `next_reminder_at` +7d
- After send, next reminder is **+3 days** (no spam)

## Manual trigger

```sql
select public.invoke_invoice_reminders();
```

## Required secrets on the Edge Function (Supabase Dashboard → Edge Functions → Secrets)

| Secret | Notes |
|--------|--------|
| `RESEND_API_KEY` | Same as `send-clivora-email` |
| `RESEND_FROM` | e.g. `CLIVORA <onboarding@resend.dev>` |
| `CRON_SECRET` | Optional override; vault secret already matches deployed fallback |

`SUPABASE_SERVICE_ROLE_KEY` / `SUPABASE_URL` are auto-injected.
