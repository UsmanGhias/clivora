import { NextResponse, type NextRequest } from "next/server";

/**
 * Pass-through middleware for Hostinger recovery.
 * Auth session refresh is temporarily disabled so a bad Edge/Supabase
 * import cannot crash the Node process boot loop (503).
 * Re-enable updateSession after production is stable.
 */
export function middleware(_request: NextRequest) {
  return NextResponse.next();
}

export const config = {
  matcher: [
    "/app/:path*",
    "/login",
    "/signup",
    "/auth/reset-password",
    "/connect/manage",
    "/admin/:path*",
  ],
};
