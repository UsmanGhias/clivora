function PhoneFrame({ children, label }: { children: React.ReactNode; label: string }) {
  return (
    <div className="flex flex-col items-center">
      <div className="relative w-[148px] rounded-[22px] border-[3px] border-[#1E293B] bg-[#1E293B] p-1 shadow-xl shadow-slate-400/30">
        <div className="absolute left-1/2 top-1.5 z-10 h-3 w-14 -translate-x-1/2 rounded-full bg-[#0F172A]" />
        <div className="overflow-hidden rounded-[18px] bg-[#F8FAFC]">
          <div className="flex items-center justify-between bg-white px-3 pb-1 pt-5">
            <span className="text-[8px] font-semibold text-[#0F172A]">9:41</span>
            <div className="flex gap-0.5">
              <span className="h-1.5 w-2.5 rounded-sm bg-[#0F172A]" />
              <span className="h-1.5 w-2 rounded-sm bg-[#0F172A]" />
            </div>
          </div>
          {children}
        </div>
        <div className="mx-auto mt-1 h-1 w-10 rounded-full bg-slate-600" />
      </div>
      <p className="mt-2 text-[9px] font-medium text-[#475569]">{label}</p>
    </div>
  );
}

function DashboardPhone() {
  return (
    <div className="px-2 pb-3 pt-1">
      <p className="text-[9px] font-bold text-[#0F172A]">Good morning!</p>
      <div className="mt-2 grid grid-cols-2 gap-1">
        {[
          { l: "Earnings", v: "$24.5k" },
          { l: "Projects", v: "6" },
          { l: "Proposals", v: "5" },
          { l: "Messages", v: "4" },
        ].map((s) => (
          <div key={s.l} className="rounded-lg border border-slate-200 bg-white p-1.5 shadow-sm">
            <p className="text-[7px] text-[#475569]">{s.l}</p>
            <p className="text-[9px] font-bold text-[#0F172A]">{s.v}</p>
          </div>
        ))}
      </div>
      <div className="mt-2 rounded-lg border border-slate-200 bg-white p-1.5 shadow-sm">
        <p className="text-[7px] font-semibold text-[#0F172A]">Earnings</p>
        <svg viewBox="0 0 120 32" className="mt-1 h-8 w-full" aria-hidden>
          <polyline
            fill="none"
            stroke="#0D9488"
            strokeWidth="1.5"
            points="4,24 24,20 44,18 64,12 84,10 104,6"
            strokeLinecap="round"
          />
        </svg>
      </div>
      <div className="mt-2 space-y-1">
        {["SaaS Dashboard", "Mobile UI"].map((p, i) => (
          <div key={p} className="rounded-lg border border-slate-200 bg-white p-1.5">
            <div className="flex justify-between text-[7px]">
              <span className="text-[#475569]">{p}</span>
              <span className="font-semibold text-[#0F172A]">{i === 0 ? "72%" : "45%"}</span>
            </div>
            <div className="mt-0.5 h-0.5 rounded-full bg-slate-100">
              <div className="h-0.5 rounded-full bg-[#0D9488]" style={{ width: i === 0 ? "72%" : "45%" }} />
            </div>
          </div>
        ))}
      </div>
      <div className="mt-2 flex justify-around rounded-xl bg-[#0F172A] py-1.5">
        {["Home", "Jobs", "Time", "More"].map((t, i) => (
          <span key={t} className={`text-[6px] font-semibold ${i === 0 ? "text-[#0D9488]" : "text-white/50"}`}>
            {t}
          </span>
        ))}
      </div>
    </div>
  );
}

function TimeTrackingPhone() {
  return (
    <div className="px-2 pb-3 pt-1">
      <p className="text-[9px] font-bold text-[#0F172A]">Time Tracking</p>
      <div className="mt-2 rounded-xl border border-slate-200 bg-white p-2 text-center shadow-sm">
        <p className="text-[7px] text-[#475569]">SaaS Dashboard</p>
        <p className="mt-1 font-mono text-lg font-bold tracking-wider text-[#0F172A]">02:34:18</p>
        <div className="mt-2 flex justify-center gap-2">
          <span className="rounded-full bg-[#0D9488] px-3 py-1 text-[8px] font-bold text-white">Stop</span>
          <span className="rounded-full border border-slate-200 px-3 py-1 text-[8px] font-semibold text-[#475569]">
            Pause
          </span>
        </div>
      </div>
      <p className="mt-2 text-[8px] font-semibold text-[#0F172A]">Today</p>
      <ul className="mt-1 space-y-1">
        {[
          { t: "SaaS Dashboard", d: "2h 34m", b: true },
          { t: "Client Call", d: "45m", b: false },
          { t: "Code Review", d: "1h 12m", b: false },
        ].map((e) => (
          <li key={e.t} className="flex items-center justify-between rounded-lg border border-slate-200 bg-white px-1.5 py-1">
            <div className="flex items-center gap-1">
              {e.b && <span className="h-1.5 w-1.5 rounded-full bg-[#0D9488]" />}
              <span className="text-[7px] text-[#475569]">{e.t}</span>
            </div>
            <span className="text-[7px] font-semibold text-[#0F172A]">{e.d}</span>
          </li>
        ))}
      </ul>
      <div className="mt-2 rounded-lg bg-[#0F172A] p-1.5">
        <p className="text-[7px] text-white/60">Billable today</p>
        <p className="text-[10px] font-bold text-white">4h 31m · $362</p>
      </div>
    </div>
  );
}

export function MobileAppMocks() {
  return (
    <div className="flex w-full max-w-full items-start justify-center gap-6 overflow-hidden rounded-2xl border border-slate-200 bg-gradient-to-b from-slate-50 to-white px-4 py-6 shadow-lg shadow-slate-200/60">
      <PhoneFrame label="Dashboard">
        <DashboardPhone />
      </PhoneFrame>
      <PhoneFrame label="Time Tracking">
        <TimeTrackingPhone />
      </PhoneFrame>
    </div>
  );
}
