# Google Play Billing Setup for CLIVORA

Complete these steps in [Google Play Console](https://play.google.com/console), then send the details below so billing can go live.

## 1. Merchant account

1. Open Play Console → **Settings** → **Payments profile**.
2. Complete **merchant registration** (business name, bank account, tax info).
3. Note your **Merchant ID** (shown in payments profile) and share it when ready.

## 2. App package

- Package name: `org.codcrafters.clivora`
- Upload at least one **AAB** to an **Internal testing** or **Closed testing** track before subscriptions work in sandbox.

## 3. Create subscriptions (required)

Create **four monthly subscriptions** (account type × plan):

| Product ID | Name |
|------------|------|
| `clivora_pro_freelancer_monthly` | Freelancer Pro |
| `clivora_pro_client_monthly` | Client Pro |
| `clivora_pro_plus_freelancer_monthly` | Freelancer Pro Plus |
| `clivora_pro_plus_client_monthly` | Client Pro Plus |

Website Pro uses **SafePay** (`docs/SAFEPAY_SETUP.md`). Do not deep-link web checkout from the Play-distributed APK.

### Server JWT note

`verify-play-purchase` signs Google OAuth JWTs with **Base64URL** (required). Redeploy the edge function after pulling this fix.

## 4. License testers

1. **Settings** → **License testing**.
2. Add Gmail accounts you use for testing (your phone Google account).
3. Test purchases will not charge real money.

## 5. Server verification (implemented)

The app calls Supabase Edge Function `verify-play-purchase` before activating Pro locally.

### Supabase secrets

1. Deploy `supabase/functions/verify-play-purchase`.
2. Set secret `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` to the full service account JSON string.
3. Run migration `012_subscriptions.sql` and `013_referrals.sql`.

### Play Console

1. **Setup** → **API access** → Link a Google Cloud project.
2. Create a **service account** with Play Developer API access.
3. Download JSON key (keep secret — store only in Supabase secrets).

### Client flow

1. User completes Google Play purchase.
2. App sends `productId` + `purchaseToken` to edge function with user JWT.
3. Server verifies via Play Developer API and upserts `subscriptions` row.
4. App activates Pro only when verification returns `active: true`.

## 6. What to send when ready

Reply with:

- [ ] Merchant ID
- [ ] Confirmation both subscription IDs are **Active**
- [ ] Testing Gmail address(es) added as license testers
- [ ] Play Console app link / internal testing opt-in link
- [ ] (Required for server verify) `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` set in Supabase

## 7. App-side product IDs (already in code)

```dart
// lib/core/constants/billing_products.dart
clivora_pro_freelancer_monthly
clivora_pro_client_monthly
clivora_pro_plus_freelancer_monthly
clivora_pro_plus_client_monthly
```

## 8. Testing on device

1. Install release/signed build from internal track (or sideload signed APK linked to same package + signing key).
2. Sign in with a **license tester** Google account.
3. Freelancer account → Hub → **Upgrade to Pro** → subscribe **Freelancer Pro**.
4. Client account → Account → **Upgrade to Client Pro** → subscribe **Client Pro**.
5. Use **Restore purchases** after reinstall.

## 9. Referral program

- Each user gets a code like `CLIVORA1A2B3C`.
- Share via **Hub → Refer & earn** or **Account → Refer & earn**.
- When a referred user subscribes, referrer earns **7 bonus Pro days** via Supabase RPC `credit_referral_on_purchase`.

## 10. Pricing shown in app

- Strikethrough: **Rs 2,800/month** (marketing list price)
- Offer: **Rs 2,000/month** (actual Play subscription price you configure)
- Freelancers and clients each pay **separately** for their own Pro plan.

---

**No merchant ID is hardcoded in the app** — Google Play Billing uses the app's signing certificate and Play Console products. Once subscriptions are active and testers are set, purchases work without embedding a merchant ID in Flutter code.

### Recorded payments profile (ops)

See [docs/internal/GOOGLE_PLAY_PAYMENTS_ACCOUNT.md](internal/GOOGLE_PLAY_PAYMENTS_ACCOUNT.md) for Merchant ID `821322956506296398`, payments account `7504-8568-3035-6197`, and profile `0631-4490-8359`.
