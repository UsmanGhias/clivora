# CLIVORA Production Slice — P0 Scenario Status

**Date:** 18 July 2026  
**Legend:** `PASS_WITH_EVIDENCE` | `FAIL_WITH_REPRODUCTION` | `NOT_IMPLEMENTED` | `BLOCKED_BY_ENVIRONMENT` | `IN_PROGRESS`

Statuses reflect **this slice** after Discovery; many remain for later phases.

| ID | Status | Notes |
|----|--------|-------|
| AUTH-01 | BLOCKED_BY_ENVIRONMENT | Needs seeded test users + E2E credentials |
| AUTH-02 | BLOCKED_BY_ENVIRONMENT | Google OAuth live; not automated here |
| AUTH-03 | BLOCKED_BY_ENVIRONMENT | Session refresh not E2E’d |
| AUTH-04 | BLOCKED_BY_ENVIRONMENT | Reset UI exists; flow not asserted |
| AUTH-05 | NOT_IMPLEMENTED | Role switch matrix tests absent |
| AUTH-06 | IN_PROGRESS | RPC + clients wired this slice; purge job deferred |
| SEC-01 | BLOCKED_BY_ENVIRONMENT | Need RLS negative suite against non-prod |
| SEC-02 | BLOCKED_BY_ENVIRONMENT | Same |
| SEC-03 | BLOCKED_BY_ENVIRONMENT | Admin deny tests absent |
| SEC-04 | IN_PROGRESS | `connect_peer_contact` live; Flutter accept path + UPDATE RLS fixed this slice |
| JOB-01..04 | NOT_IMPLEMENTED | No Playwright job lifecycle |
| DISC-01..02 | NOT_IMPLEMENTED | Search/save convergence untested |
| PROP-01..04 | NOT_IMPLEMENTED | Credit idempotency exists in SQL; no E2E |
| INVITE-01 | NOT_IMPLEMENTED | |
| MATCH-01..03 | IN_PROGRESS | RPC path canonical; concurrency tests deferred |
| CHAT-01..04 | NOT_IMPLEMENTED | Phase 3 |
| PROJ-01..04 | NOT_IMPLEMENTED | Phase 3 |
| TIME-01..03 | NOT_IMPLEMENTED | Phase 3 |
| FILE-01..02 | NOT_IMPLEMENTED | Phase 3 |
| INV-01..05 | NOT_IMPLEMENTED | Phase 3 |
| REVIEW-01..03 | NOT_IMPLEMENTED | Phase 3 |
| SUB-01..03 | BLOCKED_BY_ENVIRONMENT | Needs Play/webhook fixtures |
| CREDIT-01..02 | NOT_IMPLEMENTED | SQL ledger present; API concurrency untested |
| NOTIF-01..02 | NOT_IMPLEMENTED | |
| ADMIN-01..03 | BLOCKED_BY_ENVIRONMENT | |
| SYNC-01..04 | NOT_IMPLEMENTED | Outbox exists; cross-client E2E deferred |
| PERF/RES/A11Y | NOT_IMPLEMENTED | Later phases |

## Public smoke (this slice)

| Check | Status |
|-------|--------|
| `/` renders | Target PASS after deploy |
| `/compare` renders | Target PASS |
| `/comapre` → `/compare` | Target PASS after redirect |
| No public “hold escrow” / vanity 1.2k metrics | Target PASS after copy fix |
| Web typecheck/lint/build | Target PASS |
| Flutter analyze/test | Target PASS |
