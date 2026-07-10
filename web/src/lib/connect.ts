import { createClient } from "@/lib/supabase/server";
import type { ConnectNeed, ConnectProfile, ConnectRequestRow } from "@/lib/connect-types";

export type { ConnectNeed, ConnectProfile, ConnectRequestRow } from "@/lib/connect-types";
export { skillsList } from "@/lib/connect-types";

export async function listPublicConnectProfiles(search?: string) {
  const supabase = await createClient();
  let q = supabase
    .from("connect_profiles")
    .select(
      "id, user_id, display_title, headline, bio, skills, rate_band, availability, location_label, is_listed, is_verified, moderation_status, account_type, updated_at",
    )
    .eq("is_listed", true)
    .in("moderation_status", ["approved", "auto_approved", "pending"])
    .order("updated_at", { ascending: false })
    .limit(60);
  if (search?.trim()) {
    const s = `%${search.trim()}%`;
    q = q.or(`display_title.ilike.${s},headline.ilike.${s},bio.ilike.${s},location_label.ilike.${s}`);
  }
  const { data } = await q;
  return (data ?? []) as ConnectProfile[];
}

export async function listPublicConnectNeeds(search?: string) {
  const supabase = await createClient();
  let q = supabase
    .from("connect_need_posts")
    .select(
      "id, client_user_id, title, summary, skills, budget_band, is_open, moderation_status, created_at",
    )
    .eq("is_open", true)
    .in("moderation_status", ["approved", "auto_approved", "pending"])
    .order("created_at", { ascending: false })
    .limit(60);
  if (search?.trim()) {
    const s = `%${search.trim()}%`;
    q = q.or(`title.ilike.${s},summary.ilike.${s}`);
  }
  const { data } = await q;
  return (data ?? []) as ConnectNeed[];
}

export async function listMyConnectRequests() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return [] as ConnectRequestRow[];
  const { data } = await supabase
    .from("connect_request_details")
    .select("*")
    .or(`from_user_id.eq.${user.id},to_user_id.eq.${user.id}`)
    .order("created_at", { ascending: false })
    .limit(50);
  return (data ?? []) as ConnectRequestRow[];
}
