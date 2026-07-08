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

Create **two separate monthly subscriptions**:

| Product ID | Name | Price (PKR) | Notes |
|------------|------|-------------|--------|
| `clivora_pro_freelancer_monthly` | Freelancer Pro | **2,000** | List UI shows ~~2,800~~ offer |
| `clivora_pro_client_monthly` | Client Pro | **2,000** | Separate purchase for clients |

### In Play Console

1. **Monetize** → **Products** → **Subscriptions** → **Create subscription**.
2. Set **Product ID** exactly as in the table (cannot change later).
3. Add a **base plan** — monthly, auto-renewing.
4. Set price **PKR 2,000.00** (or your target market; app shows local Play price).
5. Optional: create a **promotional offer** or **introductory price** at 2,000 if list price is 2,800 in marketing.
6. Activate both subscriptions.

## 4. License testers

1. **Settings** → **License testing**.
2. Add Gmail accounts you use for testing (your phone Google account).
3. Test purchases will not charge real money.

## 5. Service credentials (optional, for server verify)

If you add server-side receipt validation later:

1. **Setup** → **API access** → Link a Google Cloud project.
2. Create a **service account** with Play Developer API access.
3. Download JSON key (keep secret — do not commit to git).

## 6. What to send when ready

Reply with:

- [ ] Merchant ID
- [ ] Confirmation both subscription IDs are **Active**
- [ ] Testing Gmail address(es) added as license testers
- [ ] Play Console app link / internal testing opt-in link
- [ ] (Optional) Service account JSON path if using backend verify

## 7. App-side product IDs (already in code)

```dart
// lib/core/constants/billing_products.dart
clivora_pro_freelancer_monthly
clivora_pro_client_monthly
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
- When a referred user subscribes, referrer earns **7 bonus Pro days** (stored locally; cloud sync can be added later).

## 10. Pricing shown in app

- Strikethrough: **Rs 2,800/month** (marketing list price)
- Offer: **Rs 2,000/month** (actual Play subscription price you configure)
- Freelancers and clients each pay **separately** for their own Pro plan.

---

**No merchant ID is hardcoded in the app** — Google Play Billing uses the app's signing certificate and Play Console products. Once subscriptions are active and testers are set, purchases work without embedding a merchant ID in Flutter code.
