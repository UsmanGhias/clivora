"use client";

import { useCallback, useEffect, useState } from "react";
import {
  ADMIN_EMAILS,
  ADMIN_SESSION_EMAIL,
  ADMIN_SESSION_FLAG,
  ADMIN_SESSION_PASS,
  PANEL_PASSWORD,
  PRO_PLUS_PRICE_PKR,
  PRO_PRICE_PKR,
  SYNC_KEY,
} from "@/lib/admin-auth";

type AdminEvent = {
  id: string;
  eventType: string;
  userEmail: string;
  userName: string;
  plan: string;
  amount: number;
  payload?: string;
  createdAt: string;
  source: string;
};

type AdminProfile = {
  id: string;
  email: string;
  name: string;
  accountType: string;
  plan: string;
  createdAt: string;
};

type Stats = {
  totalEvents: number;
  uniqueEmails: number;
  totalProfiles?: number;
  proProfiles?: number;
  clientProfiles?: number;
  freelancerProfiles?: number;
  signups: number;
  proActivations: number;
  auditCount: number;
  estimatedMrrPkr: number;
  events: AdminEvent[];
  auditEvents: AdminEvent[];
  profiles?: AdminProfile[];
  source?: string;
};

type Tab = "overview" | "users" | "payments" | "marketplace" | "audit" | "events";

type PaymentRequest = {
  id: string;
  email: string;
  full_name: string;
  plan: string;
  amount_pkr: number;
  payment_method: string;
  payment_reference: string;
  status: string;
  created_at: string;
  country?: string;
  account_type?: string;
  notes?: string;
};

const EMPTY = "N/A";
const ADMIN_VERSION = "v2.7.1";

function formatAuditAction(eventType: string): string {
  return eventType.replace(/^audit_/, "").replace(/_/g, " ");
}

function formatAuditDetail(payload?: string): string {
  if (!payload || payload === "{}") return EMPTY;
  try {
    const data = JSON.parse(payload) as Record<string, unknown>;
    if (typeof data.detail === "string" && data.detail) return data.detail;
    const parts: string[] = [];
    if (data.action) parts.push(String(data.action));
    if (data.entityType) parts.push(String(data.entityType));
    if (data.entityId) parts.push(`#${data.entityId}`);
    if (data.fromStatus && data.toStatus) parts.push(`${data.fromStatus} to ${data.toStatus}`);
    if (data.invoiceNumber) parts.push(String(data.invoiceNumber));
    if (data.clientName) parts.push(String(data.clientName));
    return parts.length ? parts.join(" | ") : payload.slice(0, 200);
  } catch {
    return payload.slice(0, 200);
  }
}

function formatDate(iso?: string): string {
  if (!iso) return EMPTY;
  try {
    return new Date(iso).toLocaleString(undefined, {
      dateStyle: "medium",
      timeStyle: "short",
    });
  } catch {
    return iso;
  }
}

function displayUser(e: AdminEvent): string {
  if (e.userEmail) return e.userEmail;
  if (e.userName) return e.userName;
  return EMPTY;
}

function StatCard({ label, value, sub }: { label: string; value: string | number; sub?: string }) {
  return (
    <div className="bg-white border border-slate-200 rounded-xl p-4 shadow-sm">
      <div className="text-2xl font-bold text-teal-700">{value}</div>
      <div className="text-sm font-medium text-slate-800 mt-1">{label}</div>
      {sub && <div className="text-xs text-slate-500 mt-0.5">{sub}</div>}
    </div>
  );
}

function TableShell({ title, count, children }: { title: string; count: number; children: React.ReactNode }) {
  return (
    <div className="bg-white border border-slate-200 rounded-xl overflow-hidden shadow-sm">
      <div className="px-5 py-4 border-b border-slate-200 bg-slate-50">
        <h2 className="text-base font-semibold text-slate-900">{title}</h2>
        <p className="text-xs text-slate-500 mt-0.5">{count} record{count === 1 ? "" : "s"}</p>
      </div>
      {children}
    </div>
  );
}

const thClass = "px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-600";
const tdClass = "px-4 py-3 text-sm text-slate-800";

export default function AdminPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loggedIn, setLoggedIn] = useState(false);
  const [error, setError] = useState("");
  const [stats, setStats] = useState<Stats | null>(null);
  const [loading, setLoading] = useState(false);
  const [tab, setTab] = useState<Tab>("overview");
  const [actionEmail, setActionEmail] = useState("");
  const [actionMsg, setActionMsg] = useState("");
  const [actionBusy, setActionBusy] = useState(false);
  const [paymentRequests, setPaymentRequests] = useState<PaymentRequest[]>([]);

  const loadStats = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const res = await fetch(`/api/admin/stats?key=${encodeURIComponent(SYNC_KEY)}`, {
        cache: "no-store",
      });
      if (!res.ok) throw new Error(`Stats request failed (${res.status})`);
      const data = (await res.json()) as Stats;
      data.events = Array.isArray(data.events) ? data.events : [];
      data.auditEvents = Array.isArray(data.auditEvents) ? data.auditEvents : [];
      data.profiles = Array.isArray(data.profiles) ? data.profiles : [];
      data.auditCount = data.auditCount ?? data.auditEvents.length;
      setStats(data);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Could not load stats");
      setStats(null);
    } finally {
      setLoading(false);
    }
  }, []);

  const loadPayments = useCallback(async () => {
    try {
      const res = await fetch("/api/admin/payment-requests", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ adminEmail: email, adminPassword: password }),
      });
      if (!res.ok) return;
      const data = (await res.json()) as { requests?: PaymentRequest[] };
      setPaymentRequests(Array.isArray(data.requests) ? data.requests : []);
    } catch {
      /* optional panel */
    }
  }, [email, password]);

  function adminAuthBody() {
    const adminEmail =
      (typeof window !== "undefined" ? sessionStorage.getItem(ADMIN_SESSION_EMAIL) : null) ||
      email;
    const adminPassword =
      (typeof window !== "undefined" ? sessionStorage.getItem(ADMIN_SESSION_PASS) : null) ||
      password;
    return {
      adminEmail: adminEmail.trim().toLowerCase(),
      adminPassword,
    };
  }

  async function runGrant(body: Record<string, unknown>) {
    setActionBusy(true);
    setActionMsg("");
    try {
      const auth = adminAuthBody();
      if (!auth.adminEmail || !auth.adminPassword) {
        throw new Error("Session expired. Sign out and sign in again.");
      }
      const res = await fetch("/api/admin/grant-pro", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          ...body,
          ...auth,
        }),
      });
      const json = await res.json();
      if (!res.ok) throw new Error(json.error || "Action failed");
      setActionMsg(
        body.revoke
          ? `Pro revoked for ${body.email}`
          : `${body.plan === "pro_plus" ? "Pro Plus" : "Pro"} granted to ${body.email}`,
      );
      setActionEmail("");
      await Promise.all([loadStats(), loadPayments()]);
    } catch (e) {
      setActionMsg(e instanceof Error ? e.message : "Action failed");
    } finally {
      setActionBusy(false);
    }
  }

  async function runGrantAdmin(targetEmail: string) {
    setActionBusy(true);
    setActionMsg("");
    try {
      const auth = adminAuthBody();
      if (!auth.adminEmail || !auth.adminPassword) {
        throw new Error("Session expired. Sign out and sign in again.");
      }
      const res = await fetch("/api/admin/grant-admin", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          email: targetEmail,
          ...auth,
        }),
      });
      const json = await res.json();
      if (!res.ok) throw new Error(json.error || "Action failed");
      setActionMsg(`Admin granted to ${targetEmail}`);
      setActionEmail("");
      await loadStats();
    } catch (e) {
      setActionMsg(e instanceof Error ? e.message : "Action failed");
    } finally {
      setActionBusy(false);
    }
  }

  useEffect(() => {
    if (typeof window === "undefined") return;
    const flag = sessionStorage.getItem(ADMIN_SESSION_FLAG);
    const savedEmail = sessionStorage.getItem(ADMIN_SESSION_EMAIL) ?? "";
    const savedPass = sessionStorage.getItem(ADMIN_SESSION_PASS) ?? "";
    if (flag === "1" && ADMIN_EMAILS.includes(savedEmail.toLowerCase()) && savedPass === PANEL_PASSWORD) {
      setEmail(savedEmail);
      setPassword(savedPass);
      setLoggedIn(true);
    } else {
      sessionStorage.removeItem(ADMIN_SESSION_FLAG);
      sessionStorage.removeItem(ADMIN_SESSION_EMAIL);
      sessionStorage.removeItem(ADMIN_SESSION_PASS);
    }
  }, []);

  useEffect(() => {
    if (!loggedIn) return;
    loadStats();
    loadPayments();
  }, [loggedIn, loadStats, loadPayments]);

  function login() {
    const normalized = email.trim().toLowerCase();
    if (!ADMIN_EMAILS.includes(normalized)) {
      setError("This admin email is not authorized. Use iusmanghias@gmail.com.");
      return;
    }
    if (password !== PANEL_PASSWORD) {
      setError("Incorrect password.");
      return;
    }
    sessionStorage.setItem(ADMIN_SESSION_FLAG, "1");
    sessionStorage.setItem(ADMIN_SESSION_EMAIL, normalized);
    sessionStorage.setItem(ADMIN_SESSION_PASS, password);
    setEmail(normalized);
    setLoggedIn(true);
    setError("");
    setActionMsg("");
  }

  function logout() {
    sessionStorage.removeItem(ADMIN_SESSION_FLAG);
    sessionStorage.removeItem(ADMIN_SESSION_EMAIL);
    sessionStorage.removeItem(ADMIN_SESSION_PASS);
    setLoggedIn(false);
    setPassword("");
    setStats(null);
    setPaymentRequests([]);
    setActionMsg("");
  }

  if (!loggedIn) {
    return (
      <main className="min-h-screen bg-slate-950 flex items-center justify-center p-6">
        <div className="bg-white rounded-2xl p-8 w-full max-w-md shadow-2xl border border-slate-200">
          <div className="w-12 h-12 rounded-xl bg-teal-600 flex items-center justify-center text-white font-bold text-lg mb-4">
            C
          </div>
          <h1 className="text-2xl font-bold text-slate-900">CLIVORA Admin</h1>
          <p className="text-slate-600 text-sm mt-2 mb-6">
            Production console for signups, Pro activations, cloud profiles, and audit trail.
          </p>
          {error && (
            <p className="text-red-700 text-sm mb-4 bg-red-50 border border-red-100 rounded-lg px-3 py-2">{error}</p>
          )}
          <label className="block text-sm font-semibold text-slate-800 mb-1">Admin email</label>
          <input
            className="w-full border border-slate-300 rounded-lg px-3 py-2.5 mb-4 text-slate-900 bg-white focus:outline-none focus:ring-2 focus:ring-teal-500"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="you@codcrafters.org"
            autoComplete="email"
          />
          <label className="block text-sm font-semibold text-slate-800 mb-1">Password</label>
          <input
            type="password"
            className="w-full border border-slate-300 rounded-lg px-3 py-2.5 mb-6 text-slate-900 bg-white focus:outline-none focus:ring-2 focus:ring-teal-500"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            autoComplete="current-password"
            onKeyDown={(e) => e.key === "Enter" && login()}
          />
          <button
            onClick={login}
            className="w-full bg-teal-600 hover:bg-teal-700 text-white rounded-lg py-3 font-semibold transition-colors"
          >
            Sign in
          </button>
          <p className="text-xs text-slate-500 text-center mt-6">{ADMIN_VERSION} · Supabase live · Vercel</p>
        </div>
      </main>
    );
  }

  const events = stats?.events ?? [];
  const auditEvents = stats?.auditEvents ?? [];
  const profiles = stats?.profiles ?? [];
  const sourceLabel = stats?.source === "supabase" ? "Supabase live" : "Local cache";

  const tabs: { id: Tab; label: string }[] = [
    { id: "overview", label: "Overview" },
    { id: "users", label: `Users (${profiles.length})` },
    { id: "payments", label: `Payments (${paymentRequests.length})` },
    { id: "marketplace", label: "Connect" },
    { id: "audit", label: `Audit (${auditEvents.length})` },
    { id: "events", label: `Events (${events.length})` },
  ];

  return (
    <main className="min-h-screen bg-slate-100">
      <header className="bg-slate-900 text-white px-6 py-4 flex justify-between items-center gap-4 flex-wrap sticky top-0 z-10 shadow-md">
        <div>
          <h1 className="text-xl font-bold tracking-tight">CLIVORA Admin Panel</h1>
          <p className="text-slate-300 text-sm mt-0.5">
            {ADMIN_VERSION} · {sourceLabel} · {formatDate(new Date().toISOString())}
          </p>
        </div>
        <div className="flex gap-2">
          <button
            onClick={loadStats}
            disabled={loading}
            className="text-sm font-medium bg-teal-600 hover:bg-teal-500 px-4 py-2 rounded-lg disabled:opacity-60 transition-colors"
          >
            {loading ? "Refreshing..." : "Refresh"}
          </button>
          <button
            onClick={logout}
            className="text-sm font-medium bg-slate-700 hover:bg-slate-600 px-4 py-2 rounded-lg transition-colors"
          >
            Sign out
          </button>
        </div>
      </header>

      <nav className="bg-white border-b border-slate-200 px-6 flex gap-1 overflow-x-auto">
        {tabs.map((t) => (
          <button
            key={t.id}
            onClick={() => setTab(t.id)}
            className={`px-4 py-3 text-sm font-medium border-b-2 whitespace-nowrap transition-colors ${
              tab === t.id
                ? "border-teal-600 text-teal-700"
                : "border-transparent text-slate-600 hover:text-slate-900"
            }`}
          >
            {t.label}
          </button>
        ))}
      </nav>

      <div className="max-w-7xl mx-auto p-6 space-y-6">
        {error && (
          <p className="text-red-700 text-sm bg-red-50 border border-red-200 rounded-lg px-4 py-3">{error}</p>
        )}

        {tab === "overview" && (
          <>
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-8 gap-3">
              <StatCard label="Sign-ups" value={stats?.signups ?? EMPTY} />
              <StatCard label="Pro activations" value={stats?.proActivations ?? EMPTY} />
              <StatCard label="Cloud profiles" value={stats?.totalProfiles ?? EMPTY} />
              <StatCard label="Freelancers" value={stats?.freelancerProfiles ?? EMPTY} />
              <StatCard label="Clients" value={stats?.clientProfiles ?? EMPTY} />
              <StatCard label="Pro users" value={stats?.proProfiles ?? EMPTY} />
              <StatCard label="Audit events" value={stats?.auditCount ?? EMPTY} />
              <StatCard
                label="Est. MRR (PKR)"
                value={stats ? `Rs ${stats.estimatedMrrPkr.toLocaleString()}` : EMPTY}
                sub={`Rs ${PRO_PRICE_PKR.toLocaleString()} / Pro · Rs ${PRO_PLUS_PRICE_PKR.toLocaleString()} / Plus`}
              />
            </div>

            <div className="bg-white border border-slate-200 rounded-xl p-5 shadow-sm">
              <h2 className="font-semibold text-slate-900 mb-2">Grant Pro / Pro Plus</h2>
              <p className="text-sm text-slate-600 mb-3">
                Activate website checkout plans for any CLIVORA account email.
              </p>
              <div className="flex flex-col sm:flex-row gap-2">
                <input
                  className="flex-1 border border-slate-300 rounded-lg px-3 py-2 text-slate-900"
                  placeholder="user@email.com"
                  value={actionEmail}
                  onChange={(e) => setActionEmail(e.target.value)}
                />
                <button
                  disabled={actionBusy || !actionEmail.includes("@")}
                  onClick={() => runGrant({ email: actionEmail.trim().toLowerCase(), plan: "pro" })}
                  className="bg-teal-600 hover:bg-teal-700 disabled:opacity-50 text-white px-4 py-2 rounded-lg text-sm font-semibold"
                >
                  Grant Pro
                </button>
                <button
                  disabled={actionBusy || !actionEmail.includes("@")}
                  onClick={() => runGrant({ email: actionEmail.trim().toLowerCase(), plan: "pro_plus" })}
                  className="bg-violet-600 hover:bg-violet-700 disabled:opacity-50 text-white px-4 py-2 rounded-lg text-sm font-semibold"
                >
                  Grant Pro Plus
                </button>
                <button
                  disabled={actionBusy || !actionEmail.includes("@")}
                  onClick={() => runGrant({ email: actionEmail.trim().toLowerCase(), revoke: true })}
                  className="bg-slate-700 hover:bg-slate-800 disabled:opacity-50 text-white px-4 py-2 rounded-lg text-sm font-semibold"
                >
                  Revoke
                </button>
                <button
                  disabled={actionBusy || !actionEmail.includes("@")}
                  onClick={() => runGrantAdmin(actionEmail.trim().toLowerCase())}
                  className="bg-amber-600 hover:bg-amber-700 disabled:opacity-50 text-white px-4 py-2 rounded-lg text-sm font-semibold"
                >
                  Grant Admin
                </button>
              </div>
              {actionMsg && (
                <p
                  className={`text-sm mt-3 ${
                    actionMsg.toLowerCase().includes("fail") ||
                    actionMsg.toLowerCase().includes("not authorized") ||
                    actionMsg.toLowerCase().includes("incorrect") ||
                    actionMsg.toLowerCase().includes("expired")
                      ? "text-red-700"
                      : "text-teal-700"
                  }`}
                >
                  {actionMsg}
                </p>
              )}
              <p className="text-xs text-slate-500 mt-2">
                Signed in as <strong>{email || "admin"}</strong>. Target any user email above. Checkout:{" "}
                <a href="/pro" className="text-teal-700 hover:underline">
                  /pro
                </a>
              </p>
            </div>

            <div className="grid md:grid-cols-2 gap-4">
              <div className="bg-white border border-slate-200 rounded-xl p-5 shadow-sm">
                <h2 className="font-semibold text-slate-900 mb-2">Platform summary</h2>
                <ul className="text-sm text-slate-700 space-y-2">
                  <li>
                    <span className="font-medium text-slate-900">Total events:</span> {stats?.totalEvents ?? EMPTY}
                  </li>
                  <li>
                    <span className="font-medium text-slate-900">Unique emails in events:</span>{" "}
                    {stats?.uniqueEmails ?? EMPTY}
                  </li>
                  <li>
                    <span className="font-medium text-slate-900">Data source:</span> {sourceLabel}
                  </li>
                  <li>
                    <span className="font-medium text-slate-900">Sync endpoint:</span>{" "}
                    <code className="text-xs bg-slate-100 text-slate-800 px-1.5 py-0.5 rounded">POST /api/admin/sync</code>
                  </li>
                </ul>
              </div>
              <div className="bg-white border border-slate-200 rounded-xl p-5 shadow-sm">
                <h2 className="font-semibold text-slate-900 mb-2">What syncs from the app</h2>
                <p className="text-sm text-slate-700 leading-relaxed">
                  Signups, Pro activations, and audit events (invoice status, payments, contracts, notifications,
                  admin grants). CRM data stays on the user device. Use Refresh after syncing from the in-app admin.
                </p>
              </div>
            </div>

            {auditEvents.length > 0 && (
              <TableShell title="Latest audit (preview)" count={Math.min(5, auditEvents.length)}>
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead className="bg-slate-50 border-b border-slate-200">
                      <tr>
                        <th className={thClass}>Action</th>
                        <th className={thClass}>User</th>
                        <th className={thClass}>Detail</th>
                        <th className={thClass}>Date</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-100">
                      {auditEvents.slice(0, 5).map((e) => (
                        <tr key={e.id} className="hover:bg-slate-50">
                          <td className={`${tdClass} capitalize font-medium`}>{formatAuditAction(e.eventType)}</td>
                          <td className={tdClass}>{displayUser(e)}</td>
                          <td className={`${tdClass} max-w-md`}>{formatAuditDetail(e.payload)}</td>
                          <td className={`${tdClass} whitespace-nowrap text-slate-600`}>{formatDate(e.createdAt)}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </TableShell>
            )}
          </>
        )}

        {tab === "payments" && (
          <TableShell title="Pro payment requests" count={paymentRequests.length}>
            {paymentRequests.length > 0 ? (
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead className="bg-slate-50 border-b border-slate-200">
                    <tr>
                      <th className={thClass}>Email</th>
                      <th className={thClass}>Plan</th>
                      <th className={thClass}>Amount</th>
                      <th className={thClass}>Method / Ref</th>
                      <th className={thClass}>Status</th>
                      <th className={thClass}>Date</th>
                      <th className={thClass}>Actions</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    {paymentRequests.map((r) => (
                      <tr key={r.id} className="hover:bg-slate-50">
                        <td className={tdClass}>
                          <div className="font-medium">{r.email}</div>
                          <div className="text-xs text-slate-500">{r.full_name || EMPTY}</div>
                        </td>
                        <td className={tdClass}>{r.plan}</td>
                        <td className={tdClass}>Rs {(r.amount_pkr ?? 0).toLocaleString()}</td>
                        <td className={tdClass}>
                          <div>{r.payment_method}</div>
                          <div className="text-xs text-slate-500 font-mono">{r.payment_reference}</div>
                        </td>
                        <td className={tdClass}>{r.status}</td>
                        <td className={`${tdClass} whitespace-nowrap text-slate-600`}>
                          {formatDate(r.created_at)}
                        </td>
                        <td className={tdClass}>
                          {r.status === "pending" && (
                            <div className="flex flex-col gap-1">
                              <button
                                disabled={actionBusy}
                                onClick={() =>
                                  runGrant({
                                    email: r.email,
                                    plan: r.plan === "pro_plus" ? "pro_plus" : "pro",
                                    paymentRequestId: r.id,
                                  })
                                }
                                className="text-xs bg-teal-600 text-white px-2 py-1 rounded"
                              >
                                Approve + grant
                              </button>
                            </div>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            ) : (
              <p className="px-5 py-10 text-center text-slate-500 text-sm">
                No payment requests yet. Users submit from{" "}
                <a href="/pro" className="text-teal-700 hover:underline">
                  /pro
                </a>
                .
              </p>
            )}
          </TableShell>
        )}

        {tab === "marketplace" && (
          <div className="bg-white border border-slate-200 rounded-xl p-5 shadow-sm space-y-3">
            <h2 className="font-semibold text-slate-900">CLIVORA Connect moderation</h2>
            <p className="text-sm text-slate-600">
              Pro Plus marketplace listings and need posts. Approve or hide from Supabase Table Editor for now:
              <code className="mx-1 text-xs bg-slate-100 px-1 rounded">connect_profiles</code>
              and
              <code className="mx-1 text-xs bg-slate-100 px-1 rounded">connect_need_posts</code>
              (<code className="text-xs">moderation_status</code> = approved | hidden).
            </p>
            <ul className="text-sm text-slate-700 list-disc pl-5 space-y-1">
              <li>Anonymous until mutual accept on Connect requests</li>
              <li>Only Pro Plus users can list or browse</li>
              <li>Price: Rs 5,000 / month</li>
            </ul>
          </div>
        )}

        {tab === "users" && (
          <TableShell title="Cloud profiles" count={profiles.length}>
            {profiles.length > 0 ? (
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead className="bg-slate-50 border-b border-slate-200">
                    <tr>
                      <th className={thClass}>Email</th>
                      <th className={thClass}>Name</th>
                      <th className={thClass}>Account</th>
                      <th className={thClass}>Plan</th>
                      <th className={thClass}>Joined</th>
                      <th className={thClass}>User ID</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    {profiles.map((p) => (
                      <tr key={p.id} className="hover:bg-slate-50">
                        <td className={`${tdClass} font-medium`}>{p.email || EMPTY}</td>
                        <td className={tdClass}>{p.name || EMPTY}</td>
                        <td className={tdClass}>
                          <span
                            className={`inline-block px-2 py-0.5 rounded text-xs font-medium ${
                              p.accountType === "client"
                                ? "bg-blue-100 text-blue-800"
                                : "bg-teal-100 text-teal-800"
                            }`}
                          >
                            {p.accountType || "freelancer"}
                          </span>
                        </td>
                        <td className={tdClass}>
                          <span
                            className={`inline-block px-2 py-0.5 rounded text-xs font-medium ${
                              p.plan === "pro" || p.plan === "pro_plus"
                                ? "bg-amber-100 text-amber-900"
                                : "bg-slate-100 text-slate-700"
                            }`}
                          >
                            {p.plan || "free"}
                          </span>
                        </td>
                        <td className={`${tdClass} text-slate-600 whitespace-nowrap`}>{formatDate(p.createdAt)}</td>
                        <td className={`${tdClass} text-xs text-slate-500 font-mono`}>{p.id.slice(0, 8)}...</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            ) : (
              <p className="px-5 py-10 text-center text-slate-500 text-sm">
                No cloud profiles yet. Users appear here after Google or email sign-in with Supabase.
              </p>
            )}
          </TableShell>
        )}

        {tab === "audit" && (
          <TableShell title="Full audit trail" count={auditEvents.length}>
            {auditEvents.length > 0 ? (
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead className="bg-slate-50 border-b border-slate-200">
                    <tr>
                      <th className={thClass}>Action</th>
                      <th className={thClass}>User</th>
                      <th className={thClass}>Detail</th>
                      <th className={thClass}>Source</th>
                      <th className={thClass}>Date</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    {auditEvents.map((e) => (
                      <tr key={e.id} className="hover:bg-slate-50 align-top">
                        <td className={`${tdClass} capitalize font-medium whitespace-nowrap`}>
                          {formatAuditAction(e.eventType)}
                        </td>
                        <td className={tdClass}>
                          <div>{displayUser(e)}</div>
                          {e.userName && e.userEmail && (
                            <div className="text-xs text-slate-500">{e.userName}</div>
                          )}
                        </td>
                        <td className={`${tdClass} max-w-lg`}>
                          <div>{formatAuditDetail(e.payload)}</div>
                          {e.payload && e.payload !== "{}" && (
                            <details className="mt-1">
                              <summary className="text-xs text-teal-700 cursor-pointer">Raw payload</summary>
                              <pre className="text-xs text-slate-600 mt-1 whitespace-pre-wrap break-all bg-slate-50 p-2 rounded">
                                {e.payload}
                              </pre>
                            </details>
                          )}
                        </td>
                        <td className={`${tdClass} text-slate-600`}>{e.source || EMPTY}</td>
                        <td className={`${tdClass} whitespace-nowrap text-slate-600`}>{formatDate(e.createdAt)}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            ) : (
              <p className="px-5 py-10 text-center text-slate-500 text-sm">
                No audit events yet. Change invoice status, sign contracts, or grant admin in the app, then Sync and
                Refresh.
              </p>
            )}
          </TableShell>
        )}

        {tab === "events" && (
          <TableShell title="Recent platform events" count={events.length}>
            {events.length > 0 ? (
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead className="bg-slate-50 border-b border-slate-200">
                    <tr>
                      <th className={thClass}>Event</th>
                      <th className={thClass}>User</th>
                      <th className={thClass}>Plan</th>
                      <th className={thClass}>Amount</th>
                      <th className={thClass}>Source</th>
                      <th className={thClass}>Date</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    {events.map((e) => (
                      <tr key={e.id} className="hover:bg-slate-50">
                        <td className={`${tdClass} font-medium`}>{e.eventType}</td>
                        <td className={tdClass}>{displayUser(e)}</td>
                        <td className={tdClass}>{e.plan || "free"}</td>
                        <td className={tdClass}>{e.amount > 0 ? e.amount.toLocaleString() : EMPTY}</td>
                        <td className={`${tdClass} text-slate-600`}>{e.source || EMPTY}</td>
                        <td className={`${tdClass} whitespace-nowrap text-slate-600`}>{formatDate(e.createdAt)}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            ) : (
              <p className="px-5 py-10 text-center text-slate-500 text-sm">
                No events yet. Use the app or tap Sync in the in-app admin, then Refresh here.
              </p>
            )}
          </TableShell>
        )}
      </div>

      <footer className="text-center text-slate-500 text-xs py-8 border-t border-slate-200 mt-8 bg-white">
        CLIVORA by CodCrafters · Admin {ADMIN_VERSION} ·{" "}
        <a href="https://clivora.codcrafters.org" className="text-teal-700 hover:underline">
          clivora.codcrafters.org
        </a>
      </footer>
    </main>
  );
}
