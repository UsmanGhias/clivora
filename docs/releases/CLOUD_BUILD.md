# Cloud build instructions (APK / AAB)

Use these on any CI/cloud machine that has Flutter, Android SDK, and the Play upload keystore. Do **not** skip signing checks for Play uploads.

## 1. Clone

```bash
git clone git@github.com:UsmanGhias/clivora.git
cd clivora
git checkout main
git pull
```

Confirm version:

```bash
grep '^version:' pubspec.yaml
# expect: 4.2.10+111 (or newer on main)
```

## 2. Tooling

- Flutter stable (same channel as CI / prior Play builds)
- Android SDK with build-tools + `apksigner`
- JDK 17
- Signing material for `scripts/prepare-android-signing.sh` (keystore + passwords via env/secrets — never commit)

Optional:

```bash
export FLUTTER_HOME="$HOME/flutter"
export ANDROID_HOME="$HOME/android-sdk"
export PATH="$FLUTTER_HOME/bin:$PATH"
```

## 3. Build signed APK + AAB

```bash
flutter pub get
bash build-android.sh
```

Outputs:

- `releases/clivora-4.2.10.apk`
- `releases/clivora-4.2.10.aab`
- `releases/SHA256SUMS.txt`

## 4. Verify certificate

Expected Play upload SHA-1:

```text
96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36
```

`build-android.sh` verifies this; refuse upload if it mismatches.

## 5. Web (optional same machine)

Canonical deploy repo is `UsmanGhias/clivora-web` (Vercel). After monorepo web changes:

```bash
# from clivora monorepo (requires GitHub SSH/auth to clivora-web)
CLIVORA_WEB_REMOTE=git@github.com:UsmanGhias/clivora-web.git bash web/push-to-clivora-web.sh
```

Or let Vercel rebuild from the pushed `clivora-web` main.

## 6. Smoke after install

1. Client: sign in on phone → update profile photo → sign in on web → same avatar.
2. Freelancer: create customer/project on phone → appear on web `/app/clients` / projects after sync.
3. Connect (Pro Plus): save listing as draft, then list — no PROFILE_INCOMPLETE on first publish; listing auto-approved when admin auto-approve is ON.
4. Confirm no Hub “sync pending” orange strip; Sync Center tile still available; shell only shows conflicts/failures.

## Status language

PASS / FAIL / BLOCKED / DISABLED / NOT TESTED only. Never claim zero bugs without evidence.
