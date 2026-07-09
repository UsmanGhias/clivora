import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

export const runtime = "nodejs";

function getBearer(req: NextRequest): string | null {
  const h = req.headers.get("authorization") ?? "";
  if (!h.startsWith("Bearer ")) return null;
  return h.slice(7).trim();
}

export async function POST(req: NextRequest) {
  try {
    const token = getBearer(req);
    if (!token) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
    const anon = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
    if (!url || !anon) {
      return NextResponse.json({ error: "Server misconfigured" }, { status: 500 });
    }

    const userClient = createClient(url, anon, {
      global: { headers: { Authorization: `Bearer ${token}` } },
    });
    const { data: userData, error: userErr } = await userClient.auth.getUser();
    if (userErr || !userData.user?.email) {
      return NextResponse.json({ error: "Invalid session" }, { status: 401 });
    }

    const adminEmails = (process.env.ADMIN_EMAILS ?? "")
      .split(",")
      .map((e) => e.trim().toLowerCase())
      .filter(Boolean);
    const email = userData.user.email.toLowerCase();
    if (!adminEmails.includes(email)) {
      return NextResponse.json({ error: "Not an allowlisted admin" }, { status: 403 });
    }

    const body = await req.json();
    const target = String(body.email ?? "").trim().toLowerCase();
    const revoke = Boolean(body.revoke);
    const requested = String(body.plan ?? "pro").toLowerCase();
    const plan = revoke ? "free" : requested === "pro_plus" ? "pro_plus" : "pro";
    if (!target.includes("@")) {
      return NextResponse.json({ error: "Valid email required" }, { status: 400 });
    }

    const { data, error } = await userClient.rpc("grant_pro_by_email", {
      p_email: target,
      p_plan: plan,
    });
    if (error) {
      return NextResponse.json({ error: error.message }, { status: 400 });
    }

    return NextResponse.json({ ok: true, result: data ?? null, plan });
  } catch (e) {
    return NextResponse.json({ error: e instanceof Error ? e.message : "Failed" }, { status: 500 });
  }
}
