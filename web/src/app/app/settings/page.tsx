import { redirect } from "next/navigation";
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
import { getProfile, isClientAccount, planLabel } from "@/lib/profile";
import { isProPlus } from "@/lib/plan";
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
  if (isClientAccount(profile)) redirect("/app/account");

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
            className={`px-3 py-2.5 text-sm font-semibold ${
              tab === t.id
                ? "border-b-2 border-primary text-primary"
                : "text-text-secondary hover:text-navy"
            }`}
          >
            {t.label}
          </Link>
        ))}
      </div>

      <div className="grid gap-4 xl:grid-cols-[1fr_300px]">
        <div className="space-y-4">
          {(tab === "account" || !TABS.some((t) => t.id === tab)) && (
            <>
              <FreelancerCard
                title="Account information"
                action={
                  <OutlineButton href="/app/account">Edit Profile</OutlineButton>
                }
              >
                <div className="flex flex-col gap-4 sm:flex-row sm:items-start">
                  <span className="flex h-20 w-20 shrink-0 items-center justify-center rounded-full bg-navy text-2xl font-bold text-white">
                    {(profile.name || profile.email || "?").charAt(0).toUpperCase()}
                  </span>
                  <div className="grid flex-1 gap-3 sm:grid-cols-2">
                    {[
                      ["Full name", profile.name || "—"],
                      ["Email address", profile.email || "—"],
                      ["Role", "Freelancer"],
                      ["Username", (profile.email || "").split("@")[0] || "—"],
                      ["Member since", "Jan 2024"],
                      ["Current plan", plan],
                    ].map(([k, v]) => (
                      <div key={k}>
                        <p className="text-xs font-semibold uppercase text-text-muted">{k}</p>
                        <p className="mt-1 text-sm font-semibold text-navy">
                          {k === "Current plan" ? (
                            <StatusPill tone="teal">{String(v)}</StatusPill>
                          ) : (
                            v
                          )}
                        </p>
                      </div>
                    ))}
                  </div>
                </div>
              </FreelancerCard>

              <FreelancerCard title="Quick settings">
                <div className="grid gap-2 sm:grid-cols-2">
                  {[
                    { icon: KeyRound, title: "Password", desc: "Change your password", href: "/app/account" },
                    { icon: Bell, title: "Email preferences", desc: "Choose what we send you", href: "/app/settings?tab=notifications" },
                    { icon: Globe, title: "Language & region", desc: "Locale and currency", href: "/app/settings?tab=preferences" },
                    { icon: User, title: "Profile visibility", desc: "Connect listing controls", href: "/connect/manage" },
                    { icon: Link2, title: "Connected accounts", desc: "Google and billing", href: "/app/settings?tab=apps" },
                    { icon: ShieldCheck, title: "Data & privacy", desc: "Export or delete data", href: "/delete-account" },
                  ].map((item) => (
                    <Link
                      key={item.title}
                      href={item.href}
                      className="flex items-center gap-3 rounded-xl border border-border px-3 py-3 transition hover:border-primary/40"
                    >
                      <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-primary/10 text-primary">
                        <item.icon className="h-4 w-4" />
                      </span>
                      <div className="min-w-0 flex-1">
                        <p className="text-sm font-bold text-navy">{item.title}</p>
                        <p className="text-xs text-text-secondary">{item.desc}</p>
                      </div>
                      <ChevronRight className="h-4 w-4 text-text-muted" />
                    </Link>
                  ))}
                </div>
              </FreelancerCard>

              <div className="rounded-2xl border border-red-200 bg-red-50 p-5">
                <p className="font-bold text-error">Danger zone</p>
                <p className="mt-1 text-sm text-red-800/80">
                  Permanently delete your account and associated data.
                </p>
                <Link
                  href="/delete-account"
                  className="mt-3 inline-flex rounded-xl border border-error px-4 py-2 text-sm font-semibold text-error"
                >
                  Delete account
                </Link>
              </div>
            </>
          )}

          {tab === "security" && (
            <FreelancerCard title="Security">
              <ul className="space-y-3 text-sm">
                <li className="flex items-center justify-between rounded-xl border border-border px-3 py-3">
                  <span>Two-factor authentication</span>
                  <StatusPill tone="green">Enabled</StatusPill>
                </li>
                <li className="flex items-center justify-between rounded-xl border border-border px-3 py-3">
                  <span>Email verified</span>
                  <StatusPill tone="green">Verified</StatusPill>
                </li>
              </ul>
              <p className="mt-4 text-sm text-text-secondary">
                MFA is managed through Supabase Auth. Use Manage 2FA from your profile or the mobile app.
              </p>
              <div className="mt-4">
                <PrimaryButton href="/app/account">Manage 2FA Settings</PrimaryButton>
              </div>
            </FreelancerCard>
          )}

          {tab === "notifications" && (
            <FreelancerCard title="Notification preferences">
              <ul className="space-y-3">
                {["New messages", "Invoice updates", "Connect proposals", "Project deadlines", "Marketing tips"].map(
                  (n) => (
                    <li
                      key={n}
                      className="flex items-center justify-between rounded-xl border border-border px-3 py-3 text-sm"
                    >
                      <span className="font-semibold text-navy">{n}</span>
                      <span className="rounded-full bg-primary/10 px-3 py-1 text-xs font-bold text-primary">
                        On
                      </span>
                    </li>
                  ),
                )}
              </ul>
            </FreelancerCard>
          )}

          {tab === "billing" && (
            <FreelancerCard title="Billing & plan">
              <p className="text-sm text-text-secondary">
                Current plan: <strong className="text-navy">{plan}</strong>
              </p>
              <div className="mt-4 flex flex-wrap gap-2">
                <ManageBillingButton />
                {!plus && <PrimaryButton href="/pro?plan=pro_plus">Upgrade to Pro Plus</PrimaryButton>}
              </div>
            </FreelancerCard>
          )}

          {tab === "preferences" && (
            <FreelancerCard title="Preferences">
              <div className="grid gap-3 sm:grid-cols-2">
                {[
                  ["Language", "English"],
                  ["Timezone", "Asia/Karachi"],
                  ["Currency", "USD"],
                  ["Week starts on", "Monday"],
                ].map(([k, v]) => (
                  <div key={k} className="rounded-xl border border-border px-3 py-3">
                    <p className="text-xs font-semibold uppercase text-text-muted">{k}</p>
                    <p className="mt-1 font-semibold text-navy">{v}</p>
                  </div>
                ))}
              </div>
            </FreelancerCard>
          )}

          {tab === "apps" && (
            <FreelancerCard title="Apps & integrations">
              <ul className="space-y-3">
                {["Stripe", "Google", "CLIVORA Android App"].map((app) => (
                  <li
                    key={app}
                    className="flex items-center justify-between rounded-xl border border-border px-3 py-3 text-sm"
                  >
                    <span className="font-semibold text-navy">{app}</span>
                    <StatusPill tone="green">Connected</StatusPill>
                  </li>
                ))}
              </ul>
            </FreelancerCard>
          )}
        </div>

        <aside className="space-y-4">
          <FreelancerCard title="Account security">
            <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-2xl bg-success/15 text-success">
              <ShieldCheck className="h-6 w-6" />
            </div>
            <ul className="space-y-2 text-sm text-text-secondary">
              <li className="flex items-center gap-2">
                <span className="text-success">✓</span> Two-factor authentication is enabled
              </li>
              <li className="flex items-center gap-2">
                <span className="text-success">✓</span> Email verified
              </li>
              <li className="flex items-center gap-2">
                <span className="text-success">✓</span> Last login: Today
              </li>
            </ul>
            <div className="mt-4">
              <OutlineButton href="/app/settings?tab=security">Manage Security</OutlineButton>
            </div>
          </FreelancerCard>

          <FreelancerCard title="Plan & usage">
            <div className="flex items-center justify-between">
              <p className="font-bold text-navy">{plan} Plan</p>
              <StatusPill tone="green">Active</StatusPill>
            </div>
            <ul className="mt-4 space-y-3 text-sm">
              <li>
                <div className="flex justify-between">
                  <span>Proposals</span>
                  <span className="font-semibold">{plus ? "Unlimited" : "5 / mo"}</span>
                </div>
                <div className="mt-1 h-1.5 rounded-full bg-background">
                  <div className="h-full w-2/3 rounded-full bg-primary" />
                </div>
              </li>
              <li>
                <div className="flex justify-between">
                  <span>Projects</span>
                  <span className="font-semibold">Active</span>
                </div>
                <div className="mt-1 h-1.5 rounded-full bg-background">
                  <div className="h-full w-1/2 rounded-full bg-primary" />
                </div>
              </li>
              <li>
                <div className="flex justify-between">
                  <span>Storage</span>
                  <span className="font-semibold">2.4 / 50 GB</span>
                </div>
                <div className="mt-1 h-1.5 rounded-full bg-background">
                  <div className="h-full w-[8%] rounded-full bg-primary" />
                </div>
              </li>
            </ul>
            <div className="mt-4">
              <PrimaryButton href="/pro?plan=pro_plus">Manage Plan</PrimaryButton>
            </div>
          </FreelancerCard>

          <FreelancerCard>
            <div className="flex items-start gap-3">
              <HelpCircle className="h-5 w-5 text-primary" />
              <div>
                <p className="font-bold text-navy">Need help?</p>
                <p className="mt-1 text-sm text-text-secondary">Visit the help center or contact support.</p>
                <Link href="/app/support" className="mt-2 inline-block text-sm font-semibold text-primary">
                  Visit Help Center →
                </Link>
              </div>
            </div>
          </FreelancerCard>
        </aside>
      </div>
    </div>
  );
}
