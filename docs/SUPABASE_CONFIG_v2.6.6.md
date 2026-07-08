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

| Purpose | Template | Fields |
|---------|----------|--------|
| `client_invite` | Invite with Play Store CTA | `freelancerName`, `clientName` |
| `team_invite` | Team collaboration invite | `ownerName`, `inviteeName`, `role`, `projectName` |
| `password_reset` | Branded reset notice | (none) |
| `admin_notice` | Admin alert with dashboard link | `adminMessage` |
| `task_completed` | Task done notification | `clientName`, `taskTitle`, `projectName` |
| `welcome` | New account welcome | `userName`, `accountType` |

Purple `#6C3CE1`, navy header, CODCrafters footer. Redeployed v2 (2026-07-08).

## Web admin (`web/`)

Monorepo includes Next.js 14 admin matching `clivora.codcrafters.org/admin` (v2.6.6).

## Push to standalone repo `UsmanGhias/clivora-web`

The Cloud Agent GitHub token only has access to `UsmanGhias/clivora` unless you grant Cursor app access to `clivora-web`.

### Option A — Grant Cursor access (recommended)

1. GitHub → **Settings** → **Applications** → **Cursor** → **Configure**
2. Under **Repository access**, add **UsmanGhias/clivora-web**
3. Re-run the agent or run `./push-to-clivora-web.sh` locally

### Option B — Mirror from `clivora-web-sync` branch

Web files at repo root are on branch `clivora-web-sync` in `UsmanGhias/clivora`:

```bash
git clone https://github.com/UsmanGhias/clivora-web.git
cd clivora-web
git pull https://github.com/UsmanGhias/clivora clivora-web-sync
git push origin main
```

### Option C — GitHub Actions sync

Add secret `CLIVORA_WEB_SYNC_TOKEN` (PAT with `repo` scope for `clivora-web`) to `UsmanGhias/clivora`, then run workflow **Sync web to clivora-web**.

Deploy to Vercel with env vars below.

## Data privacy

- RLS enabled on all user tables
- Team invites scoped to owner/invitee email only
- Referral credit RPC restricted to `service_role`
