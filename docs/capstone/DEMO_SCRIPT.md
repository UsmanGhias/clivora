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

## Path D — The Sprint 3 security audit (strongest engineering evidence)

This is the segment that shows senior engineering judgement rather than feature
count. Full write-up: `docs/capstone/SECURITY_AUDIT_2026-08.md`.

**Do not recreate the vulnerability on camera.** It is fixed in production. Show
the fixed behaviour live, and show the written evidence for what it did before.
Say plainly: "I found this, I reproduced it, I fixed it, and I wrote a test so it
cannot come back."

### D1 — The finding (say this out loud, ~60 seconds)

> "The guest invoice page let a client open an invoice without an account, using
> a token in the URL. The page filtered on that token. But row-level security
> runs *before* the filter, and the filter is just a query parameter the caller
> controls — so the policy had been written as 'any row that has a token'. That
> meant anyone holding the anon key, which ships inside my own web bundle and my
> own APK, could drop the filter and read every shared invoice in the product:
> client emails, amounts, and the share tokens themselves. One request would
> have disclosed the data *and* handed over the keys to every guest link."

### D2 — Show it is closed (live terminal, ~45 seconds)

```bash
ANON=<the anon key, already public in the web bundle>
URL=https://jtzjwgovqczlccyeujhq.supabase.co

curl -s "$URL/rest/v1/invoice_shares?select=invoice_number,total,client_email,public_token&public_token=not.is.null" \
     -H "apikey: $ANON"
```

Expected on camera: `[]`

Then open a real guest invoice link (`/i/<token>`) in the browser and show it
still renders. Point out both halves: the enumeration is gone, the feature works.

### D3 — Show the fix, and why a policy could not do it (~60 seconds)

Open `supabase/migrations/20260821_invoice_share_token_scope.sql`. Read the one
line that matters:

> "A row-level policy cannot express 'only the row whose token the caller
> presented', because RLS never sees the token."

Show the replacement: `invoice_share_by_token(p_token)` takes the token as an
argument and returns display columns only — no emails, no owner uids, no token.

### D4 — Show the test that keeps it fixed (~45 seconds)

Open `supabase/tests/security_invariants.sql`. Show invariant 1, then say:

> "I wrote that invariant to guard the invoice bug. The first time I ran it, it
> failed — and it pointed at `promo_codes`, where I had made exactly the same
> mistake. Anyone could list every live discount code. The test found a second
> instance of the bug I had just fixed."

That is the strongest single sentence in the whole demo. Do not skip it.

### D5 — The numbers (~30 seconds, on the results slide)

| | Before | After |
|---|---|---|
| Supabase security findings | 113 | 84 |
| Supabase performance **warnings** | 108 | **0** |
| Flutter analyzer issues | 97 | **0** |
| Foreign keys with no index | 50 | 0 |
| RLS policies re-evaluating `auth.uid()` per row | 92 | 0 |

Then the honest line about CI, which graders respect:

> "My CI had been green its whole life. It was running `flutter analyze
> --no-fatal-infos`, which printed 97 problems and exited zero. The gate could
> not fail. I fixed the 97 issues and made the gate real, so it can now fail."

## What not to click

- Admin grant-pro tools
- Stripe checkout (stub / not the Capstone story)
- Production customer records
- Do **not** run the enumeration against a table that is still exposed. Every
  finding in the audit is fixed; keep it that way on camera.

## Timing for the 15–20 minute recording

| Minutes | Content |
|---|---|
| 0:00–0:30 | Government ID to camera (name and photo readable) |
| 0:30–2:00 | What CLIVORA is + Capstone increment vs baseline |
| 2:00–6:30 | Path A — client hires, mutual accept unlocks contact |
| 6:30–11:30 | Path B — deliver and bill, invoice share link, Ask AI refusing auto-pay |
| 11:30–13:30 | Path C — Android one-account proof |
| 13:30–17:30 | **Path D — the security audit** (D1–D5) |
| 17:30–20:00 | Architecture (offline outbox, RLS, CI), board and docs links, close |

If you run long, cut from Path A and Path B, not Path D. The product loop shows
you can build. Path D shows you can engineer.
