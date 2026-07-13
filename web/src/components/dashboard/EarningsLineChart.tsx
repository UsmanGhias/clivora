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
import { cn } from "@/lib/utils";

const DEMO = [
  { day: "Jul 1", amount: 420 },
  { day: "Jul 5", amount: 680 },
  { day: "Jul 10", amount: 540 },
  { day: "Jul 15", amount: 920 },
  { day: "Jul 21", amount: 1150 },
  { day: "Jul 25", amount: 880 },
  { day: "Jul 31", amount: 1320 },
];

export function EarningsLineChart({
  total,
  accent = "teal",
  title = "Earnings overview",
  trendLabel,
  summaryBoxes,
}: {
  total: number;
  accent?: "teal" | "slate";
  title?: string;
  trendLabel?: string;
  summaryBoxes?: Array<{ label: string; value: string; tone: string }>;
}) {
  const stroke = accent === "slate" ? "#475569" : "#0D9488";
  const fill = stroke;
  const gradId = accent === "slate" ? "spendGrad" : "earnGrad";
  const scaled =
    total > 0
      ? DEMO.map((d) => ({
          ...d,
          amount: Math.round((d.amount / 1320) * Math.max(total / 6, 200)),
        }))
      : DEMO;

  return (
    <div className="rounded-2xl border border-border bg-surface p-5 shadow-sm">
      <div className="mb-4 flex flex-wrap items-start justify-between gap-2">
        <div>
          <h2 className="font-display text-lg font-bold text-navy">{title}</h2>
          <p className="mt-1 font-display text-2xl font-extrabold text-navy">
            ${total.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
          </p>
          {trendLabel && (
            <p
              className={cn(
                "mt-1 text-xs font-semibold",
                accent === "slate" ? "text-client-accent" : "text-success",
              )}
            >
              {trendLabel}
            </p>
          )}
        </div>
        <select className="rounded-lg border border-border bg-surface px-3 py-1.5 text-xs font-semibold text-text-secondary">
          <option>This month</option>
          <option>Last month</option>
        </select>
      </div>
      <div className="h-52 w-full">
        <ResponsiveContainer width="100%" height="100%">
          <AreaChart data={scaled}>
            <defs>
              <linearGradient id={gradId} x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor={fill} stopOpacity={0.35} />
                <stop offset="100%" stopColor={fill} stopOpacity={0.02} />
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" stroke="#E2E8F0" vertical={false} />
            <XAxis dataKey="day" tick={{ fontSize: 11 }} axisLine={false} tickLine={false} />
            <YAxis tick={{ fontSize: 11 }} axisLine={false} tickLine={false} width={40} />
            <Tooltip
              formatter={(v) => [`$${Number(v ?? 0).toLocaleString()}`, title.includes("Spend") ? "Spend" : "Earnings"]}
              contentStyle={{ borderRadius: 12, border: "1px solid #E2E8F0" }}
            />
            <Area
              type="monotone"
              dataKey="amount"
              stroke={stroke}
              strokeWidth={2.5}
              fill={`url(#${gradId})`}
              dot={{ r: 3, fill: stroke }}
              activeDot={{ r: 5 }}
            />
          </AreaChart>
        </ResponsiveContainer>
      </div>
      {summaryBoxes && summaryBoxes.length > 0 && (
        <div className="mt-4 grid grid-cols-2 gap-2 sm:grid-cols-4">
          {summaryBoxes.map((b) => (
            <div key={b.label} className={cn("rounded-xl px-3 py-2.5", b.tone)}>
              <p className="text-[10px] font-bold uppercase tracking-wide opacity-80">{b.label}</p>
              <p className="mt-0.5 text-sm font-extrabold">{b.value}</p>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
