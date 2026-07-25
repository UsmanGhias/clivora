# Web ↔ Android integrity map (knowledge graph)

**Updated:** 2026-07-25 · App `4.2.7+108`  
**Source:** Graphify + code audit of sync / Connect / profile / CRM.

## Integrity rule

For each role, the **same Supabase identity** must see the same cloud-backed
records on web and Android. Drift is a **cache + offline outbox**, not authority
for roles, plans, avatars, or payment state.

```
Mobile write → Drift (optional) → outbox / direct Supabase → web reads same tables
Web write → Supabase → Android pull / session sync → Drift / UI
```

## Role × domain map

| Domain | Freelancer SoT | Client SoT | Android write | Web write |
|--------|----------------|------------|---------------|-----------|
| Profile / avatar | `profiles` | `profiles` | upload → `avatar_url` http; display NetworkImage | ProfileEditForm / settings |
| CRM customers/projects/invoices | `crm_*` | N/A (shares) | outbox push/pull + deletes | CRM UI |
| Client projects | `project_shares` | `project_shares` | freelancer shares | portal reads |
| Invoices to clients | `invoice_shares` | `invoice_shares` | share sync + `total_minor` | `/i/[token]` + portal |
| Connect listings/requests | `connect_*` + RPCs | same | online RPCs | Connect UI |
| Messages | `client_messages` | same | realtime/hybrid | app messages |
| Workspace tasks / calendar / vault | flagged OFF | — | gated | gated |

## Fixed integrity bugs (this batch)

1. **Duplicate sync UI** — shell no longer banners routine pending; offline bar alone when offline; Hub links to Sync Center.
2. **Avatar** — http URLs render; after mobile upload local stores cloud URL; session pull applies cloud when local file missing/stale.
3. **Connect first publish** — upsert draft before `connect_publish_profile`.
4. **CRM deletes** — enqueue tombstones that delete cloud rows by `local_id`.
5. **Connect → Clients** — enqueue `crm_customer`; clients route to portal not `/customers`.
6. **Client CRM sync** — `syncAllForSignedInUser` skips clients (shares-only path).

## Remaining gaps (honest)

| Item | Status |
|------|--------|
| Connect proposals UI parity with web | NOT TESTED / partial (contact requests work; proposals API exists but Inbox not fully wired) |
| Full offline outbox certification matrix | NOT TESTED |
| Playwright + Flutter E2E on every journey | NOT TESTED |

Do **not** claim 100% until those evidence packs pass.
