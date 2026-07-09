import { NextRequest, NextResponse } from "next/server";
import { appendEvent } from "@/lib/admin-store";
import { insertEventToSupabase } from "@/lib/supabase-admin";

const SYNC_KEY = process.env.ADMIN_SYNC_KEY ?? "ClivoraSync2026!";

export async function POST(request: NextRequest) {
  const key = request.headers.get("x-admin-sync-key");
  if (key !== SYNC_KEY) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();
    const payload = {
      eventType: String(body.eventType ?? "unknown"),
      userEmail: String(body.userEmail ?? ""),
      userName: String(body.userName ?? ""),
      plan: String(body.plan ?? "free"),
      amount: Number(body.amount ?? 0),
      payload: String(body.payload ?? "{}"),
      createdAt: String(body.createdAt ?? new Date().toISOString()),
      source: String(body.source ?? "clivora_app"),
    };

    const event = appendEvent(payload);
    await insertEventToSupabase(payload);

    return NextResponse.json({ ok: true, id: event.id });
  } catch (e) {
    return NextResponse.json({ error: String(e) }, { status: 400 });
  }
}
