# Odoo integration (existing free apps only)

Status: **admin-only** · **two-way Contacts sync** enabled

## Target instance

- URL: `https://clivora.odoo.com`
- Database: `clivora`
- Scope: bidirectional sync with apps **already available** on the Odoo dashboard only.

## Where it appears

| Surface | Visible? |
| --- | --- |
| Admin → System Settings → Integrations | Yes — Two-way / Pull / Push |
| Freelancer Settings → Apps | No |
| Client portal | No |

## Allowed Odoo modules

| Odoo app | CLIVORA mapping |
| --- | --- |
| Contacts (`res.partner`) | CRM customers — **two-way** |
| Partner Internal Notes | Projects + invoices tracking summary (push) |
| CRM / Calendar / … | Out of scope unless product expands |

Do **not** install extra Odoo apps from CLIVORA.

## Sync behaviour

| Direction | What happens |
| --- | --- |
| **Odoo → CLIVORA** | Active Contacts with email/phone/company are upserted into `crm_customers` (match `odoo_partner_id`, then email). New rows owned by the admin who runs sync. |
| **CLIVORA → Odoo** | All CRM customers create/update Contacts; `odoo_partner_id` stored; project + invoice lists written into Internal Notes between `CLIVORA TRACKING` markers. |
| **Two-way** | Pull first, then push (so Odoo-only contacts exist before tracking push). |

Columns: `crm_customers.odoo_partner_id`, `crm_customers.odoo_synced_at`.

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
- `POST` — `{ "direction": "push"|"pull"|"both", "includeTracking": true }`
- `PUT` — verify and save `ODOO_*` into `admin_integration_secrets`

If `authOk` is false, regenerate an API key in Odoo (Preferences → Account Security) and save it in Admin or Vercel. Do not store the interactive login password.

## Security

- Interactive Odoo account passwords must not be stored — use API keys for RPC.
- Rotate any key that was shared in chat or tickets.
- Failures must not block core CLIVORA CRM.
