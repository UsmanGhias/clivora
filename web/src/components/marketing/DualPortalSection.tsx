"use client";

import { useState } from "react";
import { motion } from "framer-motion";
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
  const [tab, setTab] = useState<"freelancer" | "client">("freelancer");

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

        <div className="mt-8 inline-flex rounded-full border border-slate-200 bg-white p-1 shadow-sm">
          {d.tabs.map((t) => (
            <button
              key={t.id}
              type="button"
              onClick={() => setTab(t.id)}
              className={cn(
                "rounded-full px-5 py-2.5 text-sm font-bold transition",
                tab === t.id
                  ? "bg-primary text-white shadow-md shadow-primary/20"
                  : "text-navy hover:bg-slate-50"
              )}
            >
              {t.label}
            </button>
          ))}
        </div>
      </div>

      <div className="mx-auto mt-12 grid max-w-7xl items-start gap-6 px-5 lg:grid-cols-[220px_1fr_220px] lg:px-8">
        <div className="hidden space-y-3 lg:block">
          {d.sideFeatures.left.map((f, i) => {
            const Icon = leftIcons[i] ?? LayoutDashboard;
            return (
              <motion.div
                key={f.title}
                initial={{ opacity: 0, x: -12 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.06 }}
                className="rounded-2xl border border-slate-200 bg-white p-4 text-left shadow-sm"
              >
                <div className={cn("mb-3 inline-flex rounded-xl p-2", toneIconBg[f.tone])}>
                  <Icon className="h-4 w-4" />
                </div>
                <p className="text-sm font-bold text-navy">{f.title}</p>
                <p className="mt-1 text-xs leading-relaxed text-slate-500">{f.description}</p>
              </motion.div>
            );
          })}
        </div>

        <div className="overflow-hidden">
          {tab === "freelancer" ? <FreelancerDashMock /> : <ClientDashMock />}
        </div>

        <div className="hidden space-y-3 lg:block">
          {d.sideFeatures.right.map((f, i) => {
            const Icon = rightIcons[i] ?? MessageSquare;
            return (
              <motion.div
                key={f.title}
                initial={{ opacity: 0, x: 12 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.06 }}
                className="rounded-2xl border border-slate-200 bg-white p-4 text-left shadow-sm"
              >
                <div className={cn("mb-3 inline-flex rounded-xl p-2", toneIconBg[f.tone])}>
                  <Icon className="h-4 w-4" />
                </div>
                <p className="text-sm font-bold text-navy">{f.title}</p>
                <p className="mt-1 text-xs leading-relaxed text-slate-500">{f.description}</p>
              </motion.div>
            );
          })}
        </div>
      </div>

      <div className="mx-auto mt-10 flex max-w-5xl flex-wrap items-center justify-center gap-3 px-5 sm:gap-5">
        {d.bottomStrip.map((label, i) => {
          const Icon = stripIcons[i] ?? Settings2;
          return (
            <div
              key={label}
              className="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-3.5 py-2 text-xs font-semibold text-slate-600 shadow-sm"
            >
              <Icon className="h-3.5 w-3.5 text-primary" />
              {label}
            </div>
          );
        })}
      </div>

      <div className="mx-auto mt-10 flex max-w-3xl flex-col items-center justify-between gap-4 rounded-2xl border border-teal-100 bg-gradient-to-r from-teal-50 to-white px-6 py-4 sm:flex-row">
        <p className="text-sm font-semibold text-navy">{d.socialProof}</p>
        <span className="inline-flex items-center gap-2 rounded-full bg-primary px-3.5 py-1.5 text-xs font-bold text-white">
          <span className="flex -space-x-2">
            {["U", "A", "F", "S", "M"].map((c) => (
              <span
                key={c}
                className="flex h-6 w-6 items-center justify-center rounded-full border-2 border-white bg-navy text-[9px] font-bold"
              >
                {c}
              </span>
            ))}
          </span>
          {d.activeUsers}
        </span>
      </div>
    </section>
  );
}
