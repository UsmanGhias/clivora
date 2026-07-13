import Link from "next/link";
import {
  Bot,
  CheckCircle2,
  FileText,
  FolderKanban,
  LayoutDashboard,
  Timer,
  Users,
  ArrowRight,
} from "lucide-react";
import { marketing } from "@/lib/marketing";
import { AnalyticsPreviewMock } from "./mockups/AnalyticsPreviewMock";

const icons = [LayoutDashboard, FolderKanban, FileText, Timer, Users, Bot];

export function FreelancerOSSection() {
  const s = marketing.freelancerOs;

  return (
    <section id="freelancer-os" className="border-t border-slate-200/80 bg-white py-20 lg:py-28">
      <div className="mx-auto grid max-w-7xl items-center gap-12 px-5 lg:grid-cols-[0.95fr_1.05fr] lg:gap-14 lg:px-8">
        <div>
          <h2 className="font-display text-3xl font-extrabold leading-tight tracking-tight text-navy sm:text-4xl">
            {s.headline}
          </h2>
          <p className="mt-4 text-base leading-relaxed text-slate-600 sm:text-lg">{s.body}</p>

          <ul className="mt-8 space-y-4">
            {s.features.map((f, i) => {
              const Icon = icons[i] ?? CheckCircle2;
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

          <Link
            href={s.cta.href}
            className="mt-8 inline-flex items-center gap-2 rounded-xl border-2 border-primary bg-white px-5 py-3 text-sm font-bold text-primary transition hover:bg-teal-50"
          >
            {s.cta.label}
            <ArrowRight className="h-4 w-4" />
          </Link>
        </div>

        <div className="relative">
          <div className="absolute -inset-3 rounded-[28px] bg-gradient-to-tr from-teal-100/60 to-slate-200/40 blur-xl" />
          <div className="relative">
            <AnalyticsPreviewMock />
          </div>
        </div>
      </div>

      <div className="mx-auto mt-14 max-w-7xl px-5 lg:px-8">
        <div className="grid grid-cols-2 gap-4 rounded-2xl border border-slate-200 bg-[#F8FAFC] p-5 sm:grid-cols-3 lg:grid-cols-6 lg:p-6">
          {s.stats.map((stat) => (
            <div key={stat.label} className="text-center">
              <p className="font-display text-2xl font-extrabold text-navy sm:text-3xl">{stat.value}</p>
              <p className="mt-1 text-xs font-medium text-slate-500">{stat.label}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
