import Link from "next/link";

function EarningsChart() {
  const points = [
    { month: "Jan", y: 48, label: "2.1k" },
    { month: "Feb", y: 40, label: "3.0k" },
    { month: "Mar", y: 34, label: "3.8k" },
    { month: "Apr", y: 26, label: "4.6k" },
    { month: "May", y: 18, label: "5.4k" },
    { month: "Jun", y: 10, label: "6.2k" },
  ];
  const xs = points.map((_, i) => 14 + i * 28);
  const line = points.map((p, i) => `${xs[i]},${p.y}`).join(" ");
  const area = `${line} ${xs[xs.length - 1]},58 ${xs[0]},58`;

  return (
    <div className="flex h-full min-h-[72px] flex-col">
      <svg viewBox="0 0 176 64" className="h-full w-full flex-1" aria-hidden>
        <defs>
          <linearGradient id="earnFillV2" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor="#0D9488" stopOpacity="0.28" />
            <stop offset="100%" stopColor="#0D9488" stopOpacity="0.02" />
          </linearGradient>
        </defs>
        {[16, 32, 48].map((y) => (
          <line key={y} x1="8" x2="168" y1={y} y2={y} stroke="#E2E8F0" strokeDasharray="2 3" />
        ))}
        <polygon fill="url(#earnFillV2)" points={area} />
        <polyline
          fill="none"
          stroke="#0F766E"
          strokeWidth="2.25"
          strokeLinecap="round"
          strokeLinejoin="round"
          points={line}
        />
        {points.map((p, i) => (
          <g key={p.month}>
            <circle cx={xs[i]} cy={p.y} r={i === points.length - 1 ? 3.2 : 2.2} fill="#0D9488" />
            {i === points.length - 1 && (
              <text
                x={xs[i]}
                y={p.y - 6}
                textAnchor="middle"
                className="fill-teal-800"
                style={{ fontSize: 7, fontWeight: 700 }}
              >
                ${p.label}
              </text>
            )}
          </g>
        ))}
      </svg>
      <div className="mt-0.5 flex border-t border-slate-200 pt-1">
        {points.map((p) => (
          <span
            key={p.month}
            className="min-w-0 flex-1 text-center text-[7px] font-semibold uppercase tracking-wide text-slate-500"
          >
            {p.month}
          </span>
        ))}
      </div>
    </div>
  );
}

function Stat({ label, value, trend }: { label: string; value: string; trend?: string }) {
  return (
    <div className="rounded-lg border border-slate-200/80 bg-white px-2 py-1.5">
      <p className="truncate text-[8px] font-semibold uppercase tracking-wide text-slate-500">{label}</p>
      <p className="mt-0.5 font-display text-xs font-bold tabular-nums text-[#0F172A]">{value}</p>
      {trend && <p className="mt-0.5 text-[8px] font-bold text-emerald-600">{trend}</p>}
    </div>
  );
}

function NavItem({
  label,
  href,
  active,
  badge,
}: {
  label: string;
  href: string;
  active?: boolean;
  badge?: number;
}) {
  return (
    <Link
      href={href}
      className={`flex items-center justify-between rounded-md px-2 py-1.5 text-[9px] font-medium transition hover:bg-white/10 ${
        active ? "bg-teal-500/25 text-white" : "text-white/60"
      }`}
    >
      <span className="truncate">{label}</span>
      {badge != null && (
        <span className="rounded bg-teal-500/40 px-1.5 py-px text-[8px] font-bold text-white">{badge}</span>
      )}
    </Link>
  );
}

export function FreelancerDashMock({ compact = false }: { compact?: boolean }) {
  const projects = [
    { name: "SaaS Dashboard", pct: 72 },
    { name: "Mobile App UI", pct: 45 },
    { name: "Brand Identity", pct: 90 },
  ];
  const clients = [
    { name: "Acme Corp", spend: "$8,400" },
    { name: "Nova Labs", spend: "$5,200" },
    { name: "Pixel Co", spend: "$3,100" },
  ];

  return (
    <div
      className={`w-full max-w-full overflow-hidden rounded-xl border border-slate-200/90 bg-white shadow-[0_20px_50px_-28px_rgba(15,23,42,0.45)] ${compact ? "text-[95%]" : ""}`}
    >
      <div className={compact ? "flex min-h-[320px] sm:h-[380px]" : "flex min-h-[360px] sm:h-[480px]"}>
        <aside
          className={`hidden shrink-0 flex-col bg-[#0B1220] p-2.5 text-white sm:flex ${compact ? "w-[108px]" : "w-[132px]"}`}
        >
          <p className="font-display text-[11px] font-bold tracking-[0.04em]">CLIVORA</p>
          <p className="mt-0.5 text-[8px] font-semibold uppercase tracking-[0.16em] text-teal-300/80">
            Freelancer
          </p>
          <div className="mt-3 flex items-center gap-1.5 border-b border-white/10 pb-3">
            <span className="flex h-6 w-6 items-center justify-center rounded-full bg-teal-600 text-[8px] font-bold">
              UG
            </span>
            <div className="min-w-0">
              <p className="truncate text-[9px] font-semibold">Usman Ghias</p>
              <span className="mt-0.5 inline-block rounded bg-amber-300 px-1 py-px text-[7px] font-bold text-[#0F172A]">
                Pro Plus
              </span>
            </div>
          </div>
          <nav className="mt-2 space-y-0.5">
            <NavItem label="Dashboard" href="/login?next=/app" active />
            <NavItem label="Projects" href="/login?next=/app/projects" badge={6} />
            <NavItem label="Proposals" href="/login?next=/app/proposals" badge={5} />
            <NavItem label="Messages" href="/login?next=/app/messages" badge={4} />
            <NavItem label="Earnings" href="/login?next=/app/earnings" />
            <NavItem label="Connect" href="/login?next=/app/connect" />
            <NavItem label="Settings" href="/login?next=/app/settings" />
            <NavItem label="Profile" href="/login?next=/app/account" />
          </nav>
        </aside>

        <main className="min-w-0 flex-1 overflow-hidden bg-[#F4F7F6] p-2.5">
          <p className="font-display text-[11px] font-bold text-[#0F172A]">Good morning, Usman</p>
          <p className="text-[9px] text-slate-500">Freelance overview · synced web + Android</p>

          <div className="mt-2 grid grid-cols-2 gap-1.5 sm:grid-cols-4">
            <Stat label="Earnings" value="$24,560" trend={compact ? undefined : "+12.4%"} />
            <Stat label="Projects" value="6" />
            <Stat label="Proposals" value="5" />
            <Stat label="Messages" value="4" />
          </div>

          <div className="mt-2 grid grid-cols-1 gap-1.5 sm:grid-cols-5">
            <div className="rounded-lg border border-slate-200/80 bg-white p-2 sm:col-span-3">
              <div className="flex items-baseline justify-between gap-2">
                <div>
                  <p className="text-[9px] font-bold text-[#0F172A]">Earnings</p>
                  <p className="text-[8px] text-slate-500">Last six months</p>
                </div>
                <span className="text-[8px] font-semibold tabular-nums text-teal-700">$6.2k Jun</span>
              </div>
              <div className="mt-1 h-[78px]">
                <EarningsChart />
              </div>
            </div>

            <div className="rounded-lg border border-slate-200/80 bg-white p-2 sm:col-span-2">
              <p className="text-[9px] font-bold text-[#0F172A]">Active projects</p>
              <ul className="mt-2 space-y-2">
                {projects.map((p) => (
                  <li key={p.name}>
                    <div className="flex justify-between gap-2 text-[8px]">
                      <span className="truncate text-slate-600">{p.name}</span>
                      <span className="shrink-0 font-bold tabular-nums text-[#0F172A]">{p.pct}%</span>
                    </div>
                    <div className="mt-1 h-[3px] overflow-hidden rounded-full bg-slate-100">
                      <div
                        className="h-full rounded-full bg-gradient-to-r from-teal-700 to-teal-400"
                        style={{ width: `${p.pct}%` }}
                      />
                    </div>
                  </li>
                ))}
              </ul>
            </div>
          </div>

          <div className="mt-2 rounded-lg border border-slate-200/80 bg-white p-2">
            <p className="text-[9px] font-bold text-[#0F172A]">Top clients</p>
            <ul className="mt-1.5 divide-y divide-slate-100">
              {clients.map((c) => (
                <li key={c.name} className="flex items-center justify-between gap-2 py-1.5 first:pt-0 last:pb-0">
                  <div className="flex min-w-0 items-center gap-1.5">
                    <span className="flex h-5 w-5 shrink-0 items-center justify-center rounded-full bg-slate-800 text-[7px] font-bold text-white">
                      {c.name[0]}
                    </span>
                    <span className="truncate text-[8px] font-medium text-slate-700">{c.name}</span>
                  </div>
                  <span className="shrink-0 text-[8px] font-bold tabular-nums text-[#0F172A]">{c.spend}</span>
                </li>
              ))}
            </ul>
          </div>
        </main>
      </div>
    </div>
  );
}
