import { NextResponse, type NextRequest } from "next/server";
import { createServerClient } from "@supabase/ssr";

export async function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  let response = NextResponse.next({ request });

  try {
    const supabase = createServerClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
      {
        cookies: {
          getAll: () => request.cookies.getAll(),
          setAll: (cookies) => {
            cookies.forEach(({ name, value, options }) => {
              request.cookies.set(name, value);
              response.cookies.set(name, value, options);
            });
          },
        },
      }
    );

    const {
      data: { session },
    } = await supabase.auth.getSession();

    // Protected app routes: redirect to login if no session
    if (!session && (pathname.startsWith("/app") || pathname === "/connect/manage")) {
      const loginUrl = request.nextUrl.clone();
      loginUrl.pathname = "/login";
      loginUrl.searchParams.set("next", pathname);
      return NextResponse.redirect(loginUrl);
    }

    // Admin sub-routes: if no session, redirect to /admin login gate
    if (!session && pathname.startsWith("/admin/")) {
      return NextResponse.redirect(new URL("/admin", request.url));
    }

    // Auth pages: redirect to /app if already logged in
    if (session && (pathname === "/login" || pathname === "/signup")) {
      return NextResponse.redirect(new URL("/app", request.url));
    }
  } catch (e) {
    console.error("[middleware] Auth check error:", e);
  }

  return response;
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
