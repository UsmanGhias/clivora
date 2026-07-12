/// CodCrafters admin emails - in-app admin + auto Pro. Never shown to other users.
const kAdminEmails = {
  'admin@codcrafters.org',
  'usmanghias1@gmail.com',
  'iusmanghias@gmail.com',
};

/// Official support / contact email used across app and website.
const kOfficialEmail = 'iusmanghias@gmail.com';

/// Only these accounts can grant admin access to others.
const kSuperAdminEmail = 'iusmanghias@gmail.com';

/// CLIVORA web (clivora-web on Vercel) - https://clivora.codcrafters.org
const kClivoraWebBaseUrl = 'https://clivora.codcrafters.org';

/// Supabase password-reset emails must redirect here (not localhost).
/// Also add this URL under Supabase Auth → URL Configuration → Redirect URLs.
const kPasswordResetRedirectUrl = '$kClivoraWebBaseUrl/auth/reset-password';

/// Web admin dashboard.
const kAdminPanelUrl = '$kClivoraWebBaseUrl/admin';

/// Web Pro / Pro Plus checkout (Pakistan + worldwide).
const kProCheckoutUrl = '$kClivoraWebBaseUrl/pro';
