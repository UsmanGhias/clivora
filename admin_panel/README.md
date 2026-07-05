# CLIVORA Admin Panel

Standalone web dashboard for CodCrafters administrators. This is **separate from the mobile app** — users manage their CRM in the app; you manage platform analytics here.

## Quick start

1. Open `admin_panel/index.html` in Chrome, Edge, or Firefox (double-click the file).
2. Sign in with an authorized admin email:
   - `admin@codcrafters.org`
   - `usmanghias1@gmail.com`
3. Panel password: **`ClivoraAdmin2026!`**

## Import data from the app

1. On your phone, sign in with an admin email (auto Pro).
2. Go to **Hub → Settings → Export Analytics (Admin)**.
3. Share/save the JSON file to your computer.
4. In the admin panel, use **Import Analytics** and select that file.

The panel merges users and events (sign-ups, Pro activations) from each export.

## Features

- Platform stats: users, sign-ups, Pro count, estimated MRR (Rs 2,000/month per Pro)
- User list with manual add/edit/delete
- Event timeline from app exports
- Data stored in browser `localStorage` (per machine)

## Host remotely (optional)

Upload the `admin_panel` folder to any static host (GitHub Pages, Netlify, your server):

```
https://your-domain.com/clivora-admin/
```

Update `kAdminPanelUrl` in `lib/core/constants/admin_config.dart` if you publish a public URL.

## Security notes

- This is a **local-first** admin tool without a backend. Change `PANEL_PASSWORD` in `index.html` before hosting publicly.
- For production-grade global analytics, connect Firebase/Supabase (see `docs/ADMIN_SETUP.md`).
- Do not commit real user passwords; app auth remains on-device SQLite.

## App vs admin

| Feature | Mobile app | Admin panel |
|---------|------------|-------------|
| CRM (clients, invoices) | Yes | No |
| Pro upgrade | Yes | View stats only |
| User signup | Yes | Import/view |
| Invoice PDF | Yes | No |
