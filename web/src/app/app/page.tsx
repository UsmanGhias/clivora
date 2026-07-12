import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { getProfile, isClientAccount, planLabel } from "@/lib/profile";
import { site } from "@/lib/site";
import { SmartAppCta } from "@/components/app/SmartAppCta";
import { DashboardCharts } from "@/components/app/DashboardCharts";
import { formatConnectCredits, type ConnectCreditSummary } from "@/lib/connect-credits";

type HomeSummary = {
  open_jobs?: number;
  pending_proposals?: number;
  accepted_proposals?: number;
  milestones_needing_action?: number;
  active_milestones?: number;
  unread_messages?: number;
};

export default async function AppHomePage() {
  const profile = await getProfile();
  const client = isClientAccount(profile);
  const plan = planLabel(profile);
  const supabase = await createClient();
  const uid = profile?.id ?? "";

  let invoiceCount = 0;
  let projectCount = 0;
  let notifCount = 0;
  let home: HomeSummary = {};
  let credits: ConnectCreditSummary | null = null;

  try {
    const [inv, proj, notif, summaryRes, creditRes] = await Promise.all([
      supabase
        .from("invoice_shares")
        .select("share_id", { count: "exact", head: true })
        .eq(client ? "client_uid" : "freelancer_uid", uid),
      supabase
        .from("project_shares")
        .select("share_id", { count: "exact", head: true })
        .eq(client ? "client_uid" : "freelancer_uid", uid),
      supabase
        .from("notifications")
        .select("id", { count: "exact", head: true })
        .eq("user_uid", uid)
        .eq("is_read", false),
      supabase.rpc(client ? "client_home_summary" : "freelancer_home_summary"),
      supabase.rpc("connect_credit_summary"),
    ]);
    invoiceCount = inv.count ?? 0;
    projectCount = proj.count ?? 0;
    notifCount = notif.count ?? 0;
    if (summaryRes.data && typeof summaryRes.data === "object") {
      home = summaryRes.data as HomeSummary;
    }
    if (Array.isArray(creditRes.data) && creditRes.data[0]) {
      credits = creditRes.data[0] as ConnectCreditSummary;
    }
  } catch {
    /* ignore */
  }

  let crmStats = {
    clientCount: 0,
    crmProjectCount: 0,
    paidCount: 0,
    outstandingCount: 0,
    invoiceTotal: 0,
  };
  if (!client && uid) {
    try {
      const [customers, projects, invoices] = await Promise.all([
        supabase
          .from("crm_customers")
          .select("id", { count: "exact", head: true })
          .eq("owner_uid", uid),
        supabase
          .from("crm_projects")
          .select("id", { count: "exact", head: true })
          .eq("owner_uid", uid),
        supabase
          .from("crm_invoices")
          .select("total, status")
          .eq("owner_uid", uid)
          .limit(500),
      ]);
      const invRows = invoices.data ?? [];
      crmStats = {
        clientCount: customers.count ?? 0,
        crmProjectCount: projects.count ?? 0,
        paidCount: invRows.filter((i) => i.status === "paid").length,
        outstandingCount: invRows.filter(
          (i) => i.status !== "paid" && i.status !== "cancelled",
        ).length,
        invoiceTotal: invRows.reduce((s, i) => s + (Number(i.total) || 0), 0),
      };
    } catch {
      /* ignore */
    }
  }

  const pendingProposals = home.pending_proposals ?? 0;
  const milestones = client
    ? (home.milestones_needing_action ?? 0)
    : (home.active_milestones ?? 0);
  const unread = home.unread_messages ?? notifCount;

  return (
    <div className="space-y-6">
      <section
        className={`rounded-2xl p-6 text-white shadow-lg ${
          client ? "bg-client-gradient" : "bg-brand-gradient"
        }`}
      >
        <p className="text-sm text-white/70">Welcome back</p>
        <h1 className="mt-1 text-2xl font-extrabold">
          {profile?.name || (client ? "Client portal" : "Freelancer workspace")}
        </h1>
        <p className="mt-2 text-sm text-white/80">
          Plan: <span className="font-semibold">{plan}</span>
          {credits ? ` · Connect ${formatConnectCredits(credits)}` : ""}
        </p>
        <div className="mt-4 grid grid-cols-2 gap-2 sm:grid-cols-4">
          <Stat label="Needs action" value={pendingProposals + milestones} />
          <Stat label="Projects" value={projectCount} />
          <Stat label="Invoices" value={invoiceCount} />
          <Stat label="Unread" value={unread} />
        </div>
        <div className="mt-4 flex flex-wrap gap-2">
          {client ? (
            <Link
              href="/connect/manage"
              className="min-h-11 rounded-full bg-client-accent px-4 py-2 text-sm font-semibold text-white"
            >
              Post a job
            </Link>
          ) : (
            <Link
              href="/connect"
              className="min-h-11 rounded-full bg-primary px-4 py-2 text-sm font-semibold text-white"
            >
              Find work on Connect
            </Link>
          )}
          <Link
            href="/app/messages"
            className="min-h-11 rounded-full bg-white/15 px-4 py-2 text-sm font-semibold hover:bg-white/25"
          >
            Messages
          </Link>
          <Link
            href="/app/invoices"
            className="min-h-11 rounded-full bg-white/15 px-4 py-2 text-sm font-semibold hover:bg-white/25"
          >
            Invoices
          </Link>
        </div>
      </section>

      <section className="grid gap-3 sm:grid-cols-3">
        <PriorityCard
          title="Pending proposals"
          value={pendingProposals}
          href="/connect"
          client={client}
        />
        <PriorityCard
          title={client ? "Milestones to review" : "Active milestones"}
          value={milestones}
          href="/connect"
          client={client}
        />
        <PriorityCard
          title="Unread messages"
          value={unread}
          href="/app/messages"
          client={client}
        />
      </section>

      <section className="grid gap-4 sm:grid-cols-2">
        {client ? (
          <>
            <HomeCard title="Invoices" body="Pay, confirm, and download shared invoices." href="/app/invoices" client />
            <HomeCard title="Projects" body="Progress, files, and what needs your review." href="/app/projects" client />
            <HomeCard title="Updates" body="What changed across messages, invoices, and work." href="/app/activity" client />
            <HomeCard title="Connect" body="Hire with monthly credits · $0 platform fee." href="/connect" client />
          </>
        ) : (
          <>
            <HomeCard title="Clients" body="CRM list with follow-ups and linked work." href="/app/clients" />
            <HomeCard title="Work" body="Projects, pipeline, and deadlines." href="/app/projects" />
            <HomeCard title="Billing" body="Invoice ledger and collections." href="/app/invoices" />
            <HomeCard title="Hub" body="Alerts, readiness, and quick create." href="/app/hub" />
          </>
        )}
      </section>

      {!client && (
        <DashboardCharts
          invoiceTotal={crmStats.invoiceTotal}
          projectCount={crmStats.crmProjectCount}
          clientCount={crmStats.clientCount}
          paidCount={crmStats.paidCount}
          outstandingCount={crmStats.outstandingCount}
        />
      )}

      <SmartAppCta
        tone={client ? "client" : "freelancer"}
        title={
          client
            ? "Prefer the Android client portal for contracts and offline files"
            : "Prefer the Android app for offline CRM, PDF branding, and vault"
        }
        body="Web completes day-to-day review, messaging, invoices, and Connect. The app adds offline depth when you need it."
        deepPath={client ? "open/client-portal" : "open/dashboard"}
      />
      <p className="text-center text-xs text-text-muted">
        Pricing reference · Pro {site.pricing.proMonthlyLabel}/mo · Pro Plus{" "}
        {site.pricing.proPlusMonthlyLabel}/mo
      </p>
    </div>
  );
}

function Stat({ label, value }: { label: string; value: number }) {
  return (
    <div className="rounded-xl bg-white/10 px-3 py-2 text-center">
      <p className="text-lg font-extrabold">{value}</p>
      <p className="text-[10px] uppercase tracking-wide text-white/70">{label}</p>
    </div>
  );
}

function PriorityCard({
  title,
  value,
  href,
  client,
}: {
  title: string;
  value: number;
  href: string;
  client?: boolean;
}) {
  return (
    <Link
      href={href}
      className={`rounded-2xl border bg-surface p-4 shadow-sm ${
        client ? "border-border hover:border-client-accent/40" : "border-border hover:border-primary/40"
      }`}
    >
      <p className="text-xs font-semibold uppercase tracking-wide text-text-muted">{title}</p>
      <p className={`mt-1 text-2xl font-extrabold ${client ? "text-client-accent" : "text-primary"}`}>
        {value}
      </p>
    </Link>
  );
}

function HomeCard({
  title,
  body,
  href,
  client,
}: {
  title: string;
  body: string;
  href: string;
  client?: boolean;
}) {
  return (
    <Link
      href={href}
      className={`rounded-2xl border bg-surface p-5 shadow-sm transition ${
        client
          ? "border-border hover:border-client-accent/50"
          : "border-border hover:border-primary/40"
      }`}
    >
      <h2 className="font-bold text-text-primary">{title}</h2>
      <p className="mt-1 text-sm text-text-secondary">{body}</p>
    </Link>
  );
}
