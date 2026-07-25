# Android AAB/APK handoff (for build agent)

**Repo:** `UsmanGhias/clivora` (`main`)  
**Package:** `org.codcrafters.clivora`  
**Current version in `pubspec.yaml`:** `5.3.10+540`  
Play already has **5.3.9 (539)**. Build and upload **5.3.10 (540)** for SMTP/email + domain polish.

## Already done in code (do not re-change)

- Web base URL: `https://clivora.io` (`lib/core/constants/admin_config.dart` → `kClivoraWebBaseUrl`)
- Official email: `contact@clivora.io` (`kOfficialEmail`)
- Supabase URL + anon key: `lib/core/constants/supabase_config.dart`
- Play product IDs: `lib/core/constants/billing_products.dart`

## Build commands

```bash
cd /path/to/Clivora
flutter pub get
flutter build appbundle --release
# optional APK:
flutter build apk --release
```

Outputs:

- AAB: `build/app/outputs/bundle/release/app-release.aab`
- APK: `build/app/outputs/flutter-apk/app-release.apk`

## Signing

Use the existing Play upload keystore / Play App Signing (same as previous production uploads).  
SHA-1 on record: `96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36`

## Play Console after upload

1. Create subscriptions if missing (exact IDs):
   - `clivora_pro_freelancer_monthly`
   - `clivora_pro_client_monthly`
   - `clivora_pro_plus_freelancer_monthly`
   - `clivora_pro_plus_client_monthly`
2. Store listing contact: `contact@clivora.io`
3. Privacy / website: `https://clivora.io/privacy` · `https://clivora.io`

## Do not change for this cutover

- Application ID / package name
- Keystore
- Supabase project ref `jtzjwgovqczlccyeujhq`
- Billing product ID strings (unless Play products were created with different IDs)

## If bumping version

Edit `pubspec.yaml`:

```yaml
version: X.Y.Z+BUILD
```

Example next: `5.3.10+540` only if new commits after 5.3.9.
