"use client";

import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { ShowcaseImage } from "@/components/marketing/ShowcaseImage";
import { marketing } from "@/lib/marketing";

export function ConnectSection() {
  const c = marketing.connect;

  return (
    <section id="connect" className="border-b border-slate-200/80 bg-white py-16 sm:py-24">
      <div className="mx-auto max-w-7xl px-5 lg:px-8">
        <div className="mx-auto max-w-3xl text-center">
          <p className="text-xs font-bold uppercase tracking-[0.2em] text-primary">Connect marketplace</p>
          <h2 className="mt-3 font-display text-3xl font-extrabold tracking-tight text-navy sm:text-5xl">
            {c.headline[0]}{" "}
            <span className="bg-gradient-to-r from-primary to-emerald-400 bg-clip-text text-transparent">
              {c.headline[1]}
            </span>
          </h2>
          <p className="mt-4 text-base leading-relaxed text-slate-600 sm:text-lg">{c.body}</p>
        </div>

        <div className="mt-10">
          <ShowcaseImage
            src="/showcase/marketplace.png"
            alt="CLIVORA Connect marketplace — jobs, proposals, and hiring in one place"
          />
        </div>

        <div className="mt-10 grid gap-6 sm:grid-cols-3">
          {c.features.map((point) => (
            <div key={point.title} className="rounded-2xl border border-slate-200 bg-[#F8FAFC] p-5">
              <h3 className="text-base font-bold text-navy">{point.title}</h3>
              <p className="mt-2 text-sm leading-relaxed text-slate-500">{point.description}</p>
            </div>
          ))}
        </div>

        <div className="mt-10 flex flex-wrap items-center justify-center gap-3">
          <Link
            href={c.primaryCta.href}
            className="inline-flex items-center gap-2 rounded-xl bg-primary px-6 py-3 text-sm font-bold text-white shadow-lg shadow-teal-500/25 transition hover:bg-teal-700"
          >
            {c.primaryCta.label}
            <ArrowRight className="h-4 w-4" />
          </Link>
          <Link
            href={c.secondaryCta.href}
            className="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-6 py-3 text-sm font-semibold text-navy transition hover:bg-slate-50"
          >
            {c.secondaryCta.label}
          </Link>
        </div>
      </div>
    </section>
  );
}
