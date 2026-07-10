import { createClient } from "@/lib/supabase/server";

export type AccountType = "freelancer" | "client" | "admin";

export type Profile = {
  id: string;
  email: string | null;
  name: string | null;
  account_type: string | null;
  subscription_plan: string | null;
  role?: string | null;
};

export async function getSessionUser() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  return user;
}

export async function getProfile(): Promise<Profile | null> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const { data } = await supabase
    .from("profiles")
    .select("id, email, name, account_type, subscription_plan, role")
    .eq("id", user.id)
    .maybeSingle();

  if (data) return data as Profile;

  return {
    id: user.id,
    email: user.email ?? null,
    name: (user.user_metadata?.name as string | undefined) ?? null,
    account_type: (user.user_metadata?.account_type as string | undefined) ?? "freelancer",
    subscription_plan: "free",
  };
}

export function isClientAccount(profile: Profile | null) {
  return (profile?.account_type ?? "").toLowerCase() === "client";
}

export function isProPlus(profile: Profile | null) {
  const plan = (profile?.subscription_plan ?? "free").toLowerCase();
  return plan === "pro_plus" || plan === "plus" || plan === "proplus";
}

export function isPro(profile: Profile | null) {
  const plan = (profile?.subscription_plan ?? "free").toLowerCase();
  return plan === "pro" || isProPlus(profile);
}

export function planLabel(profile: Profile | null) {
  if (isProPlus(profile)) return "Pro Plus";
  if (isPro(profile)) return "Pro";
  return "Free";
}
