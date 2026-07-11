# CLIVORA Connect guide

**CLIVORA Connect** is a private marketplace inside CLIVORA. It helps freelancers find clients and clients find freelancers — without exposing emails until both sides agree.

---

## Access levels

| Action | Free | Pro | Pro Plus |
|--------|------|-----|----------|
| Browse talent & jobs | Yes | Yes | Yes |
| Send Connect requests | No | No | Yes |
| Publish freelancer profile | No | No | Yes |
| Post client job needs | No | No | Yes |
| Connect inbox (accept/decline) | Sign in required | Sign in | Yes |

Upgrade: [Pro Plus checkout](/pro?plan=pro_plus) or Google Play in the Android app.

---

## Pages

| URL | Purpose |
|-----|---------|
| [/connect](/connect) | Public marketplace — Talent, Jobs, Inbox tabs |
| [/connect/manage](/connect/manage) | Edit your profile or post jobs (Pro Plus) |

---

## Freelancer profile fields

When you manage your listing, fill in:

- **Display title** — your name or brand  
- **Headline** — one line pitch  
- **Bio** — longer description  
- **Skills** — comma-separated (e.g. Flutter, React, UI design)  
- **Rate band** — e.g. `$50–80/hr` or `From $500/project`  
- **Location** — city or “Remote”  
- **Availability** — e.g. “Available now”, “2 weeks notice”  
- **Listed** — toggle to show on public board  

Verified badge may be granted by admin after review.

### Trust signals on talent cards

Public talent cards show:

- **Star rating + review count** (or a **New** badge when there are no reviews yet)
- **Verified** badge when admin-approved
- **Member since** date
- **Completion rate** when milestone history exists
- Sort options: Featured, Top rated, Newest, Rate

Reviews are left after an accepted Connect request (web inbox or Android inbox ★).

### Proposals & milestones

- Freelancers can **submit proposals** on open jobs (Pro Plus).
- Clients can **Accept → milestone** on a proposal; CLIVORA auto-creates a kickoff milestone (`pending`).
- After accept, both parties can add more **milestones** and move status: pending → funded → released (or disputed).
- Admins can release escrow ledger entries from the admin panel when funds are confirmed.
- Overdue invoices can trigger **payment reminder emails** via the `send-invoice-reminders` Edge Function (Pro ops).

---

## Client job posts

Clients can post **open needs**:

- **Title** — what you need done  
- **Summary** — scope and timeline  
- **Skills** — what expertise you want  
- **Budget band** — e.g. `$1k–3k`  

Freelancers browse **Jobs** tab and send Connect requests to apply.

---

## Connect request flow

```
Browse → Send request + message → Other party sees Inbox
       → Accept → Emails revealed → Work in CRM
       → Decline → No contact shared
```

### Rules
- You cannot contact yourself.
- Restricted accounts cannot send requests (browse only).
- Blocked accounts cannot use Connect at all.

---

## After you match

1. Add them as a **client** in CRM (app can auto-link on accept).
2. Create a **project** and **invoice** in the same CLIVORA workspace.
3. Use **Messages** for ongoing chat.

This is the main advantage over Upwork/Fiverr: the relationship continues in your OS, not only on the marketplace.

---

## Moderation

Listings and job posts may be:

- **Pending** — awaiting review  
- **Approved** / **Auto-approved** — visible on board  
- **Rejected** — hidden; contact support  

Admins can verify profiles and toggle auto-approve in the admin panel.

---

## Tips for a strong profile

1. Use specific skills (not just “design”).  
2. Set a clear rate band — builds trust.  
3. Write a bio that mentions project types and industries.  
4. Keep availability updated.  
5. Respond quickly in Inbox — acceptance unlocks contact.
