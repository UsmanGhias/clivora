# Hostinger env transfer — from Vercel production pull

**Pulled:** `web/.env.production.local` (gitignored — values stay on your machine only)  
**Do not** commit, zip, or paste that file into chat.

## App secrets present on Vercel (copy these to Hostinger)

Open `web/.env.production.local` locally and copy **values** for:

```env
SUPABASE_URL=
SUPABASE_SERVICE_ROLE_KEY=
SAFEPAY_API_KEY=
SAFEPAY_SECRET_KEY=
SAFEPAY_WEBHOOK_SECRET=
ODOO_URL=
ODOO_DB=
ODOO_USERNAME=
ODOO_API_KEY=
ADMIN_SYNC_KEY=
```

## Missing on Vercel — add manually on Hostinger

These were **not** in the Vercel project env list. Add them for Hostinger production:

```env
NEXT_PUBLIC_SITE_URL=https://clivora.io
NEXT_PUBLIC_SUPABASE_URL=https://jtzjwgovqczlccyeujhq.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=<from Supabase → Project Settings → API → anon public>
```

Use the same anon key already in browser traffic / `web/.env.example` (public by design).

## Recommended optional (not on Vercel today)

```env
SAFEPAY_ENV=production
SAFEPAY_CURRENCY=USD
SAFEPAY_PUBLIC_KEY=
ODOO_SYNC_ENABLED=false
STRIPE_ENABLED=false
```

## Do NOT copy to Hostinger

Skip every system key from the pull file:

```text
VERCEL*
TURBO*
NX_DAEMON
VERCEL_OIDC_TOKEN
VERCEL_URL
VERCEL_ENV
VERCEL_GIT_*
```

## Hostinger steps

1. Websites → clivora.io → Manage → Web App → Environment Variables  
2. Paste each required name + value from `.env.production.local`  
3. Add the three `NEXT_PUBLIC_*` rows above  
4. Redeploy Hostinger  
5. Keep Vercel / `clivora.codcrafters.org` unchanged until smoke tests pass  

## Re-pull later

```bash
cd web
vercel env pull .env.production.local --environment=production --yes
sed 's/=.*$/=REDACTED/' .env.production.local
```
