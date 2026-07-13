"use client";

import {
  Area,
  AreaChart,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";

const DEMO = [
  { day: "Jul 1", amount: 120 },
  { day: "Jul 5", amount: 280 },
  { day: "Jul 10", amount: 190 },
  { day: "Jul 15", amount: 420 },
  { day: "Jul 20", amount: 360 },
  { day: "Jul 25", amount: 510 },
  { day: "Jul 31", amount: 680 },
];

export function EarningsLineChart({
  total,
  accent = "teal",
}: {
  total: number;
  accent?: "teal" | "slate";
}) {
  const stroke = accent === "slate" ? "#475569" : "#0D9488";
  const fill = accent === "slate" ? "#475569" : "#0D9488";

  return (
    <div className="rounded-2xl border border-border bg-surface p-5 shadow-sm">
      <div className="mb-4 flex items-center justify-between gap-2">
        <div>
          <h2 className="font-display text-lg font-bold text-navy">Earnings overview</h2>
          <p className="text-sm text-text-secondary">
            Total invoiced: <strong className="text-navy">${total.toLocaleString()}</strong>
          </p>
        </div>
        <select className="rounded-lg border border-border bg-surface px-3 py-1.5 text-xs font-semibold text-text-secondary">
          <option>This month</option>
          <option>Last month</option>
        </select>
      </div>
      <div className="h-56 w-full">
        <ResponsiveContainer width="100%" height="100%">
          <AreaChart data={DEMO}>
            <defs>
              <linearGradient id="earnGrad" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor={fill} stopOpacity={0.35} />
                <stop offset="100%" stopColor={fill} stopOpacity={0.02} />
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" stroke="#E2E8F0" vertical={false} />
            <XAxis dataKey="day" tick={{ fontSize: 11 }} axisLine={false} tickLine={false} />
            <YAxis tick={{ fontSize: 11 }} axisLine={false} tickLine={false} width={40} />
            <Tooltip
              formatter={(v) => [`$${Number(v ?? 0)}`, "Earnings"]}
              contentStyle={{ borderRadius: 12, border: "1px solid #E2E8F0" }}
            />
            <Area
              type="monotone"
              dataKey="amount"
              stroke={stroke}
              strokeWidth={2.5}
              fill="url(#earnGrad)"
              dot={{ r: 3, fill: stroke }}
            />
          </AreaChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
