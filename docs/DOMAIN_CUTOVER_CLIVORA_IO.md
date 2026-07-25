# CLIVORA domain cutover — clivora.io (Hostinger) + Supabase checklist

**Production web:** `https://clivora.io` (Hostinger Node.js)  
**Official email:** `contact@clivora.io`  
**Legacy host:** `https://clivora.codcrafters.org` → **308 redirect to clivora.io** (middleware + DNS)  
**Supabase project (keep):** `jtzjwgovqczlccyeujhq`  
**Android package:** `org.codcrafters.clivora`

Do **not** move the database off Supabase. Hostinger only hosts the Next.js app.

---

## 1. What to get, and from where

### A. Supabase Dashboard → Project Settings → API

Open: https://supabase.com/dashboard/project/jtzjwgovqczlccyeujhq/settings/api

| Variable | Where | Who sees it |
|----------|--------|-------------|
| `NEXT_PUBLIC_SUPABASE_URL` | Project URL (`https://jtzjwgovqczlccyeujhq.supabase.co`) | Browser (public) |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | `anon` `public` key | Browser (public) |
| `SUPABASE_URL` | Same Project URL | Server only |
| `SUPABASE_SERVICE_ROLE_KEY` | `service_role` `secret` key | **Server only — never commit** |

If an old pull file looks wrong: **ignore it** and copy fresh values from this page.

### B. Supabase Dashboard → Authentication → URL Configuration

Open: https://supabase.com/dashboard/project/jtzjwgovqczlccyeujhq/auth/url-configuration

Set:

| Field | Value |
|-------|--------|
| **Site URL** | `https://clivora.io` |
| **Redirect URLs** (keep all until cutover is stable) | `https://clivora.io/**` |
| | `https://clivora.io/auth/callback` |
| | `https://clivora.io/auth/reset-password` |
| | `https://clivora.codcrafters.org/**` *(temporary, until DNS redirect works)* |

### C. Hostinger → Websites → clivora.io → Environment Variables

Required:

```env
NEXT_PUBLIC_SITE_URL=https://clivora.io
NEXT_PUBLIC_SUPABASE_URL=https://jtzjwgovqczlccyeujhq.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=<anon from Supabase API page>
SUPABASE_URL=https://jtzjwgovqczlccyeujhq.supabase.co
SUPABASE_SERVICE_ROLE_KEY=<service_role from Supabase API page>
```

Also copy from your machine’s `web/.env.production.local` (Vercel pull) if present:

```env
SAFEPAY_API_KEY=
SAFEPAY_SECRET_KEY=
SAFEPAY_WEBHOOK_SECRET=
ODOO_URL=
ODOO_DB=
ODOO_USERNAME=
ODOO_API_KEY=
ADMIN_SYNC_KEY=
```

Skip every `VERCEL_*` / `TURBO_*` key.

Full names list: `docs/HOSTINGER_ENV_FROM_VERCEL.md`

### D. Hostinger email (mailbox)

Create / use:

| Address | Use |
|---------|-----|
| `contact@clivora.io` | Public support (website, app, Play listing) |
| `usmanghias@clivora.io` | Your personal / admin mailbox (optional) |
| `usmanghias@codcrafters.org` | Still allowed as admin login if you use it |

Play Console + website contact should show **`contact@clivora.io`**.

### E. Google / SafePay / Stripe (after Hostinger SSL works)

| Service | Update to |
|---------|-----------|
| SafePay webhook | `https://clivora.io/api/safepay/webhook` |
| Google OAuth authorized domains | `clivora.io` |
| Google Calendar redirect | `https://clivora.io/api/integrations/google/calendar/callback` |
| Resend / SMTP from | e.g. `CLIVORA <noreply@clivora.io>` or `contact@clivora.io` |

---

## 2. Redirect `clivora.codcrafters.org` → `clivora.io`

### In code (already shipped)

Next.js middleware returns **308** when `Host` is `clivora.codcrafters.org` → `https://clivora.io` + same path.

This works **while Vercel still serves** the old hostname (deploy latest `clivora-web`).

### At DNS (recommended permanent)

On the DNS host for `codcrafters.org`:

1. Prefer a **URL redirect / forwarding** record: `clivora.codcrafters.org` → `https://clivora.io` (301/308).
2. Or keep the A/CNAME pointing at Vercel until the middleware redirect is confirmed live, then switch to Hostinger/redirect.

Smoke: open `https://clivora.codcrafters.org/login` → should land on `https://clivora.io/login`.

---

## 3. Google Play subscriptions (create these exact product IDs)

In Play Console → Monetise → Products → Subscriptions → **Create subscription**:

| Product ID (exact, cannot change) | Name (user-visible) |
|-----------------------------------|---------------------|
| `clivora_pro_freelancer_monthly` | CLIVORA Pro (Freelancer) |
| `clivora_pro_client_monthly` | CLIVORA Pro (Client) |
| `clivora_pro_plus_freelancer_monthly` | CLIVORA Pro Plus (Freelancer) |
| `clivora_pro_plus_client_monthly` | CLIVORA Pro Plus (Client) |

Suggested base prices: Pro **$9/month**, Pro Plus **$19/month** (match app pricing copy).  
Activate each base plan, then activate the subscription.  
IDs must match `lib/core/constants/billing_products.dart`.

---

## 4. Smoke checklist after Hostinger deploy

1. `https://clivora.io` loads marketing home  
2. `/login` + `/signup` work  
3. Password reset email link opens `https://clivora.io/auth/reset-password`  
4. `/admin` requires admin account  
5. Android app opens Pro / privacy / support links to `clivora.io`  
6. Old host redirects to new  
7. Supabase Auth Site URL is `https://clivora.io`

---

## 5. Related docs

- `docs/HOSTINGER_DEPLOYMENT.md` — Node app settings  
- `docs/HOSTINGER_ENV_FROM_VERCEL.md` — env name transfer  
- `docs/PLAY_PRODUCTION_LAUNCH.md` — store / billing notes  
