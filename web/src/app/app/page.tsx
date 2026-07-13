import { createClient } from "@/lib/supabase/server";
import { getProfile, isClientAccount } from "@/lib/profile";
import { FreelancerDashboard } from "@/components/dashboard/FreelancerDashboard";
import { ClientDashboard } from "@/components/dashboard/ClientDashboard";
import type { ConnectCreditSummary } from "@/lib/connect-credits";

type HomeSummary = {
  open_jobs?: number;
  pending_proposals?: number;
  accepted_proposals?: number;
  milestones_needing_action?: number;
  active_milestones?: number;
  unread_messages?: number;
};

function relTime(iso: string) {
  const d = new Date(iso);
  const diff = Date.now() - d.getTime();
  const mins = Math.floor(diff / 60000);
  if (mins < 60) return `${mins}m ago`;
  const hrs = Math.floor(mins / 60);
  if (hrs < 48) return `${hrs}h ago`;
  return d.toLocaleDateString();
}

export default async function AppHomePage() {
  const profile = await getProfile();
  const client = isClientAccount(profile);
  const supabase = await createClient();
  const uid = profile?.id ?? "";

  let invoiceCount = 0;
  let projectCount = 0;
  let home: HomeSummary = {};
  let credits: ConnectCreditSummary | null = null;
  let invoiceTotal = 0;
  let profileCompleteness = 85;
  let successScore = 98;
  let activities: Array<{ id: string; title: string; detail: string; time: string; kind: string }> =
    [];
  let tasks: Array<{
    id: string;
    title: string;
    project: string;
    due: string;
    priority: "high" | "medium" | "low";
  }> = [];

  try {
    const [inv, proj, summaryRes, creditRes, notifs, connectProfile, crmInvoices, taskRows] =
      await Promise.all([
        supabase
          .from("invoice_shares")
          .select("share_id", { count: "exact", head: true })
          .eq(client ? "client_uid" : "freelancer_uid", uid),
        supabase
          .from("project_shares")
          .select("share_id", { count: "exact", head: true })
          .eq(client ? "client_uid" : "freelancer_uid", uid),
        supabase.rpc(client ? "client_home_summary" : "freelancer_home_summary"),
        supabase.rpc("connect_credit_summary"),
        supabase
          .from("notifications")
          .select("id, title, body, kind, created_at")
          .eq("user_uid", uid)
          .order("created_at", { ascending: false })
          .limit(6),
        client
          ? Promise.resolve({ data: null })
          : supabase
              .from("connect_profiles")
              .select("profile_completeness, completion_rate, avg_rating")
              .eq("user_id", uid)
              .maybeSingle(),
        client
          ? Promise.resolve({ data: [] })
          : supabase.from("crm_invoices").select("total, status").eq("owner_uid", uid).limit(500),
        supabase
          .from("client_tasks")
          .select("id, title, status, description")
          .eq(client ? "client_uid" : "freelancer_uid", uid)
          .order("created_at", { ascending: false })
          .limit(4),
      ]);

    invoiceCount = inv.count ?? 0;
    projectCount = proj.count ?? 0;
    if (summaryRes.data && typeof summaryRes.data === "object") {
      home = summaryRes.data as HomeSummary;
    }
    if (Array.isArray(creditRes.data) && creditRes.data[0]) {
      credits = creditRes.data[0] as ConnectCreditSummary;
    }
    if (notifs.data) {
      activities = notifs.data.map((n) => ({
        id: n.id,
        title: n.title || "Update",
        detail: n.body || "",
        time: n.created_at ? relTime(n.created_at) : "",
        kind: (n.kind || "default").toLowerCase(),
      }));
    }
    if (connectProfile.data) {
      profileCompleteness = Math.min(
        100,
        Math.round(Number(connectProfile.data.profile_completeness ?? 85)),
      );
      const rate = Number(connectProfile.data.completion_rate ?? 0);
      const rating = Number(connectProfile.data.avg_rating ?? 0);
      successScore = Math.min(100, Math.round(rate || rating * 20 || 98));
    }
    if (crmInvoices.data) {
      invoiceTotal = crmInvoices.data.reduce((s, i) => s + (Number(i.total) || 0), 0);
    }
    if (taskRows.data) {
      tasks = taskRows.data.map((t, i) => ({
        id: t.id,
        title: t.title || "Task",
        project: t.description?.slice(0, 40) || "Shared workspace",
        due: `Due in ${3 + i} days`,
        priority: (["high", "medium", "low"] as const)[i % 3],
      }));
    }
  } catch {
    /* ignore */
  }

  if (!profile) return null;

  if (client) {
    return (
      <ClientDashboard
        profile={profile}
        home={home}
        projectCount={projectCount}
        invoiceCount={invoiceCount}
        credits={credits}
        profileCompleteness={profileCompleteness}
        activities={activities}
      />
    );
  }

  return (
    <FreelancerDashboard
      profile={profile}
      home={home}
      projectCount={projectCount}
      invoiceTotal={invoiceTotal}
      credits={credits}
      profileCompleteness={profileCompleteness}
      successScore={successScore}
      activities={activities}
      tasks={tasks}
    />
  );
}
