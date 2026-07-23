# CLIVORA Public Integrations API v1

Slice B adds a read-only public API scaffold for server-to-server integrations.

## Authentication

Use an API key from **Admin -> System Settings -> Integrations -> Public Integrations API**:

```http
Authorization: Bearer clv_...
```

Raw tokens are shown once. CLIVORA stores only a SHA-256 hash in `public.api_keys`.
Do not put tokens in Flutter, `NEXT_PUBLIC_*`, client-side bundles, or chat.

## Scopes

- `contacts:read` for `/api/v1/contacts`
- `projects:read` for `/api/v1/projects`

Requests are validated server-side with the Supabase service role and scoped to the
API key owner's CRM rows.

## Endpoints

### Health

```http
GET /api/v1/health
```

No authentication required. Returns service status only; no configuration or secrets
are exposed.

### Contacts

```http
GET /api/v1/contacts?limit=50&offset=0
Authorization: Bearer clv_...
```

Requires `contacts:read`. Returns owner-scoped CRM customer rows.

### Projects

```http
GET /api/v1/projects?limit=50&offset=0
Authorization: Bearer clv_...
```

Requires `projects:read`. Returns owner-scoped CRM project rows.

## Revocation

Admins can revoke keys from the Integrations tab. Revocation sets `revoked_at`; the
hash remains for audit/lookup history and validation rejects revoked keys.
