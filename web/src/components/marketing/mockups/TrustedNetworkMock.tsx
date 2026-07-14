import { marketing } from "@/lib/marketing";

const FLOATING = marketing.socialProof.floatingStats;
const LOGOS = marketing.socialProof.trustedBy.logos.slice(0, 5);

export function TrustedNetworkMock() {
  return (
    <div className="relative overflow-hidden rounded-2xl border border-slate-200 bg-white p-4 shadow-lg shadow-slate-200/60 sm:p-5">
      <div className="pointer-events-none absolute -right-8 -top-8 h-32 w-32 rounded-full bg-teal-100/60 blur-2xl" />
      <p className="text-center text-sm font-extrabold text-navy sm:text-base">
        Built for Top Talent.{" "}
        <span className="bg-gradient-to-r from-primary to-teal-400 bg-clip-text text-transparent">
          Trusted by Growing Teams.
        </span>
      </p>

      <div className="mt-4 grid grid-cols-2 gap-2">
        {FLOATING.map((s) => (
          <div
            key={s.label}
            className="rounded-xl border border-slate-200 bg-[#F8FAFC] p-2.5 shadow-sm"
          >
            <p className="font-display text-lg font-extrabold text-navy">{s.value}</p>
            <p className="mt-0.5 text-[10px] font-semibold text-slate-600">{s.label}</p>
            <p className="mt-0.5 text-[9px] text-slate-400">{s.hint}</p>
          </div>
        ))}
      </div>

      <div className="mt-4 rounded-xl border border-slate-100 bg-slate-50/80 px-3 py-3">
        <p className="text-center text-[10px] font-bold uppercase tracking-[0.14em] text-slate-400">
          Trusted by studios & startups
        </p>
        <div className="mt-2 flex flex-wrap items-center justify-center gap-x-4 gap-y-2">
          {LOGOS.map((name) => (
            <span key={name} className="text-[10px] font-bold text-slate-300">
              {name}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
}
