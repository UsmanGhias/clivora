# CLIVORA Admin Setup (CodCrafters)

## Who gets admin access?

Sign in with an email listed in `lib/core/constants/admin_config.dart`:

- `iusmanghias@gmail.com` (super admin)
- `usmanghias1@gmail.com`
- `usmanghias@clivora.io`
- `usmanghias@codcrafters.org`
- `contact@clivora.io`
- `admin@codcrafters.org`

Admin users automatically receive **Pro** and can open **Hub → CodCrafters Admin**.

Public support address (shown to users): **`contact@clivora.io`**.

## What the admin dashboard shows

| Metric | Description |
|--------|-------------|
| Sign-ups | Users who registered on devices that recorded analytics |
| Pro users | Pro activations recorded locally |
| MRR | Pro count × Rs 2,000 |

## Important: local vs global stats

CLIVORA stores **client CRM data on each phone** (SQLite). Analytics events (signup, pro_activate) are also stored **locally** in `AppAnalytics` until you connect a cloud backend.

To see **all users across all installs**, connect one of:

1. **Firebase Firestore** — recommended for Play Store apps
2. **Supabase** — free PostgreSQL + REST API
3. **Custom webhook** — POST events from `AnalyticsService.track()`

## Next step for global admin

1. Create a Firebase project at https://console.firebase.google.com
2. Add Android app `org.codcrafters.clivora`
3. Download `google-services.json` → `android/app/`
4. Extend `AnalyticsService` to mirror events to Firestore collection `clivora_events`
5. Admin dashboard reads aggregated docs from `clivora_stats/summary`

Until cloud is connected, admin stats reflect **events on the device where they occurred** (useful for testing; not global production metrics).

## Admin + Play Store billing

When Google Play Billing is integrated, call `trackProActivation` after a verified purchase so revenue metrics stay accurate.
