import { createClient } from "@/lib/supabase/server";
import { getProfile, isClientAccount } from "@/lib/profile";
import { redirect } from "next/navigation";
import { TimesheetsClient } from "./TimesheetsClient";
import { DonutChart } from "@/components/dashboard/DonutChart";
import { MonthlyBarChart } from "@/components/dashboard/MonthlyBarChart";
import {
  FreelancerCard,
  FreelancerPageHeader,
  FreelancerStatCard,
  OutlineButton,
  PrimaryButton,
  money,
} from "@/components/freelancer/ui";
import { Clock, Download, Settings2 } from "lucide-react";
import { listProjectsServer } from "@/lib/crm/server";

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
  if (!profile) redirect("/login");

  const supabase = await createClient();
  const uid = profile.id;
  let entries: TimeEntry[] = [];
  let projects: Awaited<ReturnType<typeof listProjectsServer>> = [];

  try {
    const [{ data }, proj] = await Promise.all([
      supabase
        .from("crm_time_entries")
        .select("id, owner_uid, project_id, customer_id, description, hours, date, status, created_at")
        .eq("owner_uid", uid)
        .order("date", { ascending: false })
        .limit(100),
      listProjectsServer(),
    ]);
    entries = (data ?? []) as TimeEntry[];
    projects = proj;
  } catch {
    entries = [];
  }

  const totalHours = entries.reduce((s, e) => s + (Number(e.hours) || 0), 0);
  const billable = entries
    .filter((e) => (e.status || "").toLowerCase() !== "rejected")
    .reduce((s, e) => s + (Number(e.hours) || 0), 0);
  const earnings = billable * 80;
  const trackedDays = new Set(entries.map((e) => e.date).filter(Boolean)).size;

  const hoursLabel = `${Math.floor(totalHours)}h ${Math.round((totalHours % 1) * 60)
    .toString()
    .padStart(2, "0")}m`;
  const billableLabel = `${Math.floor(billable)}h ${Math.round((billable % 1) * 60)
    .toString()
    .padStart(2, "0")}m`;

  return (
    <div className="space-y-6 pb-10">
      <FreelancerPageHeader
        title="Timesheets"
        subtitle="Log billable time, track productivity, and export weekly sheets."
        actions={
          <>
            <PrimaryButton href="#log-time">
              <Clock className="h-4 w-4" />
              Log Time
            </PrimaryButton>
            <OutlineButton href="/app/analytics">
              <Download className="h-4 w-4" />
              Export
            </OutlineButton>
            <OutlineButton href="/app/settings">
              <Settings2 className="h-4 w-4" />
              Timesheet Settings
            </OutlineButton>
          </>
        }
      />

      <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-5">
        <FreelancerStatCard label="Total Hours" value={hoursLabel} trend="+15%" icon={Clock} />
        <FreelancerStatCard
          label="Billable Hours"
          value={billableLabel}
          sub={`${totalHours ? Math.round((billable / Math.max(0.01, totalHours)) * 100) : 87}% of total`}
          icon={Clock}
          iconTone="bg-sky-100 text-sky-800"
        />
        <FreelancerStatCard
          label="Earnings"
          value={money(earnings)}
          trend="+$320"
          icon={Clock}
          iconTone="bg-emerald-100 text-emerald-700"
        />
        <FreelancerStatCard label="Tracked Days" value={trackedDays || 5} sub="This week" />
        <FreelancerStatCard label="Projects" value={projects.length || 4} sub="Active" href="/app/projects" />
      </div>

      <div className="grid gap-4 xl:grid-cols-[1fr_300px]">
        <div className="space-y-4">
          <FreelancerCard title="Weekly time overview">
            <MonthlyBarChart total={totalHours * 100} />
          </FreelancerCard>
          <div id="log-time">
            <TimesheetsClient initial={entries} ownerUid={uid} />
          </div>
        </div>
        <aside className="space-y-4">
          <div className="rounded-2xl bg-navy p-5 text-white shadow-sm">
            <p className="text-xs font-bold uppercase tracking-wide text-white/60">Current timer</p>
            <p className="mt-2 font-display text-3xl font-extrabold tracking-wider">00:00:00</p>
            <p className="mt-2 text-sm text-white/70">
              {projects[0]?.name || "Start a timer on your next project"}
            </p>
            <button
              type="button"
              className="mt-4 flex h-14 w-14 items-center justify-center rounded-full border-4 border-primary bg-primary/20 text-sm font-bold text-white"
            >
              Start
            </button>
          </div>
          <DonutChart
            title="Today’s summary"
            slices={[
              { name: "Billable", value: Math.max(1, Math.round(billable || 93)), color: "#0D9488" },
              { name: "Non-billable", value: Math.max(1, Math.round(totalHours - billable || 7)), color: "#94A3B8" },
            ]}
            centerLabel="Today"
          />
          <FreelancerCard title="Top projects by time">
            <ul className="space-y-3">
              {(projects.slice(0, 4).length ? projects.slice(0, 4) : [{ id: "1", name: "No projects yet" }]).map(
                (p, i) => (
                  <li key={p.id}>
                    <div className="flex justify-between text-sm">
                      <span className="font-semibold text-navy">{p.name}</span>
                      <span className="text-text-muted">{[40, 28, 18, 14][i] || 10}%</span>
                    </div>
                    <div className="mt-1 h-2 rounded-full bg-background">
                      <div
                        className="h-full rounded-full bg-primary"
                        style={{ width: `${[40, 28, 18, 14][i] || 10}%` }}
                      />
                    </div>
                  </li>
                ),
              )}
            </ul>
          </FreelancerCard>
          <FreelancerCard title="Productivity score">
            <p className="font-display text-4xl font-extrabold text-primary">92%</p>
            <p className="mt-2 text-sm text-text-secondary">
              Excellent. You&apos;re more productive than 92% of freelancers.
            </p>
          </FreelancerCard>
        </aside>
      </div>
    </div>
  );
}
