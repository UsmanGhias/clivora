import Link from "next/link";
import { getProfile, isClientAccount } from "@/lib/profile";
import { listCustomersServer, listProjectsServer } from "@/lib/crm/server";
import { canCreateProject } from "@/lib/plan-gates";
import { ProjectsCrmPanel } from "@/components/crm/CrmPanels";
import { ProjectKanban } from "@/components/crm/ProjectKanban";
import { DownloadAppCard } from "@/components/app/DownloadAppCard";
import { createClient } from "@/lib/supabase/server";

export default async function ProjectsPage() {
  const profile = await getProfile();
  const client = isClientAccount(profile);
  let projects: Awaited<ReturnType<typeof listProjectsServer>> = [];
  let customers: Awaited<ReturnType<typeof listCustomersServer>> = [];

  if (!client) {
    try {
      projects = await listProjectsServer();
    } catch {
      projects = [];
    }
    try {
      customers = await listCustomersServer();
    } catch {
      customers = [];
    }
  }

  // Client view: shared projects
  if (client) {
    const supabase = await createClient();
    let rows: Array<{
      share_id: string;
      project_name?: string | null;
      freelancer_email?: string | null;
      status?: string | null;
      budget?: number | null;
      currency?: string | null;
    }> = [];
    try {
      const { data } = await supabase
        .from("project_shares")
        .select("share_id, project_name, freelancer_email, status, budget, currency, updated_at")
        .eq("client_uid", profile?.id ?? "")
        .order("updated_at", { ascending: false })
        .limit(50);
      if (data) rows = data;
    } catch {
      rows = [];
    }
    return (
      <div className="space-y-4">
        <div>
          <h1 className="text-2xl font-extrabold">Work / Projects</h1>
          <p className="text-sm text-text-secondary">Projects shared with you by freelancers.</p>
        </div>
        {rows.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center">
            <p className="font-semibold">No shared projects yet</p>
            <Link href="/connect" className="mt-4 inline-block text-sm font-semibold text-primary">
              Find freelancers on Connect →
            </Link>
          </div>
        ) : (
          <ul className="space-y-2">
            {rows.map((r) => (
              <li key={r.share_id} className="rounded-xl border border-border bg-surface px-4 py-3">
                <p className="font-semibold">{r.project_name || "Project"}</p>
                <p className="text-sm text-text-secondary">
                  {r.freelancer_email || "Freelancer"} · {r.status || "active"}
                  {r.budget != null ? ` · ${r.currency || ""} ${r.budget}` : ""}
                </p>
              </li>
            ))}
          </ul>
        )}
        <DownloadAppCard title="Track milestones in the app" tone="client" />
      </div>
    );
  }

  const gate = canCreateProject(profile, projects.length);

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-extrabold">Work / Projects</h1>
        <p className="text-sm text-text-secondary">
          Cloud CRM projects synced with the app. Time tracking & rich editing are app-preferred.
        </p>
      </div>
      <ProjectsCrmPanel
        initial={projects}
        customers={customers}
        canCreate={gate.ok}
        gateReason={!gate.ok ? gate.reason : undefined}
        upgradeHref={!gate.ok ? gate.upgradeHref : undefined}
      />
      {projects.length > 0 && (
        <div className="rounded-2xl border border-border bg-surface p-4 shadow-sm">
          <ProjectKanban initial={projects} />
        </div>
      )}
      <DownloadAppCard title="Time tracking & milestones in the app" />
    </div>
  );
}
