import { createClient } from "@/lib/supabase/server";
import { getProfile, isClientAccount } from "@/lib/profile";
import { TasksClient, type TaskRow } from "./TasksClient";

export const metadata = { title: "Tasks" };

export default async function TasksPage() {
  const profile = await getProfile();
  const client = isClientAccount(profile);
  const supabase = await createClient();
  let rows: TaskRow[] = [];
  let peerUid: string | null = null;

  try {
    const col = client ? "client_uid" : "freelancer_uid";
    const peerCol = client ? "freelancer_uid" : "client_uid";
    const { data, error } = await supabase
      .from("client_tasks")
      .select("id, title, status, description, created_at, is_read, project_share_id, client_uid, freelancer_uid")
      .eq(col, profile?.id ?? "")
      .order("created_at", { ascending: false })
      .limit(40);
    if (!error && data) {
      rows = data;
      peerUid = (data.find((r) => r[peerCol])?.[peerCol] as string | undefined) ?? null;
    } else if (error?.message?.includes("is_read") || error?.message?.includes("project_share")) {
      const { data: fallback } = await supabase
        .from("client_tasks")
        .select("id, title, status, description, created_at, client_uid, freelancer_uid")
        .eq(col, profile?.id ?? "")
        .order("created_at", { ascending: false })
        .limit(40);
      if (fallback) {
        rows = fallback;
        peerUid = (fallback.find((r) => r[peerCol])?.[peerCol] as string | undefined) ?? null;
      }
    }
  } catch {
    rows = [];
  }

  if (!peerUid && profile?.id) {
    try {
      const { data: share } = await supabase
        .from("project_shares")
        .select(client ? "freelancer_uid" : "client_uid")
        .eq(client ? "client_uid" : "freelancer_uid", profile.id)
        .limit(1)
        .maybeSingle();
      peerUid = client
        ? ((share as { freelancer_uid?: string } | null)?.freelancer_uid ?? null)
        : ((share as { client_uid?: string } | null)?.client_uid ?? null);
    } catch {
      peerUid = null;
    }
  }

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-extrabold">Tasks</h1>
        <p className="text-sm text-text-secondary">
          Shared client tasks from your freelancer/client workspace.
        </p>
      </div>
      <TasksClient
        initial={rows}
        isClient={!!client}
        canCreate={!!peerUid}
        peerUid={peerUid}
      />
    </div>
  );
}
