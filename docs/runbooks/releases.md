# Releases

## Web (production)

1. Develop on a `cursor/*` feature branch in `UsmanGhias/clivora`.
2. Commit as `Usman Ghias <usmanghias1@gmail.com>` only.
3. Mirror `web/` to `UsmanGhias/clivora-web` `main` for Vercel auto-deploy.
4. Confirm Vercel deployment state is **READY** (not BLOCKED/ERROR).
5. Prefer few, meaningful deploys — stay within Vercel free/Hobby limits.

## Android

Use existing release scripts / Play Store checklist; bump version only with owner approval. Do not publish to Play Store without explicit authorization.

## Rollback

- Web: redeploy previous `clivora-web` commit / Vercel rollback.  
- DB: never edit applied migrations; add forward-fix or new migration.  
- Android: staged rollout halt / previous AAB if published.
