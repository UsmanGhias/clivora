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
    return (
      <div className="space-y-4">
        <div>
          <h1 className="text-2xl font-extrabold">Invoices</h1>
          <p className="text-sm text-text-secondary">Invoices shared with you.</p>
        </div>
        {rows.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-border bg-client-surface p-8 text-center">
            <p className="font-semibold text-navy">No shared invoices yet</p>
            <p className="mt-2 text-sm text-text-secondary">
              Invoices shared by freelancers will appear here with public links and payment status.
            </p>
          </div>
        ) : (
          <div className="overflow-hidden rounded-2xl border border-border bg-surface shadow-sm">
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-border text-sm">
                <thead className="bg-client-surface text-left text-xs font-bold uppercase tracking-wide text-client-accent">
                  <tr>
                    <th className="px-4 py-3">Number</th>
                    <th className="px-4 py-3">Status</th>
                    <th className="px-4 py-3 text-right">Amount</th>
                    <th className="px-4 py-3">Date</th>
                    <th className="px-4 py-3 text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border">
                  {rows.map((r) => {
                    const publicHref = r.public_token ? `/i/${r.public_token}` : null;
                    return (
                      <tr key={r.share_id} className="align-middle">
                        <td className="px-4 py-3 font-semibold text-navy">
                          {r.invoice_number || "Invoice"}
                        </td>
                        <td className="px-4 py-3">
                          <span className="inline-flex rounded-full bg-client-surface px-2.5 py-1 text-xs font-bold capitalize text-client-accent">
                            {statusLabel(r.status)}
                          </span>
                        </td>
                        <td className="px-4 py-3 text-right font-bold text-text-primary">
                          {formatMoney(r.currency, r.total)}
                        </td>
                        <td className="px-4 py-3 text-text-secondary">
                          {formatDate(r.due_date ?? r.updated_at)}
                        </td>
                        <td className="px-4 py-3">
                          <div className="flex justify-end gap-2">
                            {publicHref ? (
                              <>
                                <a
                                  href={publicHref}
                                  className="rounded-lg bg-client-accent px-3 py-1.5 text-xs font-bold text-white"
                                >
                                  View PDF
                                </a>
                                <a
                                  href={publicHref}
                                  className="rounded-lg border border-border px-3 py-1.5 text-xs font-bold text-client-accent"
                                >
                                  Public link
                                </a>
                              </>
                            ) : (
                              <span className="text-xs text-text-muted">No public link</span>
                            )}
                          </div>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>
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

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-extrabold">Invoices</h1>
        <p className="text-sm text-text-secondary">
          Cloud CRM invoices with branded totals, customer links, and collection status.
        </p>
      </div>
      <InvoicesCrmPanel
        initial={invoices}
        customers={customers}
        projects={projects}
        canCreate={gate.ok}
        gateReason={!gate.ok ? gate.reason : undefined}
        upgradeHref={!gate.ok ? gate.upgradeHref : undefined}
      />
    </div>
  );
}
