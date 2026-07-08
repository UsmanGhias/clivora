/// Copy to `admin_config.dart` for local dev, or pass secrets via `--dart-define`.
///
/// Example build:
/// `flutter build apk --dart-define=ADMIN_SYNC_KEY=your-secret-here`
library;

const kAdminEmails = {'admin@example.com'};
const kSuperAdminEmail = 'admin@example.com';
const kClivoraWebBaseUrl = 'https://clivora.example.com';
const kAdminApiBaseUrl = kClivoraWebBaseUrl;
const kAdminSyncKey = String.fromEnvironment('ADMIN_SYNC_KEY', defaultValue: '');
const kAdminPanelUrl = '$kClivoraWebBaseUrl/admin';
