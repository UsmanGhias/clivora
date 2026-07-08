# CLIVORA Web — Admin Dashboard

Next.js 14 App Router project for [clivora.codcrafters.org](https://clivora.codcrafters.org). Powers the production admin console, mobile app admin sync API, and Supabase password-reset callback.

## Routes

| Path | Purpose |
|------|---------|
| `/` | Marketing landing with link to admin |
| `/admin` | Supabase auth login + live stats (profiles, subscriptions, email_send_log, clivora_events) |
| `/auth/reset-password` | Supabase password reset redirect from the Flutter app |
| `POST /api/admin/sync` | Flutter app analytics sync (`X-Admin-Sync-Key` header) |

## Local development

```bash
cd web
npm install
# Create .env.local with the variables listed below
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

## Vercel deployment

Deploy the `web/` directory as the Vercel project root (or set **Root Directory** to `web` in a monorepo).

### Required environment variables

| Variable | Description |
|----------|-------------|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase anon/public key |
| `SUPABASE_SERVICE_ROLE_KEY` | Service role key (server-only; used by `/api/admin/sync`) |
| `ADMIN_SYNC_KEY` | Shared secret for Flutter `X-Admin-Sync-Key` header. Set at build: `--dart-define=ADMIN_SYNC_KEY=...` |
| `ADMIN_EMAILS` | Comma-separated admin emails allowed to sign in (e.g. `admin@codcrafters.org,usmanghias1@gmail.com`) |

### Supabase Auth redirect URL

Add this under **Authentication → URL Configuration → Redirect URLs**:

```
https://clivora.codcrafters.org/auth/reset-password
```

## Flutter integration

From `lib/core/constants/admin_config.dart`:

- `kClivoraWebBaseUrl` → `https://clivora.codcrafters.org`
- `kPasswordResetRedirectUrl` → `/auth/reset-password`
- `kAdminApiBaseUrl/api/admin/sync` → analytics POST endpoint
- `ADMIN_SYNC_KEY` must match Vercel env var

## Admin sync API

```http
POST /api/admin/sync
Content-Type: application/json
X-Admin-Sync-Key: <ADMIN_SYNC_KEY>

{
  "eventType": "signup",
  "userEmail": "user@example.com",
  "userName": "Jane",
  "plan": "free",
  "amount": 0,
  "payload": "{}",
  "createdAt": "2026-07-08T12:00:00.000Z",
  "source": "clivora_app"
}
```

Events are stored in Supabase `clivora_events`.

## Branding

- Purple: `#6C3CE1`
- Navy: `#0F172A`
