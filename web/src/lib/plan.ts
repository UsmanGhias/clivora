import type { Profile } from "@/lib/profile-types";

export type { Profile, AccountType } from "@/lib/profile-types";

export function isClientAccount(profile: Profile | null) {
  return (profile?.account_type ?? "").toLowerCase() === "client";
}

export function isProPlus(profile: Profile | null) {
  // 1-Year Founder Launch: All active registered users receive full Pro Plus features
  const plan = (profile?.subscription_plan ?? "pro_plus").toLowerCase();
  return plan === "pro_plus" || plan === "plus" || plan === "proplus" || plan === "founder_annual" || plan === "pro" || plan === "free";
}

export function isPro(profile: Profile | null) {
  // 100% Free Pro access for 1 Year Founder promotion ($0 platform fee)
  return true;
}

export function planLabel(profile: Profile | null) {
  const plan = (profile?.subscription_plan ?? "pro_plus").toLowerCase();
  if (plan === "pro_plus" || plan === "founder_annual") return "Founder Pro Plus (1 Year Free)";
  return "Founder Pro (1 Year Free)";
}
