# SafePay (website Pro checkout)

Website `/pro` uses **SafePay hosted checkout** for card/bank payments. Android stays on **Google Play Billing** for monthly subscriptions.

## Keys (never commit)

| Env / DB secret | Purpose |
|-----------------|--------|
| `SAFEPAY_SECRET_KEY` | Server Bearer token for SafePay API |
| `SAFEPAY_API_KEY` (or `SAFEPAY_PUBLIC_KEY`) | `merchant_api_key` on payment session create |
| `SAFEPAY_WEBHOOK_SECRET` | HMAC secret from SafePay webhook endpoint |
| `SAFEPAY_ENV` | `production` (default) or `sandbox` |
| `SAFEPAY_CURRENCY` | Default `USD` (minor units: cents) |

Store the same values in:

1. **Vercel** project env (Production + Preview) — required for checkout + webhook.
2. Optionally **Supabase** `admin_integration_secrets` for admin health checks.

If only a `sec_…` merchant key is available, checkout may reuse it as `merchant_api_key`, but you should still set a dedicated secret key + webhook secret from the SafePay dashboard.

## Webhook

Register in SafePay dashboard → Endpoints / Webhooks:

- URL: `https://clivora.codcrafters.org/api/safepay/webhook`
- Events: `payment.succeeded` (and failed if you want logging)

Verification accepts classic SafePay **HMAC-SHA512(raw body)** via `X-SFPY-SIGNATURE`, plus timestamped SHA-256 variants.

## Flow

1. User chooses **SafePay** on `/pro` → `POST /api/safepay/checkout`
2. Server creates `pro_payment_requests` row + SafePay tracker + hosted URL
3. User pays on SafePay → redirect ` /pro?safepay=success`
4. Webhook marks request **approved**, sets `profiles.subscription_plan`, inserts `subscriptions` row (`safepay_pro` / `safepay_pro_plus`, ~31 days)

## Manual checklist

- [ ] Paste `SAFEPAY_SECRET_KEY`, `SAFEPAY_API_KEY`, `SAFEPAY_WEBHOOK_SECRET` into Vercel
- [ ] Ensure `SUPABASE_SERVICE_ROLE_KEY` is set on Vercel (webhook + tracker update)
- [ ] Register webhook URL above
- [ ] Smoke-test sandbox then production
- [ ] Rotate any key that was pasted into chat or tickets
