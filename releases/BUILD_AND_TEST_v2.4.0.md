# CLIVORA v2.4.0 — Build & Test Guide

Version: **2.4.0+38**

## What is new

### Reliability & sync
- **Offline sync outbox** with retry (notifications, invoice/project sync, analytics)
- **Invoice reconciliation** across devices using `updated_at` comparison on boot

### Notifications
- **Push notification scaffold** listens to Supabase cloud notifications
- Local alerts for messages, invoices, tasks, projects

### Activity & audit
- **Entity activity timeline** on invoices, customers (projects keep tracking)
- **Audit log service** records status changes, payments, admin grants
- **Admin Audit tab** in mobile Command Center
- **Audit trail panel** in `admin_panel/index.html` and web sync via existing `/api/admin/sync`

### Search & calendar
- **Global search** expanded: tasks, contracts, notes/messages + entity/status filters
- **Calendar month grid** with deadlines, tasks, invoice due dates, reminders

### Files & workflow
- **Entity attachments** on invoices (receipts, PDFs, screenshots)
- **Full invoice lifecycle**: draft, sent, viewed, partial, paid, overdue, disputed, canceled
- **Automation rules**: task assigned message, contract signed stage change, inactive client reminder

### Business tools
- **Analytics dashboard** (revenue, outstanding, overdue, completion rates)
- **Backup & restore** JSON export from Hub
- **Subscription manager** with grace period after billing errors

## Build

```bash
export GRADLE_USER_HOME=$HOME/.gradle
flutter pub get
dart run build_runner build
flutter build apk --release
flutter build appbundle --release
```

Output:
- `build/app/outputs/flutter-apk/app-release.apk`
- `build/app/outputs/bundle/release/app-release.aab`

Copy to `releases/clivora-v2.4.0.apk` and `releases/clivora-v2.4.0.aab`.

## Supabase

Apply migration if not yet applied:

```sql
-- supabase/migrations/009_audit_and_sync_indexes.sql
```

## Test checklist

### Sync
- [ ] Save invoice while offline (airplane mode), reconnect, verify cloud share syncs
- [ ] Client pays invoice on device B, freelancer device A shows paid after reopen

### Notifications
- [ ] Send message to client, client sees cloud notification
- [ ] Freelancer bell shows unread count

### Activity
- [ ] Change invoice status, timeline shows entry
- [ ] Super admin: Command Center → Audit tab shows events

### Search
- [ ] Hub → Search finds clients, projects, invoices, tasks
- [ ] Filter chips narrow results

### Calendar
- [ ] Hub → Calendar shows month grid with dots on due dates

### Attachments
- [ ] Edit invoice → Add attachment → file appears in list

### Admin
- [ ] Mobile admin sync pushes events to clivora-web
- [ ] Static admin panel shows Audit Trail after import/sync

### Auth (regression)
- [ ] Google sign-in still works
- [ ] Guest and email login unaffected

## Known limits (next releases)

- FCM native push requires Firebase setup (scaffold logs locally today)
- Full CRM cloud sync (customers/projects local-only; shares/messages cloud)
- clivora-web repo changes must be deployed separately on Vercel
- Localization / RTL not yet wired
