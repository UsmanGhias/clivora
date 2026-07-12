# CLIVORA Admin Panel

This legacy standalone dashboard is retired. Use `https://clivora.codcrafters.org/admin`, which requires Supabase Auth and MFA.

## Quick start

Do not host or open this file for production administration.

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

- This local tool has no authentication backend and is not safe for administration.
- Use the Supabase-backed web admin instead.
- Do not commit real user passwords; app auth remains on-device SQLite.

## App vs admin

| Feature | Mobile app | Admin panel |
|---------|------------|-------------|
| CRM (clients, invoices) | Yes | No |
| Pro upgrade | Yes | View stats only |
| User signup | Yes | Import/view |
| Invoice PDF | Yes | No |
