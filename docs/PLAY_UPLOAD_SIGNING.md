# Play Store upload signing

See also: [`docs/AGENT_HANDOFF_PRODUCTION.md`](./AGENT_HANDOFF_PRODUCTION.md).

Google Play expects your AAB signed with the **upload key** certificate:

```
SHA1:   96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36
SHA256: E7:96:CB:F9:5A:E9:61:26:13:A6:F3:A9:5C:B4:28:4A:2F:2C:FE:39:8F:2D:30:DF:BF:7B:88:88:4F:4F:05:F6
Subject: CN=CLIVORA, OU=Engineering, O=CLIVORA, L=Karachi, ST=Sindh, C=PK
Alias: clivora
```

Public cert in repo: `android/upload-cert.pem`.

## Fix (one time)

### Option A — Cursor Cloud / GitHub secrets (fastest for agents)

On the PC that has `clivora-upload-keystore.jks`:

```bash
base64 -w0 android/clivora-upload-keystore.jks
```

The output **must** start with `/u3+7Q` (JKS magic `FEEDFEED`). A truncated paste breaks signing.

Add secrets:

- `ANDROID_KEYSTORE_BASE64` = full base64 from above
- `ANDROID_KEYSTORE_PASSWORD` = store + key password (same value)
- `ANDROID_KEY_ALIAS` = `clivora` (optional)

Then: `BUILD_AAB=1 ./build-android.sh`

### Option B — Local files (never commit)

1. Place `android/clivora-upload-keystore.jks`
2. Create gitignored `android/key.properties`:

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

You must see `96:93:81:80:...`. Never upload preview SHA `7F:6B:CA:0D:...` or debug `07:FF:0F:A4:...`.

## Bad releases to ignore

Do not use for Play:

- `v2.20.0-playstore` (version regression)
- `v2.21.0-preview` (preview keystore — Google Sign-In breaks)
- `v4.1.7-sideload` (preview keystore)

Good baseline: `v3.9.6-playstore`. Production target: `v4.2.3-playstore`.
