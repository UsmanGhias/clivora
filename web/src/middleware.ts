import { type NextRequest } from "next/server";
import { updateSession } from "@/lib/supabase/middleware";

/**
 * Auth session refresh only — keep matcher narrow.
 * Old-domain redirect belongs at DNS / Vercel host, not on every Hostinger request.
 */
export async function middleware(request: NextRequest) {
  return updateSession(request);
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
