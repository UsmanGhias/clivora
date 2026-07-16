# CLIVORA — WhatsApp / AI brief (Done · Left · Idea)

**Updated:** 17 July 2026  
**Live:** https://clivora.codcrafters.org  
**Repos:** github.com/UsmanGhias/clivora · github.com/UsmanGhias/clivora-web  
**Company:** CODCrafters  

---

## 1. The idea (copy/paste for other AIs)

CLIVORA is a **business operating system for freelancers, agencies, and clients**, not only a job board.

After a hire (optional **CLIVORA Connect** marketplace), work continues in the **same product**: CRM, projects, invoices, messages, meetings, team, analytics · on **Android (offline-first Flutter)** + **Web (Next.js)** · one **Supabase** account.

**USP**
- **$0 platform fee** on deals (subscription, not commission)
- **Private contact** until mutual accept on Connect
- **Browse free** · contact/post = **Pro Plus**
- Plans: Free · Pro (~$9) · Pro Plus (~$19)
- Auth = **Supabase only** (Google + email)
- Payments today: **manual JazzCash/bank** + **Google Play** on Android · **no live card gateway**

Ask any AI: “Using this brief + done/left lists, propose the highest-impact next 5 improvements without rebuilding Done items.”

---

## 2. DONE recently (this session)

### Supabase (clivora project)
- Applied migration **chat-attachments private + owner-folder only** (fixes any-user read of chat files)

### Marketing / home (responsive)
- Connect comparison: **mobile cards** + scrollable desktop table
- Navbar mobile: **Marketplace + Get Pro**
- Pricing banner: stacks on small screens
- Hero title: tighter tracking on narrow phones

### Truthful UI (no fake “Connected” gateways)
- Invoices / Earnings: removed fake Stripe/PayPal/Wise/Payoneer “Connected”
- Client payment methods + billing copy: **coming soon** / manual/Play
- Freelancer Apps tab: removed fake Stripe “Connect”
- Client settings: password → reset flow · delete → `/delete-account` · MFA → Pro Plus
- Admin FilterBar: search can bind · removed dead Filters button

### Earlier Phase 1 (still true)
- Stripe checkout button removed from `/pro` (Coming soon)
- Sync outbox: unknown kinds no longer marked success
- Chat signed URLs: 1 hour TTL
- Master plan + status docs in `docs/internal/`

---

## 3. LEFT (honest backlog · do in small phases)

### P0 product truth / reliability
- [ ] Drift-backed sync outbox (still SharedPreferences)
- [ ] Project/client conflict “Keep local” must re-upload
- [ ] Wire admin FilterBar `onSearchChange` on each admin list page
- [ ] More private storage policies (contracts/vault) beyond chat
- [ ] Push web mirror: `bash web/push-to-clivora-web.sh` + Vercel deploy

### Freelancer web
- [ ] Dead/empty actions pass (quotes create, reminders)
- [ ] Timesheet / Hub KPI edge cases
- [ ] Connect mobile parity with web trust UI

### Client web
- [ ] Needs-action home (overdue, approvals, unread)
- [ ] Real notification prefs persistence
- [ ] Deliverable approval flows polish

### Admin
- [ ] Every FilterBar wired to real queries
- [ ] Export/import buttons that actually work or are hidden
- [ ] No fake zero metrics on fetch failure

### Explicitly deferred (owner decision)
- Live Stripe / card gateways
- Strix / production pentest
- Full Urdu i18n, Meilisearch, portfolio gallery, live escrow funding

---

## 4. How to improve with other AIs

Paste:
1. This file  
2. `docs/internal/CLIVORA-DONE-WORK-INVENTORY.md`  
3. `docs/internal/CLIVORA_CURSOR_MASTER_PRODUCTION_IMPROVEMENT_PLAN.md` §7 (backlog only)

Prompt:
> Rank §7 items by impact/effort. Do not rebuild Done. Prefer fixing dead buttons and truthful payment UI. Propose one PR-sized phase.

---

## 5. Deploy reminder

Source of truth web = `Clivora/web`. Mirror to clivora-web for Vercel:

```bash
cd web && bash push-to-clivora-web.sh
```

Android: Flutter app in same monorepo; Play SKUs must stay Active in Console.

---

*CODCrafters · CLIVORA · for WhatsApp / ChatGPT / Claude / Cursor*
