# CLIVORA Hostinger production deployment

**Status:** Ready to configure (do not cut DNS until Hostinger preview smoke passes)  
**Production target:** `https://clivora.io` (Hostinger Node.js Web App)  
**Staging / backup:** `https://clivora.codcrafters.org` (Vercel — leave running)  
**Repo:** `https://github.com/UsmanGhias/clivora-web` (`main`)  
**Backend:** Supabase project `jtzjwgovqczlccyeujhq` (unchanged)

---

## Hostinger compatibility report

| Item | Verdict | Notes |
|------|---------|--------|
| Next.js App Router + Node runtime | works on Hostinger | Requires Web Apps / Node — **not** static HTML |
| `npm ci` + `npm run build` | works on Hostinger | Node `>=20` (`engines` in package.json) |
| `npm run start` honors `PORT` | works on Hostinger | Script: `next start -H 0.0.0.0 -p ${PORT:-3000}` |
| Bind `0.0.0.0` | works on Hostinger | Required for reverse proxy |
| Supabase Auth cookies / SSR | requires configuration | Set `NEXT_PUBLIC_SITE_URL=https://clivora.io` + Supabase redirect URLs |
| API routes (admin, SafePay, AI, Odoo, vault) | works on Hostinger | Same as Vercel Node; needs same server env secrets |
| SafePay / Stripe webhooks | requires configuration | Point webhooks to `https://clivora.io/api/...` after SSL |
| Google Calendar OAuth | requires configuration | Redirect URI must use `clivora.io` + `GOOGLE_CLIENT_*` |
| Meilisearch / n8n | requires configuration | Optional; leave empty if unused |
| Odoo sync | requires configuration | Keep `ODOO_SYNC_ENABLED=false` until keys set |
| Admin local JSON events file | works on Hostinger | Writes `data/` with `/tmp` fallback |
| Edge Middleware | works on Hostinger | Next middleware runs in Node deployment |
| Moving Supabase to Hostinger MySQL | blocked | Do **not** — keep Supabase |
| Static export | blocked | App needs server routes |

---

## Exact Hostinger UI settings (paste)

| Setting | Value |
|---------|--------|
| Framework preset | Next.js |
| Branch | `main` |
| Root directory | `./` |
| Node.js | `20.x` (or 22.x if offered) |
| Package manager | npm |
| Install command | `npm ci` |
| Build command | `npm run build` |
| Start command | `npm run start` |
| Port | Hostinger auto (`PORT` env) — do not hard-code |

Do **not** choose static HTML export.

---

## Environment variables — Hostinger (production)

Copy names into Hostinger → Environment variables.  
**Values:** take from your current Vercel project / Supabase dashboard.  
**Never** paste service-role or payment secrets into chat or git.

### Required (app will not auth correctly without these)

```env
NEXT_PUBLIC_SITE_URL=https://clivora.io
NEXT_PUBLIC_SUPABASE_URL=https://jtzjwgovqczlccyeujhq.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=<same anon key as Vercel>
SUPABASE_URL=https://jtzjwgovqczlccyeujhq.supabase.co
SUPABASE_SERVICE_ROLE_KEY=<same service_role as Vercel — server only>
```

### Staging on Vercel (keep as-is)

```env
NEXT_PUBLIC_SITE_URL=https://clivora.codcrafters.org
```

(plus the same Supabase keys already configured on Vercel)

### Optional — only if already used on Vercel

```env
SAFEPAY_SECRET_KEY=
SAFEPAY_API_KEY=
SAFEPAY_PUBLIC_KEY=
SAFEPAY_WEBHOOK_SECRET=
SAFEPAY_ENV=production
SAFEPAY_CURRENCY=USD

STRIPE_ENABLED=false
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
STRIPE_PRICE_PRO=
STRIPE_PRICE_PRO_PLUS=

GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=

OPENAI_API_KEY=
ANTHROPIC_API_KEY=

MEILI_HOST=
MEILI_KEY=
AUTOMATION_WEBHOOK_SECRET=
N8N_WEBHOOK_URL=

ODOO_SYNC_ENABLED=false
```

`EMAIL_FROM` is **not** read by the app today — skip unless you add mailer code later. Use Hostinger mailbox `contact@clivora.io` for human mail; use transactional SMTP inside **Supabase Auth** for OTP/password reset.

---

## Supabase Auth URLs (do this before announcing clivora.io)

**Site URL (production):** `https://clivora.io`

**Additional redirect URLs:**

```text
https://clivora.io/**
https://www.clivora.io/**
https://clivora.codcrafters.org/**
https://*.vercel.app/**
```

Keep the Vercel/staging URLs so backup keeps working.

---

## Callbacks / webhooks (after Hostinger SSL works)

Verify paths in repo, then update provider consoles:

| Provider | URL |
|----------|-----|
| Google Calendar OAuth | `https://clivora.io/api/integrations/google/calendar/callback` |
| SafePay webhook | `https://clivora.io/api/safepay/webhook` |
| Stripe webhook (if enabled) | `https://clivora.io/api/stripe/webhook` |

---

## Deploy procedure (safe order)

1. On Hostinger: import `UsmanGhias/clivora-web` → `main` with settings above.
2. Add **all required** env vars **before** first Deploy.
3. Deploy → use Hostinger **preview URL** first (do not change DNS yet).
4. Smoke on preview:
   - `/` loads
   - `/login` + signup email
   - `/app` dashboard after login
   - password reset link domain matches `NEXT_PUBLIC_SITE_URL`
5. Only then point `clivora.io` / `www` DNS to Hostinger and set `NEXT_PUBLIC_SITE_URL=https://clivora.io` if preview used a temporary host (rebuild after env change).
6. Leave Vercel + `clivora.codcrafters.org` as staging/backup.

---

## Rollback

1. Point DNS back to Vercel / `clivora.codcrafters.org`.
2. Ensure Vercel still has `NEXT_PUBLIC_SITE_URL=https://clivora.codcrafters.org`.
3. Do **not** roll back Supabase migrations blindly.

---

## Code changes shipped for Hostinger

- `package.json` `start` binds `0.0.0.0` and uses `PORT`
- `NEXT_PUBLIC_SITE_URL` drives `site.url`, auth redirects, OAuth, vault share URLs
- Admin event file write falls back to `/tmp` when needed
- Official contact identity: `contact@clivora.io` in `site.company`

DNS cutover is **owner-only** — this doc does not switch DNS automatically.
