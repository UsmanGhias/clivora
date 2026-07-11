import { createHash, createHmac, randomBytes, scryptSync, timingSafeEqual } from "crypto";

export const OFFICIAL_EMAIL = "iusmanghias@gmail.com";

export const ADMIN_EMAILS = [
  "admin@codcrafters.org",
  "usmanghias1@gmail.com",
  "iusmanghias@gmail.com",
];

/** Env bootstrap password, used only until a hash is stored in app_settings. */
export const PANEL_PASSWORD_BOOTSTRAP =
  process.env.ADMIN_PANEL_PASSWORD ?? "ClivoraAdmin2026!";

export const SYNC_KEY = process.env.ADMIN_SYNC_KEY ?? "ClivoraSync2026!";

const SESSION_SECRET =
  process.env.ADMIN_SESSION_SECRET ?? process.env.ADMIN_SYNC_KEY ?? "ClivoraAdminSession2026!";

export const CLIVORA_PURPLE = "#6C3CE1";
export const CLIVORA_NAVY = "#0F172A";
export const PRO_PRICE_USD = 9;
export const PRO_PLUS_PRICE_USD = 19;
/** @deprecated use PRO_PRICE_USD */
export const PRO_PRICE_PKR = PRO_PRICE_USD;
/** @deprecated use PRO_PLUS_PRICE_USD */
export const PRO_PLUS_PRICE_PKR = PRO_PLUS_PRICE_USD;

export const ADMIN_SESSION_FLAG = "clivora_admin";
export const ADMIN_SESSION_EMAIL = "clivora_admin_email";
/** Session token (HMAC), never store the panel password in sessionStorage. */
export const ADMIN_SESSION_TOKEN = "clivora_admin_token";
/** @deprecated plaintext password key, cleared on login */
export const ADMIN_SESSION_PASS = "clivora_admin_pass";

const SUPABASE_URL =
  process.env.SUPABASE_URL ??
  process.env.NEXT_PUBLIC_SUPABASE_URL ??
  "https://jtzjwgovqczlccyeujhq.supabase.co";

function serviceKey(): string | null {
  return process.env.SUPABASE_SERVICE_ROLE_KEY ?? null;
}

export function isAdminEmail(email: string | null | undefined): boolean {
  if (!email) return false;
  return ADMIN_EMAILS.includes(email.trim().toLowerCase());
}

export function hashPanelPassword(password: string): string {
  const salt = randomBytes(16).toString("hex");
  const hash = scryptSync(password, salt, 64).toString("hex");
  return `${salt}:${hash}`;
}

export function verifyPanelPasswordHash(password: string, stored: string): boolean {
  const [salt, hash] = stored.split(":");
  if (!salt || !hash) return false;
  try {
    const computed = scryptSync(password, salt, 64);
    const expected = Buffer.from(hash, "hex");
    if (expected.length !== computed.length) return false;
    return timingSafeEqual(expected, computed);
  } catch {
    return false;
  }
}

export async function getStoredPanelPasswordHash(): Promise<string | null> {
  const key = serviceKey();
  if (!key) return null;
  try {
    const res = await fetch(
      `${SUPABASE_URL}/rest/v1/app_settings?select=value&key=eq.admin_panel_password_hash&limit=1`,
      {
        headers: { apikey: key, Authorization: `Bearer ${key}` },
        cache: "no-store",
      },
    );
    if (!res.ok) return null;
    const rows = (await res.json()) as Array<{ value?: { hash?: string } | string }>;
    const value = rows[0]?.value;
    if (!value) return null;
    if (typeof value === "string") return value || null;
    const hash = value.hash ?? "";
    return hash || null;
  } catch {
    return null;
  }
}

export async function setStoredPanelPasswordHash(hash: string): Promise<void> {
  const key = serviceKey();
  if (!key) throw new Error("SUPABASE_SERVICE_ROLE_KEY is not configured");
  const res = await fetch(`${SUPABASE_URL}/rest/v1/app_settings?key=eq.admin_panel_password_hash`, {
    method: "PATCH",
    headers: {
      apikey: key,
      Authorization: `Bearer ${key}`,
      "Content-Type": "application/json",
      Prefer: "return=minimal",
    },
    body: JSON.stringify({ value: { hash }, updated_at: new Date().toISOString() }),
  });
  if (!res.ok) {
    // Upsert if missing
    const ins = await fetch(`${SUPABASE_URL}/rest/v1/app_settings`, {
      method: "POST",
      headers: {
        apikey: key,
        Authorization: `Bearer ${key}`,
        "Content-Type": "application/json",
        Prefer: "resolution=merge-duplicates,return=minimal",
      },
      body: JSON.stringify({ key: "admin_panel_password_hash", value: { hash } }),
    });
    if (!ins.ok) throw new Error("Failed to store admin password hash");
  }
}

export async function verifyPanelPassword(password: string): Promise<boolean> {
  const stored = await getStoredPanelPasswordHash();
  if (stored) return verifyPanelPasswordHash(password, stored);
  // Bootstrap: accept env password until an admin sets a backend hash.
  return password === PANEL_PASSWORD_BOOTSTRAP;
}

export function issueAdminSessionToken(email: string): string {
  const exp = Date.now() + 12 * 60 * 60 * 1000;
  const payload = `${email.trim().toLowerCase()}|${exp}`;
  const sig = createHmac("sha256", SESSION_SECRET).update(payload).digest("hex");
  return Buffer.from(`${payload}|${sig}`).toString("base64url");
}

export function verifyAdminSessionToken(
  email: string | null | undefined,
  token: string | null | undefined,
): boolean {
  if (!email || !token) return false;
  try {
    const raw = Buffer.from(token, "base64url").toString("utf8");
    const [tokEmail, expStr, sig] = raw.split("|");
    if (!tokEmail || !expStr || !sig) return false;
    if (tokEmail !== email.trim().toLowerCase()) return false;
    const exp = Number(expStr);
    if (!Number.isFinite(exp) || Date.now() > exp) return false;
    const payload = `${tokEmail}|${expStr}`;
    const expected = createHmac("sha256", SESSION_SECRET).update(payload).digest("hex");
    const a = Buffer.from(sig);
    const b = Buffer.from(expected);
    if (a.length !== b.length) return false;
    return timingSafeEqual(a, b);
  } catch {
    return false;
  }
}

/**
 * Accepts either a session token (preferred) or the panel password.
 * Prefer sending `adminToken` from the browser, never persist the password.
 */
export async function assertAdminPanelAuth(
  email: string | null | undefined,
  passwordOrToken: string | null | undefined,
  opts?: { preferToken?: boolean },
) {
  if (!isAdminEmail(email)) {
    throw new Error("This email is not authorized.");
  }
  const secret = passwordOrToken ?? "";
  if (opts?.preferToken || secret.length > 40) {
    if (verifyAdminSessionToken(email, secret)) return;
  }
  if (verifyAdminSessionToken(email, secret)) return;
  const ok = await verifyPanelPassword(secret);
  if (!ok) {
    throw new Error("Incorrect password. Sign out and sign in again.");
  }
}

export function assertSyncKey(key: string | null | undefined) {
  if ((key ?? "") !== SYNC_KEY) {
    throw new Error("Unauthorized");
  }
}

/** Fingerprint for UI, not a secret. */
export function passwordConfigFingerprint(hash: string | null): string {
  if (!hash) return "bootstrap-env";
  return createHash("sha256").update(hash).digest("hex").slice(0, 8);
}

/** @deprecated kept for compile compatibility during migration */
export const PANEL_PASSWORD = PANEL_PASSWORD_BOOTSTRAP;
