import Link from "next/link";
import {
  ArrowUpRight,
  Briefcase,
  FileText,
  MessageSquare,
  Users,
} from "lucide-react";
import { EarningsLineChart } from "@/components/dashboard/EarningsLineChart";
import { ActivityFeed } from "@/components/dashboard/ActivityFeed";
import { ProfileCompleteness } from "@/components/dashboard/ProfileCompleteness";
import { ProPlusBanner } from "@/components/dashboard/ProPlusBanner";
import { portalGreeting } from "@/lib/portal-nav";
import type { ConnectCreditSummary } from "@/lib/connect-credits";
import { formatConnectCredits } from "@/lib/connect-credits";
import type { Profile } from "@/lib/profile-types";
import { isProPlus } from "@/lib/plan";

type HomeSummary = {
  open_jobs?: number;
  pending_proposals?: number;
  milestones_needing_action?: number;
  unread_messages?: number;
};

type Props = {
  profile: Profile;
  home: HomeSummary;
  projectCount: number;
  invoiceCount: number;
  credits: ConnectCreditSummary | null;
  profileCompleteness: number;
  activities: Array<{ id: string; title: string; detail: string; time: string; kind: string }>;
};

function ClientKpi({
  label,
  value,
  sub,
  icon: Icon,
  href,
}: {
  label: string;
  value: string | number;
  sub?: string;
  icon: React.ComponentType<{ className?: string }>;
  href: string;
}) {
  return (
    <Link
      href={href}
      className="rounded-2xl border border-border bg-surface p-4 shadow-sm transition hover:border-client-accent/40"
    >
      <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-client-surface text-client-accent">
        <Icon className="h-4 w-4" />
      </span>
      <p className="mt-3 text-xs font-semibold uppercase tracking-wide text-text-muted">{label}</p>
      <p className="mt-1 font-display text-2xl font-extrabold text-navy">{value}</p>
      {sub && <p className="mt-1 text-xs text-text-secondary">{sub}</p>}
    </Link>
  );
}

export function ClientDashboard({
  profile,
  home,
  projectCount,
  invoiceCount,
  credits,
  profileCompleteness,
  activities,
}: Props) {
  const plus = isProPlus(profile);
  const name = profile.name || "there";
  const proposals = home.pending_proposals ?? 0;
  const milestones = home.milestones_needing_action ?? 0;
  const unread = home.unread_messages ?? 0;
  const openJobs = home.open_jobs ?? 0;

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
        <div>
          <h1 className="font-display text-2xl font-extrabold text-navy sm:text-3xl">
            {portalGreeting()}, {name} 👋
          </h1>
          <p className="mt-1 text-sm text-text-secondary">
            Review proposals, hire talent, and track project progress.
          </p>
          {credits && (
            <p className="mt-2 text-xs font-medium text-client-accent">
              Connect · {formatConnectCredits(credits)}
            </p>
          )}
        </div>
        <div className="w-full max-w-xs">
          <ProfileCompleteness percent={profileCompleteness} isClient />
        </div>
      </div>

      <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
        <ClientKpi
          label="Open jobs"
          value={openJobs}
          sub="Posted on Connect"
          icon={Briefcase}
          href="/connect/manage"
        />
        <ClientKpi
          label="Pending proposals"
          value={proposals}
          sub="Awaiting your review"
          icon={FileText}
          href="/app/proposals"
        />
        <ClientKpi
          label="Active projects"
          value={projectCount}
          sub={`${milestones} need action`}
          icon={Users}
          href="/app/projects"
        />
        <ClientKpi
          label="Unread messages"
          value={unread}
          sub="From freelancers"
          icon={MessageSquare}
          href="/app/messages"
        />
      </div>

      <div className="grid gap-4 xl:grid-cols-3">
        <div className="xl:col-span-2">
          <EarningsLineChart total={invoiceCount * 850} accent="slate" />
        </div>
        <ActivityFeed items={activities} viewAllHref="/app/activity" />
      </div>

      <div className="rounded-2xl border border-border bg-surface p-5 shadow-sm">
        <h2 className="font-display text-lg font-bold text-navy">Quick actions</h2>
        <div className="mt-4 grid gap-2 sm:grid-cols-2 lg:grid-cols-4">
          {[
            { label: "Post a job", href: "/connect/manage" },
            { label: "Marketplace", href: "/app/connect" },
            { label: "Proposals", href: "/app/proposals" },
            { label: "Invoices", href: "/app/invoices" },
          ].map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className="inline-flex items-center justify-between rounded-xl border border-border px-4 py-3 text-sm font-semibold text-navy hover:border-client-accent/40 hover:text-client-accent"
            >
              {item.label}
              <ArrowUpRight className="h-4 w-4" />
            </Link>
          ))}
        </div>
      </div>

      <ProPlusBanner isClient isPlus={plus} />
    </div>
  );
}
