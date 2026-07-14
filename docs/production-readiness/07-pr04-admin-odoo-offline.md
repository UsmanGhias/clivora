# PR-04 — Offline sync, realtime, and admin live-data hardening

**Status:** Complete for scoped items (2026-07-14)  
**Depends on:** PR-03 remediations (`05-pr03-remediation-evidence.md`)

## Scope

| Area | Goal |
| --- | --- |
| Admin platform snapshot | Live Supabase service-role aggregates for migration overview |
| Odoo Contacts | Admin push of CRM customers using existing free Odoo apps only |
| Offline / outbox | Android `sync_outbox` + reconnect / conflict paths (Batch D) |
| Realtime | Chat / notifications channels — no silent failures |

## Findings fixed this batch

1. **Admin `AUTH_UNAVAILABLE` (503)** — fixed auth config assert fallbacks.
2. **Empty admin lists** — PostgREST selects aligned to live schema.
3. **Fabricated overview metrics** — removed invented ratios.
4. **Odoo sync** — two-way Contacts with resilient pull domain + warnings.
5. **Connect marketplace** — jobs publish approved; hire/shortlist/message; peer contact privacy.
6. **Admin Connect/Jobs CRUD** — Approve / Hide / Verify wired.

### PR-04-C — Android sync outbox

7. **Outbox success-on-failure** — `_execute` now uses `bypassQueue` direct paths for invoice/project/notification; CRM push throws `AUTH_REQUIRED` when offline-signed-out instead of silent success.
8. **Dedup + dead letter** — enqueue dedupes by kind+stable key; max retries move items to dead-letter store (last 50); banner requeues dead letter on tap.
9. **Exponential backoff** — retries wait before re-drain.
10. **Analytics drain** — mirrors via `mirrorAnalyticsEvent(rethrowOnError: true)` (no double local insert).
11. **admin_sync no-op** — stopped enqueueing dead admin events that burned retries.
12. **Message outbox** — `message_send` kind queues offline/failed hybrid sends.
13. **Sign-in drain** — `processQueue` + `reconcileInvoiceShares` after session restore / sign-in.

### PR-04-D — Realtime ACL + attachments

14. **Chat storage private** — `chat-attachments` bucket `public=false`; participant-scoped SELECT policy (uploader folder or messaging peer).
15. **`client_messages` replica identity full** — reliable filtered UPDATE realtime.
16. **`uid_for_linked_email`** — includes Connect accept / hired proposals / invoice shares.
17. **`message_allowed_peer_emails` + `unread_message_count`** — server ACL helpers for Flutter/web.
18. **Flutter mailbox** — bootstrap/stream includes `to_email`; Connect peers in `linkedPeerEmailsProvider`.
19. **Web messages realtime** — `postgres_changes` subscription on `from_uid` / `to_uid` with CHANNEL_ERROR banner.
20. **MessageCompose** — resolves recipient via `uid_for_linked_email` / Connect details (not open profiles).

## Residual / next

| ID | Item | Status |
| --- | --- | --- |
| PR-04-A | Admin live snapshot deploy | **Done** |
| PR-04-B | Odoo two-way Contacts | **Done** (Contacts app only) |
| PR-04-C | Android sync outbox + conflict evidence | **Done** (code + dead-letter; CRM LWW conflicts still invoice-first UX) |
| PR-04-D | Realtime channel ACL / chat attachment RLS | **Done** |
| PR-04-E | Runtime matrix tests (client post job → apply → hire → message; offline edit → reconnect) | **TO VERIFY** manually on device/web |

## Manual verification matrix (PR-04-E)

| # | Scenario | Expect |
| --- | --- | --- |
| 1 | Airplane mode → edit customer/invoice → reconnect | Outbox drains; banner clears |
| 2 | Offline → send chat → reconnect | `message_send` flushes; peer receives |
| 3 | Hire freelancer → open Android chat | Peer email allowed (Connect); message inserts |
| 4 | Two browser tabs on Messages | New message appears without hard refresh |
| 5 | Admin → Odoo Two-way sync | Connected · contacts; no hard Server Error |
| 6 | Chat image attachment | Only parties can signed-URL read path |

## Commands

```bash
# After deploy, signed-in admin session:
curl -sS -b '...' https://clivora.codcrafters.org/api/admin/platform | jq '.overview,.source'
curl -sS -b '...' https://clivora.codcrafters.org/api/integrations/odoo/sync-contacts | jq '{configured,ready,authOk,source,envPresence}'
```
