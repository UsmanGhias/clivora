# Phase 1 — CRM enrichment

**Applied:** `phase1_crm_enrichment` (live) + stub `20260724_phase1_crm_enrichment.sql`  
**Flag:** `crm_enrichment` / `phase1_crm_enrichment` — **OFF** until Gates 1–12

## Tables (owner RLS)

| Table | Purpose |
|-------|---------|
| `crm_companies` | Company entities (does not replace `crm_customers.company` string) |
| `crm_tags` / `crm_customer_tags` | Tag taxonomy + M2M |
| `crm_groups` / `crm_customer_groups` | Groups + M2M |
| `crm_activities` | Relationship timeline |
| `crm_segments` | Saved segment definitions (jsonb) |

## Customer additive columns

`company_id`, `lead_score`, `next_action`, `next_action_at`, `duplicate_of`

## RPCs

- `crm_recompute_lead_score(customer_id)` — rules-based 0–100
- `crm_find_duplicate_customers(customer_id)` — scored candidates

## Sync contract

| Client | Behavior |
|--------|----------|
| Web | `web/src/lib/crm/enrichment.ts` when flag on |
| Flutter | `CloudCrmEnrichmentRepository` pull/push companies + activities; customer scoring via RPC |
| SoT | Supabase; Flutter caches via existing Drift customers + cloud enrichment tables |

## Rollback

Disable flags; leave tables empty/inert. Do not drop `crm_customers`.
