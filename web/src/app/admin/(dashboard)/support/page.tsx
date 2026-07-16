"use client";

import { useState } from "react";
import { Ticket } from "lucide-react";
import { useAdminData } from "@/components/admin/AdminDataProvider";
import {
  AdminPageHeader,
  KpiGrid,
  FilterBar,
  AdminTable,
  PageLayout,
  SidePanel,
  SideCard,
  money,
  ErrorBanner,
} from "@/components/admin/ui";

export default function AdminSupportPage() {
  const { data, loading } = useAdminData();
  const [q, setQ] = useState("");
  const tickets = data?.tickets ?? 0;

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
        title="Support Tickets"
        subtitle="Customer support queue and ticket volume."
      />

      <KpiGrid
        items={[
          {
            label: "Tickets",
            value: tickets,
            icon: <Ticket className="h-4 w-4" />,
            iconBg: "bg-teal-50 text-teal-600",
          },
          { label: "Users", value: data?.overview.totalUsers ?? 0 },
          { label: "Disputes", value: data?.disputes ?? 0 },
        ]}
      />

      <PageLayout
        main={
          <div>
            <FilterBar
              searchPlaceholder="Search tickets…"
              searchValue={q}
              onSearchChange={setQ}
              onReset={() => setQ("")}
            />
            {!data && loading ? (
              <div className="rounded-2xl border border-slate-200 bg-white p-10 text-center text-sm text-slate-500">
                Loading support…
              </div>
            ) : (
              <AdminTable
                headers={["Ticket", "Requester", "Status", "Updated", "Actions"]}
                footer={<span>{tickets} tickets on record</span>}
              >
                <tr>
                  <td colSpan={6} className="px-3 py-10 text-center text-sm text-slate-500">
                    {tickets > 0
                      ? `${tickets} ticket(s) counted in platform snapshot. Detailed ticket rows are not wired yet — use Events for activity.`
                      : "No support tickets yet."}
                    {q.trim() ? ` (search: “${q.trim()}”)` : ""}
                  </td>
                </tr>
              </AdminTable>
            )}
          </div>
        }
        side={
          <SidePanel>
            <SideCard title="Support overview">
              <p className="text-xs text-slate-500">
                Ticket count from platform snapshot. Revenue context {money(data?.overview.totalRevenue ?? 0)}.
              </p>
            </SideCard>
          </SidePanel>
        }
      />
    </div>
  );
}
