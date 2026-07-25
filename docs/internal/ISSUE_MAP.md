# CLIVORA issue map (Cursor handoff)

**Memory graph:** `graphify-out/` (gitignored) · integrity map: `docs/audit/web-android-integrity.md`  
**Repos:** https://github.com/UsmanGhias/clivora · https://github.com/UsmanGhias/clivora-web  

**Flags:** SMEMaster domains **ON** (owner restore 2026-07-25). See `docs/audit/flag-truth.md`.

**App version:** `5.3.8+538`

## Fixed 2026-07-25 (integrity batch)

| ID | Issue | Fix |
|----|-------|-----|
| SYNC-UI | Double “sync pending” banners | Shell banner = conflicts/failures only; Hub → Sync Center |
| AVATAR | http avatar ignored / local path blocks cloud | NetworkImage + store cloud URL after upload |
| CONNECT-PUB | First publish PROFILE_INCOMPLETE | Upsert draft before publish RPC |
| CRM-DEL | Deletes resurrected on pull | Outbox tombstones + cloud delete by local_id |
| CONNECT-CRM | Add partner not synced | Enqueue `crm_customer`; clients → portal |
| CLIENT-CRM | Clients pushed into crm_* | Skip `syncAll` for client accounts |

## Remaining

| ID | Severity | Issue |
|----|----------|-------|
| CONNECT-PROP | P1 | Proposals Inbox parity with web |
| OFF-001 | P1 | Full offline outbox certification |
| QA-001 | P0 | Playwright + Flutter E2E evidence packs |

Status: **PASS / FAIL / BLOCKED / DISABLED / NOT TESTED** only.
