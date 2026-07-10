import { createClient } from "@/lib/supabase/server";
import { getProfile } from "@/lib/profile";

export default async function NotificationsPage() {
  const profile = await getProfile();
  const supabase = await createClient();
  let rows: Array<{
    id: string;
    title?: string | null;
    body?: string | null;
    created_at?: string | null;
    is_read?: boolean | null;
  }> = [];

  try {
    const { data, error } = await supabase
      .from("notifications")
      .select("id, title, body, created_at, is_read")
      .eq("user_uid", profile?.id ?? "")
      .order("created_at", { ascending: false })
      .limit(40);
    if (!error && data) rows = data;
  } catch {
    rows = [];
  }

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-extrabold">Notifications</h1>
        <p className="text-sm text-text-secondary">Cloud notifications synced from the same Supabase project.</p>
      </div>
      {rows.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center">
          <p className="font-semibold">No notifications yet</p>
        </div>
      ) : (
        <ul className="space-y-2">
          {rows.map((r) => (
            <li
              key={r.id}
              className={`rounded-xl border px-4 py-3 ${
                r.is_read ? "border-border bg-surface" : "border-primary/30 bg-primary/5"
              }`}
            >
              <p className="font-semibold">{r.title || "Update"}</p>
              <p className="text-sm text-text-secondary">{r.body}</p>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
