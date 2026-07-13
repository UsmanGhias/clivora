"use client";

import Link from "next/link";
import { ArrowRight, DollarSign, MessageSquare, ShieldCheck, UserRound, Zap } from "lucide-react";
import { marketing } from "@/lib/marketing";
import { cn } from "@/lib/utils";
import { ConnectJobsMock } from "./mockups/ConnectJobsMock";

const toneCard: Record<string, string> = {
  green: "bg-emerald-50 text-emerald-600",
  violet: "bg-violet-50 text-violet-600",
  orange: "bg-orange-50 text-orange-600",
  blue: "bg-sky-50 text-sky-600",
};

export function ConnectSection() {
  const c = marketing.connect;

  return (
    <section id="connect" className="border-b border-slate-200/80 bg-white py-16 sm:py-20">
      <div className="mx-auto max-w-7xl px-5 lg:px-8">
        <div className="mx-auto max-w-3xl text-center">
          <p className="text-xs font-bold uppercase tracking-[0.2em] text-primary">{c.eyebrow}</p>
          <h2 className="mt-3 font-display text-3xl font-extrabold tracking-tight text-navy sm:text-4xl">
            {c.headline[0]}{" "}
            <span className="bg-gradient-to-r from-primary to-emerald-400 bg-clip-text text-transparent">
              {c.headline[1]}
            </span>
          </h2>
          <p className="mt-4 text-base leading-relaxed text-slate-600 sm:text-lg">{c.body}</p>
          <p className="mt-3 text-sm leading-relaxed text-slate-500">{c.feeNote}</p>
        </div>

        <div className="mt-10 overflow-hidden rounded-2xl border border-slate-200 bg-[#F8FAFC] p-4 shadow-lg shadow-slate-200/50 sm:p-6">
          <div className="grid items-start gap-6 lg:grid-cols-[minmax(0,0.9fr)_minmax(0,1.4fr)]">
            <div>
              <ul className="space-y-3">
                {c.features.map((f, i) => {
                  const icons = [UserRound, ShieldCheck, Zap, MessageSquare, DollarSign];
                  const Icon = icons[i] ?? Zap;
                  return (
                    <li key={f.title} className="flex items-start gap-3">
                      <span className="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-lg bg-teal-50 text-primary">
                        <Icon className="h-4 w-4" />
                      </span>
                      <div>
                        <p className="text-sm font-semibold text-navy">{f.title}</p>
                        <p className="text-xs text-slate-500">{f.description}</p>
                      </div>
                    </li>
                  );
                })}
              </ul>
              <div className="mt-6 flex flex-wrap gap-2">
                <Link
                  href={c.secondaryCta.href}
                  className="inline-flex items-center gap-2 rounded-xl bg-primary px-4 py-2.5 text-sm font-bold text-white shadow-md shadow-teal-500/20"
                >
                  {c.secondaryCta.label}
                  <ArrowRight className="h-4 w-4" />
                </Link>
                <Link
                  href={c.primaryCta.href}
                  className="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-2.5 text-sm font-semibold text-navy"
                >
                  {c.primaryCta.label}
                </Link>
              </div>
            </div>

            <div>
              <ConnectJobsMock />
              <p className="mt-2 text-center text-xs text-slate-400">
                Illustrative Connect board shown with sample data.
              </p>
            </div>
          </div>

          <div className="mt-6 border-t border-slate-200 pt-5">
            <div className="mb-4 flex items-center justify-between">
              <p className="text-sm font-bold text-navy">Explore categories</p>
              <Link href="/connect" className="text-xs font-semibold text-primary hover:underline">
                Open Connect
              </Link>
            </div>
            <div className="grid grid-cols-2 gap-2 sm:grid-cols-3 lg:grid-cols-6">
              {c.categories.map((cat) => (
                <div
                  key={cat.title}
                  className="rounded-xl border border-slate-200 bg-white px-3 py-2.5 shadow-sm"
                >
                  <span
                    className={cn(
                      "inline-flex rounded-md px-1.5 py-0.5 text-[10px] font-bold",
                      toneCard[cat.tone],
                    )}
                  >
                    •
                  </span>
                  <p className="mt-1 text-xs font-bold text-navy">{cat.title}</p>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
