# Rollback runbook

## Web (Vercel / clivora-web)

1. Open Vercel project linked to `UsmanGhias/clivora-web`.
2. Deployments → previous known-good → Promote to Production.
3. Smoke: `https://clivora.io/` + `/login` + one protected `/app` redirect.

## Android (Play)

1. Do not promote a new AAB if SHA-1 ≠ `96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36`.
2. Keep prior Play track artifact (`4.2.5+106` or earlier) as rollback.
3. Halt staged rollout if crash/ANR spike or auth/sync P0 appears.

## Feature flags

```sql
-- Example: keep campaigns disabled
update public.app_feature_flags
set enabled = false, updated_at = now()
where key in ('campaigns', 'phase6_campaigns');
```

## Database

- Prefer forward-fix migrations.
- Do not drop `profiles_protect_privileged_columns_trg` or vault lookup RPC.
- Backups before any destructive schema work.

## Contacts

Record incident time, commit, QA identity, and cleanup in the incident runbook.
