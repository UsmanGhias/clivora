import { getProfile, isClientAccount } from "@/lib/profile";
import {
  listCustomersServer,
  listInvoicesServer,
  listProjectsServer,
} from "@/lib/crm/server";
import type { CrmInvoice } from "@/lib/crm/api";
import { canCreateInvoice, invoicesCreatedThisMonth } from "@/lib/plan-gates";
import { InvoicesCrmPanel } from "@/components/crm/CrmPanels";
import { createClient } from "@/lib/supabase/server";
import { AlertTriangle, Clock, FileText, Plus, Settings, TrendingUp } from "lucide-react";
import { DonutChart } from "@/components/dashboard/DonutChart";
import { PaymentDisclaimer } from "@/components/payments/PaymentDisclaimer";
import {
  FreelancerCard,
  FreelancerPageHeader,
  FreelancerStatCard,
  OutlineButton,
  PrimaryButton,
  money,
} from "@/components/freelancer/ui";

type InvoiceShareRow = {
  share_id: string;
  invoice_number?: string | null;
  total?: number | null;
  currency?: string | null;
  status?: string | null;
  client_email?: string | null;
  public_token?: string | null;
  due_date?: string | null;
  updated_at?: string | null;
};

function formatMoney(currency?: string | null, total?: number | null) {
  return `${currency || "USD"} ${Number(total ?? 0).toFixed(2)}`;
}

function formatDate(value?: string | null) {
  if (!value) return "-";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "-";
  return date.toLocaleDateString(undefined, { month: "short", day: "numeric", year: "numeric" });
}

function statusLabel(status?: string | null) {
  return (status || "shared").replaceAll("_", " ");
}

export default async function InvoicesPage() {
  const profile = await getProfile();
  const client = isClientAccount(profile);
  const supabase = await createClient();
  const uid = profile?.id ?? "";

  if (client) {
    let rows: InvoiceShareRow[] = [];
    try {
      const { data, error } = await supabase
        .from("invoice_shares")
        .select(
          "share_id, invoice_number, total, currency, status, client_email, freelancer_uid, client_uid, public_token, due_date, updated_at",
        )
        .or(`client_uid.eq.${uid},client_email.eq.${profile?.email ?? ""}`)
        .order("updated_at", { ascending: false })
        .limit(40);
      if (!error && data) rows = data;
    } catch {
      rows = [];
    }
    const { ClientInvoicesPanel } = await import("@/components/client/ClientInvoicesPanel");
    return (
      <ClientInvoicesPanel
        rows={rows.map((r) => ({
          ...r,
          freelancer_email: r.client_email,
          issue_date: r.updated_at,
        }))}
      />
    );
  }

  let invoices: CrmInvoice[] = [];
  let customers: Awaited<ReturnType<typeof listCustomersServer>> = [];
  let projects: Awaited<ReturnType<typeof listProjectsServer>> = [];
  try {
    invoices = await listInvoicesServer();
  } catch {
    invoices = [];
  }
  try {
    customers = await listCustomersServer();
  } catch {
    customers = [];
  }
  try {
    projects = await listProjectsServer();
  } catch {
    projects = [];
  }

  // Approximate month count from updated_at when created_at not selected
  const monthCount = invoicesCreatedThisMonth(
    invoices.map((i) => ({ created_at: i.created_at ?? i.updated_at })),
  );
  const gate = canCreateInvoice(profile, monthCount);

  const totalRevenue = invoices.reduce((s, i) => s + (Number(i.total) || 0), 0);
  const paid = invoices
    .filter((i) => (i.status || "").toLowerCase() === "paid")
    .reduce((s, i) => s + (Number(i.total) || 0), 0);
  const pending = invoices
    .filter((i) => {
      const st = (i.status || "").toLowerCase();
      return st === "sent" || st === "pending" || st === "unpaid";
    })
    .reduce((s, i) => s + (Number(i.total) || 0), 0);
  const overdue = invoices
    .filter((i) => (i.status || "").toLowerCase() === "overdue")
    .reduce((s, i) => s + (Number(i.total) || 0), 0);
  const drafts = invoices.filter((i) => (i.status || "").toLowerCase() === "draft").length;
  const pct = (n: number) => (totalRevenue > 0 ? Math.round((n / totalRevenue) * 100) : 0);

  return (
    <div className="space-y-6 pb-10">
      <FreelancerPageHeader
        title="Invoices"
        subtitle="Create, send, and track invoices with branded totals and collection status."
        actions={
          <>
            <PrimaryButton href="#create">
              <Plus className="h-4 w-4" />
              Create Invoice
            </PrimaryButton>
            <OutlineButton href="/app/settings">
              <Settings className="h-4 w-4" />
              Invoice Settings
            </OutlineButton>
          </>
        }
      />

      <PaymentDisclaimer />

      <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-5">
        <FreelancerStatCard
          label="Total Revenue"
          value={money(totalRevenue)}
          icon={TrendingUp}
        />
        <FreelancerStatCard
          label="Paid"
          value={money(paid)}
          sub={`${pct(paid)}% of total`}
          icon={FileText}
          iconTone="bg-emerald-100 text-emerald-700"
        />
        <FreelancerStatCard
          label="Pending"
          value={money(pending)}
          sub={`${pct(pending)}% of total`}
          icon={Clock}
          iconTone="bg-amber-100 text-amber-800"
        />
        <FreelancerStatCard
          label="Overdue"
          value={money(overdue)}
          sub={`${pct(overdue)}% of total`}
          icon={AlertTriangle}
          iconTone="bg-red-100 text-red-700"
        />
        <FreelancerStatCard
          label="Draft"
          value={`${drafts} Invoices`}
          icon={FileText}
          iconTone="bg-sky-100 text-sky-800"
        />
      </div>

      <div className="grid gap-4 xl:grid-cols-[1fr_280px]">
        <div id="create" className="space-y-4">
          <InvoicesCrmPanel
            initial={invoices}
            customers={customers}
            projects={projects}
            canCreate={gate.ok}
            gateReason={!gate.ok ? gate.reason : undefined}
            upgradeHref={!gate.ok ? gate.upgradeHref : undefined}
          />
        </div>
        <aside className="space-y-4">
          <DonutChart
            title="Invoice analytics"
            slices={[
              ...(paid > 0 ? [{ name: "Paid", value: paid, color: "#10B981" }] : []),
              ...(pending > 0 ? [{ name: "Pending", value: pending, color: "#F59E0B" }] : []),
              ...(overdue > 0 ? [{ name: "Overdue", value: overdue, color: "#DC2626" }] : []),
            ]}
            centerValue={money(totalRevenue, 0)}
            centerLabel="Total"
          />
          <FreelancerCard title="How you get paid">
            <p className="text-sm text-text-secondary">
              CLIVORA does not currently process client-to-freelancer payments. Record invoices here
              and settle funds directly with your clients for now.
            </p>
            <ul className="mt-3 space-y-2 text-sm">
              <li className="flex items-center justify-between rounded-xl border border-border px-3 py-2.5">
                <span className="font-semibold text-navy">Manual / off-platform</span>
                <span className="text-xs font-bold text-text-muted">Recorded in CRM</span>
              </li>
              <li className="flex items-center justify-between rounded-xl border border-border px-3 py-2.5">
                <span className="font-semibold text-navy">Google Play (Android)</span>
                <span className="text-xs font-bold text-success">Subscriptions</span>
              </li>
            </ul>
            <a
              href="/pro"
              className="mt-3 inline-block text-sm font-semibold text-primary hover:underline"
            >
              Manage plan →
            </a>
          </FreelancerCard>
          <FreelancerCard title="Quick actions">
            <ul className="space-y-2 text-sm font-semibold text-navy">
              <li>
                <a href="#create" className="flex justify-between rounded-xl border border-border px-3 py-2.5 hover:border-primary/40">
                  Create Invoice <span>→</span>
                </a>
              </li>
              <li>
                <a href="/app/proposals" className="flex justify-between rounded-xl border border-border px-3 py-2.5 hover:border-primary/40">
                  View proposals <span>→</span>
                </a>
              </li>
              <li>
                <a href="/app/settings" className="flex justify-between rounded-xl border border-border px-3 py-2.5 hover:border-primary/40">
                  Invoice settings <span>→</span>
                </a>
              </li>
              <li>
                <a href="#create" className="flex justify-between rounded-xl border border-border px-3 py-2.5 hover:border-primary/40">
                  Recurring Invoices <span>→</span>
                </a>
              </li>
            </ul>
          </FreelancerCard>
        </aside>
      </div>
    </div>
  );
}
