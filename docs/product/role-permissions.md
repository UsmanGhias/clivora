# Role permissions (summary)

## Account lock

One email → one `account_type`: `freelancer` | `client` (admin is separate privileged path). No unsupported role-switch.

## States

| State | Behavior |
| --- | --- |
| Active | Normal access for role + plan |
| Restricted | May browse Connect; cannot publish / contact / initiate Connect writes |
| Blocked | No protected app surfaces; redirect to blocked |

## Freelancer portal

CRM (plan-gated), Connect (Pro Plus for write actions), proposals, messages, timesheets, invoices, earnings, analytics, settings, referrals.

## Client portal

Post a job, browse talent, proposals inbox, projects/shares, invoices, payments navigation, messages, reports, settings.

## Admin

Privileged operators only; never expose service-role or fraud internals in public docs.
