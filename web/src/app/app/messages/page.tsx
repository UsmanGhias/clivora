import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { getProfile } from "@/lib/profile";
import { DownloadAppCard } from "@/components/app/DownloadAppCard";

export default async function MessagesPage() {
  const profile = await getProfile();
  const supabase = await createClient();
  const uid = profile?.id ?? "";
  let rows: Array<{
    id: string;
    body?: string | null;
    subject?: string | null;
    created_at?: string | null;
    from_email?: string | null;
  }> = [];

  try {
    const { data, error } = await supabase
      .from("client_messages")
      .select("id, body, subject, created_at, from_email, from_uid, to_uid")
      .or(`from_uid.eq.${uid},to_uid.eq.${uid}`)
      .order("created_at", { ascending: false })
      .limit(30);
    if (!error && data) rows = data;
  } catch {
    rows = [];
  }

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-extrabold">Messages</h1>
        <p className="text-sm text-text-secondary">
          Recent cloud messages. Full realtime chat and push alerts are in the mobile app.
        </p>
      </div>
      {rows.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center">
          <p className="font-semibold">No messages yet</p>
          <p className="mt-2 text-sm text-text-secondary">
            Start a conversation from a shared project or Connect request.
          </p>
          <Link href="/connect" className="mt-4 inline-block text-sm font-semibold text-primary">
            Open Connect →
          </Link>
        </div>
      ) : (
        <ul className="space-y-2">
          {rows.map((r) => (
            <li key={r.id} className="rounded-xl border border-border bg-surface px-4 py-3">
              {r.subject && <p className="text-xs font-semibold text-text-secondary">{r.subject}</p>}
              <p className="text-sm text-text-primary">{r.body || "(empty)"}</p>
              <p className="mt-1 text-xs text-text-secondary">
                {r.from_email || "CLIVORA"}
                {r.created_at ? ` · ${new Date(r.created_at).toLocaleString()}` : ""}
              </p>
            </li>
          ))}
        </ul>
      )}
      <DownloadAppCard title="Chat live in the CLIVORA app" />
    </div>
  );
}
