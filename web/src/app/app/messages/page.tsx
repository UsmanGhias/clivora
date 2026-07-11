import { createClient } from "@/lib/supabase/server";
import { getProfile } from "@/lib/profile";
import { DownloadAppCard } from "@/components/app/DownloadAppCard";
import { MessagesThreadView } from "./MessagesThreadView";

export type MessageRow = {
  id: string;
  body?: string | null;
  subject?: string | null;
  created_at?: string | null;
  from_email?: string | null;
  from_uid?: string | null;
  to_uid?: string | null;
  parent_message_id?: string | null;
  read_at?: string | null;
  attachments?: unknown;
};

export default async function MessagesPage() {
  const profile = await getProfile();
  const supabase = await createClient();
  const uid = profile?.id ?? "";
  let rows: MessageRow[] = [];

  try {
    const { data, error } = await supabase
      .from("client_messages")
      .select(
        "id, body, subject, created_at, from_email, from_uid, to_uid, parent_message_id, read_at, attachments",
      )
      .or(`from_uid.eq.${uid},to_uid.eq.${uid}`)
      .order("created_at", { ascending: true })
      .limit(100);
    if (!error && data) rows = data;
  } catch {
    rows = [];
  }

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-extrabold">Messages</h1>
        <p className="text-sm text-text-secondary">
          Cloud inbox. Realtime chat and push alerts are richer in the mobile app.
        </p>
      </div>
      <MessagesThreadView
        rows={rows}
        fromEmail={profile?.email ?? ""}
        myUid={uid}
      />
      <DownloadAppCard title="Chat live in the CLIVORA app" />
    </div>
  );
}
