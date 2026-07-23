# Odoo Phase 1-2 Integration

Slice C keeps Odoo read-only by default. The admin UI checks health for two Odoo
databases and does not run write sync automatically.

## Configuration

Set secrets in Vercel or save them through the Admin Integrations UI, which writes
to `admin_integration_secrets` via RPC. Do not commit real values or expose them
through Flutter or `NEXT_PUBLIC_*`.

```env
ODOO_SYNC_ENABLED=false

ODOO_MAIN_URL=
ODOO_MAIN_DB=
ODOO_MAIN_USERNAME=
ODOO_MAIN_API_KEY=

ODOO_SOCIAL_URL=
ODOO_SOCIAL_DB=
ODOO_SOCIAL_USERNAME=
ODOO_SOCIAL_API_KEY=
```

For Main only, legacy `ODOO_URL`, `ODOO_DB`, `ODOO_USERNAME`, and `ODOO_API_KEY`
are still accepted as fallback.

## Health checks

`GET /api/integrations/odoo/sync-contacts` is admin-only and returns read-only
health for Main and Social:

1. Resolve config from env, then `admin_integration_secrets`.
2. Authenticate with Odoo.
3. Count active `res.partner` rows.

The response includes readiness, source, database name, username, and partner count.
It never returns API keys.

## Write sync gate

The legacy Contacts sync remains available only behind explicit admin action:

- The UI shows a warning and requires a force checkbox.
- `POST /api/integrations/odoo/sync-contacts` refuses by default when
  `ODOO_SYNC_ENABLED` is false unless the admin sends `force: true`.
- Social is read-only in Phase 1-2; write sync targets Main only.

Do not enable Odoo write sync as a default behavior for Phase 1-2.
