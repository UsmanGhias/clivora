/// CodCrafters admin emails - in-app admin + auto Pro. Never shown to other users.
const kAdminEmails = {
  'iusmanghias@gmail.com',
  'usmanghias1@gmail.com',
  'usmanghias@clivora.io',
  'usmanghias@codcrafters.org',
  'contact@clivora.io',
  'admin@codcrafters.org',
};

/// Official support / contact email used across app and website.
const kOfficialEmail = 'contact@clivora.io';

/// Only these accounts can grant admin access to others.
const kSuperAdminEmail = 'iusmanghias@gmail.com';

/// CLIVORA web (Hostinger production) - https://clivora.io
const kClivoraWebBaseUrl = 'https://clivora.io';

/// Supabase password-reset emails must redirect here (not localhost).
/// Also add this URL under Supabase Auth → URL Configuration → Redirect URLs.
const kPasswordResetRedirectUrl = '$kClivoraWebBaseUrl/auth/reset-password';

/// Web admin dashboard.
const kAdminPanelUrl = '$kClivoraWebBaseUrl/admin';

/// Web Pro / Pro Plus checkout (Pakistan + worldwide).
const kProCheckoutUrl = '$kClivoraWebBaseUrl/pro';
