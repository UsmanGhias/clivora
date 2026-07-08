# CLIVORA v2.3.8 — Build & Test Guide

## Artifacts

| File | Use |
|------|-----|
| `releases/clivora-v2.3.8.aab` | Upload to Google Play Console (Production / Internal testing) |
| `releases/clivora-v2.3.8.apk` | Side-load on device for QA |

**Version:** 2.3.8+36

---

## Before testing (Supabase)

Run migration `008_chat_storage_policies.sql` in Supabase SQL Editor if chat images still return 403.

Set Edge Function secrets (if using email):
- `RESEND_API_KEY`
- `RESEND_FROM`

---

## Test checklist

### Auth (do not break)
- [ ] Google sign-in (freelancer + client)
- [ ] Email sign-in / sign-up
- [ ] Guest mode
- [ ] Sign out and back in

### Freelancer
- [ ] Dashboard bell icon opens **Notifications** (tap works with badge visible)
- [ ] Bottom banner "X new updates" opens notifications when badge > 0
- [ ] Messages icon opens chat
- [ ] **Search workspace** button finds clients/projects/invoices
- [ ] Hub tab still visible in bottom nav

### Client
- [ ] Portal bell opens Updates
- [ ] Bottom banner opens Updates
- [ ] Account page quick links work
- [ ] Messages + image share in chat (no 403)

### Chat images (Free plan)
- [ ] Open chat with linked contact
- [ ] Tap image icon, pick photo
- [ ] Image appears in thread for both users

### Free vs Pro
- [ ] Free: max 3 clients, 5 projects, 10 invoices/month
- [ ] Pro/Admin: unlimited (or admin auto-Pro)
- [ ] AI Assistant / Automations show Pro gate on free (if applicable)

---

## Install APK (QA)

```bash
adb install -r releases/clivora-v2.3.8.apk
```

---

## Play Console upload

1. Open [Google Play Console](https://play.google.com/console)
2. Release → Internal testing (or Production)
3. Create release → Upload `clivora-v2.3.8.aab`
4. Add release notes (see below)
5. Review and roll out

### Suggested release notes

- Fixed freelancer notification bell not responding to taps
- Chat image sharing works on Free plan (storage fix)
- Global search across clients, projects, invoices
- Improved client account page
- Free vs Pro feature groundwork

---

## Roadmap (next releases)

Priority order for future builds:

1. Push notifications (FCM)
2. Offline sync queue + conflict handling
3. File attachments (invoices, contracts, projects)
4. Activity timeline on all entities
5. Automation rules engine
6. Verified Play Billing for Pro subscriptions
