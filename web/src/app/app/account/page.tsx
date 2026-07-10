import Link from "next/link";
import { getProfile, planLabel } from "@/lib/profile";
import { site } from "@/lib/site";

export default async function AccountPage() {
  const profile = await getProfile();
  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-extrabold">Account</h1>
      <div className="rounded-2xl border border-border bg-surface p-5">
        <p className="text-sm text-text-secondary">Name</p>
        <p className="font-semibold">{profile?.name || "—"}</p>
        <p className="mt-3 text-sm text-text-secondary">Email</p>
        <p className="font-semibold">{profile?.email || "—"}</p>
        <p className="mt-3 text-sm text-text-secondary">Plan</p>
        <p className="font-semibold">{planLabel(profile)}</p>
      </div>
      <Link href="/pro" className="inline-flex rounded-full bg-primary px-4 py-2 text-sm font-semibold text-white">
        Upgrade · Pro {site.pricing.proMonthlyLabel} / Plus {site.pricing.proPlusMonthlyLabel}
      </Link>
    </div>
  );
}
