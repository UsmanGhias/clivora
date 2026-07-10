import { createClient } from "@/lib/supabase/server";

export type ConnectProfile = {
  id: string;
  user_id: string;
  display_title: string | null;
  headline: string | null;
  skills: string[] | string | null;
  rate_band: string | null;
  is_listed: boolean | null;
  is_verified: boolean | null;
  moderation_status: string | null;
  account_type: string | null;
};

export type ConnectNeed = {
  id: string;
  client_user_id: string;
  title: string | null;
  summary: string | null;
  skills: string[] | string | null;
  budget_band: string | null;
  is_open: boolean | null;
  moderation_status: string | null;
  created_at: string | null;
};

export function skillsList(skills: string[] | string | null | undefined): string[] {
  if (!skills) return [];
  if (Array.isArray(skills)) return skills.map(String);
  try {
    const parsed = JSON.parse(skills);
    if (Array.isArray(parsed)) return parsed.map(String);
  } catch {
    /* ignore */
  }
  return skills
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean);
}

export async function listPublicConnectProfiles() {
  const supabase = await createClient();
  const { data } = await supabase
    .from("connect_profiles")
    .select(
      "id, user_id, display_title, headline, skills, rate_band, is_listed, is_verified, moderation_status, account_type"
    )
    .eq("is_listed", true)
    .in("moderation_status", ["approved", "auto_approved", "pending"])
    .order("updated_at", { ascending: false })
    .limit(48);
  return (data ?? []) as ConnectProfile[];
}

export async function listPublicConnectNeeds() {
  const supabase = await createClient();
  const { data } = await supabase
    .from("connect_need_posts")
    .select(
      "id, client_user_id, title, summary, skills, budget_band, is_open, moderation_status, created_at"
    )
    .eq("is_open", true)
    .in("moderation_status", ["approved", "auto_approved", "pending"])
    .order("created_at", { ascending: false })
    .limit(48);
  return (data ?? []) as ConnectNeed[];
}
