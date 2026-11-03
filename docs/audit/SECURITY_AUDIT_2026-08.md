# CLIVORA security and performance audit — August 2026

Sprint 3 hardening pass over the Flutter app, the Next.js web app, and the
Supabase Postgres schema. Every finding below was reproduced before it was
fixed, and every fix was verified against the live project afterwards.

Auditor: Usman Ghias · Date: 2026-08-21 · Supabase project `jtzjwgovqczlccyeujhq`

---

## Headline

Three separate features shared one root cause, and it produced the worst finding
in the audit: **a policy cannot see a bearer token, so each feature had been
widened until anonymous callers could read the whole table.**

| # | Severity | Finding | Status |
|---|----------|---------|--------|
| 1 | **Critical** | Any anonymous caller could enumerate every shared invoice — client emails, amounts, and the share tokens themselves | Fixed |
| 2 | High | Any anonymous caller could enumerate every live promo code and its discount | Fixed |
| 3 | High | Unauthenticated callers could trigger the invoice-reminder email fan-out on demand | Fixed |
| 4 | Medium | 21 trigger-only functions were published as callable RPC endpoints | Fixed |
| 5 | Medium | Vault share `max_downloads` was a dead control — nothing ever counted downloads | Fixed |
| 6 | Medium | Promo `max_uses` was a dead control — the counter write always failed silently | Fixed |
| 7 | Medium | 3 `SECURITY DEFINER` functions had a role-mutable `search_path` | Fixed |
| 8 | Medium | CI reported 97 analyzer issues and passed anyway | Fixed |
| 9 | Low | CI ran the web suite on a Node version `package.json` declares unsupported | Fixed |
| 10 | Low | 12 `BuildContext`-across-async-gap crash risks in the Flutter app | Fixed |

Advisor totals, before → after:

| | Before | After |
|---|---|---|
| Security findings | 113 | 84 |
| Performance findings | 180 | 87 |
| Performance **warnings** | 108 | **0** |
| Flutter analyzer issues | 97 | **0** |

The 84 remaining security findings are all one informational class —
"`SECURITY DEFINER` function is executable by `anon`/`authenticated`" — which
Supabase raises for *every* RPC endpoint. That is inherent to an RPC
architecture. All 61 distinct functions were read individually and each one
authorises internally; see [Accepted findings](#accepted-findings).

---

## 1. Critical — every shared invoice was readable by anyone

**Where:** `public.invoice_shares`, policy `invoice_shares_public_token_read`,
consumed by `web/src/app/i/[token]/page.tsx`.

The guest invoice page read the table straight from the browser with the anon
key and filtered by token:

```ts
supabase.from("invoice_shares").select(...).eq("public_token", token)
```

The read was authorised by:

```sql
create policy invoice_shares_public_token_read on public.invoice_shares
  for select to public
  using (public_token is not null);
```

RLS runs *before* the `.eq()` filter, and the filter is just a query parameter
the caller controls. So the policy granted every anonymous caller read access to
every row that had a token, and dropping the filter dumped the table.

**Reproduced against production.** The anon key is public by design — it ships
inside the web bundle and the APK — so this needed no credentials:

```bash
curl "$URL/rest/v1/invoice_shares?select=invoice_number,total,client_email,public_token&public_token=not.is.null" \
     -H "apikey: $ANON_KEY"
```

This returned other users' invoice numbers, totals, currencies, `client_email`,
`freelancer_email`, and — worst — their `public_token` values, which *are* the
credentials for the guest links. One request both disclosed the invoice data and
handed over the keys to every guest link in the product.

**Fix** — `supabase/migrations/20260821_invoice_share_token_scope.sql`. A policy
cannot express "only the row whose token the caller presented", because RLS never
sees the token. So the token check moves into a `SECURITY DEFINER` function that
takes it as an argument, and the blanket policy is dropped:

```sql
drop policy invoice_shares_public_token_read on public.invoice_shares;

create function public.invoice_share_by_token(p_token text)
returns table (invoice_number text, total numeric, currency text,
               status text, due_date date, payment_method text)
language sql stable security definer set search_path = 'public'
as $$
  select s.invoice_number, s.total, s.currency, s.status, s.due_date, s.payment_method
  from public.invoice_shares s
  where s.public_token is not null and s.public_token = p_token
  limit 1;
$$;
```

The function returns display columns only, so the emails, the owner uids, and the
token stop being reachable at all.

**Verified after the fix:** the same `curl` returns `[]`; an unknown token
returns `[]` with no error, so the endpoint cannot be used as an oracle to probe
for live tokens; `pg_policies` shows zero anon-facing policies on the table; and
all existing guest links still resolve through the function.

---

## 2. High — every live promo code was readable by anyone

**Where:** `public.promo_codes`, policy `promo_codes_public_read`.

The same anti-pattern. The caller types a code, RLS cannot see it, so the policy
was widened to "any code that is currently live":

```sql
using (is_active = true and (expires_at is null or expires_at > now()))
```

Any holder of the anon key could therefore list every active discount code with
its `discount_type` and `discount_value` and use them.

**Fix** — `supabase/migrations/20260821_promo_code_scope.sql`. Dropped the
policy; added `promo_code_lookup(p_code)`, which is keyed on the presented code.
`web/src/lib/promo-codes.ts` now calls the function. Verified: enumeration
returns `[]`, and validating a real code still works.

---

## 3. High — anyone could trigger the invoice reminder fan-out

**Where:** `public.invoke_invoice_reminders()`.

Granted `EXECUTE` to `anon`. It reads a cron secret out of Vault and POSTs the
`send-invoice-reminders` Edge Function. Any unauthenticated caller could
therefore trigger the entire reminder run, repeatedly — unwanted mail to real
clients, plus the compute and mail spend behind it.

It is only ever called by `pg_cron`, which runs as `postgres`, so no client role
needs it. **Fix:** revoked from `public`, `anon`, `authenticated`. Verified: the
RPC now returns `401` for an anon caller.

---

## 4. Medium — trigger functions published as RPC endpoints

21 functions returning `trigger` or `event_trigger` had `EXECUTE` granted to
`PUBLIC`, `anon`, or `authenticated`, which also publishes them as PostgREST RPC
endpoints. A trigger function invoked outside a trigger context cannot do much,
but several are `SECURITY DEFINER` and exist specifically to *enforce* limits —
`crm_enforce_free_invoice_cap`, `profiles_guard_privileged_columns`,
`rls_auto_enable` — so leaving them reachable was needless attack surface.

**Fix:** revoked across the board, driven off `pg_proc` so it covers all of them
rather than a hand-written list. Verified: `crm_enforce_free_invoice_cap` now
returns `404` for an anon caller — gone from the schema cache entirely.

---

## 5 & 6. Medium — two dead controls that could never trip

Both a limit the product advertises but never enforced.

**Vault share links.** `vault_share_links.max_downloads` was only checked in the
Next.js page, and `download_count` **was never incremented anywhere in the
codebase**, so the cap could not fire however many times a link was used.
Separately, the lookup returned `storage_path` even for an expired link.

Fixed by splitting the read path from the redeem path:

- `vault_lookup_share_by_token` — metadata only, never the storage path, and
  returns zero rows for a dead link so it cannot confirm a token exists.
- `vault_redeem_share_token` — one `UPDATE ... RETURNING` that re-checks the cap
  in the `WHERE` clause under the row lock, so two simultaneous clicks on the
  last remaining download cannot both succeed.

The counted download moved to `GET /api/vault/share/[token]/download`, so the
quota is spent on an explicit click rather than on a page render or a prefetch.

**Promo codes.** `promo_codes.max_uses` had the same defect for a different
reason: the checkout page did a read-then-write of `used_count` *from the
browser*, against a table with no client `UPDATE` policy. The write always
failed and the failure was swallowed by an empty `catch`. Every code in the table
showed `used_count = 0` while having a cap set. Even with a policy it would have
been wrong — read-then-write is not atomic, and a browser can decline to send it.

Fixed with `promo_code_redeem`, an atomic capped increment called from
`POST /api/promo/redeem` on the server.

---

## 7. Medium — mutable `search_path` on `SECURITY DEFINER` functions

`crm_reject_stale_update`, `crm_invoice_payment_status`, and
`invoice_shares_sync_total_minor` did not pin `search_path`. Without it the
caller's `search_path` decides how an unqualified name resolves, so a
user-created object can shadow a real one inside a function running with the
owner's privileges. **Fix:** `set search_path = 'public'` on all three. The
schema now has zero such functions, asserted by invariant 4.

---

## 8, 9, 10. CI and client-side defects

**CI enforced nothing.** Both workflows ran:

```yaml
- run: flutter analyze lib/ --no-fatal-infos
```

which reported 97 issues and exited 0. The gate had been green for its entire
life without ever being able to fail. Now `flutter analyze` runs over the whole
package with infos fatal, against an analyzer at zero.

**CI tested an unsupported runtime.** `web/package.json` declares
`"node": ">=20 <23"`; CI ran `node-version: '24.x'`. Pinned to `22.x`.

**12 crash risks in the Flutter app.** `use_build_context_synchronously` — a
`BuildContext` used after an `await` with no guard, or guarded on the wrong
object. Each was fixed at the source: `mounted` where the code uses
`State.context`, `context.mounted` where a builder introduced a different
`BuildContext`. None were silenced with `// ignore:`.

---

## Performance

**92 of 106 RLS policies re-evaluated `auth.uid()` for every candidate row.**
Wrapping each call in a scalar subquery lets the planner hoist it into an
`InitPlan` that runs once per statement instead of once per row.

The same treatment was applied to the six `STABLE SECURITY DEFINER` helpers used
inside policies — `is_admin`, `is_super_admin`, `is_pro_plus`, `my_email`,
`crm_plan_is_paid`, `is_allowlisted_admin` — which the advisor does not flag.
These matter more than `auth.uid()`: each one does a `profiles` lookup, so an
unhoisted `is_admin()` was an extra index probe per row scanned. All six are
`provolatile = 's'`, so hoisting them is semantically identical, not merely
cheaper. 63 policies benefited.

**50 foreign keys had no covering index.** Each one forced a sequential scan of
the child table on any parent-side delete or update, and most are also the column
the app filters on (`owner_uid`, `customer_id`, `project_id`).

**One duplicate index** on `automation_webhook_queue.idempotency_key`, dropped.

Migration: `supabase/migrations/20260821_rls_performance.sql`. The policy
rewrite is driven off `pg_policies` rather than a hand-written list, because the
live schema has known drift from the migration history
(`docs/audit/schema-drift.md`), and it is idempotent — it unwraps before it
wraps, so re-running is a no-op.

Result: all 108 performance **warnings** cleared. `unused_index` rose from 22 to
72, which is expected and not a regression: the 50 new indexes have not been
scanned yet on a low-traffic database. They exist to serve foreign-key integrity
checks and the app's own filters.

---

## Regression tests

`supabase/tests/security_invariants.sql` asserts seven properties, one per class
of defect found. Each raises an exception naming the offending objects, so a
regression fails loudly instead of quietly re-opening a hole.

```
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/tests/security_invariants.sql
```

1. No table is anon-readable through a policy that does not constrain rows to the caller
2. No trigger function is reachable as RPC
3. The reminder cron entry point is not client-callable
4. Every `SECURITY DEFINER` function pins `search_path`
5. RLS is enabled on every table in `public`
6. Vault share expiry and download quota are enforced in SQL
7. The promo code usage cap is enforced in SQL

All seven pass against production as of 2026-08-21.

Invariant 1 earned its place immediately: written to guard the invoice finding,
it flagged `promo_codes` on its first run — a second instance of the same bug
that had not been on the list.

---

## Accepted findings

**`app_feature_flags` is anon-readable, deliberately.** Both clients must read
flags before anyone signs in. The table holds a flag name, a boolean, an
`updated_at`, and an `updated_by` uuid. The only thing it discloses is which
features exist. Invariant 1 carries a named exception for this table so the
decision is recorded in the test rather than implied by its absence.

**`_internal_secrets` and `admin_integration_secrets` have RLS enabled with no
policies.** The advisor reports this as `rls_enabled_no_policy`; it is the
intended state. No policies means deny-all to every client role, and the tables
are reached only through `SECURITY DEFINER` accessors that check for an
unblocked admin profile first. Both now carry a `COMMENT` saying so, so the next
reader does not "fix" it.

**84 `SECURITY DEFINER` functions are executable by `anon`/`authenticated`.**
Unavoidable for an RPC architecture — Supabase raises this for every exposed
function. All 61 distinct functions were read individually. Every privileged one
authorises internally before doing anything:

- `grant_admin_by_email`, `grant_pro_by_email` — both gate on `is_super_admin()`
- `admin_get_integration_secret`, `admin_upsert_integration_secret` — both
  require an admin profile that is neither blocked nor restricted
- `connect_peer_contact` — returns a peer's email only when an `accepted` row
  exists in `connect_requests` in either direction. This is the mutual-accept
  privacy guarantee the product makes, and it holds at the database level.

**Leaked-password protection is off.** `auth_leaked_password_protection` — enable
the HaveIBeenPwned check under Authentication → Policies in the Supabase
dashboard. One toggle, no code change; it is not reachable through the API.

---

## Files changed

**Migrations**

- `supabase/migrations/20260821_security_hardening.sql`
- `supabase/migrations/20260821_rls_performance.sql`
- `supabase/migrations/20260821_invoice_share_token_scope.sql`
- `supabase/migrations/20260821_promo_code_scope.sql`

**Tests**

- `supabase/tests/security_invariants.sql`

**Web**

- `web/src/app/i/[token]/page.tsx` — guest invoice read goes through the RPC
- `web/src/app/vault/s/[token]/page.tsx` — read-only, no storage path
- `web/src/app/api/vault/share/[token]/download/route.ts` — new, counted download
- `web/src/lib/promo-codes.ts` — RPC lookup, plus `redeemPromoCode`
- `web/src/app/api/promo/redeem/route.ts` — new, atomic redeem
- `web/src/app/pro/pro-checkout.tsx` — browser counter write replaced

**CI**

- `.github/workflows/ci.yml` — analyzer gate made real, Node pinned to 22.x
- `.github/workflows/release-android.yml` — analyzer gate made real

**Flutter** — 49 files, all analyzer findings, no behaviour changes beyond the 12
async-gap guards.
