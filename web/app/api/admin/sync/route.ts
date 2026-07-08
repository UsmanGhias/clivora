import { NextRequest, NextResponse } from "next/server";
import { createServiceRoleClient } from "@/lib/supabase";
import { parsePayload } from "@/lib/admin";

type SyncBody = {
  eventType?: string;
  userEmail?: string;
  userName?: string;
  plan?: string;
  amount?: number | string;
  payload?: unknown;
  createdAt?: string;
  source?: string;
};

export async function POST(request: NextRequest) {
  const syncKey = process.env.ADMIN_SYNC_KEY;
  if (!syncKey) {
    return NextResponse.json({ error: "Admin sync not configured" }, { status: 503 });
  }

  const headerKey = request.headers.get("x-admin-sync-key");
  if (!headerKey || headerKey !== syncKey) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  let body: SyncBody;
  try {
    body = (await request.json()) as SyncBody;
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const eventType = body.eventType?.trim();
  if (!eventType) {
    return NextResponse.json({ error: "eventType is required" }, { status: 400 });
  }

  const amount =
    typeof body.amount === "string" ? parseFloat(body.amount) || 0 : body.amount ?? 0;

  let createdAt: string | undefined;
  if (body.createdAt) {
    const parsed = new Date(body.createdAt);
    if (!Number.isNaN(parsed.getTime())) {
      createdAt = parsed.toISOString();
    }
  }

  const row: Record<string, unknown> = {
    event_type: eventType,
    user_email: (body.userEmail ?? "").trim().toLowerCase(),
    user_name: (body.userName ?? "").trim(),
    plan: (body.plan ?? "free").trim(),
    amount,
    payload: parsePayload(body.payload),
    source: (body.source ?? "clivora_app").trim(),
  };

  if (createdAt) {
    row.created_at = createdAt;
  }

  try {
    const supabase = createServiceRoleClient();
    const { data, error } = await supabase
      .from("clivora_events")
      .insert(row)
      .select("id")
      .single();

    if (error) {
      console.error("Admin sync insert failed:", error.message);
      return NextResponse.json({ error: "Failed to store event" }, { status: 500 });
    }

    return NextResponse.json({ ok: true, id: data.id });
  } catch (err) {
    console.error("Admin sync error:", err);
    return NextResponse.json({ error: "Server error" }, { status: 500 });
  }
}

export async function GET() {
  return NextResponse.json({ error: "Method not allowed" }, { status: 405 });
}
