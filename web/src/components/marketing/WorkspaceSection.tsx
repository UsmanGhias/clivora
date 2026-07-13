"use client";

import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { ShowcaseImage } from "@/components/marketing/ShowcaseImage";
import { marketing } from "@/lib/marketing";

export function WorkspaceSection() {
  const w = marketing.workspace;

  return (
    <section id="workspace" className="border-b border-slate-200/80 bg-[#F8FAFC] py-16 sm:py-24">
      <div className="mx-auto max-w-7xl px-5 lg:px-8">
        <div className="mx-auto max-w-3xl text-center">
          <p className="text-xs font-bold uppercase tracking-[0.2em] text-primary">Freelancer workspace</p>
          <h2 className="mt-3 font-display text-3xl font-extrabold tracking-tight text-navy sm:text-5xl">
            {w.headline[0]}{" "}
            <span className="bg-gradient-to-r from-primary to-emerald-400 bg-clip-text text-transparent">
              {w.headline[1]}
            </span>
          </h2>
          <p className="mt-4 text-base leading-relaxed text-slate-600 sm:text-lg">{w.body}</p>
        </div>

        <div className="mt-10">
          <ShowcaseImage
            src="/showcase/workspace.png"
            alt="CLIVORA workspace — projects, time tracking, and invoices together"
          />
        </div>

        <div className="mt-10 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {w.features.slice(0, 4).map((point) => (
            <div key={point.title} className="rounded-2xl border border-slate-200 bg-white p-5">
              <h3 className="text-base font-bold text-navy">{point.title}</h3>
              <p className="mt-2 text-sm leading-relaxed text-slate-500">{point.description}</p>
            </div>
          ))}
        </div>

        <div className="mt-10 flex flex-wrap items-center justify-center gap-3">
          <Link
            href={w.cta.href}
            className="inline-flex items-center gap-2 rounded-xl bg-navy px-6 py-3 text-sm font-bold text-white shadow-lg shadow-slate-900/20 transition hover:bg-slate-800"
          >
            {w.cta.label}
            <ArrowRight className="h-4 w-4" />
          </Link>
          <Link
            href="/features"
            className="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-6 py-3 text-sm font-semibold text-navy transition hover:bg-slate-50"
          >
            See all workspace tools
          </Link>
        </div>
      </div>
    </section>
  );
}
