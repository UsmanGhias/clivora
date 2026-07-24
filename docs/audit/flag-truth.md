# Feature-flag truth (FLAG-001) — captured 2026-07-25

## Decision

Unverified SMEMaster domain flags are **OFF** in production until each domain
passes its evidence pack (Gates 1–12 / master plan Phase 8). Owner previously
enabled all flags; they were disabled by audited migration
`flag_001_disable_unverified_domains`.

## Production values (authoritative)

| Key | Enabled |
|-----|---------|
| `phase0_foundations` | **ON** |
| `money_minor_units_dual_write` | **ON** |
| `connect_marketplace` | **ON** |
| `push_notifications` | **ON** |
| `ai_llm` | **ON** |
| `crm_enrichment` / `phase1_crm_enrichment` | OFF |
| `workspace_tasks` / `phase2_workspace_tasks` | OFF |
| `calendar_events` / `phase3_calendar_events` | OFF |
| `crm_conflict_ui` / `phase4_crm_conflicts` | OFF |
| `vault_cloud` / `phase5_vault_cloud` | OFF |
| `campaigns` / `phase6_campaigns` / `campaigns_ab_testing` | OFF |
| `automation_builder` / `phase7_automation_builder` | OFF |
| `ai_structured` / `phase8_ai_structured` | OFF |
| `admin_ops_dashboard` / `phase9_admin_ops` | OFF |

## Enforcement

- API/page gates return disabled/503 when flags are off (vault, campaigns, etc.).
- AppShell hides flag-tagged nav items until a listed key resolves true (WEB-006).
- Direct routes still check flags server-side; DB RLS remains owner-scoped.

## Audited change procedure

1. Flip **one** domain (both alias keys) at a time.
2. Record via `write_audit_event('flag_change', ...)`.
3. Re-enable only after unit + RLS + API + web + Android + feature-off evidence.
4. Rollback = set `enabled = false` on the same keys.
