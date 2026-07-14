import "server-only";

import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export type AdminPrincipal = {
  id: string;
  email: string;
  assuranceLevel: "aal1" | "aal2";
};

export class AdminAuthError extends Error {
  constructor(
    message: string,
    public readonly status: 401 | 403 | 503,
    public readonly code:
      | "AUTH_REQUIRED"
      | "ADMIN_REQUIRED"
      | "MFA_REQUIRED"
      | "AUTH_UNAVAILABLE",
  ) {
    super(message);
    this.name = "AdminAuthError";
  }
}

function assertSupabaseAuthConfig() {
  const url = process.env.SUPABASE_URL ?? process.env.NEXT_PUBLIC_SUPABASE_URL;
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !anonKey) {
    throw new AdminAuthError(
      "Admin authentication is unavailable.",
      503,
      "AUTH_UNAVAILABLE",
    );
  }
}

/**
 * Authorize an admin from the verified Supabase cookie session.
 *
 * Email allowlists, request-body credentials, and user metadata are deliberately
 * ignored. The role must be present on the caller's own database profile row.
 */
export async function requireAdmin(options: { requireAal2?: boolean } = {}) {
  assertSupabaseAuthConfig();

  const supabase = await createClient();
  const {
    data: { user },
    error: userError,
  } = await supabase.auth.getUser();

  if (userError || !user) {
    throw new AdminAuthError("Sign in required.", 401, "AUTH_REQUIRED");
  }

  const { data: profile, error: profileError } = await supabase
    .from("profiles")
    .select("role, account_type, is_blocked, is_restricted")
    .eq("id", user.id)
    .maybeSingle();

  if (profileError) {
    throw new AdminAuthError(
      "Admin authorization is temporarily unavailable.",
      503,
      "AUTH_UNAVAILABLE",
    );
  }

  if (
    !profile ||
    (profile.role !== "admin" && profile.account_type !== "admin") ||
    profile.is_blocked === true ||
    profile.is_restricted === true
  ) {
    throw new AdminAuthError("Admin role required.", 403, "ADMIN_REQUIRED");
  }

  // MFA AAL lookup can fail when the user has no factors enrolled. For read-only
  // admin gates (requireAal2=false) treat that as aal1 so the console still loads.
  const { data: aal, error: aalError } =
    await supabase.auth.mfa.getAuthenticatorAssuranceLevel();
  const levelRaw = aalError || !aal ? "aal1" : aal.currentLevel;
  const level: AdminPrincipal["assuranceLevel"] =
    levelRaw === "aal2" ? "aal2" : "aal1";

  if (options.requireAal2 && level !== "aal2") {
    throw new AdminAuthError(
      "Two-factor authentication is required for this action.",
      403,
      "MFA_REQUIRED",
    );
  }

  return {
    id: user.id,
    email: user.email ?? "",
    assuranceLevel: level,
  } satisfies AdminPrincipal;
}

/** Route-compatible alias. The cookie-backed server client is the only credential source. */
export async function requireAdminRequest(_request: Request) {
  return requireAdmin({ requireAal2: true });
}

const PRIVATE_NO_STORE_HEADERS = {
  "Cache-Control": "private, no-store, no-cache, must-revalidate, max-age=0",
  Pragma: "no-cache",
  Vary: "Cookie, Authorization",
};

export function adminJson(body: unknown, init: ResponseInit = {}) {
  const response = NextResponse.json(body, init);
  for (const [key, value] of Object.entries(PRIVATE_NO_STORE_HEADERS)) {
    response.headers.set(key, value);
  }
  return response;
}

export function adminErrorResponse(error: unknown, fallback = "Admin request failed") {
  if (error instanceof AdminAuthError) {
    return adminJson(
      { error: error.message, code: error.code },
      { status: error.status },
    );
  }

  // Do not return upstream database or service-role errors to the browser.
  console.error(fallback, error);
  return adminJson({ error: fallback }, { status: 500 });
}
