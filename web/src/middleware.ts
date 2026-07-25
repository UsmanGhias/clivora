import { NextResponse, type NextRequest } from "next/server";
import { updateSession } from "@/lib/supabase/middleware";

const LEGACY_HOSTS = new Set([
  "clivora.codcrafters.org",
  "www.clivora.codcrafters.org",
]);

const SESSION_PATHS = [
  "/app",
  "/login",
  "/signup",
  "/auth/reset-password",
  "/connect/manage",
  "/admin",
];

function needsSession(pathname: string): boolean {
  return SESSION_PATHS.some(
    (p) => pathname === p || pathname.startsWith(`${p}/`)
  );
}

/** Permanent cutover: old Vercel host → Hostinger production. */
function redirectLegacyHost(request: NextRequest): NextResponse | null {
  const host = request.headers.get("host")?.split(":")[0]?.toLowerCase() ?? "";
  if (!LEGACY_HOSTS.has(host)) return null;
  const url = request.nextUrl.clone();
  url.protocol = "https:";
  url.host = "clivora.io";
  url.port = "";
  return NextResponse.redirect(url, 308);
}

export async function middleware(request: NextRequest) {
  const legacy = redirectLegacyHost(request);
  if (legacy) return legacy;
  if (!needsSession(request.nextUrl.pathname)) {
    return NextResponse.next();
  }
  return updateSession(request);
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};
