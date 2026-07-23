# Play Store upload signing

Google Play expects your AAB signed with the **upload key** certificate:

```
SHA1:   96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36
SHA256: E7:96:CB:F9:5A:E9:61:26:13:A6:F3:A9:5C:B4:28:4A:2F:2C:FE:39:8F:2D:30:DF:BF:7B:88:88:4F:4F:05:F6
Subject: CN=CLIVORA, OU=Engineering, O=CLIVORA, L=Karachi, ST=Sindh, C=PK
Alias: clivora
```

Public cert (safe to commit): `android/upload-cert.pem`.

Recent CI/agent builds without secrets fall back to a **preview** keystore (`7F:6B:CA:0D:...`) which must **never** be uploaded to Play.

## Fix (one time)

### Option A — Cursor Cloud / GitHub secrets (fastest for agent rebuilds)

On the machine that has `clivora-upload-keystore.jks`:

```bash
base64 -w0 android/clivora-upload-keystore.jks
```

Add secrets:

- `ANDROID_KEYSTORE_BASE64` = output from above
- `ANDROID_KEYSTORE_PASSWORD` = store + key password
- `ANDROID_KEY_ALIAS` = `clivora` (optional)

Then: `BUILD_AAB=1 ./build-android.sh`

### Option B — Import password-encrypted export (from Android Studio / paste)

If you have the encrypted private-key export (alias `clivora` + X.509 cert) under
`android/.signing/clivora-upload.export` (gitignored):

```bash
CLIVORA_UPLOAD_KEY_PASSWORD='YOUR_PASSWORD' ./scripts/import-play-upload-export.sh
BUILD_AAB=1 ./build-android.sh
```

The import script decrypts the JKS KeyProtector blob, writes
`android/clivora-upload-keystore.jks` + `android/key.properties`, and refuses to
continue unless SHA1 matches `96:93:81:80:...`.

### Option C — Copy files locally (never commit)

1. Copy upload keystore to `android/clivora-upload-keystore.jks`
2. Create `android/key.properties`:

```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=clivora
storeFile=clivora-upload-keystore.jks
```

3. `BUILD_AAB=1 ./build-android.sh`

Verify before Play upload:

```bash
keytool -printcert -jarfile releases/clivora-*.aab | grep SHA1
```

You should see `96:93:81:80:...`, not `07:FF:0F:A4:...` or preview `7F:6B:CA:0D:...`.

## Sideload / preview builds (Google Sign-In)

Preview keystore SHA-1 (`7F:6B:CA:0D:63:D2:3C:AD:48:26:D5:C8:83:24:3B:2C:91:0D:A2:05`) is **not** a Play upload key.

For Google Sign-In on sideloaded preview APKs:
1. Prefer the Play Store build (upload SHA already in Firebase), or
2. Add the preview SHA-1 in Firebase Console → Project settings → Android app, **and**
3. Ensure Supabase Auth redirect URLs include `org.codcrafters.clivora://login-callback` (browser OAuth fallback in app ≥ 4.1.7).

Never upload a preview-signed AAB to Play Console.
