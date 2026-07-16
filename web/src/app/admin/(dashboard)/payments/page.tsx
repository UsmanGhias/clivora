"use client";

import { useMemo, useState } from "react";
import { CreditCard, Landmark, Unlock } from "lucide-react";
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

function nameOf(u: Record<string, unknown>) {
  return String(u.full_name || u.name || u.display_name || u.email || "—");
}

export default function AdminPaymentsPage() {
  const { data, loading } = useAdminData();
  const [activeTab, setActiveTab] = useState("all");
  const [q, setQ] = useState("");
  const payments = data?.payments ?? [];

  const kpis = useMemo(() => {
    const volume = payments.reduce((s, p) => s + Number(p.amount_usd ?? p.amount ?? 0), 0);
    const escrow = data?.overview.escrowHeld ?? 0;
    const released = payments
      .filter((p) => ["approved", "paid", "released"].includes(String(p.status).toLowerCase()))
      .reduce((s, p) => s + Number(p.amount_usd ?? p.amount ?? 0), 0);
    return { volume, escrow, released };
  }, [payments, data?.overview.escrowHeld]);

  const statuses = useMemo(() => {
    const set = new Set(payments.map((p) => String(p.status || "pending").toLowerCase()));
    return Array.from(set);
  }, [payments]);

  const filtered = useMemo(() => {
    if (activeTab === "all") return payments;
    return payments.filter((p) => String(p.status).toLowerCase() === activeTab);
  }, [payments, activeTab, q]);

  const tabs = [
    { id: "all", label: "All", count: payments.length },
    ...statuses.map((s) => ({
      id: s,
      label: s.replace(/_/g, " "),
      count: payments.filter((p) => String(p.status).toLowerCase() === s).length,
    })),
  ];

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
        title="Payments"
        subtitle="Pro payment requests and platform transactions."
        actions={null}
      />

      <KpiGrid
        items={[
          {
            label: "Volume",
            value: money(kpis.volume),
            icon: <CreditCard className="h-4 w-4" />,
            iconBg: "bg-teal-50 text-teal-600",
          },
          {
            label: "Escrow",
            value: money(kpis.escrow),
            icon: <Landmark className="h-4 w-4" />,
            iconBg: "bg-blue-50 text-blue-600",
          },
          {
            label: "Released",
            value: money(kpis.released),
            icon: <Unlock className="h-4 w-4" />,
            iconBg: "bg-emerald-50 text-emerald-600",
          },
        ]}
      />

      <PageLayout
        main={
          <div>
            <FilterBar
              searchPlaceholder="Search payments…"
              searchValue={q}
              onSearchChange={setQ}
              tabs={tabs}
              activeTab={activeTab}
              onTabChange={setActiveTab}
              onReset={() => { setActiveTab("all"); setQ(""); }}
            />

            {!data && loading ? (
              <div className="rounded-2xl border border-slate-200 bg-white p-10 text-center text-sm text-slate-500">
                Loading payments…
              </div>
            ) : (
              <AdminTable
                headers={["Payment ID", "Type / Plan", "From", "Method", "Amount", "Status", "Date", "Actions"]}
                footer={<span>Showing {filtered.length} of {payments.length} payments</span>}
              >
                {filtered.length === 0 ? (
                  <tr>
                    <td colSpan={9} className="px-3 py-10 text-center text-sm text-slate-500">
                      No payments found.
                    </td>
                  </tr>
                ) : (
                  filtered.map((p) => (
                    <tr key={String(p.id)} className="hover:bg-slate-50/80">
                      <td className="px-3 py-3">
                        <input type="checkbox" className="rounded border-slate-300" aria-label="Select row" />
                      </td>
                      <td className="px-3 py-3 font-mono text-xs font-bold text-slate-800">
                        {String(p.id).slice(0, 10)}
                      </td>
                      <td className="px-3 py-3 text-sm font-semibold capitalize text-slate-700">
                        {String(p.plan || p.type || "pro")}
                      </td>
                      <td className="px-3 py-3">
                        <AvatarCell name={nameOf(p)} email={String(p.email ?? "")} />
                      </td>
                      <td className="px-3 py-3 text-sm text-slate-600">
                        {String(p.payment_method || "—")}
                      </td>
                      <td className="px-3 py-3 font-semibold text-slate-800">
                        {money(Number(p.amount_usd ?? p.amount ?? 0))}
                      </td>
                      <td className="px-3 py-3">
                        <StatusPill status={String(p.status || "pending").replace(/_/g, " ")} />
                      </td>
                      <td className="px-3 py-3 text-sm text-slate-600">{fmtDate(String(p.created_at ?? ""))}</td>
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
            <SideCard title="Payment summary">
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-slate-500">Volume</span>
                  <span className="font-bold">{money(kpis.volume)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-500">In escrow</span>
                  <span className="font-bold text-blue-600">{money(kpis.escrow)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-500">Released</span>
                  <span className="font-bold text-teal-700">{money(kpis.released)}</span>
                </div>
              </div>
            </SideCard>
          </SidePanel>
        }
      />
    </div>
  );
}
