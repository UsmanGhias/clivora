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

## After code push

1. Hostinger → clivora.io → **Redeploy**
2. Wait for Completed
3. Open Runtime logs if still 503
4. Test `/login` and `/admin`

Old domain redirect: do at **DNS / Vercel**, not in Hostinger middleware.
