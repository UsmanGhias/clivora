import { createClient } from "@/lib/supabase/server";
import { getProfile, isClientAccount } from "@/lib/profile";
import { redirect } from "next/navigation";
import Link from "next/link";
import { TimesheetsClient } from "./TimesheetsClient";
import { ClientTimesheetActions } from "./ClientTimesheetActions";
import { LiveTimer } from "./LiveTimer";
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
import {
  ClientCard,
  ClientPageHeader,
  ClientPrimaryButton,
  ClientStatCard,
  ClientStatusPill,
} from "@/components/client/ui";
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
  minutes?: number | null;
  work_date?: string | null;
  approval_status?: string | null;
  hourly_rate?: number | null;
};

function normalizeEntry(raw: Record<string, unknown>): TimeEntry {
  const minutes = Number(raw.minutes ?? 0);
  const hours =
    raw.hours != null
      ? Number(raw.hours)
      : minutes > 0
        ? minutes / 60
        : null;
  return {
    id: String(raw.id),
    owner_uid: String(raw.owner_uid),
    project_id: (raw.project_id as string | null) ?? null,
    customer_id: (raw.customer_id as string | null) ?? null,
    description: (raw.description as string | null) ?? null,
    hours,
    date: (raw.date as string | null) ?? (raw.work_date as string | null) ?? null,
    status:
      (raw.status as string | null) ??
      (raw.approval_status as string | null) ??
      "pending",
    created_at: (raw.created_at as string | null) ?? null,
    minutes: raw.minutes as number | null | undefined,
    work_date: raw.work_date as string | null | undefined,
    approval_status: raw.approval_status as string | null | undefined,
    hourly_rate: raw.hourly_rate as number | null | undefined,
  };
}

export default async function TimesheetsPage() {
  const profile = await getProfile();
  if (!profile) redirect("/login");
  const isClient = isClientAccount(profile);
  const supabase = await createClient();
  const uid = profile.id;

  if (isClient) {
    type Share = {
      share_id: string;
      project_name: string | null;
      freelancer_uid: string | null;
      freelancer_email: string | null;
      status: string | null;
    };
    let shares: Share[] = [];
    let entries: TimeEntry[] = [];
    try {
      const { data: shareRows } = await supabase
        .from("project_shares")
        .select("share_id, project_name, freelancer_uid, freelancer_email, status")
        .eq("client_uid", uid)
        .limit(50);
      shares = (shareRows ?? []) as Share[];
      const freelancerIds = [
        ...new Set(shares.map((s) => s.freelancer_uid).filter(Boolean) as string[]),
      ];
      if (freelancerIds.length > 0) {
        const { data: timeRows } = await supabase
          .from("crm_time_entries")
          .select(
            "id, owner_uid, project_id, customer_id, description, hours, date, status, minutes, work_date, approval_status, hourly_rate, created_at",
          )
          .in("owner_uid", freelancerIds)
          .order("created_at", { ascending: false })
          .limit(100);
        entries = (timeRows ?? []).map((r) => normalizeEntry(r as Record<string, unknown>));
      }
    } catch {
      entries = [];
    }

    const pending = entries.filter(
      (e) => (e.status || "").toLowerCase() === "pending",
    ).length;
    const totalHours = entries.reduce((s, e) => s + (Number(e.hours) || 0), 0);
    const freelancerLabel = (ownerUid: string) =>
      shares.find((s) => s.freelancer_uid === ownerUid)?.freelancer_email ||
      "Freelancer";

    return (
      <div className="space-y-6 pb-10">
        <ClientPageHeader
          title="Time tracking"
          subtitle="Review shared time entries from freelancers on your projects."
          icon={Clock}
          actions={
            <ClientPrimaryButton href="/app/projects">View projects</ClientPrimaryButton>
          }
        />

        <div className="grid gap-3 sm:grid-cols-3">
          <ClientStatCard label="Shared projects" value={shares.length} icon={Clock} />
          <ClientStatCard label="Pending approval" value={pending} />
          <ClientStatCard
            label="Hours submitted"
            value={`${totalHours.toFixed(1)}h`}
          />
        </div>

        <ClientCard title="Time entries for approval">
          {entries.length === 0 ? (
            <div className="rounded-xl border border-dashed border-border px-4 py-8 text-center">
              <p className="font-semibold text-navy">No shared time entries yet</p>
              <p className="mt-2 text-sm text-text-secondary">
                When freelancers log time on shared projects, you can approve it here.
              </p>
              {shares.length === 0 && (
                <Link
                  href="/app/projects"
                  className="mt-4 inline-block text-sm font-semibold text-client-accent"
                >
                  Open projects →
                </Link>
              )}
            </div>
          ) : (
            <ul className="divide-y divide-border">
              {entries.map((entry) => (
                <li
                  key={entry.id}
                  className="flex flex-wrap items-start justify-between gap-2 py-3"
                >
                  <div>
                    <p className="text-sm font-medium text-navy">
                      {entry.description || "Time entry"}
                    </p>
                    <p className="mt-0.5 text-xs text-text-muted">
                      {freelancerLabel(entry.owner_uid)}
                      {entry.date ? ` · ${entry.date.slice(0, 10)}` : ""}
                      {entry.hours != null ? ` · ${entry.hours}h` : ""}
                    </p>
                  </div>
                  <div className="flex items-center gap-2">
                    <ClientStatusPill
                      tone={
                        (entry.status || "").toLowerCase() === "approved"
                          ? "green"
                          : (entry.status || "").toLowerCase() === "rejected"
                            ? "red"
                            : "amber"
                      }
                    >
                      {entry.status || "pending"}
                    </ClientStatusPill>
                    <ClientTimesheetActions
                      entryId={entry.id}
                      status={entry.status}
                    />
                  </div>
                </li>
              ))}
            </ul>
          )}
        </ClientCard>
      </div>
    );
  }

  let entries: TimeEntry[] = [];
  let projects: Awaited<ReturnType<typeof listProjectsServer>> = [];

  try {
    const [{ data }, proj] = await Promise.all([
      supabase
        .from("crm_time_entries")
        .select(
          "id, owner_uid, project_id, customer_id, description, hours, date, status, minutes, work_date, approval_status, hourly_rate, created_at",
        )
        .eq("owner_uid", uid)
        .order("created_at", { ascending: false })
        .limit(100),
      listProjectsServer(),
    ]);
    entries = (data ?? []).map((r) => normalizeEntry(r as Record<string, unknown>));
    projects = proj;
  } catch {
    entries = [];
  }

  const totalHours = entries.reduce((s, e) => s + (Number(e.hours) || 0), 0);
  const billable = entries
    .filter((e) => (e.status || "").toLowerCase() !== "rejected")
    .reduce((s, e) => s + (Number(e.hours) || 0), 0);
  const earnings = entries.reduce((s, e) => {
    const hours = Number(e.hours) || 0;
    const rate = Number(e.hourly_rate) || 0;
    return s + hours * rate;
  }, 0);
  const trackedDays = new Set(entries.map((e) => e.date).filter(Boolean)).size;

  const hoursLabel = `${Math.floor(totalHours)}h ${Math.round((totalHours % 1) * 60)
    .toString()
    .padStart(2, "0")}m`;
  const billableLabel = `${Math.floor(billable)}h ${Math.round((billable % 1) * 60)
    .toString()
    .padStart(2, "0")}m`;

  const hoursByProject = new Map<string, number>();
  for (const e of entries) {
    if (!e.project_id) continue;
    hoursByProject.set(e.project_id, (hoursByProject.get(e.project_id) ?? 0) + (Number(e.hours) || 0));
  }
  const topProjects = [...hoursByProject.entries()]
    .map(([id, hours]) => ({
      id,
      name: projects.find((p) => p.id === id)?.name || "Project",
      hours,
    }))
    .sort((a, b) => b.hours - a.hours)
    .slice(0, 4);
  const topHoursTotal = topProjects.reduce((s, p) => s + p.hours, 0);

  const monthBuckets = new Map<string, number>();
  for (const e of entries) {
    const d = e.date || e.work_date;
    if (!d) continue;
    const key = d.slice(0, 7);
    monthBuckets.set(key, (monthBuckets.get(key) ?? 0) + (Number(e.hours) || 0));
  }
  const monthlySeries = [...monthBuckets.entries()]
    .sort(([a], [b]) => a.localeCompare(b))
    .slice(-6)
    .map(([key, amount]) => {
      const [y, m] = key.split("-");
      const label = new Date(Number(y), Number(m) - 1, 1).toLocaleString(undefined, {
        month: "short",
      });
      return { month: label, amount: Math.round(amount * 10) / 10 };
    });

  return (
    <div className="space-y-6 pb-10">
      <FreelancerPageHeader
        title="Timesheets"
        subtitle="Log billable time, track productivity, and review weekly sheets."
        actions={
          <>
            <PrimaryButton href="#log-time">
              <Clock className="h-4 w-4" />
              Log Time
            </PrimaryButton>
            <OutlineButton href="/app/analytics">
              <Download className="h-4 w-4" />
              View analytics
            </OutlineButton>
            <OutlineButton href="/app/settings">
              <Settings2 className="h-4 w-4" />
              Timesheet Settings
            </OutlineButton>
          </>
        }
      />

      <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-5">
        <FreelancerStatCard label="Total Hours" value={hoursLabel} icon={Clock} />
        <FreelancerStatCard
          label="Billable Hours"
          value={billableLabel}
          sub={
            totalHours
              ? `${Math.round((billable / Math.max(0.01, totalHours)) * 100)}% of total`
              : "No hours logged yet"
          }
          icon={Clock}
          iconTone="bg-sky-100 text-sky-800"
        />
        <FreelancerStatCard
          label="Earnings"
          value={money(earnings)}
          sub={earnings > 0 ? "From logged hourly rates" : "Set hourly rates on entries"}
          icon={Clock}
          iconTone="bg-emerald-100 text-emerald-700"
        />
        <FreelancerStatCard
          label="Tracked Days"
          value={trackedDays}
          sub="With logged entries"
        />
        <FreelancerStatCard
          label="Projects"
          value={projects.length}
          sub="In CRM"
          href="/app/projects"
        />
      </div>

      <div className="grid gap-4 xl:grid-cols-[1fr_300px]">
        <div className="space-y-4">
          <FreelancerCard title="Monthly time overview">
            <MonthlyBarChart
              series={monthlySeries}
              valueLabel="Hours"
              formatAsMoney={false}
            />
          </FreelancerCard>
          <div id="log-time">
            <TimesheetsClient initial={entries} ownerUid={uid} />
          </div>
        </div>
        <aside className="space-y-4">
          <LiveTimer
            ownerUid={uid}
            projectName={projects[0]?.name}
            projectId={projects[0]?.id}
          />
          <DonutChart
            title="Hours summary"
            slices={
              totalHours > 0
                ? [
                    { name: "Billable", value: Math.round(billable * 10) / 10, color: "#0D9488" },
                    {
                      name: "Non-billable",
                      value: Math.round(Math.max(0, totalHours - billable) * 10) / 10,
                      color: "#94A3B8",
                    },
                  ].filter((s) => s.value > 0)
                : []
            }
            centerLabel="Hours"
          />
          <FreelancerCard title="Top projects by time">
            <ul className="space-y-3">
              {topProjects.length === 0 ? (
                <li className="text-sm text-text-secondary">
                  Log time against projects to see a breakdown.
                </li>
              ) : (
                topProjects.map((p) => {
                  const pct =
                    topHoursTotal > 0 ? Math.round((p.hours / topHoursTotal) * 100) : 0;
                  return (
                    <li key={p.id}>
                      <div className="flex justify-between text-sm">
                        <span className="font-semibold text-navy">{p.name}</span>
                        <span className="text-text-muted">
                          {p.hours.toFixed(1)}h · {pct}%
                        </span>
                      </div>
                      <div className="mt-1 h-2 rounded-full bg-background">
                        <div
                          className="h-full rounded-full bg-primary"
                          style={{ width: `${pct}%` }}
                        />
                      </div>
                    </li>
                  );
                })
              )}
            </ul>
          </FreelancerCard>
          <FreelancerCard title="Productivity score">
            <p className="font-display text-4xl font-extrabold text-primary">
              {totalHours > 0
                ? `${Math.min(100, Math.round((billable / Math.max(0.01, totalHours)) * 100))}%`
                : "—"}
            </p>
            <p className="mt-2 text-sm text-text-secondary">
              {totalHours > 0
                ? "Based on billable vs total tracked hours this period."
                : "Log time to see your productivity score."}
            </p>
          </FreelancerCard>
        </aside>
      </div>
    </div>
  );
}
