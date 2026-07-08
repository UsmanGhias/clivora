# Supabase configuration for CLIVORA v2.6.6

Project: `jtzjwgovqczlccyeujhq` (Clivora, ap-southeast-2)

## Applied via Supabase MCP (2026-07-08)

| Item | Status |
|------|--------|
| `subscriptions` + `profiles.subscription_plan` | Applied |
| `referral_codes` + `referral_redemptions` + `credit_referral_on_purchase` | Applied |
| `team_invites` + RLS + realtime | Applied |
| `send-clivora-email` edge function (branded Resend templates) | Deployed ACTIVE |
| `verify-play-purchase` edge function | Deployed ACTIVE |
| Referral RPC execute locked to `service_role` | Applied |

**Root cause of client invite email failure:** `send-clivora-email` returned **404** (function was never deployed). It is now live.

## Auth URL configuration (manual in Dashboard)

Supabase MCP cannot change Auth Site URL. Set in **Authentication → URL Configuration**:

| Setting | Value |
|---------|--------|
| **Site URL** | `https://clivora.codcrafters.org` |
| **Redirect URLs** | `https://clivora.codcrafters.org/auth/reset-password` |
| | `https://clivora.codcrafters.org/**` |

The mobile app sends `redirectTo: https://clivora.codcrafters.org/auth/reset-password` from `supabase_auth_helper.dart`.

The web callback page lives at `web/app/auth/reset-password/page.tsx`.

## Edge Function secrets

Confirm in **Project Settings → Edge Functions → Secrets**:

```
RESEND_API_KEY=REDACTED_RESEND_KEY
RESEND_FROM=CLIVORA <onboarding@resend.dev>
```

Optional for Play billing verify:

```
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON={...}
```

## Branded email types

`send-clivora-email` renders CLIVORA-branded HTML for:

| Purpose | Template |
|---------|----------|
| `client_invite` | Invite with Play Store CTA (pass `freelancerName`, `clientName`) |
| `password_reset` | Branded reset notice |
| `admin_notice` | Admin alert with dashboard link |

Purple `#6C3CE1`, navy header, CODCrafters footer.

## Web admin (`web/`)

Monorepo includes Next.js admin matching `clivora.codcrafters.org/admin`:

- Deploy `web/` to Vercel as `clivora-web`
- Set `ADMIN_SYNC_KEY` to match Flutter `ADMIN_SYNC_KEY` dart-define

## Data privacy

- RLS enabled on all user tables
- Team invites scoped to owner/invitee email only
- Referral credit RPC restricted to `service_role`
