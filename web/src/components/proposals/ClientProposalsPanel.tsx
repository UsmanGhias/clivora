"use client";

import Link from "next/link";
import { useMemo, useState } from "react";
import {
  CheckCircle2,
  MapPin,
  MessageSquare,
  Search,
  ShieldCheck,
  Star,
} from "lucide-react";
import { proposalStatusLabel, type ProposalRow } from "@/lib/connect-proposals-shared";
import { cn } from "@/lib/utils";

const TABS = ["all", "shortlisted", "hired", "declined", "withdrawn"] as const;

function statusBucket(status: string) {
  const s = status.toLowerCase();
  if (s === "accepted") return "hired";
  if (s === "shortlisted") return "shortlisted";
  if (s === "declined") return "declined";
  if (s === "withdrawn") return "withdrawn";
  return "all";
}

export function ClientProposalsPanel({ proposals }: { proposals: ProposalRow[] }) {
  const [tab, setTab] = useState<(typeof TABS)[number]>("all");
  const [query, setQuery] = useState("");

  const counts = useMemo(() => {
    const c = { all: proposals.length, shortlisted: 0, hired: 0, declined: 0, withdrawn: 0 };
    for (const p of proposals) {
      const b = statusBucket(p.status);
      if (b !== "all") c[b as keyof typeof c] += 1;
    }
    return c;
  }, [proposals]);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    return proposals.filter((p) => {
      if (tab !== "all" && statusBucket(p.status) !== tab) return false;
      if (!q) return true;
      const hay = [p.from_name, p.from_headline, p.need_title, p.message]
        .filter(Boolean)
        .join(" ")
        .toLowerCase();
      return hay.includes(q);
    });
  }, [proposals, tab, query]);

  const featuredNeed = proposals[0]?.need_title;

  return (
    <div className="space-y-6">
      <div>
        <h1 className="font-display text-2xl font-extrabold text-navy">Proposals</h1>
        <p className="mt-1 text-sm text-text-secondary">
          Review and manage proposals from freelancers.
        </p>
      </div>

      {featuredNeed && (
        <div className="rounded-2xl border border-client-accent/20 bg-client-surface/50 p-5">
          <div className="flex flex-wrap items-start justify-between gap-3">
            <div>
              <span className="rounded-lg bg-success/15 px-2 py-0.5 text-[10px] font-bold uppercase text-success">
                Open
              </span>
              <h2 className="mt-2 font-display text-lg font-bold text-navy">{featuredNeed}</h2>
              <p className="mt-1 text-sm text-text-secondary">
                {proposals[0]?.need_budget ? `Budget ${proposals[0].need_budget}` : "Fixed price range"}
              </p>
            </div>
            <Link
              href="/connect/manage"
              className="rounded-xl bg-client-accent px-4 py-2 text-sm font-semibold text-white"
            >
              View job
            </Link>
          </div>
        </div>
      )}

      <div className="grid gap-3 sm:grid-cols-5">
        {[
          { key: "all", label: "Total proposals" },
          { key: "shortlisted", label: "Shortlisted" },
          { key: "hired", label: "Hired" },
          { key: "declined", label: "Declined" },
          { key: "withdrawn", label: "Withdrawn" },
        ].map((s) => (
          <div key={s.key} className="rounded-2xl border border-border bg-surface p-4 text-center shadow-sm">
            <p
              className={cn(
                "font-display text-2xl font-extrabold",
                s.key === "declined" ? "text-error" : "text-navy",
              )}
            >
              {counts[s.key as keyof typeof counts]}
            </p>
            <p className="mt-1 text-[10px] font-semibold uppercase tracking-wide text-text-muted">
              {s.label}
            </p>
          </div>
        ))}
      </div>

      <div className="flex flex-wrap gap-2 border-b border-border pb-2">
        {TABS.map((t) => (
          <button
            key={t}
            type="button"
            onClick={() => setTab(t)}
            className={cn(
              "rounded-lg px-3 py-1.5 text-sm font-semibold capitalize",
              tab === t
                ? "border-b-2 border-client-accent text-client-accent"
                : "text-text-secondary hover:text-navy",
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
          placeholder="Search proposals, skills, freelancers…"
          className="w-full rounded-xl border border-border py-2.5 pl-10 pr-3 text-sm outline-none ring-client-accent focus:ring-2"
        />
      </div>

      {filtered.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-border bg-surface p-10 text-center">
          <p className="font-semibold text-navy">No proposals in this view</p>
          <p className="mt-2 text-sm text-text-secondary">
            Post a job on Connect to start receiving freelancer bids.
          </p>
          <Link href="/connect/manage" className="mt-4 inline-block text-sm font-semibold text-client-accent">
            Post a job →
          </Link>
        </div>
      ) : (
        <ul className="space-y-4">
          {filtered.map((p) => (
            <li
              key={p.id}
              className="rounded-2xl border border-border bg-surface p-5 shadow-sm transition hover:border-client-accent/30"
            >
              <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                <div className="flex gap-4">
                  <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-full bg-client-surface text-lg font-bold text-client-accent">
                    {(p.from_name || "F").charAt(0)}
                  </div>
                  <div className="min-w-0">
                    <div className="flex flex-wrap items-center gap-2">
                      <h3 className="font-bold text-navy">{p.from_name}</h3>
                      <span className="inline-flex items-center gap-1 rounded-lg bg-primary/10 px-2 py-0.5 text-[10px] font-bold uppercase text-primary-dark">
                        <ShieldCheck className="h-3 w-3" />
                        Verified
                      </span>
                    </div>
                    <p className="text-sm text-text-secondary">{p.from_headline || "Freelancer"}</p>
                    <p className="mt-2 line-clamp-2 text-sm text-text-secondary">{p.message}</p>
                  </div>
                </div>
                <div className="shrink-0 text-right">
                  <p className="font-display text-xl font-extrabold text-navy">
                    ${Number(p.amount ?? 0).toLocaleString()}
                  </p>
                  <p className="text-xs text-text-muted">Fixed price · {proposalStatusLabel(p.status)}</p>
                  <p className="mt-1 text-[10px] text-text-muted">
                    {new Date(p.created_at).toLocaleDateString()}
                  </p>
                </div>
              </div>
              <div className="mt-4 flex flex-wrap items-center justify-between gap-3 border-t border-border pt-4">
                <div className="flex items-center gap-1 text-xs text-amber-700">
                  <Star className="h-3.5 w-3.5 fill-amber-400 text-amber-400" />
                  5.0 · 100% job success
                </div>
                <div className="flex gap-2">
                  <button type="button" className="rounded-xl px-4 py-2 text-sm font-semibold text-client-accent">
                    Shortlist
                  </button>
                  <Link
                    href="/app/messages"
                    className="rounded-xl bg-client-accent px-4 py-2 text-sm font-semibold text-white"
                  >
                    <span className="inline-flex items-center gap-1">
                      <MessageSquare className="h-4 w-4" />
                      Message
                    </span>
                  </Link>
                </div>
              </div>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
