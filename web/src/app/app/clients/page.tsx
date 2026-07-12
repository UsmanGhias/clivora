import Link from "next/link";
import { getProfile, isClientAccount } from "@/lib/profile";
import { listCustomersServer } from "@/lib/crm/server";
import { canCreateCustomer } from "@/lib/plan-gates";
import { CustomersCrmPanel } from "@/components/crm/CrmPanels";
import { createClient } from "@/lib/supabase/server";

type SharedWorkRow = {
  share_id: string;
  freelancer_email?: string | null;
  project_name?: string | null;
  status?: string | null;
  updated_at?: string | null;
};

function formatDate(value?: string | null) {
  if (!value) return "";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "";
  return date.toLocaleDateString(undefined, { month: "short", day: "numeric" });
}

export default async function ClientsPage() {
  const profile = await getProfile();
  const client = isClientAccount(profile);
  let customers: Awaited<ReturnType<typeof listCustomersServer>> = [];
  try {
    customers = await listCustomersServer();
  } catch {
    customers = [];
  }

  if (client) {
    const supabase = await createClient();
    let sharedWork: SharedWorkRow[] = [];
    try {
      const { data } = await supabase
        .from("project_shares")
        .select("share_id, freelancer_email, project_name, status, updated_at")
        .eq("client_uid", profile?.id ?? "")
        .order("updated_at", { ascending: false })
        .limit(20);
      if (data) sharedWork = data;
    } catch {
      sharedWork = [];
    }
    const freelancers = Array.from(
      new Set(sharedWork.map((r) => r.freelancer_email).filter(Boolean) as string[]),
    );

    return (
      <div className="space-y-4">
        <div>
          <h1 className="text-2xl font-extrabold">Clients</h1>
          <p className="text-sm text-text-secondary">
            Freelancers connected to your client workspace and the work they have shared.
          </p>
        </div>
        <div className="grid gap-4 sm:grid-cols-2">
          <section className="rounded-2xl border border-border bg-surface p-5 shadow-sm">
            <p className="text-xs font-bold uppercase tracking-wide text-client-accent">
              Connected freelancers
            </p>
            <p className="mt-1 text-3xl font-extrabold text-navy">{freelancers.length}</p>
            <p className="mt-2 text-sm text-text-secondary">
              {freelancers.length > 0
                ? freelancers.slice(0, 3).join(", ")
                : "Accept a Connect match or receive shared work to build this list."}
            </p>
          </section>
          <section className="rounded-2xl border border-border bg-client-surface p-5 shadow-sm">
            <p className="text-xs font-bold uppercase tracking-wide text-client-accent">Shared work</p>
            <p className="mt-1 text-3xl font-extrabold text-navy">{sharedWork.length}</p>
            <p className="mt-2 text-sm text-text-secondary">
              Projects, invoices, and updates from freelancers stay available in your web portal.
            </p>
            <Link
              href="/connect"
              className="mt-4 inline-flex rounded-xl bg-client-accent px-4 py-2 text-sm font-bold text-white"
            >
              Find freelancers on Connect
            </Link>
          </section>
        </div>
        {sharedWork.length > 0 ? (
          <ul className="space-y-2">
            {sharedWork.map((row) => (
              <li
                key={row.share_id}
                className="flex items-center justify-between gap-3 rounded-xl border border-border bg-surface px-4 py-3"
              >
                <div>
                  <p className="font-semibold text-navy">{row.project_name || "Shared project"}</p>
                  <p className="text-sm text-text-secondary">
                    {row.freelancer_email || "Freelancer"} · {(row.status || "active").replaceAll("_", " ")}
                  </p>
                </div>
                <span className="text-xs text-text-muted">{formatDate(row.updated_at)}</span>
              </li>
            ))}
          </ul>
        ) : (
          <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center">
            <p className="font-semibold text-navy">No freelancer work shared yet</p>
            <p className="mt-2 text-sm text-text-secondary">
              Once a freelancer shares a project or invoice, it will appear here.
            </p>
          </div>
        )}
      </div>
    );
  }

  const gate = canCreateCustomer(profile, customers.length);

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-extrabold">Clients</h1>
        <p className="text-sm text-text-secondary">
          Cloud CRM clients with follow-ups, custom fields, and linked project work.
        </p>
      </div>
      <CustomersCrmPanel
        initial={customers}
        canCreate={gate.ok}
        gateReason={!gate.ok ? gate.reason : undefined}
        upgradeHref={!gate.ok ? gate.upgradeHref : undefined}
      />
      <p className="text-xs text-text-secondary">
        Looking for Connect? <Link href="/connect" className="font-semibold text-primary">Open marketplace →</Link>
      </p>
    </div>
  );
}
