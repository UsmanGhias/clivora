import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { marketing } from "@/lib/marketing";
import { cn } from "@/lib/utils";

const statusTone: Record<string, string> = {
  "Available now": "bg-emerald-50 text-emerald-700",
  Beta: "bg-amber-50 text-amber-700",
  "Coming soon": "bg-slate-100 text-slate-500",
};

/** Compact product capabilities — replaces the old dual-portal showcase. */
export function PlatformSection() {
  const p = marketing.platform;

  return (
    <section id="platform" className="bg-[#F8FAFC] py-16 lg:py-24">
      <div className="mx-auto max-w-7xl px-5 lg:px-8">
        <div className="mx-auto max-w-3xl text-center">
          <p className="text-xs font-bold uppercase tracking-[0.2em] text-primary">{p.badge}</p>
          <h2 className="mt-3 font-display text-3xl font-extrabold tracking-tight text-navy sm:text-4xl lg:text-5xl">
            {p.headline[0]}{" "}
            <span className="bg-gradient-to-r from-primary to-emerald-400 bg-clip-text text-transparent">
              {p.headline[1]}
            </span>
          </h2>
          <p className="mt-4 text-base leading-relaxed text-slate-600 sm:text-lg">{p.body}</p>
        </div>

        <div className="mt-10 grid gap-3 sm:grid-cols-2 lg:grid-cols-5">
          {p.features.map((f) => (
            <div
              key={f.title}
              className="rounded-2xl border border-slate-200 bg-white p-4 shadow-sm"
            >
              <span
                className={cn(
                  "inline-flex rounded-full px-2 py-0.5 text-[10px] font-bold",
                  statusTone[f.status] ?? statusTone["Available now"],
                )}
              >
                {f.status}
              </span>
              <p className="mt-2 text-sm font-bold text-navy">{f.title}</p>
              <p className="mt-1 text-xs leading-relaxed text-slate-500">{f.description}</p>
            </div>
          ))}
        </div>

        <div className="mt-10 flex justify-center">
          <Link
            href="/features"
            className="inline-flex items-center gap-2 rounded-xl bg-navy px-5 py-3 text-sm font-bold text-white transition hover:bg-slate-800"
          >
            See what&apos;s available
            <ArrowRight className="h-4 w-4" />
          </Link>
        </div>
      </div>
    </section>
  );
}
