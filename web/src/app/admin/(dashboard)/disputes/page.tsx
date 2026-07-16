"use client";

import { useMemo, useState } from "react";
import { AlertTriangle } from "lucide-react";
import { useAdminData } from "@/components/admin/AdminDataProvider";
import {
  AdminPageHeader,
  ExportImportAdd,
  downloadCsv,
  matchesAdminQuery,
  KpiGrid,
  FilterBar,
  AdminTable,
  StatusPill,
  AvatarCell,
  RowActions,
  PageLayout,
  SidePanel,
  SideCard,
  money,
  fmtDate,
  ErrorBanner,
} from "@/components/admin/ui";

export default function AdminDisputesPage() {
  const { data, loading } = useAdminData();
  const [q, setQ] = useState("");
  const count = data?.disputes ?? 0;
  const escrowDisputed = useMemo(
    () =>
      (data?.escrow ?? []).filter((e) => String(e.status).toLowerCase().includes("dispute")),
    [data?.escrow],
  );
  const filtered = useMemo(
    () => escrowDisputed.filter((row) => matchesAdminQuery(row, q)),
    [escrowDisputed, q],
  );

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
        title="Disputes"
        subtitle="Escrow and payment disputes requiring review."
        actions={
          <ExportImportAdd
            entity="Disputes"
            onExport={() =>
              downloadCsv(
                "disputes.csv",
                Object.keys(filtered[0] ?? { id: "", status: "", amount: "" }),
                filtered.map((row) =>
                  Object.keys(filtered[0] ?? { id: "", status: "", amount: "" }).map((k) =>
                    String(row[k] ?? ""),
                  ),
                ),
              )
            }
          />
        }
      />

      <KpiGrid
        items={[
          {
            label: "Disputes",
            value: count || escrowDisputed.length,
            icon: <AlertTriangle className="h-4 w-4" />,
            iconBg: "bg-red-50 text-red-600",
          },
          { label: "Escrow held", value: money(data?.overview.escrowHeld ?? 0) },
          { label: "Tickets", value: data?.tickets ?? 0 },
        ]}
      />

      <PageLayout
        main={
          <div>
            <FilterBar
              searchPlaceholder="Search disputes…"
              searchValue={q}
              onSearchChange={setQ}
              onReset={() => setQ("")}
            />
            {!data && loading ? (
              <div className="rounded-2xl border border-slate-200 bg-white p-10 text-center text-sm text-slate-500">
                Loading disputes…
              </div>
            ) : (
              <AdminTable
                headers={["Case", "Subject", "Status", "Opened", "Actions"]}
                footer={<span>{filtered.length} of {escrowDisputed.length || count} disputes</span>}
              >
                {filtered.length === 0 ? (
                  <tr>
                    <td colSpan={6} className="px-3 py-10 text-center text-sm text-slate-500">
                      No open disputes. Count on record: {count}.
                    </td>
                  </tr>
                ) : (
                  filtered.map((d) => (
                    <tr key={String(d.id)} className="hover:bg-slate-50/80">
                      <td className="px-3 py-3">
                        <input type="checkbox" className="rounded border-slate-300" aria-label="Select row" />
                      </td>
                      <td className="px-3 py-3 font-mono text-xs font-bold">{String(d.id).slice(0, 10)}</td>
                      <td className="px-3 py-3">
                        <AvatarCell name={String(d.title || "Dispute")} subtitle={money(Number(d.amount ?? 0))} />
                      </td>
                      <td className="px-3 py-3">
                        <StatusPill status="disputed" />
                      </td>
                      <td className="px-3 py-3 text-sm text-slate-600">{fmtDate(String(d.created_at ?? ""))}</td>
                      <td className="px-3 py-3">
                        <RowActions />
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
            <SideCard title="Dispute queue">
              <p className="text-xs text-slate-500">
                Rows come from escrow records marked disputed. Use search to narrow by id or title.
              </p>
            </SideCard>
          </SidePanel>
        }
      />
    </div>
  );
}
