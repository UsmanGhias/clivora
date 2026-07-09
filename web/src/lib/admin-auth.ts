export const OFFICIAL_EMAIL = "iusmanghias@gmail.com";

export const ADMIN_EMAILS = [
  "admin@codcrafters.org",
  "usmanghias1@gmail.com",
  "iusmanghias@gmail.com",
];

export const PANEL_PASSWORD = process.env.ADMIN_PANEL_PASSWORD ?? "REDACTED_PASSWORD";
export const SYNC_KEY = process.env.ADMIN_SYNC_KEY ?? "ClivoraSync2026!";

export const CLIVORA_PURPLE = "#6C3CE1";
export const CLIVORA_NAVY = "#0F172A";
export const PRO_PRICE_PKR = 2000;
export const PRO_PLUS_PRICE_PKR = 5000;

export const ADMIN_SESSION_FLAG = "clivora_admin";
export const ADMIN_SESSION_EMAIL = "clivora_admin_email";
export const ADMIN_SESSION_PASS = "clivora_admin_pass";

export function isAdminEmail(email: string | null | undefined): boolean {
  if (!email) return false;
  return ADMIN_EMAILS.includes(email.trim().toLowerCase());
}

export function assertAdminPanelAuth(
  email: string | null | undefined,
  password: string | null | undefined,
) {
  if (!isAdminEmail(email)) {
    throw new Error("This email is not authorized.");
  }
  if ((password ?? "") !== PANEL_PASSWORD) {
    throw new Error("Incorrect password. Sign out and sign in again.");
  }
}

export function assertSyncKey(key: string | null | undefined) {
  if ((key ?? "") !== SYNC_KEY) {
    throw new Error("Unauthorized");
  }
}
