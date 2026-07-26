# Fix Hostinger 503 on /login /admin (Node app down)

## What’s wrong

- `https://clivora.io/` can still show **200** (CDN cache of the old static home).
- `/login`, `/admin`, `/app` return **Hostinger panel 503** = the **Node.js process is not running** (not a Supabase “legacy key” problem by itself).

## Keys this app needs (LEGACY JWT only)

Ignore the new `sb_publishable_` / `sb_secret_` keys for CLIVORA web for now.

| Hostinger env | Must look like | From Supabase |
|---------------|----------------|---------------|
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | starts with **`eyJ`** | API Keys → **Legacy** → **anon** |
| `SUPABASE_SERVICE_ROLE_KEY` | starts with **`eyJ`** | API Keys → **Legacy** → **service_role** → Reveal |
| `NEXT_PUBLIC_SUPABASE_URL` | `https://jtzjwgovqczlccyeujhq.supabase.co` | Project URL |
| `SUPABASE_URL` | same URL | same |
| `NEXT_PUBLIC_SITE_URL` | `https://clivora.io` | fixed |

**Do not** put `sb_publishable_...` in `NEXT_PUBLIC_SUPABASE_ANON_KEY`.  
**Do not** put `sb_secret_...` in `SUPABASE_SERVICE_ROLE_KEY`.

`service_role` **is required** for admin APIs. It does not cause 503 by itself, but admin won’t work without the **legacy JWT** `eyJ...` service_role.

## Exact Hostinger fix (do in order)

1. Open **Websites → clivora.io → Environment variables → Show all values**
2. Confirm:
   - Anon value starts with `eyJ` (same as Legacy anon on Supabase)
   - Service role value starts with `eyJ` (click Reveal on Legacy service_role)
3. If either starts with `sb_`, **edit** and paste the Legacy `eyJ...` key instead
4. Open **Runtime logs** — copy the last red error (crash reason)
5. Open **Dashboard → Redeploy** (must rebuild + restart Node; saving env alone is not enough on some plans)
6. Wait until deployment = Completed, then hard-refresh `https://clivora.io/login`
7. If still 503: **Advanced / restart** Node app (or Redeploy again) after checking Runtime logs for OOM / `Cannot find module` / port errors

## Optional (not needed to fix 503)

- `EMAIL_FROM` — fine to keep; Edge SMTP secrets are separate in Supabase
- SafePay / Odoo — not needed for login/admin to load

## App build (Android)

No Hostinger env needed. Build from monorepo `main`:

- Version: `5.3.10+540`
- Handoff: `docs/ANDROID_BUILD_HANDOFF.md`
- Supabase keys already in `lib/core/constants/supabase_config.dart` (legacy anon JWT)
