/// CodCrafters admin emails — in-app admin + auto Pro. Never shown to other users.
const kAdminEmails = {
  'admin@codcrafters.org',
  'usmanghias1@gmail.com',
};

/// Only this account can grant admin access to others.
const kSuperAdminEmail = 'usmanghias1@gmail.com';

/// CLIVORA web (clivora-web on Vercel) — https://clivora.codcrafters.org
const kClivoraWebBaseUrl = 'https://clivora.codcrafters.org';

/// App → web admin sync API (`/api/admin/sync`).
const kAdminApiBaseUrl = kClivoraWebBaseUrl;

/// Must match `ADMIN_SYNC_KEY` on Vercel (clivora-web project).
const kAdminSyncKey = 'ClivoraSync2026!';

/// Web admin dashboard.
const kAdminPanelUrl = '$kClivoraWebBaseUrl/admin';
