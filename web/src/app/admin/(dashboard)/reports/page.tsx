"use client";

import { useMemo, useState } from "react";
import { FileText } from "lucide-react";
import { useAdminData } from "@/components/admin/AdminDataProvider";
import {
  AdminPageHeader,
  ExportImportAdd,
  downloadCsv,
  KpiGrid,
  FilterBar,
  AdminTable,
  StatusPill,
  AvatarCell,
  PageLayout,
  SidePanel,
  SideCard,
  money,
  fmtDate,
  ErrorBanner,
} from "@/components/admin/ui";

const TEMPLATES = [
  { id: "rev", name: "Revenue summary", period: "Last 30 days", key: "totalRevenue" as const },
  { id: "users", name: "User growth", period: "Last 30 days", key: "totalUsers" as const },
  { id: "escrow", name: "Escrow balance", period: "Current", key: "escrowHeld" as const },
];

export default function AdminReportsPage() {
  const { data, loading } = useAdminData();
  const [q, setQ] = useState("");
  const o = data?.overview;

  const filtered = useMemo(() => {
    const needle = q.trim().toLowerCase();
    if (!needle) return TEMPLATES;
    return TEMPLATES.filter(
      (r) => r.name.toLowerCase().includes(needle) || r.period.toLowerCase().includes(needle),
    );
  }, [q]);

  return (
    <div>
      {data?.warning && (
        <ErrorBanner
          message={data.warning}
          onViewLogs={() => {
            window.location.href = "/admin/events";
          }}
        />
      )}

      <AdminPageHeader
        title="Reports"
        subtitle="Exportable platform summaries and KPIs."
        actions={
          <ExportImportAdd
            entity="Reports"
            onExport={() =>
              downloadCsv(
                "platform-kpis.csv",
                ["metric", "value"],
                [
                  ["totalRevenue", o?.totalRevenue ?? 0],
                  ["totalUsers", o?.totalUsers ?? 0],
                  ["activeProjects", o?.activeProjects ?? 0],
                  ["totalPayments", o?.totalPayments ?? 0],
                  ["escrowHeld", o?.escrowHeld ?? 0],
                ],
              )
            }
          />
        }
      />

      <KpiGrid
        items={[
          {
            label: "Revenue",
            value: money(o?.totalRevenue ?? 0),
            icon: <FileText className="h-4 w-4" />,
            iconBg: "bg-teal-50 text-teal-600",
          },
          { label: "Users", value: o?.totalUsers ?? 0 },
          { label: "Projects", value: o?.activeProjects ?? 0 },
          { label: "Payments", value: money(o?.totalPayments ?? 0) },
        ]}
      />

      <PageLayout
        main={
          <div>
            <FilterBar
              searchPlaceholder="Search reports…"
              searchValue={q}
              onSearchChange={setQ}
              onReset={() => setQ("")}
            />
            {!data && loading ? (
              <div className="rounded-2xl border border-slate-200 bg-white p-10 text-center text-sm text-slate-500">
                Loading reports…
              </div>
            ) : (
              <AdminTable
                headers={["Report", "Period", "Value", "Generated"]}
                footer={<span>Built-in report templates</span>}
              >
                {filtered.length === 0 ? (
                  <tr>
                    <td colSpan={5} className="px-3 py-10 text-center text-sm text-slate-500">
                      No matching reports.
                    </td>
                  </tr>
                ) : (
                  filtered.map((r) => (
                    <tr key={r.id} className="hover:bg-slate-50/80">
                      <td className="px-3 py-3">
                        <AvatarCell name={r.name} subtitle={r.period} />
                      </td>
                      <td className="px-3 py-3 text-sm text-slate-600">{r.period}</td>
                      <td className="px-3 py-3 font-semibold text-slate-800">
                        {r.key === "totalUsers"
                          ? String(o?.[r.key] ?? 0)
                          : money(Number(o?.[r.key] ?? 0))}
                      </td>
                      <td className="px-3 py-3">
                        <StatusPill status="active" />
                      </td>
                      <td className="px-3 py-3 text-sm text-slate-600">
                        {fmtDate(new Date().toISOString())}
                      </td>
                    </tr>
                  ))
                )}
              </AdminTable>
            )}
          </div>
        }
        side={
          <SidePanel>
            <SideCard title="Report tips">
              <p className="text-xs text-slate-500">Use Export to download a CSV snapshot of live KPIs.</p>
            </SideCard>
          </SidePanel>
        }
      />
    </div>
  );
}
