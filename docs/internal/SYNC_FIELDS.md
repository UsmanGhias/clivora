# Cloud sync fields (web ↔ Android)

Shared Supabase truth used by both website and Flutter:

| Field / table | Synced | Notes |
|---------------|--------|-------|
| `profiles.name` | Yes | Account editors on web + app |
| `profiles.avatar_url` | Yes | Storage bucket `avatars` (http URLs only) |
| `profiles.subscription_plan` | Yes | Admin grant, SafePay, Play verify |
| `profiles.account_type` | Yes | Locked after first set |
| `subscriptions` | Yes | Play / SafePay / `admin_grant_*` |
| `project_shares` / `invoice_shares` / `quote_shares` | Yes | Client portal; match uid **or** lowercase email |
| `crm_*` | Freelancer cross-device | Clients see share snapshots, not CRM rows |
| `crm_companies` / `crm_tags` / `crm_groups` / `crm_activities` / `crm_segments` | Yes (flag `crm_enrichment`) | Phase 1; extends `crm_customers` |
| `workspace_tasks` | Yes (flag `workspace_tasks`) | Unifies Drift Tasks ↔ cloud; `client_tasks` still used for legacy share portal |
| `calendar_events` | Yes (flag `calendar_events`) | Project-linked cloud events |
| `crm_sync_conflicts` | Yes (flag `crm_conflict_ui`) | Visible CRM Keep/Take beyond invoice LWW |
| `vault_share_links` / `vault_attachments` | Yes (flag `vault_cloud`) | Metadata only |
| `campaigns` (+ blocks/templates) | Yes (flag `campaigns`) | Content publish — not email/IMAP |
| `automation_rules` + `automation_webhook_queue` | Yes (flag `automation_builder`) | Durable jobs |
| `ai_suggestions` | Yes (flag `ai_structured`) | Human review required |
| `*_minor` money columns | Dual-write | Keep numeric until cutover |
| `connect_*` | Yes (Pro Plus) | Listings join `profiles.avatar_url` for cards |

**Local-only (not claimed as cloud sync):** theme, biometrics, some Drift business_profile fields (phone/bio/skills until Connect listing is used).

Use Connect Manage for skills/headline/rate; use Account Edit for name/photo.

Program docs: [PHASE0_FOUNDATIONS.md](./PHASE0_FOUNDATIONS.md), [PHASE1_CRM_ENRICHMENT.md](./PHASE1_CRM_ENRICHMENT.md), [PHASES_2_9.md](./PHASES_2_9.md).
