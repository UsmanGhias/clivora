# Cloud sync fields (web ↔ Android)

Shared Supabase truth used by both website and Flutter:

| Field / table | Synced | Notes |
|---------------|--------|-------|
| `profiles.name` | Yes | Account editors on web + app |
| `profiles.avatar_url` | Yes | Storage bucket `avatars` (http URLs only) |
| `profiles.subscription_plan` | Yes | Admin grant, SafePay, Play verify |
| `profiles.account_type` | Yes | Locked after first set |
| `subscriptions` | Yes | Play / SafePay / `admin_grant_*` |
| `project_shares` / `invoice_shares` | Yes | Client portal; match uid **or** lowercase email |
| `crm_*` | Freelancer cross-device | Clients see share snapshots, not CRM rows |
| `connect_*` | Yes (Pro Plus) | Listings join `profiles.avatar_url` for cards |

**Local-only (not claimed as cloud sync):** theme, biometrics, some Drift business_profile fields (phone/bio/skills until Connect listing is used).

Use Connect Manage for skills/headline/rate; use Account Edit for name/photo.
