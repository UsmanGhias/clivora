# Play Store upload signing

Google Play expects your AAB signed with the **upload key** certificate:

```
SHA1: 96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36
```

Recent CI/agent builds used the **debug keystore** (`07:FF:0F:A4:...`) because `android/key.properties` and `android/clivora-upload-keystore.jks` are not in the repo.

## Fix (one time)

### Option A — Cursor Cloud secrets (fastest for agent rebuilds)

1. On your PC (where `clivora-upload-keystore.jks` lives), run:

```bash
base64 -w0 android/clivora-upload-keystore.jks
```

2. In **Cursor → Cloud Agent → Secrets**, add:
- `ANDROID_KEYSTORE_BASE64` = output from step 1
- `ANDROID_KEYSTORE_PASSWORD` = your keystore password
- `ANDROID_KEY_ALIAS` = `clivora` (optional)

3. Re-run the agent build: `BUILD_AAB=1 ./build-android.sh`

### Option B — Copy files into repo (local only, never commit)

1. Copy your upload keystore to `android/clivora-upload-keystore.jks` (the file used for Play Console v2.6.1).
2. Create `android/key.properties`:

```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=clivora
storeFile=clivora-upload-keystore.jks
```

3. Build:

```bash
BUILD_AAB=1 ./build-android.sh
```

4. Upload `releases/clivora-2.6.7.aab` to Play Console.

Verify signing before upload:

```bash
keytool -printcert -jarfile releases/clivora-2.6.7.aab | grep SHA1
```

You should see `96:93:81:80:...`, not `07:FF:0F:A4:...` or the preview key `7F:6B:CA:0D:...`.

## Sideload / preview builds (Google Sign-In)

Preview keystore SHA-1 (`7F:6B:CA:0D:63:D2:3C:AD:48:26:D5:C8:83:24:3B:2C:91:0D:A2:05`) is **not** a Play upload key.

For Google Sign-In on sideloaded preview APKs:
1. Prefer the Play Store build (upload SHA already in Firebase), or
2. Add the preview SHA-1 in Firebase Console → Project settings → Android app, **and**
3. Ensure Supabase Auth redirect URLs include `org.codcrafters.clivora://login-callback` (browser OAuth fallback in app ≥ 4.1.7).

Never upload a preview-signed AAB to Play Console.
