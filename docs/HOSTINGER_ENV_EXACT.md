# Exact Hostinger env — paste into clivora.io → Environment variables

Vercel CLI now redacts secrets as `[SENSITIVE]` in agent mode, so those values must be copied from dashboards (links below).  
**Public keys below are exact and ready to paste.**

---

## Block A — paste these as-is (required)

```env
NEXT_PUBLIC_SITE_URL=https://clivora.io
NEXT_PUBLIC_SUPABASE_URL=https://jtzjwgovqczlccyeujhq.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp0emp3Z292cWN6bGNjeWV1amhxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODMxODAwNzMsImV4cCI6MjA5ODc1NjA3M30.BwatkYlqX88GRCdyAvTCiUmsCF3Nc171an8XfosuuLM
SUPABASE_URL=https://jtzjwgovqczlccyeujhq.supabase.co
STRIPE_ENABLED=false
ODOO_SYNC_ENABLED=false
SAFEPAY_ENV=production
SAFEPAY_CURRENCY=USD
```

---

## Block B — secrets (copy from dashboards — do NOT use `[SENSITIVE]`)

### 1) Supabase service role (required)

Open: https://supabase.com/dashboard/project/jtzjwgovqczlccyeujhq/settings/api  

1. Under **Project API keys** → **`service_role`** → **Reveal**  
2. Paste into Hostinger:

```env
SUPABASE_SERVICE_ROLE_KEY=<paste service_role secret here>
```

### 2) SafePay (required for `/pro` checkout)

Open your SafePay dashboard → API keys / Endpoints.

```env
SAFEPAY_API_KEY=<Public key starts with sec_ + UUID>
SAFEPAY_SECRET_KEY=<Secret key>
SAFEPAY_WEBHOOK_SECRET=<Webhook signing secret>
```

After Hostinger is live, set webhook URL to:  
`https://clivora.io/api/safepay/webhook`

### 3) Admin sync key

From Vercel → Project `clivora` → Settings → Environment Variables → **ADMIN_SYNC_KEY** → Reveal  
(or generate a new long random string and use the same value only on Hostinger).

```env
ADMIN_SYNC_KEY=<revealed or new secret>
```

### 4) Odoo (optional — skip if unused)

```env
ODOO_URL=
ODOO_DB=
ODOO_USERNAME=
ODOO_API_KEY=
```

---

## Block C — Supabase Auth (dashboard only — not Hostinger env)

Open: https://supabase.com/dashboard/project/jtzjwgovqczlccyeujhq/auth/url-configuration

| Field | Value |
|-------|--------|
| Site URL | `https://clivora.io` |
| Redirect URLs | `https://clivora.io/**` |
| | `https://clivora.io/auth/callback` |
| | `https://clivora.io/auth/reset-password` |
| | `https://clivora.codcrafters.org/**` (temporary) |

### Auth SMTP (password reset / confirm — use Hostinger mailbox)

Open: Authentication → SMTP Settings → Enable custom SMTP

| Field | Value |
|-------|--------|
| Host | `smtp.hostinger.com` |
| Port | `465` |
| Username | `contact@clivora.io` (or `noreply@clivora.io`) |
| Password | mailbox password from Hostinger Emails |
| Sender email | `contact@clivora.io` |
| Sender name | `CLIVORA` |

---

## Block D — Edge Function secrets (product emails — no Resend)

Open: https://supabase.com/dashboard/project/jtzjwgovqczlccyeujhq/settings/functions  

Add / replace:

```env
SMTP_HOST=smtp.hostinger.com
SMTP_PORT=465
SMTP_USER=contact@clivora.io
SMTP_PASS=<same mailbox password>
SMTP_FROM=CLIVORA <contact@clivora.io>
```

Remove if present: `RESEND_API_KEY`, `RESEND_FROM`.

---

## After paste

1. Hostinger → **Redeploy**  
2. Smoke: `https://clivora.io/login`  
3. Test password reset email  
4. Keep Vercel old host only until redirect works  

Related: `docs/DOMAIN_CUTOVER_CLIVORA_IO.md`
