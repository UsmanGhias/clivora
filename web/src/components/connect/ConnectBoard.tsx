"use client";

import { FormEvent, useMemo, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import {
  Briefcase,
  MapPin,
  MessageSquare,
  Search,
  ShieldCheck,
  Sparkles,
  Users,
} from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import {
  skillsList,
  type ConnectNeed,
  type ConnectProfile,
  type ConnectRequestRow,
} from "@/lib/connect-types";
import { site } from "@/lib/site";
import { cn } from "@/lib/utils";

type Tab = "talent" | "jobs" | "inbox";

export function ConnectBoard({
  profiles,
  needs,
  requests,
  signedIn,
  isProPlus,
  isClient,
  isRestricted,
  myUserId,
}: {
  profiles: ConnectProfile[];
  needs: ConnectNeed[];
  requests: ConnectRequestRow[];
  signedIn: boolean;
  isProPlus: boolean;
  isClient: boolean;
  isRestricted: boolean;
  myUserId?: string;
}) {
  const router = useRouter();
  const [tab, setTab] = useState<Tab>("talent");
  const [query, setQuery] = useState("");
  const [busyId, setBusyId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [ok, setOk] = useState<string | null>(null);
  const [compose, setCompose] = useState<{
    toUserId: string;
    targetProfileId?: string;
    targetNeedId?: string;
    label: string;
  } | null>(null);
  const [message, setMessage] = useState("Hi — I'd like to connect on CLIVORA.");

  const filteredProfiles = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return profiles;
    return profiles.filter((p) => {
      const hay = [
        p.display_title,
        p.headline,
        p.bio,
        p.location_label,
        p.rate_band,
        ...skillsList(p.skills),
      ]
        .filter(Boolean)
        .join(" ")
        .toLowerCase();
      return hay.includes(q);
    });
  }, [profiles, query]);

  const filteredNeeds = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return needs;
    return needs.filter((n) => {
      const hay = [n.title, n.summary, n.budget_band, ...skillsList(n.skills)]
        .filter(Boolean)
        .join(" ")
        .toLowerCase();
      return hay.includes(q);
    });
  }, [needs, query]);

  async function sendRequest(e: FormEvent) {
    e.preventDefault();
    if (!compose) return;
    setError(null);
    setOk(null);
    if (!signedIn) {
      router.push("/login?next=/connect");
      return;
    }
    if (!isProPlus) {
      router.push("/pro?plan=pro_plus");
      return;
    }
    if (isRestricted) {
      setError("Your account is restricted. Contact support to restore Connect posting.");
      return;
    }
    setBusyId(compose.toUserId);
    try {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) throw new Error("Sign in required");
      if (compose.toUserId === user.id) throw new Error("You cannot contact yourself");
      const { error: err } = await supabase.from("connect_requests").insert({
        from_user_id: user.id,
        to_user_id: compose.toUserId,
        target_profile_id: compose.targetProfileId || null,
        target_need_id: compose.targetNeedId || null,
        message: message.trim() || "I'd like to connect on CLIVORA.",
        status: "pending",
      });
      if (err) throw err;
      setOk("Request sent. Contact details unlock after they accept.");
      setCompose(null);
      router.refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not send request");
    } finally {
      setBusyId(null);
    }
  }

  async function respond(requestId: string, accept: boolean) {
    setBusyId(requestId);
    setError(null);
    try {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) throw new Error("Sign in required");
      const { error: err } = await supabase
        .from("connect_requests")
        .update({
          status: accept ? "accepted" : "declined",
          ...(accept ? { revealed_at: new Date().toISOString() } : {}),
          updated_at: new Date().toISOString(),
        })
        .eq("id", requestId)
        .eq("to_user_id", user.id);
      if (err) throw err;
      setOk(accept ? "Accepted — emails are now visible." : "Request declined.");
      router.refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Update failed");
    } finally {
      setBusyId(null);
    }
  }

  function contactGate(action: () => void) {
    if (!signedIn) {
      router.push("/login?next=/connect");
      return;
    }
    if (!isProPlus) {
      router.push("/pro?plan=pro_plus");
      return;
    }
    if (isRestricted) {
      setError("Your account is restricted from Connect actions.");
      return;
    }
    action();
  }

  return (
    <div className="space-y-6">
      {/* Search + tabs */}
      <div className="rounded-2xl border border-border bg-surface p-4 shadow-sm">
        <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
          <div className="relative flex-1">
            <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-text-muted" />
            <input
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder={tab === "jobs" ? "Search jobs, skills, budget…" : "Search talent, skills, location…"}
              className="w-full rounded-xl border border-border bg-white py-2.5 pl-10 pr-3 text-sm outline-none ring-primary focus:ring-2"
            />
          </div>
          <div className="flex rounded-xl bg-background p-1">
            {(
              [
                { id: "talent" as const, label: "Talent", icon: Users },
                { id: "jobs" as const, label: "Jobs", icon: Briefcase },
                { id: "inbox" as const, label: "Inbox", icon: MessageSquare },
              ] as const
            ).map((t) => (
              <button
                key={t.id}
                type="button"
                onClick={() => setTab(t.id)}
                className={cn(
                  "inline-flex flex-1 items-center justify-center gap-1.5 rounded-lg px-3 py-2 text-xs font-bold sm:flex-none",
                  tab === t.id ? "bg-navy text-white" : "text-text-secondary hover:text-navy",
                )}
              >
                <t.icon className="h-3.5 w-3.5" />
                {t.label}
                {t.id === "inbox" && requests.length > 0 && (
                  <span className="rounded-full bg-primary px-1.5 text-[10px] text-white">
                    {requests.length}
                  </span>
                )}
              </button>
            ))}
          </div>
        </div>
        <div className="mt-3 flex flex-wrap gap-2 text-xs text-text-secondary">
          <span className="rounded-full bg-primary/10 px-2.5 py-1 font-semibold text-primary-dark">
            {filteredProfiles.length} freelancers
          </span>
          <span className="rounded-full bg-client-surface px-2.5 py-1 font-semibold text-client-accent">
            {filteredNeeds.length} open jobs
          </span>
          {!isProPlus && (
            <Link href="/pro?plan=pro_plus" className="rounded-full bg-amber-100 px-2.5 py-1 font-semibold text-amber-900">
              Upgrade to Pro Plus to contact · {site.pricing.proPlusMonthlyLabel}/mo
            </Link>
          )}
        </div>
      </div>

      {(error || ok) && (
        <p
          className={cn(
            "rounded-xl px-4 py-3 text-sm",
            error ? "bg-error/10 text-error" : "bg-primary/10 text-primary-dark",
          )}
        >
          {error || ok}
        </p>
      )}

      {compose && (
        <form onSubmit={sendRequest} className="rounded-2xl border border-primary/30 bg-primary/5 p-4 space-y-3">
          <p className="text-sm font-bold text-navy">Contact {compose.label}</p>
          <p className="text-xs text-text-secondary">
            Emails stay private until both sides accept — safer than open marketplaces.
          </p>
          <textarea
            required
            rows={3}
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            className="w-full rounded-xl border border-border px-3 py-2 text-sm"
          />
          <div className="flex flex-wrap gap-2">
            <button
              type="submit"
              disabled={!!busyId}
              className="rounded-full bg-primary px-4 py-2 text-sm font-semibold text-white disabled:opacity-60"
            >
              {busyId ? "Sending…" : "Send Connect request"}
            </button>
            <button
              type="button"
              onClick={() => setCompose(null)}
              className="rounded-full border border-border px-4 py-2 text-sm font-semibold"
            >
              Cancel
            </button>
          </div>
        </form>
      )}

      {tab === "talent" && (
        <section className="space-y-4">
          <div className="flex items-end justify-between gap-3">
            <div>
              <h2 className="text-xl font-extrabold text-navy">Top freelancers</h2>
              <p className="text-sm text-text-secondary">Verified listings from the CLIVORA network</p>
            </div>
            {signedIn && isProPlus && !isClient && (
              <Link href="/connect/manage" className="text-sm font-semibold text-primary">
                Edit my profile →
              </Link>
            )}
          </div>
          {filteredProfiles.length === 0 ? (
            <Empty text="No talent matches yet. Try another search or publish your listing." />
          ) : (
            <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
              {filteredProfiles.map((p) => (
                <article
                  key={p.id}
                  className="flex flex-col rounded-2xl border border-border bg-surface p-5 shadow-sm transition hover:border-primary/40"
                >
                  <div className="flex items-start justify-between gap-2">
                    <div>
                      <h3 className="font-bold text-navy">{p.display_title || "Freelancer"}</h3>
                      {p.location_label && (
                        <p className="mt-0.5 inline-flex items-center gap-1 text-xs text-text-muted">
                          <MapPin className="h-3 w-3" />
                          {p.location_label}
                        </p>
                      )}
                    </div>
                    {p.is_verified && (
                      <span className="inline-flex items-center gap-1 rounded-full bg-primary/10 px-2 py-0.5 text-[10px] font-bold uppercase text-primary-dark">
                        <ShieldCheck className="h-3 w-3" /> Verified
                      </span>
                    )}
                  </div>
                  <p className="mt-2 line-clamp-2 text-sm text-text-secondary">
                    {p.headline || p.bio || "Available on CLIVORA Connect"}
                  </p>
                  {p.rate_band && (
                    <p className="mt-2 text-sm font-extrabold text-navy">{p.rate_band}</p>
                  )}
                  {p.availability && (
                    <p className="text-xs font-medium text-success">{p.availability}</p>
                  )}
                  <div className="mt-3 flex flex-wrap gap-1.5">
                    {skillsList(p.skills)
                      .slice(0, 6)
                      .map((s) => (
                        <span
                          key={s}
                          className="rounded-full bg-background px-2 py-0.5 text-[11px] text-text-secondary"
                        >
                          {s}
                        </span>
                      ))}
                  </div>
                  <button
                    type="button"
                    disabled={p.user_id === myUserId}
                    onClick={() =>
                      contactGate(() =>
                        setCompose({
                          toUserId: p.user_id,
                          targetProfileId: p.id,
                          label: p.display_title || "freelancer",
                        }),
                      )
                    }
                    className="mt-4 rounded-full bg-navy px-4 py-2 text-sm font-semibold text-white disabled:opacity-40"
                  >
                    Contact
                  </button>
                </article>
              ))}
            </div>
          )}
        </section>
      )}

      {tab === "jobs" && (
        <section className="space-y-4">
          <div className="flex items-end justify-between gap-3">
            <div>
              <h2 className="text-xl font-extrabold text-navy">Open jobs</h2>
              <p className="text-sm text-text-secondary">Client briefs looking for freelancers</p>
            </div>
            {signedIn && isProPlus && isClient && (
              <Link href="/connect/manage" className="text-sm font-semibold text-primary">
                Post a job →
              </Link>
            )}
          </div>
          {filteredNeeds.length === 0 ? (
            <Empty text="No open jobs match. Clients can post needs from Manage." />
          ) : (
            <div className="grid gap-4 sm:grid-cols-2">
              {filteredNeeds.map((n) => (
                <article
                  key={n.id}
                  className="rounded-2xl border border-border bg-surface p-5 shadow-sm"
                >
                  <div className="flex items-start justify-between gap-2">
                    <h3 className="font-bold text-navy">{n.title || "Job"}</h3>
                    <span className="rounded-full bg-amber-100 px-2 py-0.5 text-[10px] font-bold uppercase text-amber-900">
                      Open
                    </span>
                  </div>
                  <p className="mt-2 line-clamp-4 text-sm text-text-secondary">
                    {n.summary || "Details in Connect"}
                  </p>
                  {n.budget_band && (
                    <p className="mt-2 text-sm font-extrabold text-navy">Budget: {n.budget_band}</p>
                  )}
                  <div className="mt-3 flex flex-wrap gap-1.5">
                    {skillsList(n.skills)
                      .slice(0, 8)
                      .map((s) => (
                        <span
                          key={s}
                          className="rounded-full bg-background px-2 py-0.5 text-[11px] text-text-secondary"
                        >
                          {s}
                        </span>
                      ))}
                  </div>
                  <button
                    type="button"
                    disabled={n.client_user_id === myUserId}
                    onClick={() =>
                      contactGate(() =>
                        setCompose({
                          toUserId: n.client_user_id,
                          targetNeedId: n.id,
                          label: n.title || "job poster",
                        }),
                      )
                    }
                    className="mt-4 rounded-full bg-primary px-4 py-2 text-sm font-semibold text-white disabled:opacity-40"
                  >
                    Apply / Contact
                  </button>
                </article>
              ))}
            </div>
          )}
        </section>
      )}

      {tab === "inbox" && (
        <section className="space-y-4">
          <div>
            <h2 className="text-xl font-extrabold text-navy">Connect inbox</h2>
            <p className="text-sm text-text-secondary">
              Accept to reveal emails. Decline to keep privacy.
            </p>
          </div>
          {!signedIn ? (
            <Empty text="Sign in to see Connect requests." />
          ) : requests.length === 0 ? (
            <Empty text="No requests yet. Contact talent or apply to jobs to start." />
          ) : (
            <ul className="space-y-3">
              {requests.map((r) => {
                const incoming = r.to_user_id === myUserId;
                const peerName = incoming ? r.from_name || r.from_email : r.to_name || r.to_email;
                const peerEmail = incoming ? r.from_email : r.to_email;
                const revealed = r.status === "accepted" && r.revealed_at;
                return (
                  <li key={r.id} className="rounded-2xl border border-border bg-surface p-4">
                    <div className="flex flex-wrap items-start justify-between gap-2">
                      <div>
                        <p className="font-bold text-navy">
                          {incoming ? "From" : "To"}: {peerName || "CLIVORA user"}
                        </p>
                        <p className="mt-1 text-sm text-text-secondary">{r.message}</p>
                        <p className="mt-1 text-xs uppercase tracking-wide text-text-muted">
                          {r.status}
                          {r.created_at ? ` · ${new Date(r.created_at).toLocaleString()}` : ""}
                        </p>
                        {revealed && peerEmail && (
                          <p className="mt-2 text-sm font-semibold text-primary-dark">
                            Contact: {peerEmail}
                          </p>
                        )}
                      </div>
                      {incoming && r.status === "pending" && (
                        <div className="flex gap-2">
                          <button
                            type="button"
                            disabled={!!busyId}
                            onClick={() => respond(r.id, true)}
                            className="rounded-full bg-primary px-3 py-1.5 text-xs font-bold text-white"
                          >
                            Accept
                          </button>
                          <button
                            type="button"
                            disabled={!!busyId}
                            onClick={() => respond(r.id, false)}
                            className="rounded-full border border-border px-3 py-1.5 text-xs font-bold"
                          >
                            Decline
                          </button>
                        </div>
                      )}
                    </div>
                  </li>
                );
              })}
            </ul>
          )}
        </section>
      )}

      <div className="rounded-2xl border border-dashed border-navy/20 bg-navy/[0.03] p-5">
        <div className="flex items-start gap-3">
          <Sparkles className="mt-0.5 h-5 w-5 text-primary" />
          <div>
            <p className="font-bold text-navy">Why Connect beats open marketplaces</p>
            <p className="mt-1 text-sm text-text-secondary">
              Private contact until mutual accept, same CRM workspace after you match, and one
              subscription that also unlocks unlimited clients, projects, and invoices.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}

function Empty({ text }: { text: string }) {
  return (
    <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center text-sm text-text-secondary">
      {text}
    </div>
  );
}
