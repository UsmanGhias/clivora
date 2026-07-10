import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { getProfile } from "@/lib/profile";
import { DownloadAppCard } from "@/components/app/DownloadAppCard";

export default async function ClientsPage() {
  const profile = await getProfile();
  const supabase = await createClient();

  let rows: Array<{
    share_id: string;
    client_email?: string | null;
    project_name?: string | null;
    status?: string | null;
  }> = [];

  try {
    const { data, error } = await supabase
      .from("project_shares")
      .select("share_id, client_email, project_name, status, updated_at")
      .eq("freelancer_uid", profile?.id ?? "")
      .order("updated_at", { ascending: false })
      .limit(50);
    if (!error && data) rows = data;
  } catch {
    rows = [];
  }

  // Dedupe by client email for a client-centric view
  const byClient = new Map<string, (typeof rows)[0]>();
  for (const r of rows) {
    const key = (r.client_email || r.share_id).toLowerCase();
    if (!byClient.has(key)) byClient.set(key, r);
  }
  const clients = Array.from(byClient.values());

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-extrabold">Clients</h1>
        <p className="text-sm text-text-secondary">
          Clients linked via cloud project shares. Full CRM (local contacts, notes, invites) is in the app.
        </p>
      </div>
      {clients.length === 0 ? (
        <div className="space-y-4">
          <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center">
            <p className="font-semibold">No cloud clients yet</p>
            <p className="mt-2 text-sm text-text-secondary">
              Invite clients from the CLIVORA app, or open Connect to find new work.
            </p>
            <Link href="/connect" className="mt-4 inline-block text-sm font-semibold text-primary">
              Open Connect →
            </Link>
          </div>
          <DownloadAppCard title="Add clients in the app" />
        </div>
      ) : (
        <>
          <ul className="space-y-2">
            {clients.map((r) => (
              <li key={r.share_id} className="rounded-xl border border-border bg-surface px-4 py-3">
                <p className="font-semibold">{r.client_email || "Client"}</p>
                <p className="text-sm text-text-secondary">
                  Latest: {r.project_name || "Shared project"} · {r.status || "active"}
                </p>
              </li>
            ))}
          </ul>
          <DownloadAppCard />
        </>
      )}
    </div>
  );
}
