import { createClient } from "@/lib/supabase/server";

export type PortalNavCounts = {
  proposals: number;
  messages: number;
  notifications: number;
};

export async function getPortalNavCounts(
  uid: string,
  isClient: boolean,
): Promise<PortalNavCounts> {
  const supabase = await createClient();
  const counts: PortalNavCounts = { proposals: 0, messages: 0, notifications: 0 };
  if (!uid) return counts;

  try {
    const [proposals, messages, notifications] = await Promise.all([
      supabase
        .from("connect_proposals")
        .select("id", { count: "exact", head: true })
        .eq(isClient ? "to_user_id" : "from_user_id", uid)
        .in("status", isClient ? ["pending", "shortlisted", "viewed"] : ["pending", "viewed", "shortlisted"]),
      supabase
        .from("notifications")
        .select("id", { count: "exact", head: true })
        .eq("user_uid", uid)
        .eq("is_read", false),
      supabase
        .from("notifications")
        .select("id", { count: "exact", head: true })
        .eq("user_uid", uid)
        .eq("is_read", false),
    ]);
    counts.proposals = proposals.count ?? 0;
    counts.notifications = notifications.count ?? 0;
    counts.messages = messages.count ?? 0;
  } catch {
    /* ignore */
  }

  return counts;
}

export function portalGreeting() {
  const h = new Date().getHours();
  if (h < 12) return "Good morning";
  if (h < 17) return "Good afternoon";
  return "Good evening";
}
