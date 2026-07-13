import Link from "next/link";
import { ArrowRight, Briefcase, DollarSign, Sparkles, Shield } from "lucide-react";
import { marketing } from "@/lib/marketing";
import { cn } from "@/lib/utils";
import { ConnectJobsMock } from "./mockups/ConnectJobsMock";

const featureIcons = [DollarSign, Shield, Sparkles];
const toneCard: Record<string, string> = {
  green: "bg-emerald-50 text-emerald-700",
  violet: "bg-violet-50 text-violet-700",
  orange: "bg-orange-50 text-orange-700",
  blue: "bg-sky-50 text-sky-700",
};

export function ConnectSection() {
  const c = marketing.connect;

  return (
    <section id="connect" className="border-t border-slate-200/80 bg-white py-20 lg:py-28">
      <div className="mx-auto max-w-7xl px-5 lg:px-8">
        <div className="grid items-start gap-10 lg:grid-cols-[0.9fr_1.1fr] lg:gap-12">
          <div>
            <h2 className="font-display text-3xl font-extrabold tracking-tight text-navy sm:text-4xl">
              {c.headline[0]}{" "}
              <span className="text-primary">{c.headline[1]}</span>
            </h2>
            <p className="mt-4 text-base leading-relaxed text-slate-600">{c.body}</p>

            <ul className="mt-7 space-y-4">
              {c.features.map((f, i) => {
                const Icon = featureIcons[i] ?? Sparkles;
                return (
                  <li key={f.title} className="flex gap-3">
                    <span className="mt-0.5 flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-teal-50 text-primary">
                      <Icon className="h-4 w-4" />
                    </span>
                    <div>
                      <p className="text-sm font-bold text-navy">{f.title}</p>
                      <p className="mt-0.5 text-sm text-slate-500">{f.description}</p>
                    </div>
                  </li>
                );
              })}
            </ul>

            <div className="mt-8 flex flex-col gap-3 sm:flex-row">
              <Link
                href={c.primaryCta.href}
                className="inline-flex items-center justify-center gap-2 rounded-xl bg-primary px-5 py-3 text-sm font-bold text-white shadow-lg shadow-primary/20 transition hover:bg-primary-dark"
              >
                {c.primaryCta.label}
                <ArrowRight className="h-4 w-4" />
              </Link>
              <Link
                href={c.secondaryCta.href}
                className="inline-flex items-center justify-center gap-2 rounded-xl border border-navy/20 bg-white px-5 py-3 text-sm font-bold text-navy transition hover:bg-slate-50"
              >
                {c.secondaryCta.label}
                <ArrowRight className="h-4 w-4" />
              </Link>
            </div>
          </div>

          <div className="relative">
            <div className="mb-4 flex flex-wrap gap-2 rounded-2xl border border-slate-200 bg-[#F8FAFC] p-3">
              {c.ribbon.map((r) => (
                <div
                  key={r.label}
                  className="inline-flex items-center gap-2 rounded-xl bg-white px-3 py-2 text-xs shadow-sm"
                >
                  <Briefcase className="h-3.5 w-3.5 text-primary" />
                  <span className="font-extrabold text-navy">{r.value}</span>
                  <span className="text-slate-500">{r.label}</span>
                </div>
              ))}
            </div>
            <ConnectJobsMock />
          </div>
        </div>

        <div className="mt-14">
          <div className="mb-6 flex items-end justify-between gap-4">
            <h3 className="font-display text-xl font-extrabold text-navy sm:text-2xl">
              Explore Top Categories
            </h3>
            <Link href="/connect" className="text-sm font-semibold text-primary hover:underline">
              View all categories →
            </Link>
          </div>
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
            {c.categories.map((cat) => (
              <Link
                key={cat.title}
                href="/connect"
                className={cn(
                  "rounded-2xl border border-slate-200 p-5 transition hover:-translate-y-0.5 hover:shadow-md",
                  toneCard[cat.tone]
                )}
              >
                <p className="text-sm font-bold">{cat.title}</p>
                <p className="mt-1 text-xs opacity-80">{cat.jobs}</p>
              </Link>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
