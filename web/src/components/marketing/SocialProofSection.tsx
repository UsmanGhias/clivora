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
import { TrustLogos } from "./TrustLogos";

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
      <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(ellipse_60%_50%_at_80%_40%,rgba(13,148,136,0.1),transparent_60%)]" />

      <div className="relative mx-auto grid max-w-7xl items-start gap-12 px-5 lg:grid-cols-[1.1fr_0.9fr] lg:px-8">
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

        <div className="relative mx-auto w-full max-w-md lg:max-w-none">
          <div className="relative aspect-square overflow-hidden rounded-[2rem] border border-slate-200 bg-gradient-to-br from-slate-50 via-teal-50/40 to-white shadow-xl shadow-slate-200/60">
            <div
              className="absolute inset-[12%] rounded-full opacity-80"
              style={{
                backgroundImage:
                  "radial-gradient(circle at center, transparent 38%, rgba(13,148,136,0.08) 39%, transparent 40%), radial-gradient(circle, #0D9488 1.2px, transparent 1.3px)",
                backgroundSize: "100% 100%, 14px 14px",
              }}
            />
            <div className="absolute left-[8%] top-[18%] rounded-2xl border border-slate-200 bg-white p-3 shadow-lg">
              <p className="text-lg font-extrabold text-navy">{s.floatingStats[1].value}</p>
              <p className="text-[10px] font-medium text-slate-500">{s.floatingStats[1].label}</p>
              <p className="mt-1 text-[10px] font-semibold text-emerald-600">{s.floatingStats[1].hint}</p>
            </div>
            <div className="absolute right-[6%] top-[12%] max-w-[160px] rounded-2xl border border-slate-200 bg-white p-3 shadow-lg">
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
              <p className="text-xs font-bold text-navy">{s.floatingStats[0].value} Active</p>
              <p className="text-[10px] text-slate-500">{s.floatingStats[0].hint}</p>
            </div>
            <div className="absolute bottom-[16%] left-[14%] rounded-2xl border border-slate-200 bg-white p-3 shadow-lg">
              <p className="text-lg font-extrabold text-navy">{s.floatingStats[2].value}</p>
              <p className="text-[10px] font-medium text-slate-500">{s.floatingStats[2].label}</p>
              <p className="mt-1 text-[10px] font-semibold text-violet-600">{s.floatingStats[2].hint}</p>
            </div>
            <div className="absolute bottom-[22%] right-[8%] rounded-2xl border border-slate-200 bg-white p-3 shadow-lg">
              <p className="text-lg font-extrabold text-navy">{s.floatingStats[3].value}</p>
              <p className="text-[10px] font-medium text-slate-500">{s.floatingStats[3].label}</p>
              <p className="mt-1 text-[10px] text-slate-400">{s.floatingStats[3].hint}</p>
            </div>
          </div>
        </div>
      </div>

      <div className="relative mt-16">
        <div className="mx-auto mb-4 max-w-7xl px-5 lg:px-8">
          <div className="flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between">
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
        </div>
        <TrustLogos title="" logos={s.trustedBy.logos} />
      </div>

      <div className="mx-auto mt-10 max-w-7xl px-5 lg:px-8">
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
