import Link from "next/link";
import {
  ArrowRight,
  BarChart3,
  Bot,
  FileSignature,
  FolderKanban,
  MessageSquare,
  Receipt,
  Timer,
  Users,
  Search,
  Send,
  Briefcase,
  Wallet,
  TrendingUp,
} from "lucide-react";
import { marketing } from "@/lib/marketing";
import { FreelancerDashMock } from "./mockups/FreelancerDashMock";
import { MobileAppMocks } from "./mockups/MobileAppMocks";

const featureIcons = [
  FolderKanban,
  Receipt,
  Timer,
  MessageSquare,
  Users,
  Bot,
  FileSignature,
  BarChart3,
];

const stepIcons = [Search, Send, Briefcase, Users, Receipt, Wallet, TrendingUp];

export function WorkspaceSection() {
  const w = marketing.workspace;

  return (
    <section id="workspace" className="overflow-hidden py-20 lg:py-28">
      <div className="mx-auto max-w-7xl px-5 lg:px-8">
        <div className="grid items-start gap-10 lg:grid-cols-[0.85fr_1.15fr] lg:gap-8">
          <div>
            <h2 className="font-display text-3xl font-extrabold tracking-tight text-navy sm:text-4xl">
              {w.headline[0]}{" "}
              <span className="text-primary">{w.headline[1]}</span>
            </h2>
            <p className="mt-4 text-base leading-relaxed text-slate-600">{w.body}</p>
            <Link
              href={w.cta.href}
              className="mt-6 inline-flex items-center gap-2 rounded-xl bg-primary px-5 py-3 text-sm font-bold text-white shadow-lg shadow-primary/20 transition hover:bg-primary-dark"
            >
              {w.cta.label}
              <ArrowRight className="h-4 w-4" />
            </Link>

            <div className="mt-8 grid grid-cols-2 gap-3">
              {w.features.map((f, i) => {
                const Icon = featureIcons[i] ?? FolderKanban;
                return (
                  <div
                    key={f.title}
                    className="rounded-xl border border-slate-200 bg-white p-3 shadow-sm"
                  >
                    <Icon className="mb-2 h-4 w-4 text-primary" />
                    <p className="text-xs font-bold text-navy">{f.title}</p>
                    <p className="mt-0.5 text-[11px] text-slate-500">{f.description}</p>
                  </div>
                );
              })}
            </div>
          </div>

          <div className="relative space-y-6">
            <FreelancerDashMock />
            <div className="flex justify-center lg:justify-end">
              <MobileAppMocks />
            </div>
          </div>
        </div>

        <div className="mt-16">
          <h3 className="text-center font-display text-2xl font-extrabold text-navy">
            {w.workflow.title}
          </h3>
          <div className="mt-8 flex flex-wrap items-start justify-center gap-3 lg:gap-0">
            {w.workflow.steps.map((step, i) => {
              const Icon = stepIcons[i] ?? Search;
              return (
                <div key={step.title} className="flex items-center">
                  <div className="w-[100px] text-center sm:w-[120px]">
                    <span className="mx-auto flex h-11 w-11 items-center justify-center rounded-2xl border border-teal-100 bg-teal-50 text-primary">
                      <Icon className="h-5 w-5" />
                    </span>
                    <p className="mt-2 text-xs font-bold text-navy">{step.title}</p>
                    <p className="mt-0.5 text-[10px] text-slate-500">{step.description}</p>
                  </div>
                  {i < w.workflow.steps.length - 1 ? (
                    <div className="mx-1 hidden h-px w-6 border-t border-dashed border-teal-300 lg:block xl:w-10" />
                  ) : null}
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </section>
  );
}
