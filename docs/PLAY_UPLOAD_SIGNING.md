# Play Store upload signing

Google Play expects your AAB signed with the **upload key** certificate:

```
SHA1: 96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36
```

Recent CI/agent builds used the **debug keystore** (`07:FF:0F:A4:...`) because `android/key.properties` and `android/clivora-upload-keystore.jks` are not in the repo.

## Fix (one time)

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

You should see `96:93:81:80:...`, not `07:FF:0F:A4:...`.

## If you lost the upload keystore

Request an upload key reset in Google Play Console → App integrity → Upload key.
