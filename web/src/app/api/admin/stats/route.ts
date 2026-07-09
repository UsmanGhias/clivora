import { NextRequest, NextResponse } from "next/server";
import { adminStats, loadEvents } from "@/lib/admin-store";
import {
  buildStats,
  fetchEventsFromSupabase,
  fetchProfileCount,
  fetchProfilesFromSupabase,
} from "@/lib/supabase-admin";

const SYNC_KEY = process.env.ADMIN_SYNC_KEY ?? "ClivoraSync2026!";

export async function GET(request: NextRequest) {
  const key = request.headers.get("x-admin-sync-key") ?? request.nextUrl.searchParams.get("key");
  if (key !== SYNC_KEY) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const [cloudEvents, profileCount, profiles] = await Promise.all([
    fetchEventsFromSupabase(500),
    fetchProfileCount(),
    fetchProfilesFromSupabase(100),
  ]);

  if (cloudEvents.length > 0) {
    return NextResponse.json(buildStats(cloudEvents, profileCount, profiles));
  }

  const localStats = adminStats();
  return NextResponse.json({
    ...localStats,
    totalProfiles: profileCount || profiles.length,
    proProfiles: profiles.filter((p) => p.plan === "pro").length,
    clientProfiles: profiles.filter((p) => p.accountType === "client").length,
    freelancerProfiles: profiles.filter((p) => p.accountType !== "client").length,
    profiles,
    source: profiles.length > 0 ? "supabase" : "local",
    events: loadEvents().filter((e) => !e.eventType.startsWith("audit_")).slice(0, 150),
  });
}
