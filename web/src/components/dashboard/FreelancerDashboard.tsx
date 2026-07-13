import Link from "next/link";
import {
  ArrowUpRight,
  Briefcase,
  FileText,
  MessageSquare,
  Star,
  TrendingUp,
} from "lucide-react";
import { EarningsLineChart } from "@/components/dashboard/EarningsLineChart";
import { ActivityFeed } from "@/components/dashboard/ActivityFeed";
import { TasksWidget } from "@/components/dashboard/TasksWidget";
import { ProfileCompleteness } from "@/components/dashboard/ProfileCompleteness";
import { ProPlusBanner } from "@/components/dashboard/ProPlusBanner";
import { portalGreeting } from "@/lib/portal-nav";
import type { ConnectCreditSummary } from "@/lib/connect-credits";
import { formatConnectCredits } from "@/lib/connect-credits";
import type { Profile } from "@/lib/profile-types";
import { isProPlus } from "@/lib/plan";

type HomeSummary = {
  pending_proposals?: number;
  active_milestones?: number;
  unread_messages?: number;
  accepted_proposals?: number;
};

type Props = {
  profile: Profile;
  home: HomeSummary;
  projectCount: number;
  invoiceTotal: number;
  credits: ConnectCreditSummary | null;
  profileCompleteness: number;
  successScore: number;
  activities: Array<{ id: string; title: string; detail: string; time: string; kind: string }>;
  tasks: Array<{ id: string; title: string; project: string; due: string; priority: "high" | "medium" | "low" }>;
};

function KpiCard({
  label,
  value,
  sub,
  trend,
  icon: Icon,
  href,
}: {
  label: string;
  value: string | number;
  sub?: string;
  trend?: string;
  icon: React.ComponentType<{ className?: string }>;
  href: string;
}) {
  return (
    <Link
      href={href}
      className="group rounded-2xl border border-border bg-surface p-4 shadow-sm transition hover:border-primary/40"
    >
      <div className="flex items-start justify-between gap-2">
        <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-primary/10 text-primary">
          <Icon className="h-4 w-4" />
        </span>
        {trend && (
          <span className="inline-flex items-center gap-0.5 rounded-lg bg-success/10 px-2 py-0.5 text-[10px] font-bold text-success">
            <TrendingUp className="h-3 w-3" />
            {trend}
          </span>
        )}
      </div>
      <p className="mt-3 text-xs font-semibold uppercase tracking-wide text-text-muted">{label}</p>
      <p className="mt-1 font-display text-2xl font-extrabold text-navy">{value}</p>
      {sub && <p className="mt-1 text-xs text-text-secondary">{sub}</p>}
    </Link>
  );
}

export function FreelancerDashboard({
  profile,
  home,
  projectCount,
  invoiceTotal,
  credits,
  profileCompleteness,
  successScore,
  activities,
  tasks,
}: Props) {
  const plus = isProPlus(profile);
  const name = profile.name || "there";
  const pending = home.pending_proposals ?? 0;
  const unread = home.unread_messages ?? 0;
  const activeMilestones = home.active_milestones ?? 0;

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
        <div>
          <h1 className="font-display text-2xl font-extrabold text-navy sm:text-3xl">
            {portalGreeting()}, {name} 👋
          </h1>
          <p className="mt-1 text-sm text-text-secondary">Let&apos;s crush your goals today.</p>
          {credits && (
            <p className="mt-2 text-xs font-medium text-primary">
              Connect · {formatConnectCredits(credits)}
            </p>
          )}
        </div>
        <div className="w-full max-w-xs">
          <ProfileCompleteness percent={profileCompleteness} />
        </div>
      </div>

      <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-5">
        <KpiCard
          label="Total earnings"
          value={`$${invoiceTotal.toLocaleString()}`}
          sub="Invoiced in CRM"
          trend={invoiceTotal > 0 ? "+18.2% vs last month" : undefined}
          icon={TrendingUp}
          href="/app/invoices"
        />
        <KpiCard
          label="Active projects"
          value={projectCount}
          sub={`${activeMilestones} in progress`}
          icon={Briefcase}
          href="/app/projects"
        />
        <KpiCard
          label="Pending proposals"
          value={pending}
          sub={pending > 0 ? "Awaiting client review" : "Submit on Connect"}
          icon={FileText}
          href="/app/proposals"
        />
        <KpiCard
          label="Unread messages"
          value={unread}
          sub="New from clients"
          icon={MessageSquare}
          href="/app/messages"
        />
        <Link
          href="/app/hub"
          className="rounded-2xl border border-border bg-surface p-4 shadow-sm transition hover:border-primary/40"
        >
          <div className="flex items-start justify-between">
            <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-primary/10 text-primary">
              <Star className="h-4 w-4" />
            </span>
            <span className="rounded-lg bg-primary/10 px-2 py-0.5 text-[10px] font-bold uppercase text-primary-dark">
              Top rated
            </span>
          </div>
          <p className="mt-3 text-xs font-semibold uppercase tracking-wide text-text-muted">
            Success score
          </p>
          <p className="mt-1 font-display text-2xl font-extrabold text-navy">{successScore}%</p>
        </Link>
      </div>

      <div className="grid gap-4 xl:grid-cols-3">
        <div className="xl:col-span-2">
          <EarningsLineChart total={invoiceTotal} accent="teal" />
        </div>
        <ActivityFeed items={activities} viewAllHref="/app/activity" />
      </div>

      <div className="grid gap-4 lg:grid-cols-2">
        <TasksWidget tasks={tasks} viewAllHref="/app/tasks" />
        <div className="rounded-2xl border border-border bg-surface p-5 shadow-sm">
          <h2 className="font-display text-lg font-bold text-navy">Quick actions</h2>
          <div className="mt-4 grid gap-2 sm:grid-cols-2">
            {[
              { label: "Find jobs", href: "/app/connect" },
              { label: "My proposals", href: "/app/proposals" },
              { label: "Clients", href: "/app/clients" },
              { label: "Billing", href: "/app/invoices" },
            ].map((item) => (
              <Link
                key={item.href}
                href={item.href}
                className="inline-flex items-center justify-between rounded-xl border border-border px-4 py-3 text-sm font-semibold text-navy hover:border-primary/40 hover:text-primary"
              >
                {item.label}
                <ArrowUpRight className="h-4 w-4" />
              </Link>
            ))}
          </div>
        </div>
      </div>

      <ProPlusBanner isClient={false} isPlus={plus} />
    </div>
  );
}
