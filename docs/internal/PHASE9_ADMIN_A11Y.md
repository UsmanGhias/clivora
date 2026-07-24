# Phase 9 — Admin ops & a11y notes

## Admin ops

- Route: `/admin/ops` (flag `admin_ops_dashboard` / `phase9_admin_ops`)
- Surfaces: `automation_webhook_queue`, `audit_events`
- Does not replace `/admin/audit` or marketplace Jobs moderation

## Accessibility incremental checklist (apply per surface)

- [ ] Interactive controls have visible labels / `aria-label`
- [ ] Forms announce errors in text (not color alone)
- [ ] Lists/tables paginate or virtualize beyond ~50 rows
- [ ] Focus order matches visual order; skip-to-content where shells allow
- [ ] RTL: avoid hard-coded `ml-*`/`mr-*` on new panels; prefer logical properties when touching layout
- [ ] Empty / loading / retry states present on every new flag-gated page

New Phase 1–8 pages ship with basic labels, empty states, and error text. Full virtualization/RTL polish continues incrementally under this flag.
