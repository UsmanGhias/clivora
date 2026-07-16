# CLIVORA — Phase 1 status (Master Production Plan)

**Date:** 16 July 2026  
**Source plan:** `docs/internal/CLIVORA_CURSOR_MASTER_PRODUCTION_IMPROVEMENT_PLAN.md`  
**Repos:** `UsmanGhias/clivora` (source of truth) · `UsmanGhias/clivora-web` (Vercel mirror via `web/push-to-clivora-web.sh`)

## Inventory legend

| Status | Meaning |
|--------|---------|
| Already Done | Present and working; do not rebuild |
| Needs Verification | Exists; confirm in staging/prod |
| Needs Improvement | Exists with known gaps (this phase) |
| New | Not started |
| Blocked | Needs owner decision / secrets / legal |
| Deferred | Explicitly out of scope for now |

## Payments (§4)

| Item | Status | Notes |
|------|--------|-------|
| No live Stripe/gateway | **Already Done** (enforced this phase) | UI shows Coming soon; APIs still require `STRIPE_ENABLED=true` |
| Manual JazzCash / bank request | Already Done | `/pro` form |
| Play Billing (Android) | Already Done | Keep as primary in-app path |
| Live escrow funding | Deferred | Ledger UI only |

## P0 — Privacy / storage (§5)

| Item | Status | Change |
|------|--------|--------|
| Public `chat-attachments` bucket | **Needs Improvement → Fixed (migration)** | `20260716_p0_chat_storage_owner_only.sql` sets `public=false` |
| Any-auth SELECT on all chat objects | **Fixed (migration)** | Owner-folder policies only |
| Signed URL TTL | **Improved** | Flutter now 1 hour (was 7 days) |
| MIME allowlist | Already Done | jpeg/png/webp/gif |
| Full object membership for contracts/invoices | Needs Improvement | Next phase |
| Quarantine/scanning | New | Later |

**Action required from you:** apply migration on Supabase project `jtzjwgovqczlccyeujhq` (SQL editor or `supabase db push`).

## P0 — Sync outbox (§5)

| Item | Status | Change |
|------|--------|--------|
| Unknown outbox kind treated as success | **Fixed** | Now fails permanently + user message |
| SharedPreferences JSON queue | Needs Improvement | Move to Drift tables (next phase) |
| Idempotency keys / states / backoff | Needs Improvement | Next phase |
| Keep local / Take cloud for projects | Needs Improvement | Partial today |

## P0 — Authorization (§5)

| Item | Status | Notes |
|------|--------|-------|
| Web admin via profile role (not body credentials) | Already Done | `web/src/lib/admin-auth.ts` |
| Hardcoded admin emails in UI copy | **Improved** | Removed from admin denied page |
| Bootstrap email allowlists in SQL seeds | Needs Verification | Prefer DB role grants only |
| Org/workspace RBAC matrix | New | Larger phase |

## P0 — CI / tests

| Item | Status |
|------|--------|
| Flutter analyze + test workflow | Already Done (exists) |
| Full PR matrix (web lint/typecheck/build + Playwright) | Needs Improvement |
| Secret scanning | New |

## Strix / pentest

| Item | Status |
|------|--------|
| Authorized Strix runbook | **New doc** → `docs/internal/STRIX_AUTHORIZED_PENTEST.md` |
| Running Strix against production | **Blocked** until you confirm staging URL + consent |

## Next phases (do not bulk-implement)

1. Drift-backed outbox + conflict upload for Keep local  
2. Private policies for remaining buckets  
3. Manual payment audit records (no gateway)  
4. Freelancer Today page (§7.1) as first product improvement  
5. PR CI expansion  

## Deploy notes

```bash
# After merge to main / working branch:
cd web && bash push-to-clivora-web.sh   # mirrors to clivora-web for Vercel

# Supabase: run migration 20260716_p0_chat_storage_owner_only.sql
```
