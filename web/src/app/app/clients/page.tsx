import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { getProfile } from "@/lib/profile";

export default async function ClientsPage() {
  const profile = await getProfile();
  const supabase = await createClient();

  let rows: Array<{
    id: string;
    client_email?: string | null;
    project_name?: string | null;
  }> = [];

  try {
    const { data, error } = await supabase
      .from("client_project_shares")
      .select("id, client_email, project_name, status, updated_at")
      .eq("freelancer_uid", profile?.id ?? "")
      .order("updated_at", { ascending: false })
      .limit(50);
    if (!error && data) rows = data;
  } catch {
    rows = [];
  }

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-extrabold">Clients</h1>
        <p className="text-sm text-text-secondary">
          Cloud-linked client relationships. Full CRM editing stays in the mobile app; web shows synced shares.
        </p>
      </div>
      {rows.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center">
          <p className="font-semibold">No cloud client links yet</p>
          <p className="mt-2 text-sm text-text-secondary">
            Invite clients from the CLIVORA app, or open Connect to find new work.
          </p>
          <Link href="/connect" className="mt-4 inline-block text-sm font-semibold text-primary">
            Open Connect →
          </Link>
        </div>
      ) : (
        <ul className="space-y-2">
          {rows.map((r) => (
            <li key={r.id} className="rounded-xl border border-border bg-surface px-4 py-3">
              <p className="font-semibold">{r.project_name || "Shared project"}</p>
              <p className="text-sm text-text-secondary">{r.client_email}</p>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
