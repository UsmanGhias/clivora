# Risk register (production readiness)

Severity per master plan §5. Status: OPEN / FIXED / MITIGATED / TRACKED.

| ID | Sev | Risk | Status | Notes |
|----|-----|------|--------|-------|
| SEC-1 | P0 | Self-elevation via `profiles` update | FIXED | Trigger `profiles_protect_privileged_columns` blocks role/account_type/flags/plan changes by non-admins |
| DB-001 | P0 | Comment-only migrations, non-reproducible schema | FIXED (install) / TRACKED (drift CI + upgrade test) | `20260725_smemaster_full_schema.sql` |
| FLAG-001 | P0 | All new flags ON before gates | MITIGATED | Documented; server enforcement present; nav filter pending (WEB-006) |
| VAULT-001 | P1 | Share trusts caller path/id | FIXED | Resolves owner-scoped `vault_attachments` by `file_id`; `file_path` must be under caller uid |
| VAULT-002 | P1 | Unclamped expiry | FIXED | Clamped integer 1–720h |
| VAULT-003 | P1 | URL from request Origin | FIXED | Uses `NEXT_PUBLIC_SITE_URL`/`site.url` |
| VAULT-004 | P1 | Raw backend errors leaked | FIXED | Stable codes; details to server logs |
| AUTO-001 | P1 | Query-string secret | FIXED | Header-only, constant-time compare |
| AUTO-002 | P1 | No size/schema/source validation | FIXED | 64KB cap, JSON parse, allowed sources, optional HMAC+timestamp |
| AUTO-004 | P1 | `received:true` while not durable | FIXED | 202 only after durable insert; 502/503 otherwise |
| AUTO-003 | P1 | Idempotency/replay | MITIGATED | Idempotency key + `resolution=ignore-duplicates`; needs unique index on key to be fully enforced (TRACKED) |
| AUTO-005 | P1 | Forward before durable accept | FIXED | No synchronous n8n forward; worker path required (TRACKED: build worker) |
| WEB-005 | P1 | `invoice_shares.total_minor` not dual-written | FIXED | Flutter share upsert now writes `total_minor` |
| APP-006 | P1 | Cloud-only workspace tasks never land in Drift | FIXED | `pullTasks` inserts local row + stamps `local_id` |
| WEB-006 | P2 | Nav not flag-filtered | OPEN | Filter AppShell nav by dual-key flags |
| OPS-001 | P2 | Admin ops false-empty on audit error | OPEN | Surface PostgREST error in `/admin/ops` |
| SEC-2 | P2 | CSP/HSTS/cookie/CSRF full review | OPEN | Header audit |
| QA-001 | P0 (gate) | No web unit/integration/E2E | OPEN | Add Vitest + Playwright critical journeys |
| OFF-001 | P1 (gate) | Offline outbox not certified | OPEN | Process-death/restart/account-switch tests |
| PAY-001 | P1 (gate) | Payment lifecycle unproven | OPEN | Keep gateways disabled; entitlement ledger |
| SEC-001 | P1 | Odoo AAL2 on sensitive writes | OPEN | Re-check current code |
| REL-001 | P0 (gate) | Release manifest mismatch (4.2.x) | OPEN | Signed release manifest |

## Immediate next batch (recommended)

1. Add unique index for automation queue idempotency key (finish AUTO-003).
2. AppShell flag-filtered nav (WEB-006).
3. Admin ops error surfacing (OPS-001).
4. Web test scaffold (QA-001) + first Playwright critical journeys.
