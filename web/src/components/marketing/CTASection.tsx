import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { marketing } from "@/lib/marketing";

export function CTASection() {
  const c = marketing.cta;

  return (
    <section className="pb-16 lg:pb-24">
      <div className="mx-auto max-w-7xl px-5 lg:px-8">
        <div className="relative grid overflow-hidden rounded-[1.75rem] border border-navy/10 bg-[#F7FAF9] lg:grid-cols-[1.15fr_0.85fr]">
          <div className="relative px-7 py-12 sm:px-10 sm:py-14">
            <p className="text-[11px] font-bold uppercase tracking-[0.2em] text-teal-800">Next step</p>
            <h2 className="mt-3 max-w-lg font-display text-3xl font-extrabold leading-tight text-navy sm:text-4xl">
              {c.headline}
            </h2>
            <p className="mt-4 max-w-md text-sm leading-relaxed text-slate-600 sm:text-base">{c.body}</p>
            <div className="mt-8 flex flex-col gap-3 sm:flex-row sm:items-center">
              <Link
                href={c.primary.href}
                className="inline-flex items-center justify-center gap-2 rounded-lg bg-navy px-5 py-3 text-sm font-bold text-white transition hover:bg-navy/90"
              >
                {c.primary.label}
                <ArrowRight className="h-4 w-4" />
              </Link>
              <Link
                href={c.secondary.href}
                className="inline-flex items-center justify-center gap-2 rounded-lg border border-navy/15 bg-white px-5 py-3 text-sm font-bold text-navy transition hover:border-teal-500"
              >
                {c.secondary.label}
              </Link>
            </div>
          </div>
          <div className="relative hidden items-end justify-end bg-navy px-8 py-10 text-white lg:flex">
            <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(ellipse_80%_60%_at_20%_0%,rgba(45,212,191,0.35),transparent_55%)]" />
            <div className="relative max-w-xs space-y-3 text-sm leading-relaxed text-white/75">
              <p className="font-display text-lg font-bold text-white">What you get on day one</p>
              <p>Free CRM limits, Connect browse, invoices, and the Android app on the same email.</p>
              <p className="text-teal-200">Clients pay freelancers directly on your invoice - $0 deal fee.</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
