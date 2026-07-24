# CLIVORA issue map (Cursor handoff)

**Memory graph:** `/home/usmanghias/Projects/clivora/Clivora/graphify-out/` (Graphify-Labs/graphify — 6579 nodes / 12299 edges).  
**Repos:** https://github.com/UsmanGhias/clivora · https://github.com/UsmanGhias/clivora-web  
**Note:** `UsmanGhias/clivorasearch` was referenced by the user; primary app/web repos are `clivora` / `clivora-web`.

Flags: all SMEMaster domain flags are **ON** in production `app_feature_flags`.

## Fixed in this pass (2026-07-25)

| ID | Severity | Issue | Fix |
|----|----------|-------|-----|
| SEC-1 | P0 | Any authenticated user could `UPDATE profiles.role` to admin | Trigger `profiles_protect_privileged_columns` |
| WEB-1 | P0 | Automation webhook queue insert used non-existent columns; lied `queued:true` | Insert `event_type`+`payload`; report real `queued` |
| WEB-2 | P1 | Vault share URL 404; weak token; ungated | Flag gate + crypto token + `/vault/s/[token]` + RPC lookup |
| WEB-3 | P1 | Conflict Keep/Take only marked status | Apply customer snapshot then resolve |
| WEB-4 | P1 | AppShell missing AI suggestions nav | Added `/app/ai-suggestions` |
| APP-1 | P0 | Duplicate `action:` on Tasks scaffold | Single Row action |
| APP-2 | P0 | CRM activities `.eq` after `.limit` | Filter before order/limit |
| APP-3 | P0 | Missing `user_scoped_queries` import | Import added |
| APP-4 | P1 | Task complete/delete skipped outbox | Enqueue `workspace_task` (+ tombstone delete) |
| APP-5 | P2 | Client milestones / menu / admin-ops allowlist | Auth route helper updated |
| APP-7 | P1 | Calendar FAB does not enqueue outbox | Enqueue `calendar_event` |

## Remaining (track next)

| ID | Severity | Issue | Suggested fix |
|----|----------|-------|---------------|
| APP-6 | P1 | Workspace pull does not create Drift rows for cloud-only tasks | Mirror CRM customer pull insert |
| WEB-5 | P1 | `invoice_shares.total_minor` rarely dual-written | Write on share create/update |
| WEB-6 | P2 | AppShell does not hide nav when flags off | `isFeatureEnabledClient` filter |
| OPS-1 | P2 | Admin ops silent empty on audit errors | Surface PostgREST errors |
| QA-1 | — | Full Gates 1–12 evidence still required | Manual/E2E checklist |

## Graphify usage

```bash
# Already installed via uv tool install graphifyy
cd /home/usmanghias/Projects/clivora/Clivora
graphify query "how does workspace_tasks sync"
graphify path "CloudCrmRepository" "SyncOutboxService"
```

Do **not** claim production-ready solely because flags are ON — run gates with evidence.
