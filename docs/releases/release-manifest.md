# Release manifest (REL-001)

**Status:** Release candidate — **NOT** certified production-ready (remaining gates open).  
**Prepared:** 2026-07-25

## Artifact identity

| Item | Value |
|------|-------|
| Android versionName | `4.2.9` |
| Android versionCode | `110` |
| Monorepo branch | `main` |
| Expected Play signing SHA-1 | `96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36` |
| Package | `org.codcrafters.clivora` |
| Web deploy source | `UsmanGhias/clivora-web` (canonical Vercel) |
| Authoring web tree | `UsmanGhias/clivora/web` → sync via `web/push-to-clivora-web.sh` |
| Live site | `https://clivora.codcrafters.org` |
| Supabase project | `jtzjwgovqczlccyeujhq` |

Commit SHAs are filled at push time (`git rev-parse HEAD` in each repo).

## Feature flags at this RC

See `docs/audit/flag-truth.md`. SMEMaster domains are **ON** (owner restore).

## Migrations included

Real SQL (not stubs) under `supabase/migrations/`:

- `20260724_phase0_foundations.sql`
- `20260724_phase1_crm_enrichment.sql`
- `20260724_phases_2_9_program.sql`
- `20260724_automation_queue_rls.sql`
- `20260725_protect_profiles_privileged.sql`
- `20260725_vault_share_public_lookup.sql`
- `20260725_invoice_shares_total_minor_dual_write.sql`
- `20260725_smemaster_full_schema.sql` (reference export)

## Rollback

1. **Web:** Redeploy previous Vercel deployment for `clivora-web`.
2. **Android:** Keep previous Play artifact (`4.2.5+106` / earlier) available; do not promote `+107` if smoke fails.
3. **Flags:** Leave unverified domains OFF; do not re-enable without evidence.
4. **DB:** Prefer forward repair; do not drop tables. Privileged-column trigger and vault RPC must stay.

## Build (cloud / CI machine with signing secrets)

```bash
git clone https://github.com/UsmanGhias/clivora.git
cd clivora
git checkout main
git pull
# Ensure android signing env / keystore via scripts/prepare-android-signing.sh
bash build-android.sh
# Outputs: releases/clivora-4.2.6.apk and releases/clivora-4.2.6.aab
# Verify APK SHA-1 matches Expected Play signing SHA-1 above.
```

## Honest claim language

```text
PASS / FAIL / BLOCKED / DISABLED / NOT TESTED only.
This RC ships blocker remediations; full master-plan certification is still open.
```
