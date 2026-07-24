# Web ↔ Android feature parity (SMEMaster program)

| Surface | Web route | Android route | Roles |
|---------|-----------|---------------|-------|
| CRM enrichment | `/app/clients` panel | Customer edit → enrichment panel | Freelancer |
| Workspace tasks | `/app/workspace-tasks` | `/workspace-tasks` | Freelancer |
| Portal shared tasks | `/app/tasks` | `/client-tasks` (client), Notifications inbox (freelancer) | Both |
| Calendar cloud | `/app/calendar` | `/calendar` (+ cloud FAB) | Freelancer |
| CRM conflicts | `/app/conflicts` | `/crm-conflicts` | Freelancer |
| Campaigns | `/app/campaigns` | `/campaigns` | Freelancer |
| Automation builder | `/app/automation` | `/automation-builder` | Freelancer |
| AI suggestions | `/app/ai-suggestions` | `/ai-suggestions` | Freelancer |
| Admin ops | `/admin/ops` | `/admin-ops` | Admin |
| Sync outbox | (mobile) | `/sync-center` | Freelancer |

Clients never get CRM enrichment / campaigns / automation builder / workspace CRM — same as web client portal.
