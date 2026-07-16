"use client";

import Link from "next/link";
import {
  Briefcase,
  CreditCard,
  FolderKanban,
  RefreshCw,
  Users,
  Wallet,
  Zap,
} from "lucide-react";
import { useAdminData } from "@/components/admin/AdminDataProvider";
import {
  AdminBtn,
  AdminPageHeader,
  downloadCsv,
  ErrorBanner,
  KpiGrid,
  PageLayout,
  SideCard,
  SidePanel,
  money,
  relative,
} from "@/components/admin/ui";

export default function AdminOverviewPage() {
  const { data, loading, error, refresh } = useAdminData();
  const o = data?.overview;

  return (
    <div>
      {(data?.warning || error) && (
        <ErrorBanner
          message={data?.warning || error || "Stats request failed (503)"}
          onViewLogs={() => {
            window.location.href = "/admin/events";
          }}
        />
      )}

      <AdminPageHeader
        title="Overview"
        subtitle="Platform totals from live admin data."
        actions={
          <>
            <AdminBtn variant="primary" onClick={() => void refresh()}>
              <RefreshCw className={`h-3.5 w-3.5 ${loading ? "animate-spin" : ""}`} /> Refresh
            </AdminBtn>
            <AdminBtn
              variant="dark"
              onClick={() =>
                downloadCsv(
                  "overview-kpis.csv",
                  ["metric", "value"],
                  [
                    ["totalRevenue", o?.totalRevenue ?? 0],
                    ["totalUsers", o?.totalUsers ?? 0],
                    ["activeProjects", o?.activeProjects ?? 0],
                    ["totalPayments", o?.totalPayments ?? 0],
                    ["escrowHeld", o?.escrowHeld ?? 0],
                    ["totalPayouts", o?.totalPayouts ?? 0],
                  ],
                )
              }
            >
              Export report
            </AdminBtn>
          </>
        }
      />

      <KpiGrid
        items={[
          {
            label: "Total Revenue",
            value: money(o?.totalRevenue ?? 0),
            icon: <Wallet className="h-4 w-4" />,
            iconBg: "bg-emerald-50 text-emerald-600",
          },
          {
            label: "Total Users",
            value: o?.totalUsers ?? 0,
            icon: <Users className="h-4 w-4" />,
            iconBg: "bg-blue-50 text-blue-600",
          },
          {
            label: "Freelancers",
            value: o?.freelancers ?? 0,
            icon: <Briefcase className="h-4 w-4" />,
            iconBg: "bg-violet-50 text-violet-600",
          },
          {
            label: "Active Projects",
            value: o?.activeProjects ?? 0,
            icon: <FolderKanban className="h-4 w-4" />,
            iconBg: "bg-orange-50 text-orange-600",
          },
          {
            label: "Total Jobs",
            value: o?.totalJobs ?? 0,
            icon: <Zap className="h-4 w-4" />,
            iconBg: "bg-cyan-50 text-cyan-600",
          },
          {
            label: "Total Payments",
            value: money(o?.totalPayments ?? 0),
            icon: <CreditCard className="h-4 w-4" />,
            iconBg: "bg-pink-50 text-pink-600",
          },
        ]}
      />

      <PageLayout
        main={
          <div className="space-y-4">
            <div className="grid gap-4 lg:grid-cols-2">
              <div className="rounded-2xl border border-slate-200 bg-white p-4 shadow-sm">
                <h3 className="mb-3 text-sm font-bold">Revenue Overview</h3>
                <EmptySeries label="No revenue time-series available yet" />
                <div className="mt-3 grid grid-cols-2 gap-2 text-xs sm:grid-cols-4">
                  <Metric label="Total Revenue" value={money(o?.totalRevenue ?? 0)} />
                  <Metric label="Platform Fee" value={money(o?.platformFee ?? 0)} />
                  <Metric label="Escrow Held" value={money(o?.escrowHeld ?? 0)} />
                  <Metric label="Total Payouts" value={money(o?.totalPayouts ?? 0)} />
                </div>
              </div>

              <div className="rounded-2xl border border-slate-200 bg-white p-4 shadow-sm">
                <h3 className="mb-3 text-sm font-bold">User Growth</h3>
                <EmptySeries label="No user growth time-series available yet" />
                <div className="mt-3 grid grid-cols-2 gap-2 text-xs sm:grid-cols-4">
                  <Metric label="Total Users" value={String(o?.totalUsers ?? 0)} />
                  <Metric label="New Users" value={String(o?.newUsers ?? 0)} />
                  <Metric label="Freelancers" value={String(o?.freelancers ?? 0)} />
                  <Metric label="New Freelancers" value={String(o?.newFreelancers ?? 0)} />
                </div>
              </div>
            </div>

            <div className="grid gap-4 lg:grid-cols-3">
              <div className="rounded-2xl border border-slate-200 bg-white p-4 shadow-sm lg:col-span-1">
                <h3 className="mb-3 text-sm font-bold">Platform Health</h3>
                <p className="text-sm text-slate-500">
                  Live health checks are not instrumented in this build. Use events and logs for
                  operational signal.
                </p>
                <Link href="/admin/events" className="mt-3 inline-block text-xs font-bold text-teal-600">
                  View system logs →
                </Link>
              </div>

              <div className="rounded-2xl border border-slate-200 bg-white p-4 shadow-sm lg:col-span-2">
                <h3 className="mb-3 text-sm font-bold">Recent Activity</h3>
                <ul className="space-y-2.5">
                  {(data?.events ?? []).slice(0, 8).map((ev) => (
                    <li key={String(ev.id)} className="flex items-start justify-between gap-3 text-sm">
                      <div>
                        <div className="font-semibold text-slate-800">{String(ev.event_type ?? "event")}</div>
                        <div className="text-xs text-slate-500">
                          {String(ev.user_email || ev.user_name || "system")}
                        </div>
                      </div>
                      <div className="shrink-0 text-[11px] text-slate-400">{relative(String(ev.created_at))}</div>
                    </li>
                  ))}
                  {(data?.events?.length ?? 0) === 0 && (
                    <li className="text-sm text-slate-500">No recent events yet.</li>
                  )}
                </ul>
              </div>
            </div>
          </div>
        }
        side={
          <SidePanel>
            <SideCard title="Quick links" footer={<Link href="/admin/settings">System settings →</Link>}>
              <div className="space-y-2 text-sm">
                <Link className="block font-semibold text-teal-700" href="/admin/users">Users</Link>
                <Link className="block font-semibold text-teal-700" href="/admin/payments">Payments</Link>
                <Link className="block font-semibold text-teal-700" href="/admin/escrow">Escrow</Link>
                <Link className="block font-semibold text-teal-700" href="/admin/connect">Connect</Link>
              </div>
            </SideCard>
            <SideCard title="Source">
              <p className="text-xs text-slate-500">
                Data source: <strong>{data?.source ?? "…"}</strong>
                {loading ? " · refreshing…" : ""}
              </p>
            </SideCard>
          </SidePanel>
        }
      />
    </div>
  );
}

function Metric({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-xl bg-slate-50 px-2.5 py-2">
      <div className="text-[10px] font-semibold uppercase tracking-wide text-slate-400">{label}</div>
      <div className="font-bold text-slate-800">{value}</div>
    </div>
  );
}

function EmptySeries({ label }: { label: string }) {
  return (
    <div className="flex h-48 items-center justify-center rounded-xl border border-dashed border-slate-200 bg-slate-50">
      <p className="px-4 text-center text-sm font-medium text-slate-500">{label}</p>
    </div>
  );
}
