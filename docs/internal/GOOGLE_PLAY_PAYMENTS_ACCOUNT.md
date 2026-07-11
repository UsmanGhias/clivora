# Google Play payments account (merchant)

These values are configured in **Google Play Console → Payments** — they are **not** embedded in the Flutter APK. Play Billing uses your app signing key + product IDs.

## Your verified payments profile (as of Jul 2026)

| Field | Value |
|-------|--------|
| Payments account ID | `7504-8568-3035-6197` |
| Payments account nickname | Google Play Apps |
| Payment schedule | Paid monthly · US$1 threshold |
| Payments profile ID | `0631-4490-8359` |
| Country/Region | Pakistan (PK) |
| Account type | Individual |
| Name | Muhammad Usman Khan |
| Merchant ID | `821322956506296398` |
| Business | CODCrafters |
| Credit card statement name | Usman Ghias |
| Website | https://codcrafters.org |
| Support email | iusmanghias@gmail.com |
| Payments primary contact | usmanghias1@gmail.com |

## How this connects to the CLIVORA app

1. **Merchant / payments profile** (above) → lets Google pay out subscription revenue to your bank.
2. **In-app products** (must exist and be Active in Play Console):

| Product ID | Plan |
|------------|------|
| `clivora_pro_freelancer_monthly` | Pro $9 |
| `clivora_pro_client_monthly` | Pro $9 |
| `clivora_pro_plus_freelancer_monthly` | Pro Plus $19 |
| `clivora_pro_plus_client_monthly` | Pro Plus $19 |

3. **App code** (`lib/core/constants/billing_products.dart`) only references those product IDs.
4. **Server verify** (`supabase/functions/verify-play-purchase`) confirms purchases with the Play Developer API using a service-account JSON secret.

## Checklist to finish Google payments

- [x] Payments profile verified (PK individual)
- [x] Merchant ID issued
- [ ] All four subscription product IDs **Active** with base plans
- [ ] License testers added (Settings → License testing)
- [ ] AAB uploaded to Internal/Closed testing track
- [ ] `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` set in Supabase secrets
- [ ] End-to-end test purchase on a license-tester device

See also: [GOOGLE_PLAY_BILLING_SETUP.md](../GOOGLE_PLAY_BILLING_SETUP.md)
