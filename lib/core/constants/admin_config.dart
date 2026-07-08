/// CodCrafters admin emails — in-app admin + auto Pro. Never shown to other users.
const kAdminEmails = {
  'admin@codcrafters.org',
  'usmanghias1@gmail.com',
};

/// Only this account can grant admin access to others.
const kSuperAdminEmail = 'usmanghias1@gmail.com';

/// CLIVORA web (clivora-web on Vercel) — https://clivora.codcrafters.org
const kClivoraWebBaseUrl = 'https://clivora.codcrafters.org';

/// Supabase password-reset emails must redirect here (not localhost).
/// Also add this URL under Supabase Auth → URL Configuration → Redirect URLs.
const kPasswordResetRedirectUrl = '$kClivoraWebBaseUrl/auth/reset-password';

/// App → web admin sync API (`/api/admin/sync`).
const kAdminApiBaseUrl = kClivoraWebBaseUrl;

/// Injected at build time: `--dart-define=ADMIN_SYNC_KEY=your-secret`
/// Must match `ADMIN_SYNC_KEY` on Vercel (clivora-web project).
const kAdminSyncKey = String.fromEnvironment('ADMIN_SYNC_KEY', defaultValue: '');

/// Web admin dashboard.
const kAdminPanelUrl = '$kClivoraWebBaseUrl/admin';
