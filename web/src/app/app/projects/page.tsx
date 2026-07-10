import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { getProfile } from "@/lib/profile";
import { DownloadAppCard } from "@/components/app/DownloadAppCard";

export default async function ProjectsPage() {
  const profile = await getProfile();
  const supabase = await createClient();
  let rows: Array<{
    share_id: string;
    project_name?: string | null;
    client_email?: string | null;
    status?: string | null;
    budget?: number | null;
    currency?: string | null;
  }> = [];

  try {
    const { data, error } = await supabase
      .from("project_shares")
      .select("share_id, project_name, client_email, status, budget, currency, updated_at")
      .eq("freelancer_uid", profile?.id ?? "")
      .order("updated_at", { ascending: false })
      .limit(50);
    if (!error && data) rows = data;
  } catch {
    rows = [];
  }

  // Also show projects where user is the client
  if (rows.length === 0) {
    try {
      const { data } = await supabase
        .from("project_shares")
        .select("share_id, project_name, freelancer_email, status, budget, currency, updated_at")
        .eq("client_uid", profile?.id ?? "")
        .order("updated_at", { ascending: false })
        .limit(50);
      if (data) {
        rows = data.map((r) => ({
          share_id: r.share_id,
          project_name: r.project_name,
          client_email: r.freelancer_email,
          status: r.status,
          budget: r.budget,
          currency: r.currency,
        }));
      }
    } catch {
      /* ignore */
    }
  }

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-extrabold">Work / Projects</h1>
        <p className="text-sm text-text-secondary">
          Cloud-shared projects. Full editing, time tracking, and milestones are in the Android app.
        </p>
      </div>
      {rows.length === 0 ? (
        <div className="space-y-4">
          <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center">
            <p className="font-semibold">No shared projects yet</p>
            <p className="mt-2 text-sm text-text-secondary">
              Share a project with a client from the mobile app to see it here.
            </p>
            <Link href="/connect" className="mt-4 inline-block text-sm font-semibold text-primary">
              Find work on Connect →
            </Link>
          </div>
          <DownloadAppCard title="Create projects in the app" />
        </div>
      ) : (
        <>
          <ul className="space-y-2">
            {rows.map((r) => (
              <li key={r.share_id} className="rounded-xl border border-border bg-surface px-4 py-3">
                <p className="font-semibold">{r.project_name || "Project"}</p>
                <p className="text-sm text-text-secondary">
                  {r.client_email || "Linked"} · {r.status || "active"}
                  {r.budget != null ? ` · ${r.currency || ""} ${r.budget}` : ""}
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
