import Link from "next/link";
import {
  Briefcase,
  FileText,
  MessageSquare,
  Sparkles,
  TrendingUp,
  Bot,
} from "lucide-react";
import { EarningsLineChart } from "@/components/dashboard/EarningsLineChart";
import { ActivityFeed } from "@/components/dashboard/ActivityFeed";
import { ProfileCompleteness } from "@/components/dashboard/ProfileCompleteness";
import { ProjectListCard, type DashboardProject } from "@/components/dashboard/ProjectListCard";
import { PeopleListCard, type PersonRow } from "@/components/dashboard/PeopleListCard";
import { WeekOverview } from "@/components/dashboard/WeekOverview";
import { DonutChart } from "@/components/dashboard/DonutChart";
import { portalGreeting } from "@/lib/portal-nav";
import type { ConnectCreditSummary } from "@/lib/connect-credits";
import { formatConnectCredits } from "@/lib/connect-credits";
import type { Profile } from "@/lib/profile-types";
import { isProPlus } from "@/lib/plan";
import { cn } from "@/lib/utils";

type HomeSummary = {
  pending_proposals?: number;
  active_milestones?: number;
  unread_messages?: number;
  accepted_proposals?: number;
};

type Opportunity = {
  id: string;
  title: string;
  budget: string;
  type: string;
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
  projects: DashboardProject[];
  clients: PersonRow[];
  proposalSlices: Array<{ name: string; value: number; color: string }>;
  opportunities: Opportunity[];
  week: { timeTracked: string; earned: string; tasksDone: number; productivity: number };
};

function KpiCard({
  label,
  value,
  sub,
  trend,
  icon: Icon,
  href,
  iconTone,
}: {
  label: string;
  value: string | number;
  sub?: string;
  trend?: string;
  icon: React.ComponentType<{ className?: string }>;
  href: string;
  iconTone: string;
}) {
  return (
    <Link
      href={href}
      className="group rounded-2xl border border-border bg-surface p-4 shadow-sm transition hover:border-primary/40"
    >
      <div className="flex items-start justify-between gap-2">
        <span className={cn("flex h-10 w-10 items-center justify-center rounded-xl", iconTone)}>
          <Icon className="h-5 w-5" />
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
  projects,
  clients,
  proposalSlices,
  opportunities,
  week,
}: Props) {
  const plus = isProPlus(profile);
  const firstName = (profile.name || "there").split(" ")[0];
  const pending = home.pending_proposals ?? 0;
  const unread = home.unread_messages ?? 0;
  const inProgress = projects.filter((p) => {
    const s = (p.status || "").toLowerCase();
    return s.includes("progress") || s === "active" || s === "ongoing";
  }).length;

  return (
    <div className="space-y-6 pb-8">
      <div className="flex flex-col gap-4 xl:flex-row xl:items-start xl:justify-between">
        <div>
          <h1 className="font-display text-2xl font-extrabold text-navy sm:text-3xl">
            {portalGreeting()}, {firstName}! 👋
          </h1>
          <p className="mt-1 text-sm text-text-secondary">Let&apos;s crush your goals today.</p>
          {credits && (
            <p className="mt-2 text-xs font-semibold text-primary">
              Connect · {formatConnectCredits(credits)}
            </p>
          )}
        </div>
        <div className="w-full max-w-sm">
          <ProfileCompleteness percent={profileCompleteness} successScore={successScore} />
        </div>
      </div>

      <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
        <KpiCard
          label="Total earnings"
          value={`$${invoiceTotal.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`}
          sub="Invoiced in CRM"
          trend={invoiceTotal > 0 ? "+18.2% vs last month" : undefined}
          icon={TrendingUp}
          href="/app/invoices"
          iconTone="bg-primary/10 text-primary"
        />
        <KpiCard
          label="Active projects"
          value={projectCount}
          sub={`${inProgress || home.active_milestones || 0} in progress`}
          icon={Briefcase}
          href="/app/projects"
          iconTone="bg-violet-100 text-violet-700"
        />
        <KpiCard
          label="Pending proposals"
          value={pending}
          sub={pending > 0 ? "Awaiting review" : "Submit on Connect"}
          icon={FileText}
          href="/app/proposals"
          iconTone="bg-amber-100 text-amber-800"
        />
        <KpiCard
          label="Unread messages"
          value={unread}
          sub="From clients"
          icon={MessageSquare}
          href="/app/messages"
          iconTone="bg-sky-100 text-sky-800"
        />
      </div>

      <div className="grid gap-4 xl:grid-cols-3">
        <div className="space-y-4 xl:col-span-2">
          <EarningsLineChart
            total={invoiceTotal}
            accent="teal"
            title="Earnings overview"
            trendLabel={invoiceTotal > 0 ? "↑ Growing this month" : undefined}
          />
          <WeekOverview {...week} />
        </div>
        <ActivityFeed items={activities} viewAllHref="/app/activity" />
      </div>

      <div className="grid gap-4 lg:grid-cols-3">
        <ProjectListCard projects={projects} />
        <PeopleListCard title="Top clients" people={clients} href="/app/clients" />
        <DonutChart
          title="Proposals status"
          slices={proposalSlices}
          centerValue={proposalSlices.reduce((s, x) => s + x.value, 0)}
          centerLabel="Total"
        />
      </div>

      <div className="relative overflow-hidden rounded-2xl bg-navy p-6 text-white shadow-sm">
        <div className="relative z-10 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <div className="flex items-start gap-3">
            <span className="flex h-12 w-12 items-center justify-center rounded-2xl bg-primary/20 text-primary-light">
              <Bot className="h-6 w-6" />
            </span>
            <div>
              <p className="font-display text-lg font-bold">Boost your workflow with AI</p>
              <p className="mt-1 max-w-md text-sm text-white/70">
                Draft proposals, summarize client threads, and plan milestones faster inside CLIVORA.
              </p>
            </div>
          </div>
          <Link
            href="/app/hub"
            className="inline-flex min-h-11 items-center justify-center rounded-xl bg-primary px-5 py-2.5 text-sm font-bold text-white hover:bg-primary-dark"
          >
            Try AI Assistant
          </Link>
        </div>
        <div className="pointer-events-none absolute -right-8 -top-8 h-40 w-40 rounded-full bg-primary/20 blur-2xl" />
      </div>

      <div>
        <div className="mb-3 flex items-center justify-between">
          <h2 className="font-display text-lg font-bold text-navy">Recommended opportunities</h2>
          <Link href="/app/connect" className="text-xs font-semibold text-primary">
            Browse Connect →
          </Link>
        </div>
        {opportunities.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-border bg-surface p-6 text-center text-sm text-text-secondary">
            Open Connect to discover jobs matching your skills.
          </div>
        ) : (
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {opportunities.map((o) => (
              <Link
                key={o.id}
                href="/app/connect"
                className="rounded-2xl border border-border bg-surface p-4 shadow-sm transition hover:border-primary/40"
              >
                <p className="font-semibold text-navy">{o.title}</p>
                <p className="mt-1 text-sm font-bold text-primary">{o.budget}</p>
                <p className="mt-2 text-xs text-text-muted">{o.type}</p>
              </Link>
            ))}
          </div>
        )}
      </div>

      {!plus && (
        <div className="flex flex-col gap-4 rounded-2xl border border-primary/25 bg-gradient-to-r from-primary/5 to-white p-5 sm:flex-row sm:items-center sm:justify-between">
          <div className="flex items-start gap-3">
            <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-primary text-white">
              <Sparkles className="h-5 w-5" />
            </span>
            <div>
              <p className="font-display font-bold text-navy">Unlock more with Pro Plus</p>
              <p className="mt-1 text-sm text-text-secondary">
                Get featured, more Connect credits, advanced analytics and more.
              </p>
            </div>
          </div>
          <Link
            href="/pro?plan=pro_plus"
            className="inline-flex min-h-11 shrink-0 items-center justify-center rounded-xl bg-primary px-5 py-2.5 text-sm font-bold text-white"
          >
            Upgrade now
          </Link>
        </div>
      )}
    </div>
  );
}
