# Fix Hostinger 503 on /login /admin (Node app down)

## Root cause (July 2026)

Build can succeed while the site still 503s. Two issues stacked:

1. **`@supabase/supabase-js@2.110+` requires Node ≥22** but Hostinger was on **Node 20** → runtime crash after deploy.
2. Over-broad middleware matcher loaded Supabase on every request (Edge warning).

**Fix shipped:** pin `@supabase/supabase-js@2.49.1` + narrow middleware matcher again. Redeploy `clivora-web` main.

Optional: set Hostinger Node to **22.x** for future Supabase upgrades.

## Keys (LEGACY JWT only)

| Hostinger env | Must start with |
|---------------|-----------------|
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | `eyJ` |
| `SUPABASE_SERVICE_ROLE_KEY` | `eyJ` |

Do **not** use `sb_publishable_` / `sb_secret_` for this Next app yet.

## Crash loop: `✓ Starting...` forever, never Ready

Logs show Next binding `0.0.0.0:3000` then restarting every second.

**Cause:** Hostinger injects `PORT`; if the app ignores it (or npm does not expand `${PORT:-3000}`), the proxy health-check fails and the platform restarts the process → 503.

**Fix:** `npm run start` → `node scripts/start.mjs` which always uses `process.env.PORT`.

Also: middleware temporarily pass-through so Edge/Supabase cannot crash boot.

After deploy, Runtime logs should show:
```
[clivora] next start -H 0.0.0.0 -p <HOSTINGER_PORT> (PORT=...)
✓ Ready
```

