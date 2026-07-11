import { createClient } from "@/lib/supabase/server";
import { getProfile, isClientAccount } from "@/lib/profile";
import { redirect } from "next/navigation";
import { TimesheetsClient } from "./TimesheetsClient";

export type TimeEntry = {
  id: string;
  owner_uid: string;
  project_id: string | null;
  customer_id: string | null;
  description: string | null;
  hours: number | null;
  date: string | null;
  status: string | null;
  created_at: string | null;
};

export default async function TimesheetsPage() {
  const profile = await getProfile();
  if (isClientAccount(profile)) redirect("/app");

  const supabase = await createClient();
  const uid = profile?.id ?? "";
  let entries: TimeEntry[] = [];

  try {
    const { data } = await supabase
      .from("crm_time_entries")
      .select("id, owner_uid, project_id, customer_id, description, hours, date, status, created_at")
      .eq("owner_uid", uid)
      .order("date", { ascending: false })
      .limit(100);
    entries = (data ?? []) as TimeEntry[];
  } catch {
    entries = [];
  }

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-extrabold">Timesheets</h1>
        <p className="text-sm text-text-secondary">
          Log and manage time entries for your projects.
        </p>
      </div>
      <TimesheetsClient initial={entries} ownerUid={uid} />
    </div>
  );
}
