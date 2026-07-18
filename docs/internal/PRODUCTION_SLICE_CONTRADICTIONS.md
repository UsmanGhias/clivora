# CLIVORA Production Slice — Contradiction Report

**Date:** 18 July 2026  
**Rule:** Canonical behavior = direct invoice + $0 deal fee; no live escrow custody.

| ID | Contradiction | Canonical choice | Fix in this slice |
|----|---------------|------------------|-------------------|
| C1 | Marketing: “hold escrow” / “Track payments, payouts, escrow” vs homepage direct-pay model | Direct invoice + payment-status tracking only | Rewrite marketing copy |
| C2 | Client home `escrowHeld={outstandingTotal * 0.6}` fabricates money | Never invent financial metrics | Remove fake escrow; show open balances honestly |
| C3 | Docs: “payments in one platform” implies fund movement | Invoices + recorded payment status | Docs index/copy update |
| C4 | Compare: Upwork middleman “Mostly freelancers” | Both sides: client marketplace/initiation + freelancer service fee | Update compare row |
| C5 | Traction `1.2k+` / `3.4k+` / `860+` unverifiable | Product facts only | Replace with product facts |
| C6 | “Verified Professionals” without verification lifecycle | “Complete professional profiles” | ConnectSection rename |
| C7 | Flutter `respondToRequest` direct UPDATE vs web `connect_respond_request` RPC | RPC-only accept/decline | Flutter uses RPC; tighten UPDATE RLS |
| C8 | `connect_requests_update` allows `from_user_id` to UPDATE (sender could self-accept) | Recipient or SECURITY DEFINER RPC only | New migration drops broad UPDATE |
| C9 | `AccountDeletionService` calls missing `request_account_deletion` | Server RPC + profile flags | Add + apply migration |
| C10 | Repo stub `017` vs live Connect DDL | Document + additive Phase 1 migration in repo | Replace stub content + new dated migration |
| C11 | `/comapre` 404 | Permanent redirect to `/compare` | `next.config.ts` |
| C12 | Compare title doubles `\| CLIVORA` via layout template | Absolute title | Fix metadata |
| C13 | Admin escrow UI exists while live release disabled | Keep admin internal; never claim live escrow publicly | Public copy only this slice; admin API already refuses live release |

## Stop conditions checked

- Money/privacy: choosing invoice-direct over escrow — **aligned with product + live DB** (no `connect_escrow_ledger` live).
- No production destructive data mutation planned beyond additive schema (deletion columns + RLS tighten + RPC).
