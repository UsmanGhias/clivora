"use client";

import {
  Bar,
  BarChart,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";

export type MonthlyBarPoint = {
  month: string;
  amount: number;
};

export function MonthlyBarChart({
  series,
  valueLabel = "Amount",
  formatAsMoney = true,
}: {
  /** Real monthly points only. When omitted or empty, an empty state is shown. */
  series?: MonthlyBarPoint[];
  valueLabel?: string;
  formatAsMoney?: boolean;
}) {
  const data = series && series.length > 0 ? series : [];
  const isEmpty = data.length === 0;

  if (isEmpty) {
    return (
      <div className="flex h-56 w-full items-center justify-center rounded-xl border border-dashed border-border bg-background/50">
        <p className="px-4 py-2 text-center text-sm font-semibold text-text-secondary">
          No monthly data yet
        </p>
      </div>
    );
  }

  return (
    <div className="relative h-56 w-full">
      <ResponsiveContainer width="100%" height="100%">
        <BarChart data={data}>
          <CartesianGrid strokeDasharray="3 3" stroke="#E2E8F0" vertical={false} />
          <XAxis dataKey="month" tick={{ fontSize: 11 }} axisLine={false} tickLine={false} />
          <YAxis tick={{ fontSize: 11 }} axisLine={false} tickLine={false} width={40} />
          <Tooltip
            formatter={(v) => [
              formatAsMoney
                ? `$${Number(v ?? 0).toLocaleString()}`
                : Number(v ?? 0).toLocaleString(undefined, { maximumFractionDigits: 1 }),
              valueLabel,
            ]}
            contentStyle={{ borderRadius: 12, border: "1px solid #E2E8F0" }}
          />
          <Bar dataKey="amount" fill="#0D9488" radius={[8, 8, 0, 0]} />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}
