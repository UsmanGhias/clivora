"use client";

import Link from "next/link";
import {
  ArrowRight,
  BarChart3,
  Bot,
  FileText,
  FolderKanban,
  MessageSquare,
  Receipt,
  Timer,
  Users,
} from "lucide-react";
import { marketing } from "@/lib/marketing";
import { cn } from "@/lib/utils";
import { WorkspaceDesktopMock } from "./mockups/WorkspaceDesktopMock";

const featureIcons = [
  FolderKanban,
  Receipt,
  Timer,
  MessageSquare,
  Users,
  Bot,
  FileText,
  BarChart3,
];

const statusTone: Record<string, string> = {
  "Available now": "bg-emerald-50 text-emerald-700",
  Beta: "bg-amber-50 text-amber-700",
  "Coming soon": "bg-slate-100 text-slate-500",
};

const stepTones = [
  "bg-teal-50 text-teal-700",
  "bg-violet-50 text-violet-600",
  "bg-orange-50 text-orange-600",
  "bg-amber-50 text-amber-600",
  "bg-emerald-50 text-emerald-600",
  "bg-sky-50 text-sky-600",
  "bg-pink-50 text-pink-600",
];

export function WorkspaceSection() {
  const w = marketing.workspace;

  return (
    <section id="workspace" className="border-b border-slate-200/80 bg-[#F8FAFC] py-16 sm:py-20">
      <div className="mx-auto max-w-7xl px-5 lg:px-8">
        <div className="mx-auto max-w-3xl text-center">
          <p className="text-xs font-bold uppercase tracking-[0.2em] text-primary">Freelancer workspace</p>
          <h2 className="mt-3 font-display text-3xl font-extrabold tracking-tight text-navy sm:text-4xl">
            {w.headline[0]}{" "}
            <span className="bg-gradient-to-r from-primary to-emerald-400 bg-clip-text text-transparent">
              {w.headline[1]}
            </span>
          </h2>
          <p className="mt-4 text-base leading-relaxed text-slate-600 sm:text-lg">{w.body}</p>
        </div>

        <div className="mt-10 overflow-hidden rounded-2xl border border-slate-200 bg-white p-4 shadow-lg shadow-slate-200/50 sm:p-6">
          <div className="grid items-start gap-8 lg:grid-cols-[minmax(0,1fr)_minmax(0,1.15fr)]">
            <div>
              <div className="grid grid-cols-2 gap-2.5">
                {w.features.map((f, i) => {
                  const Icon = featureIcons[i] ?? FolderKanban;
                  return (
                    <div
                      key={f.title}
                      className="rounded-xl border border-slate-200 bg-[#F8FAFC] p-3 shadow-sm"
                    >
                      <div className="flex items-start justify-between gap-2">
                        <span className="inline-flex rounded-lg bg-teal-50 p-1.5 text-primary">
                          <Icon className="h-3.5 w-3.5" />
                        </span>
                        <span
                          className={cn(
                            "rounded-full px-1.5 py-0.5 text-[9px] font-bold",
                            statusTone[f.status] ?? statusTone["Available now"],
                          )}
                        >
                          {f.status}
                        </span>
                      </div>
                      <p className="mt-2 text-xs font-bold text-navy">{f.title}</p>
                      <p className="mt-0.5 text-[10px] leading-relaxed text-slate-500">{f.description}</p>
                    </div>
                  );
                })}
              </div>

              <Link
                href={w.cta.href}
                className="mt-6 inline-flex items-center gap-2 rounded-xl bg-primary px-5 py-3 text-sm font-bold text-white shadow-lg shadow-teal-500/25 transition hover:bg-teal-700"
              >
                {w.cta.label}
                <ArrowRight className="h-4 w-4" />
              </Link>
            </div>

            <div>
              <WorkspaceDesktopMock />
              <p className="mt-3 text-center text-xs text-slate-400">{w.mockCaption}</p>
            </div>
          </div>
        </div>

        <div className="mt-12 text-center">
          <h3 className="font-display text-xl font-extrabold text-navy sm:text-2xl">{w.workflow.title}</h3>
          <div className="relative mx-auto mt-8 max-w-5xl">
            <div className="absolute left-0 right-0 top-5 hidden h-px bg-slate-200 sm:block" aria-hidden />
            <div className="grid grid-cols-2 gap-4 sm:grid-cols-4 lg:grid-cols-7">
              {w.workflow.steps.map((step, i) => (
                <div key={step.title} className="relative flex flex-col items-center text-center">
                  <span
                    className={cn(
                      "relative z-10 flex h-10 w-10 items-center justify-center rounded-full border-2 border-white text-xs font-bold shadow-sm",
                      stepTones[i % stepTones.length],
                    )}
                  >
                    {i + 1}
                  </span>
                  <p className="mt-2 text-xs font-bold text-navy">{step.title}</p>
                  <p className="mt-0.5 text-[10px] text-slate-500">{step.description}</p>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
