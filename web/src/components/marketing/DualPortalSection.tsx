"use client";

import {
  BarChart3,
  Bot,
  Cloud,
  FileText,
  FolderKanban,
  LayoutDashboard,
  MessageSquare,
  Network,
  Settings2,
  Shield,
  Timer,
  Wallet,
} from "lucide-react";
import { marketing } from "@/lib/marketing";
import { cn } from "@/lib/utils";
import { FreelancerDashMock } from "./mockups/FreelancerDashMock";
import { ClientDashMock } from "./mockups/ClientDashMock";

const toneIconBg: Record<string, string> = {
  violet: "bg-violet-100 text-violet-600",
  green: "bg-emerald-100 text-emerald-600",
  orange: "bg-orange-100 text-orange-600",
  blue: "bg-sky-100 text-sky-600",
  teal: "bg-teal-100 text-teal-700",
};

const leftIcons = [LayoutDashboard, FolderKanban, FileText];
const rightIcons = [MessageSquare, Network, Bot];
const stripIcons = [BarChart3, Wallet, FileText, Timer, Shield, Settings2];

export function DualPortalSection() {
  const d = marketing.dualPortal;

  return (
    <section id="platform" className="relative overflow-hidden py-20 lg:py-28">
      <div className="mx-auto max-w-7xl px-5 text-center lg:px-8">
        <span className="inline-flex items-center gap-2 rounded-full border border-teal-200 bg-teal-50 px-3 py-1 text-[11px] font-bold uppercase tracking-[0.14em] text-primary">
          <Cloud className="h-3.5 w-3.5" />
          {d.badge}
        </span>
        <h2 className="mt-5 font-display text-3xl font-extrabold tracking-tight text-navy sm:text-4xl lg:text-5xl">
          {d.headline[0]}{" "}
          <span className="bg-gradient-to-r from-primary to-emerald-400 bg-clip-text text-transparent">
            {d.headline[1]}
          </span>
        </h2>
        <p className="mx-auto mt-4 max-w-2xl text-base text-slate-600 sm:text-lg">{d.body}</p>
        <div className="mt-6 inline-flex gap-2 text-xs font-semibold">
          <span className="rounded-full bg-primary px-3 py-1.5 text-white">For Freelancers</span>
          <span className="rounded-full border border-navy/20 bg-white px-3 py-1.5 text-navy">
            For Clients
          </span>
        </div>
      </div>

      <div className="mx-auto mt-12 grid max-w-7xl items-start gap-6 px-5 lg:grid-cols-2 lg:px-8">
        <div className="overflow-hidden">
          <p className="mb-2 text-center text-xs font-bold uppercase tracking-[0.14em] text-primary">
            Freelancer dashboard
          </p>
          <FreelancerDashMock />
        </div>
        <div className="overflow-hidden">
          <p className="mb-2 text-center text-xs font-bold uppercase tracking-[0.14em] text-slate-500">
            Client portal
          </p>
          <ClientDashMock />
        </div>
      </div>

      <div className="mx-auto mt-8 hidden max-w-7xl grid-cols-2 gap-6 px-5 lg:grid lg:px-8">
        <div className="grid grid-cols-3 gap-3">
          {d.sideFeatures.left.map((f, i) => {
            const Icon = leftIcons[i] ?? LayoutDashboard;
            return (
              <div key={f.title} className="rounded-2xl border border-slate-200 bg-white p-4 text-left shadow-sm">
                <div className={cn("mb-3 inline-flex rounded-xl p-2", toneIconBg[f.tone])}>
                  <Icon className="h-4 w-4" />
                </div>
                <p className="text-sm font-bold text-navy">{f.title}</p>
                <p className="mt-1 text-xs leading-relaxed text-slate-500">{f.description}</p>
              </div>
            );
          })}
        </div>
        <div className="grid grid-cols-3 gap-3">
          {d.sideFeatures.right.map((f, i) => {
            const Icon = rightIcons[i] ?? MessageSquare;
            return (
              <div key={f.title} className="rounded-2xl border border-slate-200 bg-white p-4 text-left shadow-sm">
                <div className={cn("mb-3 inline-flex rounded-xl p-2", toneIconBg[f.tone])}>
                  <Icon className="h-4 w-4" />
                </div>
                <p className="text-sm font-bold text-navy">{f.title}</p>
                <p className="mt-1 text-xs leading-relaxed text-slate-500">{f.description}</p>
              </div>
            );
          })}
        </div>
      </div>

      <div className="mx-auto mt-10 max-w-6xl overflow-x-auto px-5 lg:px-8">
        <div className="flex min-w-max flex-nowrap items-center justify-center gap-2 sm:gap-3">
          {d.bottomStrip.map((label, i) => {
            const Icon = stripIcons[i] ?? Settings2;
            return (
              <div
                key={label}
                className="inline-flex shrink-0 items-center gap-2 rounded-full border border-slate-200 bg-white px-3.5 py-2 text-xs font-semibold text-slate-600 shadow-sm"
              >
                <Icon className="h-3.5 w-3.5 text-primary" />
                {label}
              </div>
            );
          })}
        </div>
      </div>

      <div className="mx-auto mt-10 flex max-w-3xl flex-col items-center justify-between gap-4 rounded-2xl border border-teal-100 bg-gradient-to-r from-teal-50 to-white px-6 py-4 sm:flex-row">
        <p className="text-sm font-semibold text-navy">{d.socialProof}</p>
        <span className="inline-flex items-center gap-2 rounded-full bg-primary px-3.5 py-1.5 text-xs font-bold text-white">
          {d.activeUsers}
        </span>
      </div>
    </section>
  );
}
