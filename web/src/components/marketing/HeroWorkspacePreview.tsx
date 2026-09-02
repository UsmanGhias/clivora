"use client";

import { useState } from "react";
import Link from "next/link";
import {
  Briefcase,
  CheckCircle2,
  DollarSign,
  FileText,
  Layers,
  Sparkles,
  TrendingUp,
  Users,
  ShieldCheck,
  Zap,
  ArrowUpRight,
  Clock,
} from "lucide-react";
import { useLivePlatformStats } from "@/lib/useLivePlatformStats";

export function HeroWorkspacePreview() {
  const [tab, setTab] = useState<"freelancer" | "client">("freelancer");
  const stats = useLivePlatformStats();

  return (
    <div className="relative mx-auto w-full max-w-2xl lg:max-w-none">
      {/* Ambient background glow halos */}
      <div
        className="pointer-events-none absolute -top-12 -left-12 h-72 w-72 rounded-full bg-teal-400/20 blur-3xl"
        aria-hidden
      />
      <div
        className="pointer-events-none absolute -bottom-10 -right-10 h-72 w-72 rounded-full bg-cyan-400/20 blur-3xl"
        aria-hidden
      />

      {/* Main Glassmorphic Showcase Container */}
      <div className="relative overflow-hidden rounded-3xl border border-slate-200/90 bg-white/90 p-3 sm:p-5 shadow-[0_24px_60px_-15px_rgba(15,23,42,0.12)] backdrop-blur-xl transition-all">
        {/* Top Workspace Header Bar */}
        <div className="flex flex-wrap items-center justify-between gap-3 border-b border-slate-100 pb-3">
          {/* Workspace Switcher Pills */}
          <div className="inline-flex rounded-xl bg-slate-100/90 p-1">
            <button
              type="button"
              onClick={() => setTab("freelancer")}
              className={`flex items-center gap-1.5 rounded-lg px-3 py-1.5 text-xs font-bold transition-all ${
                tab === "freelancer"
                  ? "bg-white text-navy shadow-xs"
                  : "text-slate-500 hover:text-navy"
              }`}
            >
              <Briefcase className="h-3.5 w-3.5 text-teal-600" />
              <span>Freelancer OS</span>
            </button>
            <button
              type="button"
              onClick={() => setTab("client")}
              className={`flex items-center gap-1.5 rounded-lg px-3 py-1.5 text-xs font-bold transition-all ${
                tab === "client"
                  ? "bg-white text-navy shadow-xs"
                  : "text-slate-500 hover:text-navy"
              }`}
            >
              <Users className="h-3.5 w-3.5 text-cyan-600" />
              <span>Client Portal</span>
            </button>
          </div>

          {/* Live System Badge */}
          <div className="flex items-center gap-2">
            <span className="inline-flex items-center gap-1.5 rounded-full bg-emerald-50 px-2.5 py-1 text-[11px] font-bold text-emerald-800 border border-emerald-200/60">
              <span className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse" />
              <span>Live: {stats.formattedJobs} Roles</span>
            </span>
          </div>
        </div>

        {/* Dynamic Workspace Content */}
        {tab === "freelancer" ? (
          <div className="mt-4 space-y-4">
            {/* Quick Metrics Strip */}
            <div className="grid grid-cols-2 gap-2.5 sm:grid-cols-4">
              <div className="rounded-2xl border border-slate-100 bg-slate-50/70 p-3">
                <div className="flex items-center justify-between text-slate-500 text-[11px] font-semibold">
                  <span>Gross Earned</span>
                  <DollarSign className="h-3.5 w-3.5 text-teal-600" />
                </div>
                <p className="mt-1 text-lg font-black text-navy">$14,850</p>
                <p className="text-[10px] font-bold text-teal-700">0% Platform Cut</p>
              </div>

              <div className="rounded-2xl border border-slate-100 bg-slate-50/70 p-3">
                <div className="flex items-center justify-between text-slate-500 text-[11px] font-semibold">
                  <span>Active Deals</span>
                  <Layers className="h-3.5 w-3.5 text-cyan-600" />
                </div>
                <p className="mt-1 text-lg font-black text-navy">4 Projects</p>
                <p className="text-[10px] font-bold text-emerald-600">All in Escrow</p>
              </div>

              <div className="rounded-2xl border border-slate-100 bg-slate-50/70 p-3">
                <div className="flex items-center justify-between text-slate-500 text-[11px] font-semibold">
                  <span>Remote Jobs</span>
                  <Zap className="h-3.5 w-3.5 text-amber-500" />
                </div>
                <p className="mt-1 text-lg font-black text-navy">{stats.formattedJobs}</p>
                <p className="text-[10px] font-bold text-teal-700">Direct Apply</p>
              </div>

              <div className="rounded-2xl border border-slate-100 bg-slate-50/70 p-3">
                <div className="flex items-center justify-between text-slate-500 text-[11px] font-semibold">
                  <span>Tracked Hours</span>
                  <Clock className="h-3.5 w-3.5 text-violet-600" />
                </div>
                <p className="mt-1 text-lg font-black text-navy">38.5 hrs</p>
                <p className="text-[10px] font-bold text-slate-500">Auto-Invoiced</p>
              </div>
            </div>

            {/* Active Deliverable & Direct Contract Card */}
            <div className="rounded-2xl border border-slate-200/80 bg-white p-4 shadow-xs">
              <div className="flex items-start justify-between gap-3">
                <div>
                  <div className="flex items-center gap-2">
                    <span className="rounded-md bg-teal-100 px-2 py-0.5 text-[10px] font-extrabold text-teal-800">
                      MILESTONE 2 OF 3
                    </span>
                    <span className="text-xs font-bold text-slate-700">Mobile Fintech Architecture</span>
                  </div>
                  <p className="mt-1 text-xs text-slate-500">
                    Client: Apex Digital Ventures · Milestone Value: <strong className="text-navy">$4,200.00</strong>
                  </p>
                </div>
                <span className="rounded-full bg-emerald-50 px-2.5 py-1 text-xs font-bold text-emerald-700 border border-emerald-200">
                  Escrow Funded
                </span>
              </div>

              {/* Progress bar */}
              <div className="mt-3">
                <div className="flex justify-between text-[11px] font-semibold text-slate-600">
                  <span>SOW Deliverables Completed</span>
                  <span className="font-bold text-navy">78%</span>
                </div>
                <div className="mt-1.5 h-2 w-full overflow-hidden rounded-full bg-slate-100">
                  <div className="h-full rounded-full bg-gradient-to-r from-teal-600 to-cyan-500" style={{ width: "78%" }} />
                </div>
              </div>
            </div>

            {/* Inbound Lead & Instant Proposal Bridge */}
            <div className="flex flex-col sm:flex-row items-center justify-between gap-3 rounded-2xl border border-teal-200/70 bg-gradient-to-r from-teal-50/80 to-cyan-50/50 p-3.5">
              <div className="flex items-center gap-3">
                <div className="rounded-xl bg-teal-600 p-2 text-white shadow-xs">
                  <Sparkles className="h-4 w-4" />
                </div>
                <div>
                  <p className="text-xs font-bold text-navy">Inbound Inquiry via Portfolio Bridge</p>
                  <p className="text-[11px] text-slate-600">AI Brief generated & synced with CRM lead.</p>
                </div>
              </div>
              <Link
                href="/for-freelancers"
                className="inline-flex items-center gap-1 rounded-xl bg-navy px-3 py-1.5 text-xs font-bold text-white transition hover:bg-navy/90"
              >
                <span>View Workspace</span>
                <ArrowUpRight className="h-3.5 w-3.5" />
              </Link>
            </div>
          </div>
        ) : (
          <div className="mt-4 space-y-4">
            {/* Client Portal Metrics */}
            <div className="grid grid-cols-2 gap-2.5 sm:grid-cols-4">
              <div className="rounded-2xl border border-slate-100 bg-slate-50/70 p-3">
                <div className="flex items-center justify-between text-slate-500 text-[11px] font-semibold">
                  <span>Escrow Safe</span>
                  <ShieldCheck className="h-3.5 w-3.5 text-emerald-600" />
                </div>
                <p className="mt-1 text-lg font-black text-navy">$8,400</p>
                <p className="text-[10px] font-bold text-emerald-700">100% Protected</p>
              </div>

              <div className="rounded-2xl border border-slate-100 bg-slate-50/70 p-3">
                <div className="flex items-center justify-between text-slate-500 text-[11px] font-semibold">
                  <span>Active Engineers</span>
                  <Users className="h-3.5 w-3.5 text-teal-600" />
                </div>
                <p className="mt-1 text-lg font-black text-navy">3 Hired</p>
                <p className="text-[10px] font-bold text-teal-700">Verified Talent</p>
              </div>

              <div className="rounded-2xl border border-slate-100 bg-slate-50/70 p-3">
                <div className="flex items-center justify-between text-slate-500 text-[11px] font-semibold">
                  <span>Platform Fee</span>
                  <DollarSign className="h-3.5 w-3.5 text-emerald-600" />
                </div>
                <p className="mt-1 text-lg font-black text-navy">$0.00</p>
                <p className="text-[10px] font-bold text-emerald-700">Save 20%</p>
              </div>

              <div className="rounded-2xl border border-slate-100 bg-slate-50/70 p-3">
                <div className="flex items-center justify-between text-slate-500 text-[11px] font-semibold">
                  <span>Invoices Settled</span>
                  <FileText className="h-3.5 w-3.5 text-blue-600" />
                </div>
                <p className="mt-1 text-lg font-black text-navy">6 Invoices</p>
                <p className="text-[10px] font-bold text-slate-500">Stripe / SafePay</p>
              </div>
            </div>

            {/* Instant AI Statement of Work Generation Card */}
            <div className="rounded-2xl border border-slate-200/80 bg-white p-4 shadow-xs">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <span className="flex h-6 w-6 items-center justify-center rounded-lg bg-teal-500/10 text-teal-600 font-extrabold text-xs">
                    AI
                  </span>
                  <p className="text-xs font-bold text-navy">Instant Statement of Work (SOW)</p>
                </div>
                <span className="text-[11px] font-bold text-teal-700">Ready in 5s</span>
              </div>
              <p className="mt-2 text-xs leading-relaxed text-slate-600">
                Scope requirements instantly compiled into deliverable milestones, budget breakdown, and IP assignment.
              </p>
              <div className="mt-3 flex gap-2">
                <Link
                  href="/start-a-project"
                  className="inline-flex items-center gap-1.5 rounded-xl bg-teal-600 px-3 py-1.5 text-xs font-bold text-white transition hover:bg-teal-700 shadow-xs"
                >
                  <Sparkles className="h-3 w-3" />
                  <span>Generate Project SOW</span>
                </Link>
                <Link
                  href="/connect"
                  className="inline-flex items-center gap-1.5 rounded-xl border border-slate-200 bg-slate-50 px-3 py-1.5 text-xs font-bold text-navy transition hover:bg-slate-100"
                >
                  <span>Browse Talent</span>
                </Link>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
