# CLIVORA — WhatsApp / AI brief (Done · Left · Idea)

**Updated:** 16 July 2026  
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

## 2. DONE (this push)

### Supabase (Clivora project only — `jtzjwgovqczlccyeujhq`)
- Migration **chat-attachments private + owner-folder only**

### Marketing / home (responsive)
- Connect comparison: mobile cards + desktop table
- Navbar: hamburger until `lg` (no mid-width overcrowding)
- Connect pillars: 1-col until `md`
- Pricing banner stacks on small screens
- Hero tracking uses `sm:` (no invalid `xs:`)

### Admin
- FilterBar search wired across list pages + Reset clears query
- Dead Export/Import/Add hidden unless handler provided; CSV export where data exists
- Overview “Export report” downloads KPI CSV
- Settings Save → browser draft (no fake backup buttons)
- Support page: no fake ticket rows

### Freelancer
- Proposal **Withdraw** updates Supabase status
- Earnings: removed fake % withdrawn/available; honest labels; View invoices CTA
- Stripe “Connect” / fake gateway Connected badges removed

### Client
- Proposal **Shortlist** updates Supabase
- Settings: real plan/account copy; notification prefs persist in localStorage
- Invoice Export CSV works; dead Filters/Status buttons removed
- Team / prefs / apps link to real routes

### Deferred on purpose
- Live Stripe / card gateways
- Strix / production pentest

---

## 3. LEFT (next phases — honest)

- [ ] Drift-backed sync outbox (still SharedPreferences)
- [ ] Project conflict “Keep local” must re-upload
- [ ] Private policies for remaining storage buckets
- [ ] Admin server-side settings API (draft is local only)
- [ ] Push web mirror: `cd web && bash push-to-clivora-web.sh`
- [ ] Client needs-action home polish
- [ ] Timesheet/analytics fake trend % cleanup where still present
- [ ] Flutter screenshot bugs (calendar, coach marks, contracts CTA, etc.)

---

## 4. How to ask other AIs for improvements

Paste:
1. This file  
2. `docs/internal/CLIVORA-DONE-WORK-INVENTORY.md`  
3. `docs/internal/CLIVORA_CURSOR_MASTER_PRODUCTION_IMPROVEMENT_PLAN.md` §7  

Prompt:
> Rank remaining items by impact/effort. Do not rebuild Done. Prefer dead buttons and truthful UI. Propose one PR-sized phase. Skip Stripe and pentest.

---

## 5. Deploy

```bash
cd web && bash push-to-clivora-web.sh   # mirrors to clivora-web / Vercel
```

*CODCrafters · CLIVORA · WhatsApp / ChatGPT / Claude / Cursor*
