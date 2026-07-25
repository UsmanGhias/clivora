# SafePay (website Pro checkout)

Website `/pro` uses **SafePay hosted checkout**. Android stays on **Google Play Billing**.

## Exact mapping from SafePay dashboard → Hostinger (production)

Open Hostinger → clivora.io → Environment Variables (or keep staging on Vercel until cutover).

Add for **Production**:

| SafePay dashboard label | Env name | Example format |
|-------------------------|----------|----------------|
| **Public key** | `SAFEPAY_API_KEY` | `sec_` + UUID with hyphens, e.g. `sec_edeade52-46aa-483b-b87d-009d3ce41554` |
| **Secret key** | `SAFEPAY_SECRET_KEY` | long hex string |
| Same secret key (or Endpoints webhook secret) | `SAFEPAY_WEBHOOK_SECRET` | same hex, or the secret shown when you create the webhook |
| — | `SAFEPAY_ENV` | **`sandbox` for now** (DB preferred). Switch to `production` when live. |
| — | `SAFEPAY_CURRENCY` | `USD` (or `PKR`) |

Also required (already should exist):

- `SUPABASE_SERVICE_ROLE_KEY`
- `SUPABASE_URL` / `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SITE_URL=https://clivora.io`

After saving env vars, **Redeploy** Hostinger.

### Public key format (critical)

SafePay rejects keys that are not:

```text
sec_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

If your Public key looks like `sec_ddd46226iu8ogftuf488b608` (no UUID hyphens), copy it again from the SafePay **API** tab — do not type it by hand.

### Webhook

In SafePay → **Endpoints**:

1. Add URL: `https://clivora.io/api/safepay/webhook`
2. Events: `payment.succeeded` (and optionally `payment.failed`)
3. Copy the webhook signing secret into `SAFEPAY_WEBHOOK_SECRET` (if SafePay shows a separate one)

Health check: `GET https://clivora.io/api/safepay/webhook` → `{ ok: true }`

Unsigned POSTs correctly return `401` — that means the route is live.

### Fallback unlock

After checkout redirect, `/pro?safepay=success&tracker=...` also calls `/api/safepay/confirm`, which polls SafePay and unlocks Pro even if the webhook is delayed.

## Flow

1. `/pro` → SafePay → hosted pay
2. Redirect back + webhook/confirm unlocks plan (~31 days)

## Rotate keys

Any key pasted into chat should be rotated in the SafePay dashboard after live checkout works.
