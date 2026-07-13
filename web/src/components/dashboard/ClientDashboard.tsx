import Link from "next/link";
import {
  Briefcase,
  DollarSign,
  FileText,
  MessageSquare,
  Plus,
  Sparkles,
  UserPlus,
  Users,
} from "lucide-react";
import { EarningsLineChart } from "@/components/dashboard/EarningsLineChart";
import { ActivityFeed } from "@/components/dashboard/ActivityFeed";
import { ProjectListCard, type DashboardProject } from "@/components/dashboard/ProjectListCard";
import { PeopleListCard, type PersonRow } from "@/components/dashboard/PeopleListCard";
import { DonutChart } from "@/components/dashboard/DonutChart";
import { ConnectCreditsWidget } from "@/components/connect/ConnectCreditsWidget";
import { portalGreeting } from "@/lib/portal-nav";
import type { ConnectCreditSummary } from "@/lib/connect-credits";
import { formatConnectCredits } from "@/lib/connect-credits";
import type { Profile } from "@/lib/profile-types";
import { isProPlus } from "@/lib/plan";
import { cn } from "@/lib/utils";

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
  totalSpent: number;
  paidTotal: number;
  escrowHeld: number;
  refunds: number;
  credits: ConnectCreditSummary | null;
  activities: Array<{ id: string; title: string; detail: string; time: string; kind: string }>;
  projects: DashboardProject[];
  freelancers: PersonRow[];
  spendSlices: Array<{ name: string; value: number; color: string }>;
};

function ClientKpi({
  label,
  value,
  sub,
  icon: Icon,
  href,
  iconTone,
}: {
  label: string;
  value: string | number;
  sub?: string;
  icon: React.ComponentType<{ className?: string }>;
  href: string;
  iconTone: string;
}) {
  return (
    <Link
      href={href}
      className="rounded-2xl border border-border bg-surface p-4 shadow-sm transition hover:border-client-accent/40"
    >
      <span className={cn("flex h-10 w-10 items-center justify-center rounded-xl", iconTone)}>
        <Icon className="h-5 w-5" />
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
  totalSpent,
  paidTotal,
  escrowHeld,
  refunds,
  credits,
  activities,
  projects,
  freelancers,
  spendSlices,
}: Props) {
  const plus = isProPlus(profile);
  const firstName = (profile.name || "there").split(" ")[0];
  const proposals = home.pending_proposals ?? 0;
  const unread = home.unread_messages ?? 0;
  const openJobs = home.open_jobs ?? 0;
  const inProgress = projects.filter((p) => {
    const s = (p.status || "").toLowerCase();
    return s.includes("progress") || s === "active";
  }).length;

  return (
    <div className="space-y-6 pb-8">
      <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
        <div>
          <h1 className="font-display text-2xl font-extrabold text-navy sm:text-3xl">
            {portalGreeting()}, {firstName} 👋
          </h1>
          <p className="mt-1 text-sm text-text-secondary">
            Hire talent, review proposals, and track spending in one place.
          </p>
          {credits && (
            <p className="mt-2 text-xs font-semibold text-client-accent">
              Connect · {formatConnectCredits(credits)}
            </p>
          )}
        </div>
        <div className="flex flex-wrap gap-2">
          <Link
            href="/connect/manage"
            className="inline-flex min-h-11 items-center gap-1.5 rounded-xl bg-client-accent px-4 py-2.5 text-sm font-bold text-white hover:bg-client-header"
          >
            <Plus className="h-4 w-4" />
            Post a job
          </Link>
          <Link
            href="/app/hub"
            className="inline-flex min-h-11 items-center gap-1.5 rounded-xl border-2 border-client-accent px-4 py-2.5 text-sm font-bold text-client-accent hover:bg-client-surface"
          >
            <UserPlus className="h-4 w-4" />
            Invite team
          </Link>
        </div>
      </div>

      <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-5">
        <ClientKpi
          label="Open jobs"
          value={openJobs}
          sub="New applicants waiting"
          icon={Briefcase}
          href="/connect/manage"
          iconTone="bg-client-surface text-client-accent"
        />
        <ClientKpi
          label="Active projects"
          value={projectCount}
          sub={`${inProgress || home.milestones_needing_action || 0} in progress`}
          icon={Users}
          href="/app/projects"
          iconTone="bg-violet-100 text-violet-700"
        />
        <ClientKpi
          label="Pending proposals"
          value={proposals}
          sub="Awaiting your review"
          icon={FileText}
          href="/app/proposals"
          iconTone="bg-amber-100 text-amber-800"
        />
        <ClientKpi
          label="Unread messages"
          value={unread}
          sub="From freelancers"
          icon={MessageSquare}
          href="/app/messages"
          iconTone="bg-sky-100 text-sky-800"
        />
        <ClientKpi
          label="Total spent"
          value={`$${totalSpent.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`}
          sub="This month"
          icon={DollarSign}
          href="/app/invoices"
          iconTone="bg-emerald-100 text-emerald-800"
        />
      </div>

      <div className="grid gap-4 xl:grid-cols-[1fr_300px]">
        <div className="space-y-4">
          <EarningsLineChart
            total={totalSpent}
            accent="slate"
            title="Spending overview"
            trendLabel={totalSpent > 0 ? "↑ 12.5% vs last month" : undefined}
            summaryBoxes={[
              {
                label: "Total spent",
                value: `$${totalSpent.toLocaleString()}`,
                tone: "bg-client-surface text-client-accent",
              },
              {
                label: "Escrow held",
                value: `$${escrowHeld.toLocaleString()}`,
                tone: "bg-sky-50 text-sky-800",
              },
              {
                label: "Paid to freelancers",
                value: `$${paidTotal.toLocaleString()}`,
                tone: "bg-violet-50 text-violet-800",
              },
              {
                label: "Refunds",
                value: `$${refunds.toLocaleString()}`,
                tone: "bg-amber-50 text-amber-900",
              },
            ]}
          />

          <div className="grid gap-4 lg:grid-cols-3">
            <ProjectListCard projects={projects} isClient />
            <PeopleListCard
              title="Top freelancers"
              people={freelancers}
              href="/app/connect"
              isClient
              amountHeader="Rate"
            />
            <DonutChart
              title="Spending by category"
              slices={spendSlices}
              centerLabel="Spend"
              centerValue={spendSlices.length ? "%" : "—"}
            />
          </div>
        </div>

        <aside className="space-y-4">
          <ActivityFeed items={activities} viewAllHref="/app/activity" accent="slate" />
          <ConnectCreditsWidget signedIn isClient />
          <div className="rounded-2xl border border-client-accent/20 bg-gradient-to-br from-client-surface to-white p-5 shadow-sm">
            <div className="flex items-start gap-3">
              <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-client-accent text-white">
                <Sparkles className="h-5 w-5" />
              </span>
              <div>
                <p className="font-display font-bold text-navy">
                  {plus ? "Unlock more with Pro Plus" : "Upgrade to Pro Plus"}
                </p>
                <p className="mt-1 text-sm text-text-secondary">
                  Featured talent, more Connect credits, and team-ready hiring tools.
                </p>
              </div>
            </div>
            <Link
              href="/pro?plan=pro_plus"
              className="mt-4 inline-flex w-full items-center justify-center rounded-xl bg-client-accent px-4 py-2.5 text-sm font-bold text-white hover:bg-client-header"
            >
              {plus ? "Manage plan" : "Upgrade now"}
            </Link>
          </div>
        </aside>
      </div>
    </div>
  );
}
