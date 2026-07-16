# CLIVORA — WhatsApp / AI brief (Done · Left · Idea)

**Updated:** 16 July 2026  
**Live:** https://clivora.codcrafters.org  
**Repos:** github.com/UsmanGhias/clivora · github.com/UsmanGhias/clivora-web  

---

## Idea

CLIVORA = freelancer/agency **business OS** + optional **$0-fee Connect** marketplace. Android offline-first + Next.js web, one Supabase account. Monetize subscriptions (Free / Pro $9 / Pro Plus $19), not take rates. Auth = Supabase only. Payments today = JazzCash/manual + Google Play — **no live card gateway**.

---

## DONE (this release candidate push)

### Phase 1 — Offline sync integrity
- Drift `sync_outbox_entries` + `sync_conflict_entries` (schema **v18**)
- One-time SharedPreferences → Drift migration
- States: pending / processing / retrying / conflicted / permanently_failed / completed
- Idempotency keys (UUID), exponential backoff, max 8 retries
- Unknown kinds → permanently_failed (retained, never success)
- Keep local re-uploads full CRM record; Take cloud applies cloud fields
- Sync Center screen (`/sync-center`) + logout clears user queue
- Unit tests for outbox table / failure retention / conflict CRUD

### Phase 2 — Storage
- Inventory doc + migration creating private buckets (contracts, invoice-docs, project-files, identity, disputes, support, temp-exports) with owner-folder RLS
- Avatars / portfolio thumbs public read; chat-attachments already private

### Phase 3 — Truthful UI
- Removed fake MoM %, demo charts, fake escrow held, admin “All systems operational”
- Payment disclaimer on invoices/earnings/payments surfaces
- Marketing responsive polish continued

### Phase 4 — Flutter blockers
- Calendar selected vs today styling clarified
- Contracts Send CTA works for drafts

### Phase 5 — Client needs-action
- Client home “Needs your action” from real invoice/proposal/message counts

### Deferred (on purpose)
- Live Stripe / funded escrow / pentest / Meilisearch / iOS / major redesign

---

## LEFT before hard launch gate

- [ ] Relationship-based storage ACL (shared project/invoice files)
- [ ] Full RC test matrix on separate role accounts
- [ ] Signed AAB Play internal track upgrade test
- [ ] `cd web && bash push-to-clivora-web.sh` after merge
- [ ] Flutter coach-mark TalkBack / deep-link edge cases retest

---

## Ask other AIs

Paste this file + `CLIVORA-DONE-WORK-INVENTORY.md` + master plan §7. Prompt: rank remaining LEFT items; do not rebuild Done; skip Stripe/pentest.
