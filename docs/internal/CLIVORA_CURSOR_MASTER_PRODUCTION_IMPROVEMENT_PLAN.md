# CLIVORA — Cursor Master Production Improvement Plan

**Prepared for:** CODCrafters / Usman Ghias  
**Product:** CLIVORA — Operating System for Freelancers, Agencies & Clients  
**Primary repository:** `UsmanGhias/clivora`  
**Web mirror:** `UsmanGhias/clivora-web`  
**Prepared:** 16 July 2026  
**Document status:** Authoritative improvement brief for Cursor  

---

## 1. Instruction to Cursor

You are working as a senior software-house team on an existing production-intended product. Do not behave as a prototype generator. Preserve working functionality, study the repository before editing, make changes in small reviewable phases, and prove that each change does not break freelancer, client, admin, web, or Android workflows.

This document is an improvement contract. It is not permission to rewrite the product or implement every item simultaneously.

### Mandatory operating rules

1. Read the root `AGENTS.md`, `.cursor/rules/clivora-software-house.mdc`, current plans, entitlement documentation, role contracts, web-to-Android contracts, regression matrix, release notes, PR template, and this document before editing.
2. Inventory the current implementation before proposing a replacement.
3. Mark every item as `Already Done`, `Needs Verification`, `Needs Improvement`, `New`, `Blocked`, or `Deferred`.
4. Never describe an existing feature as missing until code, migrations, routes, and documentation have been searched.
5. Do not rebuild completed trust, reviews, Hub KPIs, reminders, escrow ledger UI, offline foundation, or marketplace functionality merely under a new name.
6. Prefer improving existing Flutter, Next.js, Supabase, Drift, Riverpod, and repository patterns.
7. Supabase Auth remains the only identity provider. Do not introduce Firebase Auth, NextAuth, Keycloak, or parallel identities.
8. Do not rewrite the product into microservices.
9. Preserve Free, Pro, and Pro Plus semantics unless an entitlement plan explicitly changes them.
10. Connect marketplace browsing remains free; marketplace write/contact actions remain Pro Plus; platform commission remains $0.
11. Do not implement Stripe, Stripe Connect, crypto, or any live payment gateway. No payment method is integrated yet.
12. Payment-related UI must be truthful: use `Coming soon`, `Manual/off-platform`, or hide actions behind a disabled feature flag. Never simulate successful real payments.
13. It is acceptable to maintain provider-neutral interfaces and data models, but do not activate gateway code, collect card data, or claim escrow is funded.
14. Never store merchant credentials, service-role keys, API secrets, signing keys, or purchase tokens in client code or committed files.
15. No production mutation may rely only on a hidden button. Enforce access on the server/database layer.
16. Do not force-push, delete user data, rewrite migrations already applied in production, or change public contracts without an approved migration plan.
17. New migrations must be forward-only, idempotent where practical, documented, and tested against a clean database and an upgraded database.
18. Do not mix unrelated work into one change.
19. Do not mark work complete merely because it compiles.
20. Update changelog, regression matrix, contracts, and feature inventory after shipping.

---

## 2. Product direction

CLIVORA should not become only another job board. Its strongest position is:

> A business operating system in which freelancers and small agencies find clients, manage relationships, deliver projects, collaborate, invoice, record payments, and grow recurring business, with an optional zero-commission marketplace.

The priority is to make the best 20–30 workflows reliable and delightful rather than add hundreds of disconnected screens.

### Core audiences

- Freelancer: acquire, organize, deliver, invoice, and retain clients.
- Client: hire, approve, communicate, track work, and maintain records.
- Agency/team: delegate work with controlled permissions and profitability visibility.
- Administrator: operate the platform safely with auditability, moderation, support, and system health.

### Success principles

- One source of truth for roles and entitlements.
- No fake metrics, fake transactions, fake availability, or fake integrations.
- Offline operations must be recoverable and observable.
- Financial records must be auditable even before a gateway exists.
- Private data must remain private across RLS, APIs, files, search, exports, and AI.
- Web and Android should implement the same business rules even when their interfaces differ.

---

## 3. Existing capabilities that must be preserved

Before editing, verify and protect these existing areas:

- Supabase email/password and Google authentication.
- Freelancer/client role lock and admin access checks.
- Flutter offline CRM using Drift.
- Sync outbox, connectivity indication, cloud backup/restore, and conflict foundation.
- Clients, projects, tasks, invoices, quotes, products, expenses, credit notes, purchase orders, vendors, notes, and calendar.
- Invoice PDF and client-sharing paths.
- Freelancer/client messages, notifications, and attachments metadata.
- Connect talent/jobs/proposals/reviews, filtering, Pro Plus gates, trust surfaces, and zero-fee positioning.
- Client portal projects, invoices, contracts, tasks, activity, and messages.
- Team invitations and project sharing foundation.
- Analytics, reports, subscription screens, referral entry, security settings, profile, global search, onboarding, and admin tools.
- Web workspace routes for CRM, messages, timesheets, meetings, support, referrals, Connect, team, analytics, activity, notifications, account, and settings.
- Admin routes for users, marketplace, invoices, proposals, escrow ledger, disputes, support, reports, audit, events, settings, and feature flags.
- Marketing, documentation, privacy, terms, cookies, data-safety, and deletion pages.

If any capability is incomplete, repair its actual gap; do not create a duplicate module.

---

## 4. Scope decision: payments are deferred

### Build now

- Manual payment-status recording with actor, timestamp, note, evidence reference, and audit event.
- Invoice states such as draft, sent, viewed, partially paid, paid, overdue, disputed, void, and refunded-recorded.
- Provider-neutral fields/interfaces that do not expose a fake provider.
- Feature flags that prevent unavailable payment actions.
- Clear copy explaining that CLIVORA does not currently process funds.
- Admin reconciliation views for manually recorded payment events.
- Accounting exports and financial reporting based on recorded data.

### Do not build now

- Stripe Checkout, Stripe Customer Portal, Stripe Connect, webhooks, card collection, stored cards, live payout initiation, live escrow funding, crypto payments, or automatic refunds.
- Any UI that says funds are secured by CLIVORA unless a regulated operational flow truly exists.
- Any automatic entitlement activation from an unverified payment claim.

### Repository treatment

Existing Stripe stubs should be disabled behind an explicit server-side flag, excluded from marketing claims, and documented as dormant. Do not invest production effort in them until the owner selects a provider and legal/commercial requirements are settled.

---

## 5. Verified high-risk issues to investigate first

### P0 — privacy and access control

1. The `chat-attachments` Supabase bucket is configured as public in an existing production-security migration. Replace public access with a private bucket and short-lived signed URLs.
2. Audit every storage bucket: avatars may be public; contracts, invoices, chat attachments, identity documents, dispute evidence, and project files must be private.
3. Add object-level policies that validate workspace/project/conversation membership, not only a user-ID folder prefix.
4. Ensure signed URL generation is server-controlled and expires quickly.
5. Add file extension, MIME signature, size, filename, and path validation.
6. Prevent SVG/script-based upload attacks and unsafe inline rendering.
7. Add quarantine/scanning hooks for untrusted documents.
8. Test cross-user access for every shared table and bucket.
9. Verify blocked/restricted users cannot continue through direct API/database calls.
10. Ensure exports, search, analytics, notifications, and AI never cross tenant boundaries.

### P0 — offline sync and data integrity

1. Move the sync outbox from SharedPreferences JSON into durable Drift tables.
2. Never treat an unknown outbox operation as success. Record a permanent error and retain it for recovery.
3. Give each mutation a stable operation ID/idempotency key.
4. Prevent two sync workers from processing the same item concurrently.
5. Add states: pending, processing, retrying, conflicted, permanently_failed, completed.
6. Add exponential backoff, retry ceilings, next-attempt time, and dead-letter recovery.
7. Protect queue operations with transactions.
8. Do not store sensitive queue payloads unencrypted when avoidable.
9. Complete project/customer conflict behavior: `Keep local` must upload the local record; `Take cloud` must apply cloud values locally. Merely discarding the conflict is not resolution.
10. Display record-level sync status, last-synced time, error reason, and retry action.
11. Preserve deletions with tombstones so deleted records do not reappear.
12. Define conflict rules using server version, local version, update timestamp, and actor—not status alone.
13. Test logout/account switching while items are pending.
14. Scope all local IDs and queues to the authenticated user/workspace.
15. Test reinstall/restore and database migration behavior.

### P0 — authorization model

1. Replace hardcoded admin email logic with database-managed memberships and roles after a safe migration.
2. Keep a tightly controlled bootstrap-super-admin procedure, not permanent business logic tied to a personal email.
3. Create an organization/workspace membership model supporting owner, admin, finance, manager, member, client, and read-only roles.
4. Add explicit permissions for view, create, edit, delete, invite, export, bill, approve, moderate, and configure.
5. Enforce permissions through RLS/functions and server routes.
6. Avoid trusting `user_metadata`, client-provided plan values, route visibility, or cached local roles.
7. Require step-up authentication for role grants, account blocking, data exports, escrow-ledger release records, and destructive operations.
8. Audit every privileged mutation with actor, target, before/after values, reason, correlation ID, and timestamp.
9. Add session revocation and forced logout for blocked users.
10. Test horizontal and vertical privilege escalation.

### P0 — test and release protection

The current test footprint is not proportional to the product. Create pull-request CI, not only tag-time Android checks.

Required CI jobs:

- Web dependency install, lint, typecheck, unit tests, production build.
- Flutter dependency resolution, format check, analyze, unit/widget tests.
- Supabase SQL lint/migration checks and clean-database application.
- Upgrade-path migration test using a representative previous schema.
- Secret scanning and dependency auditing.
- Generated-code consistency.
- Contract/regression-matrix validation.
- Playwright smoke tests against a preview environment when safe.
- Artifact and size reporting.

Branch protection should require passing checks and prevent direct unreviewed production deployment.

---

## 6. Required automated test matrix

### Identity and accounts

- Signup by freelancer and client.
- Google callback success/failure.
- Email verification and reset-password journeys.
- Role lock cannot be bypassed.
- Blocked/restricted/deleted accounts.
- Session refresh and logout across tabs/devices.
- Account switch does not expose prior local data.

### Entitlements

- One central Free/Pro/Pro Plus matrix.
- UI and server/database checks match.
- Expired/admin-granted/promotional plans.
- Pro Plus Connect write gates.
- No client can change its plan through profile updates.
- Feature-flag and entitlement interactions.

### RLS and tenant isolation

- User A cannot read/update/delete User B's CRM data.
- Freelancer sees only legitimately shared client data.
- Client sees only shared projects/invoices/files/messages.
- Team member permissions are enforced per project/workspace.
- Admin endpoints reject non-admins.
- Storage access follows the same relationship rules.

### CRM and finance records

- CRUD ownership for clients/projects/tasks/invoices.
- Currency precision, tax, discount, partial payments, credit notes, due dates, recurring schedules, and totals.
- Invoice numbering uniqueness and concurrency.
- PDF generation snapshots and Unicode/long-text handling.
- Manual payment recording and audit history.
- Void/refund-recorded behavior without gateway assumptions.

### Offline and multi-device

- Create/edit/delete offline then reconnect.
- Duplicate retry does not duplicate records.
- Two-device simultaneous edit.
- Queue survives restart.
- Logout with pending work.
- Token expiry during sync.
- Network failure at each step.
- Real Keep local/Take cloud results.
- Tombstone behavior.

### Connect marketplace

- Guest browse and prohibited write.
- Free/Pro/Pro Plus gates.
- Job lifecycle and proposal state transitions.
- Duplicate proposals, withdrawal, rejection, acceptance.
- Accepted relationship reveals only permitted contact information.
- Review eligibility and one-review constraints.
- Ranking cannot be manipulated through client fields.
- Moderation and reporting.

### Client portal and messaging

- Invitation/relationship acceptance.
- Unread counts and message ordering.
- Attachment authorization.
- Invoice/project share isolation.
- Client update restrictions.
- Blocking/reporting and restricted-user behavior.

### Admin and operations

- Every admin route/API rejects unauthenticated/non-admin requests.
- Grant/revoke role and plan audit.
- Moderation, support, dispute, feature flag, export, and account restriction.
- Operational fetch failures show errors, not zero-value fake health.
- Audit logs are immutable to normal admins.

---

## 7. Product improvement backlog

Cursor must not implement this backlog in bulk. Convert approved items into small plans with acceptance criteria.

### 7.1 Freelancer home and CRM

1. A focused `Today` page: urgent tasks, overdue invoices, proposals, approvals, unread messages, and next meetings.
2. Customizable quick actions.
3. Client health indicators using transparent rules.
4. Project health indicators.
5. Follow-up reminders.
6. Contact timeline combining messages, projects, invoices, notes, and meetings.
7. Tags and custom fields.
8. Client segmentation.
9. Duplicate client detection and merge.
10. Bulk import with preview, validation, and rollback.
11. CSV export with permission/audit checks.
12. Archived client restoration.
13. Client onboarding checklists.
14. Lead pipeline distinct from active clients.
15. Lead source and conversion reporting.
16. Interaction notes with internal/private scope.
17. Relationship ownership in agency workspaces.
18. Smart empty states that recommend one next action.
19. Saved filters/views.
20. Bulk actions with undo where safe.

### 7.2 Projects, tasks, delivery, and time

1. Project templates.
2. Task templates, subtasks, and checklists.
3. Dependencies and blocked-task states.
4. Custom statuses with stable system mappings.
5. Kanban/list/calendar/table views sharing one source of truth.
6. Recurring tasks.
7. Milestone dependencies.
8. Deliverable submission and approval records.
9. Structured revision requests.
10. Change requests showing scope, cost, and deadline effect.
11. Project risk register.
12. Activity timeline with actor and before/after state.
13. Internal versus client-visible notes.
14. File versioning and approval.
15. Project archive download.
16. Automated weekly status reports.
17. Time estimate versus actual.
18. One active timer per user enforced transactionally.
19. Idle-time handling.
20. Manual timesheet correction with reason/audit.
21. Timesheet approval.
22. Billable/non-billable classification.
23. Project budget burn and alerts.
24. Team capacity/workload.
25. Profitability by client/project after cost rates are configured.

### 7.3 Invoices and business finance without a gateway

1. Web recurring invoice parity.
2. Deposits and payment schedules as records.
3. Partial-payment allocation.
4. Credit notes linked to original invoices.
5. Void workflow preserving history.
6. Manual refund records preserving history.
7. Multi-currency records with stored exchange-rate snapshot.
8. Tax profiles and inclusive/exclusive tax.
9. Rounding and decimal rules per currency.
10. Invoice approval before sending.
11. Branded templates.
12. Reminder schedules and escalation.
13. Aging report.
14. Cash-flow forecast from due dates and probability.
15. Revenue and expense categories.
16. Receipt attachment and optional future OCR interface.
17. Vendor bill records.
18. Bank/CSV import with reconciliation preview.
19. Accounting export.
20. Immutable financial audit events.
21. Clear manual/off-platform payment evidence workflow.
22. Dispute status connected to invoice/milestone/support record.
23. Purchase order requirement per client.
24. Sequential numbering rules per workspace and fiscal period.
25. Duplicate/inconsistent invoice detection.

### 7.4 Connect marketplace

1. Deep category/subcategory taxonomy.
2. Skills ontology with aliases and normalized IDs.
3. Cloud-synced saved searches.
4. Daily/instant alerts with user-controlled frequency.
5. Portfolio galleries with media, role, result, skills, and verified relationship where available.
6. Freelancer availability calendar.
7. Shortlists and private talent folders.
8. Invite-to-job.
9. Proposal templates and drafts.
10. Screening questions and structured answers.
11. Proposal version history.
12. Proposal withdrawal/resubmission rules.
13. Client proposal comparison.
14. Interview scheduling using existing meeting links.
15. Job autosave and preview.
16. Job attachments using private storage.
17. Spam/duplicate-job detection.
18. Rate/range validation.
19. Hiring-history indicators based only on verifiable events.
20. Identity/business verification state without false claims.
21. Ranking explanations.
22. New-freelancer discovery opportunity.
23. Anti-gaming protection for reviews and ranking.
24. Report/block flows.
25. Moderation queues, reason codes, evidence, appeals, and audit.
26. Proposal-to-project conversion without duplicate records.
27. Rehire workflow.
28. Favorite freelancers.
29. Client needs and freelancer services listings with clear separate semantics.
30. Search quality analytics and no-result recovery.

### 7.5 Messaging, meetings, files, and notifications

1. True realtime delivery with reconnect reconciliation.
2. Delivery/read states.
3. Typing indicators with throttling.
4. Replies/threads and reactions.
5. Safe edit/delete policy with audit where business records are affected.
6. Pinned messages.
7. Conversation and attachment search.
8. Attachment gallery.
9. Voice notes only after private upload foundation is safe.
10. Quiet hours and notification preferences.
11. Email/push/in-app notification matrix.
12. Notification deduplication and grouping.
13. Deep-link tests for every notification type.
14. Meeting agenda, notes, decisions, and action items.
15. Meeting history connected to projects/clients.
16. Expiring vault/file share links.
17. File versioning and comments.
18. Access revocation for shared links.
19. Retention and deletion policy.
20. Abuse, block, and report controls.

### 7.6 Client experience

1. Needs-action home.
2. Pending approvals, overdue invoice records, disputed milestones, unread messages, and upcoming deadlines.
3. One-click deliverable approval with confirmation.
4. Structured revision requests.
5. Shared project timeline.
6. Client organization with multiple members.
7. Client roles: owner, finance, project approver, collaborator, view-only.
8. Budget visibility controls.
9. Procurement/PO workflow.
10. Freelancer/vendor shortlist.
11. Rehire and duplicate-project-from-template.
12. Shared calendar.
13. Notification digest.
14. Project archive export.
15. Satisfaction pulse and eligible final review.
16. Client onboarding checklist.
17. Clear difference between platform record and actual off-platform payment.
18. Mobile-responsive approval journeys.
19. Accessibility-first portal.
20. Client-facing status explanations in plain language.

### 7.7 Agency and team model

1. Multiple workspaces.
2. Workspace switching.
3. Granular role/permission matrix.
4. Project-specific membership.
5. Client-specific access.
6. Temporary access with expiry.
7. Member suspension and session revocation.
8. Delegated approvals.
9. Internal cost rates protected from clients.
10. Utilization and margin reporting.
11. Workload/capacity planning.
12. Team mentions and assignments.
13. Contractor onboarding/offboarding checklist.
14. Ownership transfer.
15. Agency-branded client portal.
16. Custom domain as a later paid capability.
17. Team audit history.
18. Invite expiry/revocation.
19. Seat-limit entitlements if adopted later.
20. Data export/closure for a workspace.

### 7.8 Admin and operations

1. Honest system-health checks based on real dependencies.
2. Show `Unknown`/`Unavailable`, never `All systems operational` without evidence.
3. Configuration readiness page without exposing secrets.
4. User lifecycle and session revocation.
5. Role and plan grant history.
6. Moderation case management.
7. Dispute-to-support bridge.
8. Support SLA, assignment, status, priority, and internal notes.
9. Feature flags with environment, audience, rollout percentage, owner, and expiry.
10. Audit-log search/export with permissions.
11. Immutable high-risk events.
12. Background job visibility.
13. Failed email/notification/sync queues.
14. Data retention and deletion jobs.
15. Rate-limit dashboards.
16. Abuse signals and manual review.
17. Operational runbooks linked from failures.
18. Safe impersonation only if approved, read-only by default, prominently indicated, and fully audited.
19. Admin action confirmation and required reason.
20. Disaster-recovery dashboard and last successful backup evidence.

### 7.9 AI, only after authorization and data quality

1. Permission-aware retrieval over the user's own authorized data.
2. Source citations for answers.
3. No service-role data sweep exposed to a user request.
4. Workspace/project filters enforced before retrieval.
5. Proposal drafting from approved profile/portfolio context.
6. Project plan drafting.
7. Meeting summary and action extraction.
8. Invoice anomaly warnings.
9. Late-payment risk as an explainable estimate, not a fact.
10. Project health summary.
11. Client follow-up suggestions.
12. Natural-language search over permitted CRM records.
13. Weekly business digest.
14. AI usage quotas and cost limits.
15. User opt-out and retention controls.
16. Prompt-injection defenses for uploaded content.
17. Redaction of sensitive fields.
18. Evaluation dataset and quality metrics.
19. Feedback/report-answer controls.
20. Safe fallback when no model key exists; never present template output as intelligent analysis.

---

## 8. Web UI/UX requirements

1. Create one shared design system: color roles, typography, spacing, radius, shadows, icons, motion, focus, charts, tables, forms, empty/loading/error states.
2. Preserve role distinction without making freelancer and client feel like unrelated products.
3. Use consistent page structure: title, purpose, primary action, filters, content, contextual help.
4. Reduce dashboard card overload; prioritize next actions.
5. Use responsive tables that become meaningful mobile cards, not horizontal overflow by default.
6. Add skeletons without layout shift.
7. Every empty state must explain why it is empty and what to do next.
8. Every error state must offer recovery and correlation/support information.
9. Destructive actions require explicit confirmation and consequence text.
10. Preserve form drafts and warn before navigation.
11. Validate inline and summarize errors accessibly.
12. Meet keyboard navigation, visible focus, contrast, screen-reader labels, and reduced-motion requirements.
13. Establish Core Web Vitals/performance budgets.
14. Lazy-load heavy dashboards/charts and avoid unnecessary client components.
15. Use pagination/cursor loading for large lists.
16. Provide timezone and currency context wherever values can be ambiguous.
17. Add command/search experience only after authorization and result quality are correct.
18. Make beta/coming-soon/unconfigured states explicit.
19. Remove marketing claims not backed by working behavior.
20. Keep feature names and status terminology consistent across docs, Android, web, admin, and emails.

---

## 9. Flutter Android UI/UX requirements

1. Build a role-aware `Today` home rather than displaying every module equally.
2. Simplify navigation to primary destinations plus a searchable tools hub.
3. Preserve Material 3 consistency and define reusable tokens/components.
4. Add record-level sync badges, last-synced time, and failed-sync recovery.
5. Ensure offline-created records are visually distinguishable without alarming the user.
6. Provide a sync center for pending, conflicted, failed, and completed operations.
7. Test back behavior, deep links, process death, rotation, and restoration.
8. Avoid modal/dialog overload for routine workflows.
9. Optimize large lists, images, PDF generation, startup, and Drift queries.
10. Add tablet layouts.
11. Complete Urdu before advertising full Urdu support; verify RTL where appropriate.
12. Support font scaling, TalkBack, contrast, large targets, and reduced animation.
13. Enforce biometric fallback/recovery safely.
14. Never retain another account's local data after logout/account switch.
15. Queue offline attachments durably.
16. Handle notification permission denial gracefully.
17. Test every push/local notification destination.
18. Make Play Billing wording match actual configured SKUs and availability; if not active, do not show a purchasable claim.
19. Track crashes and non-sensitive diagnostics with consent/retention rules.
20. Use golden tests for critical freelancer/client screens and common device widths.

---

## 10. Public website and documentation

1. Position CLIVORA as a freelancer/agency operating system, not only an Upwork replacement.
2. Do not show invented users, revenue, transactions, ratings, uptime, or growth.
3. Separate pages for freelancers, clients, and agencies.
4. Demonstrate complete workflows instead of giant feature lists.
5. Explain $0 platform commission precisely and distinguish it from external payment fees.
6. Explain that live payment processing is not currently integrated.
7. Publish a security overview without revealing exploitable details.
8. Publish honest status and incident history when monitoring exists.
9. Connect changelog entries to releases.
10. Keep pricing and entitlement copy generated/validated from a canonical matrix.
11. Mark features Available, Beta, Limited, Coming soon, or Deferred.
12. Add use-case pages for developers, designers, consultants, and small agencies.
13. Add factual comparison pages with dated claims and sources.
14. Improve metadata, canonical URLs, sitemap, robots rules, Open Graph, structured data, and image optimization.
15. Make docs searchable and version-aware.
16. Add onboarding tutorials and role-specific quick starts.
17. Provide account deletion/export instructions matching real behavior.
18. Keep legal pages consistent with actual collection, retention, subprocessors, and features.
19. Add accessible cookie/consent controls only for technologies actually used.
20. Run broken-link, accessibility, and performance checks in CI.

---

## 11. Data and Supabase standards

1. Every tenant-owned table needs explicit ownership/workspace columns and RLS.
2. Every shared table needs relationship-based policies.
3. Avoid email as a long-term relational key; use UUIDs and keep email as mutable contact data.
4. Add foreign keys, uniqueness constraints, check constraints, and appropriate indexes.
5. Define deletion behavior explicitly.
6. Use server timestamps and version/revision fields for synchronization.
7. Make financial/audit events append-only where appropriate.
8. Do not expose service-role operations to browser/mobile bundles.
9. Security-definer functions must set a safe search path, minimize grants, validate caller/arguments, and receive dedicated tests.
10. Review migration ordering and duplicate policy definitions.
11. Generate a schema/RLS inventory.
12. Add query-performance review for dashboards, search, messages, and admin lists.
13. Paginate large reads.
14. Avoid silent catches that convert outages into empty lists.
15. Return typed domain errors and log server-side correlation IDs.
16. Implement retention/deletion rules for events, notifications, files, support, and telemetry.
17. Backups must be tested by restoration, not only creation.
18. Document Supabase free-plan limits and scale thresholds.
19. Maintain a provider migration/export path without prematurely moving to Contabo.
20. Never expose the project/service configuration beyond what public clients require.

---

## 12. Observability and operational readiness

- Structured logs with correlation/request IDs.
- Error tracking for web and Flutter.
- Privacy-safe analytics with a documented event dictionary.
- Metrics for auth failures, API errors, RLS denials, sync queue age, conflicts, notification failures, email failures, job duration, and admin actions.
- Alerts for sustained failures, not every single exception.
- Dependency health checks that differentiate healthy, degraded, unavailable, and unconfigured.
- Release/version/build identifiers visible to support.
- Runbooks for auth outage, database outage, broken migration, notification failure, data exposure, compromised admin, and rollback.
- Tested rollback strategy for web and Android configuration.
- Backup and restore exercises.
- Status page only when it is powered by real monitoring.

---

## 13. Performance requirements

Set budgets after measuring baselines. At minimum:

- No unbounded database/API list reads.
- No N+1 dashboard queries.
- Indexed ownership, relationship, date, status, and search fields.
- Paginated messages, events, audit logs, marketplace results, files, and admin users.
- Avoid rendering every chart/table on initial dashboard load.
- Cache only data whose authorization and invalidation are understood.
- Optimize images and thumbnails.
- Measure web LCP, CLS, INP, JavaScript size, and API latency.
- Measure Android cold/warm start, frame jank, memory, database latency, sync duration, and crash-free sessions.
- Add regression thresholds to CI where stable.

---

## 14. Required implementation sequence

### Phase 0 — baseline and truth audit

Deliverables:

- Current architecture map.
- Route/screen/module inventory.
- Supabase table, RLS, function, trigger, and storage inventory.
- Role and entitlement matrix comparison across web/mobile/database/docs.
- Automated-test inventory and coverage gaps.
- Known configuration readiness report.
- Confirmed issue list with evidence; no speculative bugs.

No feature implementation in this phase.

### Phase 1 — privacy and authorization

- Private storage migration.
- Signed access paths.
- Cross-user RLS tests.
- Block/restriction enforcement.
- Role/membership design and safe migration plan.
- Admin-action auditing.

### Phase 2 — sync integrity

- Drift outbox.
- Idempotency/retries/dead letter.
- Real conflict resolution.
- Tombstones and multi-device tests.
- Sync center UI.

### Phase 3 — CI and regression protection

- Web/Flutter/SQL PR checks.
- Playwright critical journeys.
- Flutter critical widget/golden tests.
- Branch/release gates and migration checks.

### Phase 4 — product consistency

- Canonical roles/entitlements/statuses.
- Web/Android parity audit.
- Honest payment/unconfigured UI.
- Error/empty/loading states.
- Accessibility and responsive corrections.

### Phase 5 — highest-value product expansion

Recommended order:

1. Client needs-action home.
2. Team ACL/workspaces.
3. Portfolio gallery.
4. Cloud saved searches and alerts.
5. Web recurring invoices.
6. Deliverable/revision/change-request workflow.
7. Dispute/support bridge.
8. Realtime messaging polish.
9. Permission-aware AI.
10. Complete Urdu and deeper accessibility.

### Deferred

- Live payment gateways and funded escrow.
- Crypto payments.
- iOS unless separately approved.
- Self-hosted Meilisearch until scale proves it necessary.
- Large third-party platforms such as Keycloak, Rocket.Chat, Discourse, Kill Bill, or Chatwoot unless a measured problem justifies them.
- Contests and work-diary screenshots until core workflows are stable.

---

## 15. Cursor task protocol

For every phase/task, Cursor must first return a plan in this format:

### A. Evidence

- Files, routes, migrations, components, services, and tests inspected.
- Current behavior.
- Confirmed problem and reproduction.
- Affected roles/platforms.

### B. Change design

- Smallest safe solution.
- Data/RLS/API/UI changes.
- Compatibility and migration impact.
- Security/privacy considerations.
- Rollback plan.

### C. Acceptance criteria

Use testable Given/When/Then statements. Include freelancer, client, admin, web, Android, offline, permission, loading, empty, error, and accessibility cases where relevant.

### D. Implementation

- Use a focused branch.
- Keep commits coherent.
- Do not edit unrelated files.
- Preserve user changes.
- Add tests with production code.
- Update contracts/docs/changelog.

### E. Verification report

- Commands run and results.
- Manual journeys tested.
- Migrations verified clean and upgraded.
- Screenshots for UI changes.
- Security/RLS negative tests.
- Known limitations.
- Exact rollback instructions.

No item is `Done` without this verification report.

---

## 16. Definition of done

A change is complete only when:

1. The requirement and affected roles are clear.
2. Existing functionality was inspected and preserved.
3. Authorization is enforced server/database-side.
4. Data migration and rollback are defined where relevant.
5. Automated positive and negative tests exist.
6. Loading, empty, error, offline, and retry behavior are handled.
7. Accessibility and responsive behavior are checked.
8. Logs do not expose secrets or excessive personal data.
9. Web/Android contracts remain compatible.
10. Entitlements match the canonical matrix.
11. CI passes.
12. Documentation, changelog, regression matrix, and feature inventory are updated.
13. The UI makes no false availability/security/payment claim.
14. A verification report identifies what was tested and what remains.

---

## 17. First prompt to give Cursor

Copy the following exactly:

> Read the root AGENTS.md, `.cursor/rules/clivora-software-house.mdc`, repository plans/contracts/regression matrix/release documents, the existing complete-work inventory, and `CLIVORA_CURSOR_MASTER_PRODUCTION_IMPROVEMENT_PLAN.md`. Do not edit code yet. Perform Phase 0 only: produce an evidence-based baseline and truth audit of Flutter Android, Next.js web, Supabase schema/RLS/storage, roles, entitlements, offline sync, admin authorization, automated tests, CI, configuration readiness, and web↔Android parity. Search the repository before calling anything missing. Classify every result as Already Done, Needs Verification, Needs Improvement, New, Blocked, or Deferred. Payments are Deferred: do not implement Stripe or any gateway. Identify the top 20 confirmed production risks with exact file references and reproduction/verification steps. Then propose small implementation phases with dependencies, acceptance criteria, tests, rollback, and documentation changes. Stop after presenting the audit and plan; wait for approval before modifying files.

After approving Phase 0, give Cursor only one phase at a time.

---

## 18. Final product standard

CLIVORA does not become production-grade because it contains many modules. It becomes production-grade when users can trust that:

- their data cannot leak to another account;
- offline work will not disappear;
- roles and plans cannot be bypassed;
- invoices and records remain correct and auditable;
- unavailable payment functionality is represented honestly;
- freelancer, client, team, and admin workflows agree across platforms;
- failures are visible and recoverable;
- releases are protected by meaningful automated tests;
- new features extend the operating system instead of duplicating it.

That standard must guide every Cursor decision.
