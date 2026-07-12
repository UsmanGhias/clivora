import { adminErrorResponse, adminJson, requireAdmin } from "@/lib/admin-auth";
import {
  AdminServiceConfigurationError,
  requireAdminServiceConfig,
} from "@/lib/admin-service";
import { adminStats, loadEvents } from "@/lib/admin-store";
import {
  buildStats,
  fetchEventsFromSupabase,
  fetchProfileCount,
  fetchProfilesFromSupabase,
} from "@/lib/supabase-admin";

export const dynamic = "force-dynamic";

export async function GET() {
  try {
    await requireAdmin({ requireAal2: true });
    requireAdminServiceConfig();

    const [cloudEvents, profileCount, profiles] = await Promise.all([
      fetchEventsFromSupabase(500),
      fetchProfileCount(),
      fetchProfilesFromSupabase(100),
    ]);

    if (cloudEvents.length > 0) {
      return adminJson(buildStats(cloudEvents, profileCount, profiles));
    }

    const localStats = adminStats();
    return adminJson({
      ...localStats,
      totalProfiles: profileCount || profiles.length,
      proProfiles: profiles.filter((profile) => profile.plan === "pro").length,
      clientProfiles: profiles.filter((profile) => profile.accountType === "client").length,
      freelancerProfiles: profiles.filter((profile) => profile.accountType !== "client").length,
      profiles,
      source: profiles.length > 0 ? "supabase" : "local",
      events: loadEvents()
        .filter((event) => !event.eventType.startsWith("audit_"))
        .slice(0, 150),
    });
  } catch (error) {
    if (error instanceof AdminServiceConfigurationError) {
      return adminJson(
        { error: "Admin service is unavailable.", code: "ADMIN_SERVICE_UNAVAILABLE" },
        { status: 503 },
      );
    }
    return adminErrorResponse(error, "Could not load admin statistics");
  }
}
