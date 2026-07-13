import { redirect } from "next/navigation";
import { getProfile, isClientAccount, planLabel } from "@/lib/profile";
import { isProPlus } from "@/lib/plan";
import { createClient } from "@/lib/supabase/server";
import { ClientSettingsPanel } from "@/components/client/ClientSettingsPanel";
import Link from "next/link";
import {
  Bell,
  ChevronRight,
  Globe,
  HelpCircle,
  KeyRound,
  Link2,
  ShieldCheck,
  User,
} from "lucide-react";
import { ManageBillingButton } from "@/components/app/ManageBillingButton";
import {
  FreelancerCard,
  FreelancerPageHeader,
  OutlineButton,
  PrimaryButton,
  StatusPill,
} from "@/components/freelancer/ui";

export const metadata = { title: "Settings" };

const TABS = [
  { id: "account", label: "Account" },
  { id: "security", label: "Security" },
  { id: "notifications", label: "Notifications" },
  { id: "billing", label: "Billing & Plan" },
  { id: "preferences", label: "Preferences" },
  { id: "apps", label: "Apps & Integrations" },
] as const;

export default async function SettingsPage({
  searchParams,
}: {
  searchParams?: Promise<{ tab?: string }>;
}) {
  const profile = await getProfile();
  if (!profile) redirect("/login");

  if (isClientAccount(profile)) {
    const supabase = await createClient();
    const uid = profile.id;
    let jobsPosted = 0;
    let activeProjects = 0;
    let invoices = 0;
    let totalSpent = 0;
    try {
      const [jobs, projects, inv] = await Promise.all([
        supabase
          .from("connect_need_posts")
          .select("id", { count: "exact", head: true })
          .eq("owner_uid", uid),
        supabase
          .from("project_shares")
          .select("share_id", { count: "exact", head: true })
          .eq("client_uid", uid),
        supabase
          .from("invoice_shares")
          .select("share_id, total")
          .eq("client_uid", uid)
          .limit(200),
      ]);
      jobsPosted = jobs.count ?? 0;
      activeProjects = projects.count ?? 0;
      if (inv.data) {
        invoices = inv.data.length;
        totalSpent = inv.data.reduce((s, r) => s + (Number(r.total) || 0), 0);
      }
    } catch {
      /* ignore */
    }
    return (
      <ClientSettingsPanel
        profile={profile}
        plan={planLabel(profile)}
        plus={isProPlus(profile)}
        stats={{ jobsPosted, activeProjects, invoices, totalSpent }}
      />
    );
  }

  const params = searchParams ? await searchParams : {};
  const tab = (params.tab as string) || "account";
  const plus = isProPlus(profile);
  const plan = planLabel(profile);

  return (
    <div className="space-y-6 pb-10">
      <FreelancerPageHeader
        title="Settings"
        subtitle="Manage your account, security, billing, and preferences."
      />

      <div className="flex flex-wrap gap-1 border-b border-border">
        {TABS.map((t) => (
          <Link
            key={t.id}
            href={`/app/settings?tab=${t.id}`}
            className={`border-b-2 px-3 py-2 text-sm font-semibold ${
              tab === t.id
                ? "border-primary text-primary"
                : "border-transparent text-text-muted hover:text-navy"
            }`}
          >
            {t.label}
          </Link>
        ))}
      </div>

      <div className="grid gap-4 xl:grid-cols-[1fr_300px]">
        <div className="space-y-4">
          {tab === "account" && (
            <FreelancerCard title="Account">
              <div className="flex items-start gap-4">
                <span className="flex h-14 w-14 items-center justify-center rounded-full bg-primary text-lg font-bold text-white">
                  {(profile.name || "?").charAt(0).toUpperCase()}
                </span>
                <div>
                  <p className="font-bold text-navy">{profile.name || "Freelancer"}</p>
                  <p className="text-sm text-text-secondary">{profile.email}</p>
                  <StatusPill tone="teal">{plan}</StatusPill>
                </div>
              </div>
              <div className="mt-4 flex gap-2">
                <PrimaryButton href="/app/account">Edit profile</PrimaryButton>
                <OutlineButton href="/app/account">View public profile</OutlineButton>
              </div>
            </FreelancerCard>
          )}

          {tab === "security" && (
            <FreelancerCard title="Security">
              <div className="flex items-start gap-3">
                <KeyRound className="h-5 w-5 text-primary" />
                <div>
                  <p className="font-semibold text-navy">Password & 2FA</p>
                  <p className="text-sm text-text-secondary">
                    Keep your account secure with a strong password and MFA.
                  </p>
                  <div className="mt-3">
                    <PrimaryButton>Update security</PrimaryButton>
                  </div>
                </div>
              </div>
            </FreelancerCard>
          )}

          {tab === "notifications" && (
            <FreelancerCard title="Notifications">
              <ul className="space-y-3">
                {["New messages", "Proposal updates", "Payment alerts", "Product tips"].map((l) => (
                  <li key={l} className="flex items-center justify-between rounded-xl border border-border px-4 py-3">
                    <span className="flex items-center gap-2 text-sm font-semibold">
                      <Bell className="h-4 w-4 text-primary" />
                      {l}
                    </span>
                    <input type="checkbox" defaultChecked className="accent-primary" />
                  </li>
                ))}
              </ul>
            </FreelancerCard>
          )}

          {tab === "billing" && (
            <FreelancerCard title="Billing & Plan">
              <p className="text-sm text-text-secondary">
                You are on <strong>{plan}</strong>
                {plus ? " with Pro Plus benefits." : ". Upgrade for more Connect credits."}
              </p>
              <div className="mt-4">
                <ManageBillingButton />
              </div>
            </FreelancerCard>
          )}

          {tab === "preferences" && (
            <FreelancerCard title="Preferences">
              <div className="flex items-center gap-3 rounded-xl border border-border p-4">
                <Globe className="h-5 w-5 text-primary" />
                <div>
                  <p className="font-semibold text-navy">Language & region</p>
                  <p className="text-sm text-text-secondary">English · USD</p>
                </div>
              </div>
            </FreelancerCard>
          )}

          {tab === "apps" && (
            <FreelancerCard title="Apps & Integrations">
              <div className="flex items-center gap-3 rounded-xl border border-border p-4">
                <Link2 className="h-5 w-5 text-primary" />
                <div>
                  <p className="font-semibold text-navy">Connected tools</p>
                  <p className="text-sm text-text-secondary">Stripe billing is linked when you subscribe.</p>
                </div>
              </div>
            </FreelancerCard>
          )}
        </div>

        <aside className="space-y-4">
          <FreelancerCard title="Account health">
            <div className="flex items-center gap-2 text-sm">
              <ShieldCheck className="h-4 w-4 text-success" />
              <span>Email verified</span>
            </div>
            <div className="mt-2 flex items-center gap-2 text-sm">
              <User className="h-4 w-4 text-primary" />
              <span>Profile ready for Connect</span>
            </div>
          </FreelancerCard>
          <FreelancerCard>
            <div className="flex items-start gap-3">
              <HelpCircle className="h-5 w-5 text-primary" />
              <div>
                <p className="font-semibold text-navy">Need help?</p>
                <Link href="/app/support" className="mt-2 inline-flex items-center text-sm font-semibold text-primary">
                  Visit support <ChevronRight className="h-4 w-4" />
                </Link>
              </div>
            </div>
          </FreelancerCard>
        </aside>
      </div>
    </div>
  );
}
