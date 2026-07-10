import { getProfile, isClientAccount } from "@/lib/profile";
import {
  listCustomersServer,
  listInvoicesServer,
  listProjectsServer,
} from "@/lib/crm/server";
import type { CrmInvoice } from "@/lib/crm/api";
import { canCreateInvoice, invoicesCreatedThisMonth } from "@/lib/plan-gates";
import { InvoicesCrmPanel } from "@/components/crm/CrmPanels";
import { DownloadAppCard } from "@/components/app/DownloadAppCard";
import { createClient } from "@/lib/supabase/server";

type InvoiceShareRow = {
  share_id: string;
  invoice_number?: string | null;
  total?: number | null;
  currency?: string | null;
  status?: string | null;
  client_email?: string | null;
  public_token?: string | null;
};

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
          "share_id, invoice_number, total, currency, status, client_email, freelancer_uid, client_uid, public_token, updated_at",
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
          <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center">
            <p className="font-semibold">No shared invoices yet</p>
          </div>
        ) : (
          <ul className="space-y-2">
            {rows.map((r) => (
              <li
                key={r.share_id}
                className="flex items-center justify-between rounded-xl border border-border bg-surface px-4 py-3"
              >
                <div>
                  <p className="font-semibold">{r.invoice_number}</p>
                  <p className="text-sm text-text-secondary">{r.status}</p>
                  {r.public_token && (
                    <a href={`/i/${r.public_token}`} className="text-xs font-semibold text-primary">
                      Public link →
                    </a>
                  )}
                </div>
                <p className="font-bold">
                  {r.currency} {Number(r.total ?? 0).toFixed(2)}
                </p>
              </li>
            ))}
          </ul>
        )}
        <DownloadAppCard title="PDF download & payment confirm in the app" tone="client" />
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
          Cloud CRM invoices. Branded PDF, vault attachments, and payment flows are app-preferred.
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
      <DownloadAppCard title="Branded PDF invoices in the app" />
    </div>
  );
}
