# Feature-flag truth (FLAG-001) — updated 2026-07-25

## Decision

Owner restored **all** SMEMaster domain flags **ON** in production so client,
freelancer, and admin surfaces that were flag-gated show again. Previous
`flag_001_disable_unverified_domains` OFF state is superseded by this owner
restore.

## Production values (authoritative)

| Key | Enabled |
|-----|---------|
| `phase0_foundations` | **ON** |
| `money_minor_units_dual_write` | **ON** |
| `connect_marketplace` | **ON** |
| `push_notifications` | **ON** |
| `ai_llm` | **ON** |
| `crm_enrichment` / `phase1_crm_enrichment` | **ON** |
| `workspace_tasks` / `phase2_workspace_tasks` | **ON** |
| `calendar_events` / `phase3_calendar_events` | **ON** |
| `crm_conflict_ui` / `phase4_crm_conflicts` | **ON** |
| `vault_cloud` / `phase5_vault_cloud` | **ON** |
| `campaigns` / `phase6_campaigns` / `campaigns_ab_testing` | **ON** |
| `automation_builder` / `phase7_automation_builder` | **ON** |
| `ai_structured` / `phase8_ai_structured` | **ON** |
| `admin_ops_dashboard` / `phase9_admin_ops` | **ON** |

## Enforcement

- API/page gates allow when flags are on (vault, campaigns, automation, etc.).
- AppShell shows flag-tagged nav items when any listed key resolves true.
- Direct routes still check flags server-side; DB RLS remains owner-scoped
  (and shared_with for workspace tasks).

## Rollback

Set `enabled = false` on the same keys in `app_feature_flags` (prefer one
domain / alias pair at a time).
