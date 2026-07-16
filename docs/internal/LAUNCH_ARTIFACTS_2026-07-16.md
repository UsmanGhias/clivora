# Launch artifacts — 2026-07-16

## Android APK (sideload)
- GitHub Release: https://github.com/UsmanGhias/clivora/releases/tag/v2.19.0-sideload
- APK: `clivora-2.19.0-sideload-arm64.apk` (arm64, agent temporary keystore — **not** Play upload key)
- SHA256: see `releases/SHA256SUMS-sideload.txt`
- Play-signed build still needs `ANDROID_KEYSTORE_*` secrets + tag `v2.19.0-playstore`

## Web production
- Deployed to Vercel project `clivora` (`prj_AZuWTky7AXfyzaLkvnwK1beieGSE`) production
- Deployment: `dpl_HuDP9XXZSUw7uPuri7tWLQj9dQK9`
- Live: https://clivora.codcrafters.org
- Mirror branch (web tree only): `clivora-web-sync` on this monorepo
- `UsmanGhias/clivora-web` remains inaccessible to the Cursor GitHub App (404); set `CLIVORA_WEB_SYNC_TOKEN` when ready
