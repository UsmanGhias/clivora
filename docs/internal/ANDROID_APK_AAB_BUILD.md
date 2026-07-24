# Build APK + AAB (for cloud agent / CI — do not invent signing)

Repo: `UsmanGhias/clivora` on branch `main`  
Package: `org.codcrafters.clivora`  
Version on this push: **4.2.5+106**

## Prerequisites (secrets)

Play upload keystore must be available to the builder (same as existing releases):

- `KEYSTORE_BASE64` or file at path used by `scripts/prepare-android-signing.sh`
- `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD` (names as in that script / GitHub secrets)

Expected upload cert SHA-1 (script enforces):

`96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36`

## Commands

```bash
git clone https://github.com/UsmanGhias/clivora.git
cd clivora
git checkout main
git pull

# Install Flutter stable matching project SDK, Android SDK, accept licenses
# Then:
bash build-android.sh
```

Outputs:

- `releases/clivora-4.2.5.apk`
- `releases/clivora-4.2.5.aab`
- `releases/SHA256SUMS.txt`

## Do not

- Do not use `SKIP_SIGNING_CHECK=1` for Play uploads
- Do not force unsigned release builds
- Do not change `applicationId` / package name

## Web mirror

Website ships separately to `UsmanGhias/clivora-web` (Vercel). Mobile does not embed the Next.js app.

## Feature flags

New SMEMaster-parity surfaces (CRM enrichment, workspace tasks, calendar cloud events, conflicts, campaigns, automation builder, AI suggestions, admin ops) stay **OFF** in `app_feature_flags` until Gates 1–12. UI shows gated empty states when off; enable in Supabase admin after QA.
