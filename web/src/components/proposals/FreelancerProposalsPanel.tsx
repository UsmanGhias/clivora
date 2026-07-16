"use client";

import Link from "next/link";
import { useMemo, useState } from "react";
import {
  CheckCircle2,
  MessageSquare,
  Search,
  ShoppingBag,
  Smartphone,
} from "lucide-react";
import { proposalStatusLabel, type ProposalRow } from "@/lib/connect-proposals-shared";
import { createClient } from "@/lib/supabase/client";
import { cn } from "@/lib/utils";

const TABS = ["all", "pending", "viewed", "shortlisted", "hired", "declined"] as const;

function statusBucket(status: string) {
  const s = status.toLowerCase();
  if (s === "accepted") return "hired";
  if (s === "shortlisted") return "shortlisted";
  if (s === "declined") return "declined";
  if (s === "viewed") return "viewed";
  if (s === "withdrawn") return "declined";
  return "pending";
}

const STATUS_STYLE: Record<string, string> = {
  pending: "bg-amber-100 text-amber-800",
  viewed: "bg-sky-100 text-sky-800",
  shortlisted: "bg-emerald-100 text-emerald-800",
  hired: "bg-primary text-white",
  declined: "bg-red-100 text-red-700",
};

function JobIcon({ title }: { title: string }) {
  const t = title.toLowerCase();
  const Icon = t.includes("mobile") || t.includes("ui") ? Smartphone : ShoppingBag;
  return (
    <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary">
      <Icon className="h-5 w-5" />
    </span>
  );
}

export function FreelancerProposalsPanel({ proposals }: { proposals: ProposalRow[] }) {
  const [tab, setTab] = useState<(typeof TABS)[number]>("all");
  const [query, setQuery] = useState("");
  const [rows, setRows] = useState(proposals);
  const [busyId, setBusyId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const counts = useMemo(() => {
    const fresh = { all: rows.length, pending: 0, viewed: 0, shortlisted: 0, hired: 0, declined: 0 };
    for (const p of rows) {
      const b = statusBucket(p.status);
      if (b === "pending") fresh.pending += 1;
      else if (b === "viewed") fresh.viewed += 1;
      else if (b === "shortlisted") fresh.shortlisted += 1;
      else if (b === "hired") fresh.hired += 1;
      else if (b === "declined") fresh.declined += 1;
      else fresh.pending += 1;
    }
    return fresh;
  }, [rows]);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    return rows.filter((p) => {
      const bucket = statusBucket(p.status);
      if (tab !== "all" && bucket !== tab) return false;
      if (!q) return true;
      const hay = [p.need_title, p.to_name, p.message].filter(Boolean).join(" ").toLowerCase();
      return hay.includes(q);
    });
  }, [rows, tab, query]);

  async function withdraw(id: string) {
    setBusyId(id);
    setError(null);
    try {
      const supabase = createClient();
      const { error: err } = await supabase
        .from("connect_proposals")
        .update({ status: "withdrawn" })
        .eq("id", id);
      if (err) throw err;
      setRows((prev) => prev.map((p) => (p.id === id ? { ...p, status: "withdrawn" } : p)));
    } catch (e) {
      setError(e instanceof Error ? e.message : "Could not withdraw proposal");
    } finally {
      setBusyId(null);
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="font-display text-2xl font-extrabold text-navy">My proposals</h1>
        <p className="mt-1 text-sm text-text-secondary">
          Track and manage all proposals you&apos;ve submitted.
        </p>
      </div>

      {error && (
        <p className="rounded-xl border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700">{error}</p>
      )}

      <div className="flex flex-wrap gap-2 border-b border-border pb-2">
        {TABS.map((t) => (
          <button
            key={t}
            type="button"
            onClick={() => setTab(t)}
            className={cn(
              "rounded-lg px-3 py-1.5 text-sm font-semibold capitalize",
              tab === t
                ? "bg-primary text-white"
                : "text-text-secondary hover:bg-primary/5 hover:text-primary",
            )}
          >
            {t === "all" ? `All (${counts.all})` : `${t} (${counts[t]})`}
          </button>
        ))}
      </div>

      <div className="relative">
        <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-text-muted" />
        <input
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Search by job or client…"
          className="w-full rounded-xl border border-border bg-surface py-2.5 pl-10 pr-3 text-sm outline-none focus:border-primary"
        />
      </div>

      {filtered.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-border bg-surface p-10 text-center">
          <CheckCircle2 className="mx-auto h-10 w-10 text-primary/40" />
          <p className="mt-3 font-semibold text-navy">No proposals in this view</p>
          <Link href="/connect" className="mt-3 inline-block text-sm font-semibold text-primary">
            Browse Connect jobs →
          </Link>
        </div>
      ) : (
        <ul className="space-y-3">
          {filtered.map((p) => {
            const bucket = statusBucket(p.status);
            const hired = bucket === "hired";
            const withdrawn = p.status.toLowerCase() === "withdrawn";
            return (
              <li key={p.id} className="rounded-2xl border border-border bg-white p-4 shadow-sm">
                <div className="flex items-start gap-3">
                  <JobIcon title={p.need_title || ""} />
                  <div className="min-w-0 flex-1">
                    <p className="font-semibold text-navy">{p.need_title || "Open job"}</p>
                    <p className="mt-0.5 text-sm text-text-secondary">
                      {p.to_name || "Client"} · {proposalStatusLabel(p.status)}
                    </p>
                    {p.message && (
                      <p className="mt-2 line-clamp-2 text-sm text-text-muted">{p.message}</p>
                    )}
                  </div>
                  <span
                    className={cn(
                      "shrink-0 rounded-lg px-2.5 py-1 text-[10px] font-bold uppercase",
                      STATUS_STYLE[bucket] ?? STATUS_STYLE.pending,
                    )}
                  >
                    {proposalStatusLabel(p.status)}
                  </span>
                </div>
                <div className="mt-4 flex flex-wrap gap-2 border-t border-border pt-4">
                  {!hired && !withdrawn ? (
                    <>
                      <button
                        type="button"
                        disabled={busyId === p.id}
                        onClick={() => void withdraw(p.id)}
                        className="text-sm font-semibold text-text-secondary disabled:opacity-50"
                      >
                        {busyId === p.id ? "Withdrawing…" : "Withdraw"}
                      </button>
                      <Link
                        href="/app/messages"
                        className="rounded-xl border-2 border-primary px-4 py-2 text-sm font-semibold text-primary"
                      >
                        Discuss / revise
                      </Link>
                    </>
                  ) : hired ? (
                    <Link
                      href="/app/projects"
                      className="rounded-xl bg-primary px-4 py-2 text-sm font-semibold text-white"
                    >
                      View project
                    </Link>
                  ) : null}
                  <Link
                    href="/app/messages"
                    className="ml-auto inline-flex items-center gap-1 text-sm font-semibold text-primary"
                  >
                    <MessageSquare className="h-4 w-4" />
                    Message client
                  </Link>
                </div>
              </li>
            );
          })}
        </ul>
      )}
    </div>
  );
}
