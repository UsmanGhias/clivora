# Odoo integration (existing free apps only)

Status: **configured via env — no new Odoo apps installed**

## Target instance

- URL: `https://clivora.odoo.com`
- Scope: sync CLIVORA CRM data into apps **already available** on the Odoo dashboard only.

## Allowed Odoo modules (from your free apps list)

| Odoo app | CLIVORA mapping |
| --- | --- |
| Contacts | Freelancer clients / CRM customers |
| CRM | Optional opportunity mirror (later) |
| Calendar | Meeting links (later; Google Calendar also pending) |
| Discuss / Live Chat | Not auto-synced (CLIVORA messages stay primary) |
| Accounting / Sales / Inventory / … | **Out of scope** unless product decision expands |

Do **not** install extra Odoo apps from CLIVORA. Track only what already exists.

## Secrets (never commit)

Set on the server / Vercel / Edge Function environment:

```bash
ODOO_URL=https://clivora.odoo.com
ODOO_DB=<database name>
ODOO_USERNAME=<login email>
ODOO_API_KEY=<api key>
```

Web route: `POST /api/integrations/odoo/sync-contacts` (authenticated) pushes the current user's CRM customers into Odoo **Contacts**.

## Security

- API key must never ship in the Android APK or public Next.js bundle.
- Sync is user-initiated from Settings → Apps.
- Failures must not block core CLIVORA CRM.
