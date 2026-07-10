import Link from "next/link";
import { getProfile, isClientAccount } from "@/lib/profile";
import { listCustomersServer } from "@/lib/crm/server";
import { canCreateCustomer } from "@/lib/plan-gates";
import { CustomersCrmPanel } from "@/components/crm/CrmPanels";
import { DownloadAppCard } from "@/components/app/DownloadAppCard";

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
    return (
      <div className="space-y-4">
        <div>
          <h1 className="text-2xl font-extrabold">Clients</h1>
          <p className="text-sm text-text-secondary">
            Client accounts view shared work from freelancers. Manage your own CRM in the freelancer app.
          </p>
        </div>
        <DownloadAppCard title="Switch to freelancer mode in the app" />
      </div>
    );
  }

  const gate = canCreateCustomer(profile, customers.length);

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-extrabold">Clients</h1>
        <p className="text-sm text-text-secondary">
          Cloud CRM clients (synced with the Android app). Offline editing & invites are richer in the app.
        </p>
      </div>
      <CustomersCrmPanel
        initial={customers}
        canCreate={gate.ok}
        gateReason={!gate.ok ? gate.reason : undefined}
        upgradeHref={!gate.ok ? gate.upgradeHref : undefined}
      />
      <DownloadAppCard title="Full CRM offline in the app" />
      <p className="text-xs text-text-secondary">
        Looking for Connect? <Link href="/connect" className="font-semibold text-primary">Open marketplace →</Link>
      </p>
    </div>
  );
}
