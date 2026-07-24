# CLIVORA agent handoff (production)

Last verified: 2026-07-24 — Cloud agent run for **4.2.1** restore from **v3.9.6-playstore**.

## Source of truth

| Item | Value |
|------|--------|
| Good Play baseline | Git tag `v3.9.6-playstore` → `3.9.6+96` |
| Target production | `4.2.3+104` |
| Live web | https://clivora.codcrafters.org (mirror `UsmanGhias/clivora-web`) |
| Android package | `org.codcrafters.clivora` |
| Firebase project | `clivora533` |
| Supabase project | `jtzjwgovqczlccyeujhq` |

## Do NOT ship / ignore these releases

These were preview/wrong-signing or version-regression builds. Prefer `v3.9.6-playstore` or **`v4.2.3-playstore`** once published:

- `v2.20.0-playstore` (version regression)
- `v2.21.0-preview` (preview keystore — breaks Google Sign-In)
- `v4.1.7-sideload` (preview keystore — browser OAuth workaround)

Owner should unlist/delete those GitHub release assets when convenient.

## Play upload signing (required for Google Sign-In)

Expected upload certificate:

```
SHA1:   96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36
SHA256: E7:96:CB:F9:5A:E9:61:26:13:A6:F3:A9:5C:B4:28:4A:2F:2C:FE:39:8F:2D:30:DF:BF:7B:88:88:4F:4F:05:F6
Alias:  clivora
Subject: CN=CLIVORA, OU=Engineering, O=CLIVORA, L=Karachi, ST=Sindh, C=PK
```

Public cert in repo: `android/upload-cert.pem`.

### Cursor / GitHub secrets (never commit)

On the machine with the keystore:

```bash
base64 -w0 android/clivora-upload-keystore.jks
```

Set secrets:

- `ANDROID_KEYSTORE_BASE64` — full base64 of `clivora-upload-keystore.jks` (must start with `/u3+7Q` = JKS `FEEDFEED`)
- `ANDROID_KEYSTORE_PASSWORD` — same as `storePassword` / `keyPassword` in local `key.properties`
- `ANDROID_KEY_ALIAS` — `clivora` (optional)

Local gitignored files (owner PC / cloud agent only):

```properties
# android/key.properties
storePassword=<SECRET>
keyPassword=<SECRET>
keyAlias=clivora
storeFile=clivora-upload-keystore.jks
```

Build:

```bash
bash scripts/prepare-android-signing.sh   # if using secrets
BUILD_AAB=1 ./build-android.sh            # fails closed unless SHA1 matches Play upload
```

Import path if you only have the encrypted export under `android/.signing/`:

```bash
CLIVORA_UPLOAD_KEY_PASSWORD='<SECRET>' ./scripts/import-play-upload-export.sh
```

## What 4.2.1 restores vs adopts

**Restored from `v3.9.6-playstore` (do not regress):**

- Freelancer home / dashboard UI (`lib/features/dashboard/dashboard_screen.dart`)
- Native Google Sign-In only (`lib/core/auth/auth_service.dart`) — no browser OAuth detour
- Priority strips as in 3.9.6

**Adopted from later good work (keep):**

- Connect bottom-nav icon: **travel_explore** (3.9.6 connected logo) for both client and freelancer Pro Plus
- Hub bottom-nav icon: **Icons.hub** (network hub) for freelancer tabs
- Command Center / Hub screen: restored from `v3.9.6-playstore` (`more_screen.dart`, `tool_grid_tile.dart`), with Work & collaboration shown first
- Web/admin/Odoo and other mainline product fixes already on `main` (not the preview APK line)
- Play signing fail-closed scripts + upload cert docs

**Rejected:**

- Preview keystore (`7F:6B:CA:0D:...`)
- Sideload “Google OAuth browser fallback” as primary login UX
- Version numbers below `3.9.6+96` for Play uploads

## Google Sign-In checklist

1. App signed with upload SHA `96:93:81:80:...` (already in Firebase for Play builds)
2. Supabase Auth redirect URLs may still include `org.codcrafters.clivora://login-callback` (deep link kept; native Google is primary)
3. Web client ID: `976757530869-ap3ea6t2noq56o46tfokgdp6haj6ioqj.apps.googleusercontent.com`

## Web deploy

After merging to `main`:

```bash
bash web/push-to-clivora-web.sh
```

## Secrets never to commit

- Odoo API keys / SafePay keys
- `android/clivora-upload-keystore.jks`
- `android/key.properties`
- Raw `ANDROID_KEYSTORE_BASE64` / passwords in markdown

Use Supabase `admin_integration_secrets` and Cursor/GitHub Actions secrets instead.
