# CLIVORA Production Slice — Implementation Map

**Date:** 18 July 2026  
**Scope:** Discovery for master-plan Phase 1 + P0 credibility  
**Product model:** Freelancer OS + Connect discovery + direct invoices + $0 deal fee (no live escrow custody)

## Entity → surfaces

| Entity | Tables / RPCs | RLS / auth | Web | Flutter | Admin | Tests |
|--------|---------------|------------|-----|---------|-------|-------|
| Identity / profile | `profiles`, `handle_new_user`, `finalize_account_type` | account_type lock, admin allowlist | `/signup`, `/login`, `/app`, `/delete-account` | Auth + profile screens | `/admin/users` | Flutter unit only |
| Roles | `profiles.account_type`, `profiles.role`, `is_admin()` | 003/007 migrations; allowlist emails | Role-aware `/app` portals | Role-aware home | MFA + allowlist | None automated |
| Connect profile / jobs | `connect_profiles`, `connect_need_posts` | Live remote policies | `/connect`, `/app/connect` | `connect_marketplace_screen` | `/admin/connect` | None |
| Connect request | `connect_requests`, `connect_respond_request`, `connect_peer_contact` | SELECT parties; UPDATE too loose (sender+recipient) | `ConnectBoard` RPC | Was raw UPDATE → RPC in this slice | — | None |
| Proposals / credits | `connect_proposals`, credit ledger, `connect_submit_proposal` | Idempotency keys | `/app/proposals`, Connect | Marketplace service RPCs | Credits in admin | Ledger SQL only |
| CRM / projects | CRM cloud tables, local Drift | Membership RLS | `/app/projects`, tasks | CRM + sync outbox | — | Drift tests |
| Messages | `client_messages`, storage | Chat policies | `/app/messages` | Chat screens | — | Deep-link unit |
| Time | `client_time_entries` | Client access migration | `/app/timesheets` | Timer + offline | — | Partial |
| Invoices | Invoice shares + local/cloud | Share expiry | `/app/invoices` | Invoice sync kinds | `/admin/invoices` | None E2E |
| Reviews | `connect_reviews`, `connect_submit_review` | Requires engagement | Connect UI | Marketplace `leaveReview` | Moderation TBD | None |
| Subscriptions | `subscriptions`, Play verify fn | Server-derived plan | `/pro` | Billing | `/admin/payments` | Edge fn |
| Account deletion | **`request_account_deletion` (added this slice)** | SECURITY DEFINER | Legal page + in-app settings | `AccountDeletionService` | User lookup | Pending |
| Offline sync | Drift `SyncOutboxEntries` | N/A client | N/A | `sync_outbox_service` | — | `sync_outbox_service_test` |

## Canonical money model

- CLIVORA does **not** hold, release, or protect funds in production.
- Invoices record amounts and **manual/user-entered payment status**.
- Admin “escrow” screens reflect milestone **status labels** only; live release API refuses funding RPCs.
- Marketing and client dashboard must not imply custody.

## Repo vs live schema

- Repo migrations: 34 files under `supabase/migrations/`.
- Live Clivora project: additional Connect/admin migrations applied remotely (not all mirrored in repo).
- Stub `017_clivora_connect_and_crm_backup.sql` replaced/supplemented in this slice with Connect contract + Phase 1 RPCs.
