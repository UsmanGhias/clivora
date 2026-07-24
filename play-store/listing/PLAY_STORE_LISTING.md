# CLIVORA — Google Play Store Listing (production)

**Package name:** `org.codcrafters.clivora`  
**Version name:** `4.2.3`  
**Version code:** `104`  
**Upload signing SHA-1:** `96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36`

---

## App name (30 characters max)

```
CLIVORA
```

## Short description (80 characters max)

```
CRM for freelancers — clients, projects, invoices & Connect in one app.
```

## Full description

```
CLIVORA is your business OS for freelancers, consultants, and small agencies. Manage clients, projects, invoices, and payments — and grow with CLIVORA Connect.

WHY CLIVORA?
• Modern workspace built for busy freelancers and clients
• Works online with secure cloud sync (Supabase)
• Google Sign-In and email accounts
• Free plan to start; Pro / Pro Plus via Google Play Billing

CLIENTS & PROJECTS
• Organize clients and contacts
• Track projects, tasks, milestones, and timelines
• Notes, file vault, and collaboration tools

INVOICING & MONEY
• Create and send professional invoices
• Quotes, credits, recurring invoices, expenses
• Payment tracking and reports

CLIVORA CONNECT (Pro Plus)
• Discover and connect with freelancers and clients
• Listings, requests, and marketplace tools

SECURITY & ACCOUNT CONTROL
• Biometric device lock (optional)
• In-app Privacy Policy and Terms
• Delete account from Security & Privacy
• No ads; we do not use the advertising ID

FREE PLAN
• Limited clients, projects, and invoices

Upgrade to Pro or Pro Plus with Google Play subscriptions (restore purchases supported).

Website: https://clivora.codcrafters.org
Privacy: https://clivora.codcrafters.org/privacy
Terms: https://clivora.codcrafters.org/terms
Delete account (web): https://clivora.codcrafters.org/delete-account
Built by CodCrafters.
```

---

## Categorization suggestions

| Field | Value |
|-------|--------|
| App category | Business |
| Tags | CRM, invoicing, freelancer, productivity |
| Target audience | 18+ (not designed for children) |
| Ads | No |
| In-app purchases | Yes (Play Billing subscriptions) |

---

## Data safety (declare accurately in Play Console)

Collect / share as applicable to your live backend:

- Account info (email, name, profile photo)
- App activity / diagnostics (crash, performance) if enabled
- Financial info only as invoice metadata you store for the user (not card numbers via CLIVORA if clients pay externally)
- Photos (optional — profile / attachments) via camera or picker

Security practices:

- Data encrypted in transit (HTTPS / TLS)
- Users can request deletion (in-app + web)
- Not for children / not directed to children

Advertising ID: **Not used** (manifest removes `AD_ID`).

---

## Privacy policy URL (required)

```
https://clivora.codcrafters.org/privacy
```

## Release notes (4.2.3)

```
• Production build with Play upload signing
• Command Center / Hub restored to the 3.9.6 layout
• Connect logo (travel_explore) on freelancer and client
• Hub network icon on navigation
• Native Google Sign-In
• Play Billing for Pro / Pro Plus
• Account deletion and privacy links
• Policy-friendly permissions (no advertising ID)
```

---

## Upload artifacts

| File | Path / URL |
|------|------------|
| AAB (Play) | `releases/clivora-4.2.3.aab` |
| APK (sideload QA only) | `releases/clivora-4.2.3.apk` |
| GitHub release | `v4.2.3-playstore` |

Upload **only** the AAB signed with SHA-1 `96:93:81:80:...` to Play Console.
