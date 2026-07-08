# CLIVORA — Data Storage & Backend Setup Guide

## Do you need to set up a database server?

**No.** CLIVORA is built as an **offline-first mobile app**. There is no backend server or cloud database to configure.

Everything runs on the user's phone.

---

## Where is data stored?

| Data | Storage | Location on device |
|------|---------|-------------------|
| Customers, projects, invoices | SQLite (Drift) | App private storage |
| Tasks, expenses, notes | SQLite (Drift) | App private storage |
| User accounts (email, password hash) | SQLite (Drift) | App private storage |
| Login session | SharedPreferences | App private storage |
| Profile photos | File system | `Documents/images/` |
| Theme preference | SQLite + SharedPreferences | App private storage |

**Database file:** Created automatically on first launch at:

```
/data/data/org.codcrafters.clivora/app_flutter/clivora.sqlite
```

(Exact path varies by Android version; users cannot access it without root.)

---

## What you do NOT need to set up

- ❌ MySQL / PostgreSQL / Firebase server
- ❌ REST API backend
- ❌ Database hosting (AWS RDS, etc.)
- ❌ Authentication server (auth is local)
- ❌ Environment variables or `.env` on a server

---

## What happens when a user installs the app

1. App opens → SQLite database is **created automatically**
2. Default business profile and settings are **seeded automatically**
3. User signs up → account row added to local `Users` table
4. All CRM data saved to local tables on the same device

---

## Limitations of local-only storage

| Scenario | Behavior |
|----------|----------|
| User uninstalls app | **All data is lost** |
| User gets new phone | **Data does not transfer** (unless you add cloud sync later) |
| User clears app data | **All data is lost** |
| Multiple devices | **No sync** — each device is independent |

---

## Future: if you want cloud sync (Phase 3+)

You would need to add:

1. **Backend API** (Firebase, Supabase, or custom Node/Dart server)
2. **Cloud database** (Firestore, PostgreSQL, etc.)
3. **Sync logic** in the Flutter app
4. **Updated privacy policy** and Data safety form

This is **not required** for the current v1.2.1 release.

---

## Code references

| Component | File |
|-----------|------|
| Database schema | `lib/data/database/tables.dart` |
| Database + migrations | `lib/data/database/database.dart` |
| Providers | `lib/data/providers/app_providers.dart` |
| Auth (local) | `lib/core/auth/auth_service.dart` |

**Schema version:** 3 (Customers, Projects, Invoices, Users, Tasks, Expenses, Notes, etc.)

---

## Play Console "Data safety" answer

When Google asks where data is stored, answer:

> **Data is stored locally on the user's device. It is not transmitted to developer servers.**
