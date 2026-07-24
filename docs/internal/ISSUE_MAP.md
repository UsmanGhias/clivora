# CLIVORA issue map (Cursor handoff)

**Memory graph:** `/home/usmanghias/Projects/clivora/Clivora/graphify-out/` (gitignored).  
**Repos:** https://github.com/UsmanGhias/clivora · https://github.com/UsmanGhias/clivora-web  

**Flags (2026-07-25):** unverified SMEMaster domain flags are **OFF** in production.
Keep ON: `phase0_foundations`, `money_minor_units_dual_write`, `connect_marketplace`,
`push_notifications`, `ai_llm`. See `docs/audit/flag-truth.md`.

**App version:** `4.2.6+107` — see `docs/releases/release-manifest.md`.

## Fixed (2026-07-25 remediations)

| ID | Severity | Issue | Fix |
|----|----------|-------|-----|
| SEC-1 | P0 | Self-set `profiles.role=admin` | Trigger `profiles_protect_privileged_columns` |
| FLAG-001 | P0 | Flags ON before gates | Unverified domains disabled in DB |
| DB-001 | P0 | Comment-only migrations | Real exported SQL committed |
| APP-006 | P1 | Cloud-only workspace tasks skipped in Drift | `pullTasks` inserts + stamps `local_id` |
| WEB-005 | P1 | `invoice_shares.total_minor` gaps | Client dual-write + DB trigger |
| WEB-006 | P2 | Nav ignored flags | AppShell filters flag-tagged items |
| OPS-001 | P2 | Admin ops false empty | Surface query errors in OpsClient |
| VAULT-001..004 | P1 | Path trust / Origin / expiry / raw errors | Owner resolve, clamp, trusted base URL, codes |
| AUTO-001..005 | P1 | Query secret / best-effort queue | Header auth, HMAC optional, 202 after durable insert |
| SEC-001 | P1 | Odoo writes without AAL2 | Sync/PUT require AAL2; health test AAL1 |
| QA-001 | P0 (partial) | No web unit tests | Vitest + `money.test.ts` + `test:ci` script |

## Remaining (do not claim production-ready)

| ID | Severity | Issue |
|----|----------|-------|
| OFF-001 | P1 | Full offline outbox certification matrix |
| LOCAL-001 | P1 | Prove every Drift query is user-scoped |
| PAY-001 | P1 | Payment entitlement ledger / duplicate events |
| QA-001 | P0 | Playwright critical E2E + Flutter integration_test pack |
| REL | — | Full Gates 1–12 evidence pack |

## Graphify

```bash
cd /home/usmanghias/Projects/clivora/Clivora
graphify query "how does workspace_tasks sync"
```

Status language: **PASS / FAIL / BLOCKED / DISABLED / NOT TESTED** only.
