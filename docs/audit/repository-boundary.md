# Repository boundary & deployment source of truth

## Repos

- `UsmanGhias/clivora` (monorepo): Flutter Android app + `web/` subtree + `supabase/migrations` + docs.
- `UsmanGhias/clivora-web`: standalone Next.js app deployed by Vercel (project `clivora`).

## Declared canonical source

- **Deployment canonical:** `UsmanGhias/clivora-web/main` (Vercel builds this).
- **Authoring canonical:** `clivora/web` in the monorepo — mirror with `web/push-to-clivora-web.sh`
  (or equivalent rsync that excludes `.git`, `node_modules`, `.next`).

## Rules

1. Do not hand-edit `clivora-web` for feature work; author in the monorepo and sync.
2. Keep trees identical except `.git` / install artifacts.
3. TODO: CI drift check between copies.
4. Live site: `https://clivora.codcrafters.org`

## Current RC

See `docs/releases/release-manifest.md` (`4.2.7+108`).
See also `docs/releases/CLOUD_BUILD.md` and `docs/audit/web-android-integrity.md`.
