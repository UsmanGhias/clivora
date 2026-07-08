# CLIVORA v2.3.9 — Build & Testing Guide

## Build artifacts

| File | Path | Use |
|------|------|-----|
| **AAB (Play Console)** | `releases/clivora-v2.3.9.aab` | Upload to Google Play Console |
| **APK (side-load test)** | `releases/clivora-v2.3.9.apk` | Install on device for QA |

**Version:** 2.3.9+37

### Install test APK
```bash
adb install -r releases/clivora-v2.3.9.apk
```

---

## What changed in v2.3.9

1. **Freelancer notifications bell** — fixed duplicate route; bell and bottom banner open Notifications screen.
2. **Client notifications** — bell and banner open Updates tab (unchanged, verified).
3. **Chat images (FREE)** — storage policies fixed; uploads use signed URLs (no 403 for Free users).
4. **Free vs Pro gating** — Team, File Vault, AI, Workflows, Export require Pro (with upgrade prompt).
5. **Notifications screen** — shows unread client messages for freelancers.

---

## Testing checklist

### Auth (do not break)
- [ ] Google sign-in (freelancer)
- [ ] Google sign-in (client)
- [ ] Email sign-in / sign-up
- [ ] Guest mode preview

### Freelancer
- [ ] Dashboard bell icon opens **Notifications**
- [ ] Bottom banner “X new updates” opens **Notifications**
- [ ] Hub → Follow-ups opens **Notifications**
- [ ] Notifications → tap unread message → **Client Chat**
- [ ] Messages → choose contact → send text
- [ ] Messages → image icon → pick photo → sends without 403
- [ ] Search workspace from dashboard
- [ ] Hub → Team / File Vault / AI / Workflows → Pro gate on Free plan
- [ ] Upgrade screen opens from Pro gate

### Client
- [ ] Portal bell → Updates tab
- [ ] Bottom banner → Updates tab
- [ ] Messages with linked freelancer
- [ ] Send image in chat (Free — must work)
- [ ] Account page quick links

### Supabase (one-time)
Run migration `008_chat_storage_policies.sql` in SQL Editor if chat images still fail.

Set Edge Function secrets for email (optional):
```
RESEND_API_KEY=your_key
RESEND_FROM=CLIVORA <onboarding@resend.dev>
```

---

## Free vs Pro summary

| Feature | Free | Pro |
|---------|------|-----|
| Clients / projects / invoices (limits apply) | Yes | Unlimited |
| Google & email auth | Yes | Yes |
| Chat text + **images** | Yes | Yes |
| Notifications center | Yes | Yes |
| Global search | Yes | Yes |
| Calendar | Yes | Yes |
| Team | No | Yes |
| File Vault | No | Yes |
| CLIVORA AI | No | Yes |
| Workflows / automations | No | Yes |
| Data export | No | Yes |

---

## Roadmap (next releases)

These are planned; not all are in v2.3.9:

- Push notifications (FCM)
- Full offline sync queue with retry
- Activity timeline on every entity
- Invoice lifecycle (draft → sent → paid → overdue)
- Real Play Billing subscription verification
- Audit log for admin actions

---

## Play Console upload

1. Open [Google Play Console](https://play.google.com/console)
2. Production → Create new release
3. Upload `releases/clivora-v2.3.9.aab`
4. Release notes: “Notifications fix, chat images, Free/Pro gates”
5. Roll out to internal testing first, then production
