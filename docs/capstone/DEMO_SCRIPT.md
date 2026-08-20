# Capstone demo script (Sprint 3)

Use the **live** product at [https://clivora.io](https://clivora.io) (or localhost `web/` if you are showing development). This is the hire → deliver → invoice loop graders should see.

Do **not** demonstrate Stripe/escrow as live payments. Say “clients pay you directly against the invoice.”

## Accounts

Use two of your own test accounts (do not show real customer PII):

| Role | Where to sign in |
|---|---|
| Client | [https://clivora.io/login](https://clivora.io/login) → client workspace |
| Freelancer | Same login URL → freelancer workspace / Android app |

## Path A — Client hires (US-9)

1. Open [https://clivora.io](https://clivora.io) — homepage, $0 deal fee, web + Android.
2. Sign in as **client**.
3. Open Connect (`/app/connect` or `/connect`).
4. Post a need **or** open an existing job you created for the demo.
5. Show a freelancer proposal (cover letter + bid).
6. **Accept** so contact can unlock (mutual accept). State on camera: emails stay private until both sides accept.

## Path B — Freelancer delivers and bills (US-10)

1. Sign in as **freelancer** (web or Android).
2. Open the matched project. Show budget / hourly rate if set.
3. Open **Timesheets**. Start/stop timer only if an approved rate exists; otherwise show the empty/honest state.
4. Open **Invoices**. Create or open a draft, then open the public share link `/i/[token]`.
5. Show **Ask AI** (Pro): ask “How many clients do I have?” then “Should CLIVORA auto-pay this invoice?” — the second must refuse auto-pay.

## Path C — Android (initiative)

1. Open the Play Store listing or the installed app `org.codcrafters.clivora`.
2. Sign in with the same freelancer email.
3. Show dashboard + one CRM list (clients or invoices) to prove one account.

## What not to click

- Admin grant-pro tools
- Stripe checkout (stub / not the Capstone story)
- Production customer records

## Timing for the 15–20 minute recording

| Minutes | Content |
|---|---|
| 0:00–0:30 | Government ID to camera (name and photo readable) |
| 0:30–2:00 | What CLIVORA is + Capstone increment vs baseline |
| 2:00–8:00 | Path A |
| 8:00–14:00 | Path B including invoice link + Ask AI |
| 14:00–17:00 | Android one-account proof |
| 17:00–20:00 | Architecture (offline outbox, RLS, CI) + board/docs links |
