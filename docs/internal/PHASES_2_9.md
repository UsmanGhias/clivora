# Phases 2–9 — gated program

**Applied:** `phases_2_9_smemaster_program` + stub `20260724_phases_2_9_program.sql`  
All product flags **OFF**. Enable only after Gates 1–12 evidence.

| Phase | Flag keys | Cloud tables | Notes |
|-------|-----------|--------------|-------|
| 2 Tasks | `workspace_tasks`, `phase2_workspace_tasks` | `workspace_tasks` | Unifies Drift Tasks ↔ cloud; `client_tasks` remains for legacy portal shares |
| 3 Calendar | `calendar_events`, `phase3_calendar_events` | `calendar_events` | Project-linked events |
| 4 Conflicts | `crm_conflict_ui`, `phase4_crm_conflicts` | `crm_sync_conflicts` | Visible Keep/Take beyond invoice LWW |
| 5 Vault | `vault_cloud`, `phase5_vault_cloud` | `vault_*` (Phase 0) | Metadata + RLS; flag gated |
| 6 Campaigns | `campaigns`, `phase6_campaigns` | `campaigns`, blocks, templates | Content publish — **not** IMAP/email blast |
| 7 Automation | `automation_builder`, `phase7_automation_builder` | `automation_rules` | Enqueues `automation_webhook_queue` |
| 8 AI | `ai_structured`, `phase8_ai_structured` | `ai_suggestions` | Human review; no auto-pay/publish |
| 9 Admin/a11y | `admin_ops_dashboard`, `phase9_admin_ops` | uses queue/audit | Ops console + incremental a11y |

## Sync principle

Supabase is SoT for new domains. Flutter Drift + outbox. Web online-first.

## Rollback

Disable flags; tables stay inert. Additive only — no plan CHECK / account_type changes.
