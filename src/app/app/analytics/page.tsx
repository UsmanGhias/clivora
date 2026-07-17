import { redirect } from "next/navigation";
import Link from "next/link";
import {
  BarChart3,
  Briefcase,
  CheckCircle2,
  Clock,
  FileText,
  Star,
  TrendingUp,
  Users,
  Wallet,
} from "lucide-react";
import { getProfile, isClientAccount } from "@/lib/profile";
import { loadFreelancerFinance } from "@/lib/freelancer-finance";
import { EarningsLineChart } from "@/components/dashboard/EarningsLineChart";
import { DonutChart } from "@/components/dashboard/DonutChart";
import { MonthlyBarChart } from "@/components/dashboard/MonthlyBarChart";
import { ActivityFeed } from "@/components/dashboard/ActivityFeed";
import { PaymentDisclaimer } from "@/components/payments/PaymentDisclaimer";
import {
  FreelancerCard,
  FreelancerPageHeader,
  FreelancerStatCard,
  PrimaryButton,
  money,
} from "@/components/freelancer/ui";
import {
  ClientCard,
  ClientPageHeader,
  ClientPrimaryButton,
  ClientStatCard,
  ClientStatusPill,
  money as clientMoney,
} from "@/components/client/ui";
import { createClient } from "@/lib/supabase/server";

export const metadata = { title: "Analytics" };

export default async function AnalyticsPage() {
  const profile = await getProfile();
  if (!profile) redirect("/login");
  const isClient = isClientAccount(profile);

  if (isClient) {
    const supabase = await createClient();
    type ShareRow = {
      share_id: string;
      invoice_number: string | null;
      total: number | null;
      status: string | null;
      currency: string | null;
      due_date: string | null;
      freelancer_email: string | null;
      updated_at: string | null;
    };
    let shares: ShareRow[] = [];
    try {
      const { data } = await supabase
        .from("invoice_shares")
        .select(
          "share_id, invoice_number, total, status, currency, due_date, freelancer_email, updated_at",
        )
        .eq("client_uid", profile.id)
        .order("updated_at", { ascending: false })
        .limit(100);
      shares = (data ?? []) as ShareRow[];
    } catch {
      shares = [];
    }
    let total = 0;
    let paid = 0;
    let pending = 0;
    let overdue = 0;
    for (const r of shares) {
      const amt = Number(r.total) || 0;
      total += amt;
      const s = (r.status || "").toLowerCase();
      if (s === "paid") paid += amt;
      else if (s === "overdue") overdue += amt;
      else pending += amt;
    }

    return (
      <div className="space-y-6 pb-10">
        <ClientPageHeader
          title="Reports"
          subtitle="Spending report from invoices shared with your account."
          icon={BarChart3}
          actions={
            <ClientPrimaryButton href="/app/invoices">
              <FileText className="h-4 w-4" />
              Open invoices
            </ClientPrimaryButton>
          }
        />
        <PaymentDisclaimer />
        <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
          <ClientStatCard label="Total spend" value={clientMoney(total)} icon={Wallet} />
          <ClientStatCard label="Paid" value={clientMoney(paid)} icon={CheckCircle2} iconTone="bg-emerald-100 text-emerald-700" />
          <ClientStatCard label="Pending" value={clientMoney(pending)} icon={FileText} iconTone="bg-amber-100 text-amber-800" />
          <ClientStatCard label="Overdue" value={clientMoney(overdue)} icon={FileText} iconTone="bg-red-100 text-red-700" />
        </div>
        <ClientCard title="Invoice spending">
          {shares.length === 0 ? (
            <p className="rounded-xl border border-dashed border-border px-4 py-8 text-center text-sm text-text-secondary">
              No shared invoices yet. When freelancers share invoices, they appear here.
            </p>
          ) : (
            <ul className="divide-y divide-border">
              {shares.map((r) => (
                <li key={r.share_id} className="flex flex-wrap items-center justify-between gap-2 py-3">
                  <div className="min-w-0">
                    <p className="font-semibold text-navy">
                      {r.invoice_number || r.share_id}
                    </p>
                    <p className="truncate text-xs text-text-muted">
                      {r.freelancer_email || "Freelancer"}
                      {r.due_date ? ` · due ${new Date(r.due_date).toLocaleDateString()}` : ""}
                    </p>
                  </div>
                  <div className="flex items-center gap-2">
                    <p className="font-bold text-navy">{clientMoney(Number(r.total) || 0)}</p>
                    <ClientStatusPill
                      tone={
                        (r.status || "").toLowerCase() === "paid"
                          ? "green"
                          : (r.status || "").toLowerCase() === "overdue"
                            ? "red"
                            : "amber"
                      }
                    >
                      {r.status || "pending"}
                    </ClientStatusPill>
                  </div>
                </li>
              ))}
            </ul>
          )}
        </ClientCard>
      </div>
    );
  }

  const fin = await loadFreelancerFinance(profile.id);
  const activeProjects = fin.projects.filter((p) => {
    const s = (p.status || "").toLowerCase();
    return !["completed", "done", "cancelled"].includes(s);
  }).length;
  const completedProjects = fin.projects.filter((p) => {
    const s = (p.status || "").toLowerCase();
    return ["completed", "done"].includes(s);
  }).length;
  const hoursLabel = `${Math.floor(fin.timeHours)}h ${Math.round((fin.timeHours % 1) * 60)}m`;
  const successRate = fin.projects.length
    ? Math.round((completedProjects / Math.max(1, fin.projects.length)) * 100)
    : null;

  const nonBillable = Math.max(0, fin.timeHours - fin.billableHours);
  const performance = [
    fin.billableHours > 0
      ? { name: "Billable", value: Math.round(fin.billableHours * 10) / 10, color: "#0D9488" }
      : null,
    nonBillable > 0
      ? { name: "Non-billable", value: Math.round(nonBillable * 10) / 10, color: "#0EA5E9" }
      : null,
  ].filter(Boolean) as Array<{ name: string; value: number; color: string }>;

  const projectSlices = [
    { name: "Completed", value: completedProjects, color: "#0EA5E9" },
    { name: "In Progress", value: activeProjects, color: "#0D9488" },
    {
      name: "On Hold",
      value: fin.projects.filter((p) => (p.status || "").toLowerCase().includes("hold")).length,
      color: "#F59E0B",
    },
  ].filter((x) => x.value > 0);

  return (
    <div className="space-y-6 pb-10">
      <FreelancerPageHeader
        title="Analytics"
        subtitle="Track your performance, earnings, projects and growth."
        icon={BarChart3}
        actions={
          <PrimaryButton href="/app/earnings">
            <Wallet className="h-4 w-4" />
            View earnings
          </PrimaryButton>
        }
      />

      <PaymentDisclaimer />

      <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-6">
        <FreelancerStatCard
          label="Total Earnings"
          value={money(fin.totalRevenue)}
          icon={TrendingUp}
        />
        <FreelancerStatCard
          label="Billable Hours"
          value={hoursLabel}
          icon={Clock}
          iconTone="bg-sky-100 text-sky-800"
        />
        <FreelancerStatCard
          label="Active Projects"
          value={activeProjects || fin.projects.length}
          icon={Briefcase}
          iconTone="bg-violet-100 text-violet-800"
        />
        <FreelancerStatCard
          label="Completed Projects"
          value={completedProjects}
          icon={CheckCircle2}
          iconTone="bg-emerald-100 text-emerald-700"
        />
        <FreelancerStatCard
          label="Clients"
          value={fin.customers.length}
          icon={Users}
          iconTone="bg-amber-100 text-amber-800"
        />
        <FreelancerStatCard
          label="Success Rate"
          value={successRate == null ? "—" : `${successRate}%`}
          sub={successRate == null ? "No projects yet" : "Completed / total projects"}
          icon={Star}
          iconTone="bg-fuchsia-100 text-fuchsia-800"
        />
      </div>

      <div className="grid gap-4 xl:grid-cols-3">
        <div className="xl:col-span-2">
          <EarningsLineChart
            total={fin.totalRevenue}
            title="Earnings overview"
            accent="teal"
            summaryBoxes={[
              {
                label: "Invoice total",
                value: money(fin.totalRevenue),
                tone: "bg-primary/10 text-primary-dark",
              },
              {
                label: "Paid",
                value: money(fin.paid),
                tone: "bg-sky-50 text-sky-800",
              },
            ]}
          />
        </div>
        <DonutChart
          title="Hours breakdown"
          slices={performance}
          centerLabel="Hours"
        />
      </div>

      <div className="grid gap-4 lg:grid-cols-2">
        <FreelancerCard title="Earnings by month">
          <MonthlyBarChart series={[]} />
        </FreelancerCard>
        <DonutChart
          title="Projects summary"
          slices={projectSlices}
          centerValue={fin.projects.length}
          centerLabel="Total"
        />
      </div>

      <div className="grid gap-4 lg:grid-cols-2">
        <ActivityFeed items={fin.activities} viewAllHref="/app/notifications" />
        <FreelancerCard title="Insights">
          <ul className="space-y-3 text-sm">
            <li className="rounded-xl bg-primary/5 px-3 py-3">
              <p className="font-bold text-navy">Keep going</p>
              <p className="mt-1 text-text-secondary">
                {fin.projects.length === 0
                  ? "Create a project or send a proposal to start building your track record."
                  : "Track hours and invoices so your analytics stay grounded in real activity."}
              </p>
            </li>
            <li>
              <Link href="/app/connect" className="text-sm font-semibold text-primary">
                Find more jobs →
              </Link>
            </li>
          </ul>
        </FreelancerCard>
      </div>
    </div>
  );
}
