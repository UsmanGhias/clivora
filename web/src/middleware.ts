import { type NextRequest } from "next/server";
import { updateSession } from "@/lib/supabase/middleware";

/** Auth session guard — Hostinger-safe (narrow matcher + hardened updateSession). */
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
    "/admin",
    "/admin/:path*",
  ],
};
