# Staging deployment

**Site:** https://staging.clivora.io  
**Monorepo branch:** `staging`  
**Web mirror branch:** `UsmanGhias/clivora-web` → `staging` only

## Sync rules

- Live production (`https://clivora.io`) deploys from `clivora-web` **`main`**. Do not push staging experiments there.
- Push web staging only:

```bash
bash web/push-to-clivora-web-staging.sh
```

- Align git staging with live main before new work:

```bash
git fetch origin
git checkout staging
git reset --hard origin/main
git push origin staging --force-with-lease
```

## Hostinger

1. Deployments → Settings → Branch = **`staging`**
2. Copy env vars from live; set `NEXT_PUBLIC_SITE_URL=https://staging.clivora.io`
3. Ensure `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, and `SUPABASE_SERVICE_ROLE_KEY` are set (fail-closed outside local development)

## Database

Staging Hostinger currently points at production Supabase (`jtzjwgovqczlccyeujhq`) until a dedicated Supabase staging branch/project exists.

- Ship **web API changes first**, then apply SQL migrations.
- Do **not** run `apply_migration` against production without an explicit approval gate.
- Unapplied P0 migration in repo: `supabase/migrations/20260731_audit_p0_payment_storage_search_path.sql`

## Smoke checklist

- [ ] `/`, `/features`, `/pricing`, `/connect` return HTTP 200
- [ ] Signed-in `/pro` manual payment submit hits `POST /api/pro/payment-requests` (not client table insert)
- [ ] SafePay checkout still creates a pending row via service role
- [ ] Admin Odoo secret save still works (service-role table write after AAL2)
