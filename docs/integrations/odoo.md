# Odoo integration (existing free apps only)

Status: **admin-only** · Contacts sync enabled

## Target instance

- URL: `https://clivora.odoo.com`
- Database: `clivora`
- Scope: sync CLIVORA CRM customers into apps **already available** on the Odoo dashboard only.

## Where it appears

| Surface | Visible? |
| --- | --- |
| Admin → System Settings → Integrations | Yes — sync button |
| Freelancer Settings → Apps | No |
| Client portal | No |

## Allowed Odoo modules

| Odoo app | CLIVORA mapping |
| --- | --- |
| Contacts | CRM customers (admin sync) |
| CRM / Calendar / … | Out of scope unless product expands |

Do **not** install extra Odoo apps from CLIVORA.

## Configuration (server-only)

Prefer Vercel project env (production/preview/development):

```bash
ODOO_URL=https://clivora.odoo.com
ODOO_DB=clivora
ODOO_USERNAME=<login email>
ODOO_API_KEY=<api key>
```

Fallback: `admin_integration_secrets` table + `admin_get_integration_secret` RPC (admin role required). Never commit keys. Never ship keys in Android APK/AAB.

API: `GET|POST|PUT /api/integrations/odoo/sync-contacts` (admin session required).

- `GET` — configuration + live auth probe (`ready`, `authOk`, `partnerCount`)
- `POST` — push **all** CRM customers into Odoo Contacts (create/update by email)
- `PUT` — verify and save `ODOO_*` into `admin_integration_secrets` (Admin → Integrations form)

If `authOk` is false, regenerate an API key in Odoo (Preferences → Account Security) and save it in Admin or Vercel. Do not store the interactive login password.

## Security

- Interactive Odoo account passwords must not be stored — use API keys for RPC.
- Rotate any key that was shared in chat or tickets.
- Failures must not block core CLIVORA CRM.
