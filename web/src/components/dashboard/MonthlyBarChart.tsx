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

const DEMO = [
  { month: "Feb", amount: 2800 },
  { month: "Mar", amount: 3200 },
  { month: "Apr", amount: 4100 },
  { month: "May", amount: 4750 },
  { month: "Jun", amount: 5200 },
  { month: "Jul", amount: 6100 },
];

export function MonthlyBarChart({ total }: { total: number }) {
  const data =
    total > 0
      ? DEMO.map((d) => ({
          ...d,
          amount: Math.round((d.amount / 6100) * Math.max(total / 6, 400)),
        }))
      : DEMO;

  return (
    <div className="h-56 w-full">
      <ResponsiveContainer width="100%" height="100%">
        <BarChart data={data}>
          <CartesianGrid strokeDasharray="3 3" stroke="#E2E8F0" vertical={false} />
          <XAxis dataKey="month" tick={{ fontSize: 11 }} axisLine={false} tickLine={false} />
          <YAxis tick={{ fontSize: 11 }} axisLine={false} tickLine={false} width={40} />
          <Tooltip
            formatter={(v) => [`$${Number(v ?? 0).toLocaleString()}`, "Earnings"]}
            contentStyle={{ borderRadius: 12, border: "1px solid #E2E8F0" }}
          />
          <Bar dataKey="amount" fill="#0D9488" radius={[8, 8, 0, 0]} />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}
