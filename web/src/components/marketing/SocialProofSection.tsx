import Link from "next/link";
import {
  Building2,
  Globe2,
  Rocket,
  ShieldCheck,
  ThumbsUp,
  TrendingUp,
  Users,
  Crown,
  Briefcase,
  MessageCircle,
} from "lucide-react";
import { marketing } from "@/lib/marketing";
import { cn } from "@/lib/utils";

const toneBg: Record<string, string> = {
  violet: "bg-violet-100 text-violet-600",
  blue: "bg-sky-100 text-sky-600",
  teal: "bg-teal-100 text-teal-700",
  orange: "bg-orange-100 text-orange-600",
  green: "bg-emerald-100 text-emerald-600",
};

const featureIcons = [Crown, ShieldCheck, ShieldCheck, Globe2, Rocket, TrendingUp];
const metricIcons = [Users, Briefcase, ThumbsUp, ShieldCheck, MessageCircle];

export function SocialProofSection() {
  const s = marketing.socialProof;

  return (
    <section id="trust" className="relative overflow-hidden py-20 lg:py-28">
      <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(ellipse_60%_50%_at_80%_40%,rgba(13,148,136,0.12),transparent_60%)]" />

      <div className="relative mx-auto grid max-w-7xl items-center gap-14 px-5 lg:grid-cols-[1.05fr_0.95fr] lg:px-8">
        <div>
          <span className="inline-flex items-center gap-2 rounded-full border border-teal-200 bg-teal-50 px-3 py-1 text-[11px] font-bold uppercase tracking-[0.12em] text-primary">
            <ShieldCheck className="h-3.5 w-3.5" />
            {s.badge}
          </span>
          <h2 className="mt-5 font-display text-3xl font-extrabold tracking-tight text-navy sm:text-4xl lg:text-[2.75rem]">
            {s.headline[0]}{" "}
            <span className="bg-gradient-to-r from-primary to-teal-400 bg-clip-text text-transparent">
              {s.headline[1]}
            </span>
          </h2>
          <p className="mt-4 max-w-xl text-base leading-relaxed text-slate-600">{s.body}</p>

          <div className="mt-8 grid gap-3 sm:grid-cols-2">
            {s.features.map((f, i) => {
              const Icon = featureIcons[i] ?? Building2;
              return (
                <div
                  key={f.title}
                  className="rounded-2xl border border-slate-200 bg-white p-4 shadow-sm transition hover:shadow-md"
                >
                  <div className={cn("mb-3 inline-flex rounded-xl p-2", toneBg[f.tone])}>
                    <Icon className="h-4 w-4" />
                  </div>
                  <p className="text-sm font-bold text-navy">{f.title}</p>
                  <p className="mt-1 text-xs leading-relaxed text-slate-500">{f.description}</p>
                </div>
              );
            })}
          </div>
        </div>

        {/* Globe + floating cards — matches mockup composition */}
        <div className="relative mx-auto aspect-square w-full max-w-[520px]">
          <div className="absolute inset-[8%] rounded-full border border-teal-100/80 bg-gradient-to-br from-teal-50/80 via-white to-slate-50 shadow-inner" />
          <div
            className="absolute inset-[14%] rounded-full opacity-90"
            style={{
              backgroundImage:
                "radial-gradient(circle at 50% 50%, transparent 34%, rgba(13,148,136,0.07) 35%, transparent 36%), radial-gradient(circle, #0D9488 1.15px, transparent 1.25px)",
              backgroundSize: "100% 100%, 12px 12px",
            }}
          />
          {/* orbital rings */}
          <div className="absolute inset-[10%] rounded-full border border-dashed border-teal-200/70" />
          <div className="absolute inset-[22%] rounded-full border border-teal-100/60" />

          <div className="absolute left-[2%] top-[20%] z-10 max-w-[170px] rounded-2xl border border-slate-200 bg-white p-3 shadow-xl shadow-slate-200/80">
            <p className="font-display text-xl font-extrabold text-navy">{s.floatingStats[1].value}</p>
            <p className="text-[10px] font-medium text-slate-500">{s.floatingStats[1].label}</p>
            <svg viewBox="0 0 80 24" className="mt-1 h-5 w-full text-emerald-500" aria-hidden>
              <polyline fill="none" stroke="currentColor" strokeWidth="2" points="0,18 16,14 32,16 48,8 64,10 80,4" />
            </svg>
            <p className="text-[10px] font-semibold text-emerald-600">{s.floatingStats[1].hint}</p>
          </div>

          <div className="absolute right-[0%] top-[10%] z-10 max-w-[180px] rounded-2xl border border-slate-200 bg-white p-3 shadow-xl">
            <div className="mb-2 flex -space-x-2">
              {["A", "B", "C"].map((c) => (
                <span
                  key={c}
                  className="flex h-7 w-7 items-center justify-center rounded-full border-2 border-white bg-navy text-[9px] font-bold text-white"
                >
                  {c}
                </span>
              ))}
              <span className="flex h-7 w-7 items-center justify-center rounded-full bg-primary text-[9px] font-bold text-white">
                +
              </span>
            </div>
            <p className="text-xs font-bold text-navy">{s.floatingStats[0].value} freelancers</p>
            <p className="text-[10px] text-slate-500">{s.floatingStats[0].hint}</p>
          </div>

          <div className="absolute bottom-[14%] left-[8%] z-10 rounded-2xl border border-slate-200 bg-white p-3 shadow-xl">
            <p className="font-display text-xl font-extrabold text-navy">{s.floatingStats[2].value}</p>
            <p className="text-[10px] font-medium text-slate-500">{s.floatingStats[2].label}</p>
            <svg viewBox="0 0 80 24" className="mt-1 h-5 w-full text-violet-500" aria-hidden>
              <polyline fill="none" stroke="currentColor" strokeWidth="2" points="0,16 20,14 40,10 60,12 80,6" />
            </svg>
            <p className="text-[10px] font-semibold text-violet-600">{s.floatingStats[2].hint}</p>
          </div>

          <div className="absolute bottom-[22%] right-[2%] z-10 max-w-[160px] rounded-2xl border border-slate-200 bg-white p-3 shadow-xl">
            <p className="font-display text-xl font-extrabold text-navy">{s.floatingStats[3].value}</p>
            <p className="text-[10px] font-medium text-slate-500">{s.floatingStats[3].label}</p>
            <div className="mt-2 flex -space-x-1">
              {["🇺🇸", "🇬🇧", "🇨🇦", "🇦🇺", "🇵🇰"].map((f) => (
                <span
                  key={f}
                  className="flex h-6 w-6 items-center justify-center rounded-full border border-white bg-slate-50 text-[10px] shadow-sm"
                >
                  {f}
                </span>
              ))}
              <span className="flex h-6 w-6 items-center justify-center rounded-full bg-slate-100 text-[9px] font-bold text-slate-500">
                +
              </span>
            </div>
            <p className="mt-1 text-[10px] text-slate-400">{s.floatingStats[3].hint}</p>
          </div>
        </div>
      </div>

      <div className="relative mx-auto mt-16 max-w-7xl px-5 lg:px-8">
        <div className="flex flex-col gap-2 border-b border-slate-200 pb-6 sm:flex-row sm:items-end sm:justify-between">
          <div>
            <p className="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">
              {s.trustedBy.title}
            </p>
            <p className="mt-1 max-w-xl text-sm text-slate-500">{s.trustedBy.body}</p>
          </div>
          <Link href={s.trustedBy.link.href} className="text-sm font-semibold text-primary hover:underline">
            {s.trustedBy.link.label} →
          </Link>
        </div>
        <div className="flex flex-wrap items-center justify-center gap-x-10 gap-y-4 py-8">
          {s.trustedBy.logos.map((name) => (
            <span
              key={name}
              className="font-display text-sm font-bold tracking-wide text-slate-300 transition hover:text-slate-500 sm:text-base"
            >
              {name}
            </span>
          ))}
        </div>
      </div>

      <div className="mx-auto mt-4 max-w-7xl px-5 lg:px-8">
        <div className="grid grid-cols-2 gap-3 rounded-2xl border border-slate-200 bg-white p-4 sm:grid-cols-3 lg:grid-cols-5 lg:p-5">
          {s.metrics.map((m, i) => {
            const Icon = metricIcons[i] ?? Users;
            return (
              <div key={m.label} className="flex items-center gap-3 px-2 py-2">
                <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-teal-50 text-primary">
                  <Icon className="h-4 w-4" />
                </span>
                <div>
                  <p className="text-sm font-extrabold text-navy">{m.value}</p>
                  <p className="text-[11px] text-slate-500">{m.label}</p>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
