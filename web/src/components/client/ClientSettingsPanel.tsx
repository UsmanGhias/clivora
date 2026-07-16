"use client";

import Link from "next/link";
import { useState } from "react";
import {
  BadgeCheck,
  Bell,
  CreditCard,
  KeyRound,
  Trash2,
  HelpCircle,
  Headphones,
  User,
  Shield,
  Wallet,
  Users,
  SlidersHorizontal,
  AppWindow,
} from "lucide-react";
import {
  ClientCard,
  ClientPageHeader,
  ClientOutlineButton,
  ClientPrimaryButton,
  ClientStatCard,
  ClientStatusPill,
  money,
} from "@/components/client/ui";
import { ManageBillingButton } from "@/components/app/ManageBillingButton";
import { cn } from "@/lib/utils";
import type { Profile } from "@/lib/profile-types";

const NAV = [
  { key: "account", label: "Account", icon: User },
  { key: "profile", label: "Profile", icon: User },
  { key: "notifications", label: "Notifications", icon: Bell },
  { key: "security", label: "Security", icon: Shield },
  { key: "payment", label: "Payment methods", icon: CreditCard },
  { key: "billing", label: "Billing & plans", icon: Wallet },
  { key: "team", label: "Team", icon: Users },
  { key: "preferences", label: "Preferences", icon: SlidersHorizontal },
  { key: "apps", label: "Connected apps", icon: AppWindow },
] as const;

type Props = {
  profile: Profile;
  plan: string;
  plus: boolean;
  stats: {
    jobsPosted: number;
    activeProjects: number;
    invoices: number;
    totalSpent: number;
  };
};

export function ClientSettingsPanel({ profile, plan, plus, stats }: Props) {
  const [tab, setTab] = useState<(typeof NAV)[number]["key"]>("account");

  return (
    <div className="space-y-6 pb-10">
      <ClientPageHeader title="Settings" subtitle="Manage your account, billing, and preferences." />

      <div className="grid gap-6 lg:grid-cols-[220px_1fr]">
        <nav className="space-y-0.5 rounded-2xl border border-border bg-surface p-2 shadow-sm">
          {NAV.map((item) => {
            const Icon = item.icon;
            const active = tab === item.key;
            return (
              <button
                key={item.key}
                type="button"
                onClick={() => setTab(item.key)}
                className={cn(
                  "flex w-full items-center gap-2 rounded-xl px-3 py-2.5 text-left text-sm font-semibold transition",
                  active
                    ? "border-l-4 border-client-accent bg-client-surface text-navy"
                    : "text-text-secondary hover:bg-client-surface/60",
                )}
              >
                <Icon className="h-4 w-4 shrink-0" />
                {item.label}
              </button>
            );
          })}
        </nav>

        <div className="space-y-4">
          {(tab === "account" || tab === "profile") && (
            <>
              <ClientCard
                title="Account information"
                action={<ClientOutlineButton href="/app/account">Edit profile</ClientOutlineButton>}
              >
                <div className="flex flex-col gap-6 lg:flex-row lg:items-start lg:justify-between">
                  <div className="flex items-start gap-4">
                    <span className="flex h-16 w-16 items-center justify-center rounded-full bg-navy text-xl font-bold text-white">
                      {(profile.name || profile.email || "?").charAt(0).toUpperCase()}
                    </span>
                    <div>
                      <p className="font-display text-lg font-bold text-navy">
                        {profile.name || "Client"}
                      </p>
                      <p className="text-sm text-text-secondary">{profile.email}</p>
                      <div className="mt-2 flex flex-wrap items-center gap-2">
                        {profile.email ? (
                          <ClientStatusPill tone="green">
                            <span className="inline-flex items-center gap-1">
                              <BadgeCheck className="h-3 w-3" /> Account active
                            </span>
                          </ClientStatusPill>
                        ) : null}
                        <span className="text-xs text-text-muted capitalize">
                          {profile.account_type || "client"}
                        </span>
                      </div>
                      <p className="mt-2 text-xs text-text-muted">
                        Plan: {plan}
                        {plus ? " · Pro Plus" : ""}
                      </p>
                    </div>
                  </div>
                  <div className="rounded-xl border border-border bg-client-surface/50 p-4">
                    <p className="text-xs font-semibold uppercase text-text-muted">Plan</p>
                    <div className="mt-1 flex items-center gap-2">
                      <p className="font-bold text-navy">{plan}</p>
                      {plus && <ClientStatusPill tone="green">Active</ClientStatusPill>}
                    </div>
                    <p className="mt-1 text-xs text-text-secondary">
                      {plus ? "Pro Plus features unlocked" : "Upgrade anytime via /pro or Play"}
                    </p>
                    <div className="mt-3">
                      <ManageBillingButton />
                    </div>
                  </div>
                </div>
              </ClientCard>

              <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
                <ClientStatCard
                  label="Jobs posted"
                  value={stats.jobsPosted}
                  sub="View all jobs →"
                  href="/connect/manage"
                  icon={User}
                  iconTone="bg-violet-100 text-violet-700"
                />
                <ClientStatCard
                  label="Active projects"
                  value={stats.activeProjects}
                  sub="View all projects →"
                  href="/app/projects"
                  icon={Users}
                  iconTone="bg-emerald-100 text-emerald-700"
                />
                <ClientStatCard
                  label="Invoices"
                  value={stats.invoices}
                  sub="View all invoices →"
                  href="/app/invoices"
                  icon={CreditCard}
                  iconTone="bg-sky-100 text-sky-800"
                />
                <ClientStatCard
                  label="Total spent"
                  value={money(stats.totalSpent, 0)}
                  sub="View payments →"
                  href="/app/payments"
                  icon={Wallet}
                  iconTone="bg-amber-100 text-amber-800"
                />
              </div>

              <ClientCard title="Quick actions">
                <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
                  {[
                    { label: "Change password", icon: KeyRound, href: "#security", danger: false },
                    { label: "Payment methods", icon: CreditCard, href: "/pro", danger: false },
                    { label: "Notification settings", icon: Bell, href: "#notifications", danger: false },
                    { label: "Delete account", icon: Trash2, href: "/delete-account", danger: true },
                  ].map((a) => {
                    const Icon = a.icon;
                    return (
                      <Link
                        key={a.label}
                        href={a.href}
                        onClick={(e) => {
                          if (a.href === "#security") {
                            e.preventDefault();
                            setTab("security");
                          }
                          if (a.href === "#notifications") {
                            e.preventDefault();
                            setTab("notifications");
                          }
                        }}
                        className={cn(
                          "flex items-center gap-3 rounded-xl border border-border p-4 transition hover:bg-client-surface",
                          a.danger && "hover:border-error/40",
                        )}
                      >
                        <span
                          className={cn(
                            "flex h-10 w-10 items-center justify-center rounded-xl",
                            a.danger ? "bg-red-50 text-error" : "bg-client-surface text-client-accent",
                          )}
                        >
                          <Icon className="h-5 w-5" />
                        </span>
                        <span
                          className={cn(
                            "text-sm font-semibold",
                            a.danger ? "text-error" : "text-navy",
                          )}
                        >
                          {a.label}
                        </span>
                      </Link>
                    );
                  })}
                </div>
              </ClientCard>
            </>
          )}

          {tab === "notifications" && (
            <ClientCard title="Notification settings">
              <NotificationPrefs />
            </ClientCard>
          )}

          {tab === "security" && (
            <ClientCard title="Security">
              <p className="text-sm text-text-secondary">
                Update your password from the reset-password flow, or enable MFA after upgrading to
                Pro Plus in Account settings on the freelancer workspace / mobile app.
              </p>
              <div className="mt-4 flex flex-wrap gap-2">
                <ClientPrimaryButton href="/auth/reset-password">
                  Reset password email
                </ClientPrimaryButton>
                <ClientOutlineButton href="/pro?plan=pro_plus">Pro Plus for MFA</ClientOutlineButton>
              </div>
            </ClientCard>
          )}

          {(tab === "payment" || tab === "billing") && (
            <ClientCard title={tab === "payment" ? "Payment methods" : "Billing & plans"}>
              <p className="text-sm text-text-secondary">
                {tab === "payment"
                  ? "Card payouts are coming soon. Pay freelancers off-platform and keep invoices in CLIVORA."
                  : `You are on ${plan}. Renew with JazzCash/manual on /pro or Google Play on Android.`}
              </p>
              <div className="mt-4">
                <ManageBillingButton />
              </div>
            </ClientCard>
          )}

          {(tab === "team" || tab === "preferences" || tab === "apps") && (
            <ClientCard title={NAV.find((n) => n.key === tab)?.label}>
              <p className="text-sm text-text-secondary">
                {tab === "team"
                  ? "Invite collaborators from Team when your org is set up."
                  : tab === "preferences"
                    ? "Notification preferences are above under Notifications."
                    : "Connected apps and OAuth links will appear here as they ship."}
              </p>
              <div className="mt-4 flex flex-wrap gap-3">
                {tab === "team" && (
                  <Link href="/app/team" className="text-sm font-semibold text-client-accent">
                    Open Team →
                  </Link>
                )}
                {tab === "preferences" && (
                  <button
                    type="button"
                    onClick={() => setTab("notifications")}
                    className="text-sm font-semibold text-client-accent"
                  >
                    Notification settings →
                  </button>
                )}
                {tab === "apps" && (
                  <Link href="/connect" className="text-sm font-semibold text-client-accent">
                    Open Connect →
                  </Link>
                )}
              </div>
            </ClientCard>
          )}

          <div className="flex flex-col gap-3 rounded-2xl border border-sky-100 bg-sky-50 p-5 sm:flex-row sm:items-center sm:justify-between">
            <div className="flex items-start gap-3">
              <span className="flex h-10 w-10 items-center justify-center rounded-xl bg-sky-100 text-sky-700">
                <HelpCircle className="h-5 w-5" />
              </span>
              <div>
                <p className="font-semibold text-navy">Need help with your account?</p>
                <p className="text-sm text-text-secondary">
                  Our support team is here to help you get the most out of CLIVORA.
                </p>
              </div>
            </div>
            <div className="flex gap-2">
              <ClientPrimaryButton href="/app/support">Visit Help Center</ClientPrimaryButton>
              <span className="flex h-10 w-10 items-center justify-center rounded-full bg-client-accent text-white">
                <Headphones className="h-5 w-5" />
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

const PREF_KEYS = [
  "New proposals",
  "Invoice updates",
  "Project milestones",
  "Messages from freelancers",
  "Marketing emails",
] as const;

function NotificationPrefs() {
  const storageKey = "clivora.client.notifPrefs";
  const [prefs, setPrefs] = useState<Record<string, boolean>>(() => {
    if (typeof window === "undefined") {
      return Object.fromEntries(PREF_KEYS.map((k) => [k, true]));
    }
    try {
      const raw = localStorage.getItem(storageKey);
      if (raw) return { ...Object.fromEntries(PREF_KEYS.map((k) => [k, true])), ...JSON.parse(raw) };
    } catch {
      /* ignore */
    }
    return Object.fromEntries(PREF_KEYS.map((k) => [k, true]));
  });
  const [saved, setSaved] = useState(false);

  function toggle(label: string) {
    setPrefs((prev) => {
      const next = { ...prev, [label]: !prev[label] };
      localStorage.setItem(storageKey, JSON.stringify(next));
      setSaved(true);
      return next;
    });
  }

  return (
    <div className="space-y-3">
      <ul className="space-y-3">
        {PREF_KEYS.map((label) => (
          <li
            key={label}
            className="flex items-center justify-between rounded-xl border border-border px-4 py-3"
          >
            <span className="text-sm font-semibold text-navy">{label}</span>
            <input
              type="checkbox"
              checked={Boolean(prefs[label])}
              onChange={() => toggle(label)}
              className="h-4 w-4 accent-client-accent"
            />
          </li>
        ))}
      </ul>
      {saved && <p className="text-xs font-semibold text-emerald-700">Saved on this device.</p>}
    </div>
  );
}

