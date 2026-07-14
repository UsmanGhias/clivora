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
import { TrustedNetworkMock } from "./mockups/TrustedNetworkMock";

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
      <div className="relative mx-auto grid max-w-7xl items-center gap-12 px-5 lg:grid-cols-[1fr_1.05fr] lg:px-8">
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

        <TrustedNetworkMock />
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
