"use client";

import { useCallback, useEffect, useState } from "react";
import { Logo } from "@/components/ui/Logo";
import { createBrowserSupabaseClient } from "@/lib/supabase-browser";

const PRO_PRICE_USD = 9;
const PRO_PLUS_PRICE_USD = 19;

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
  isBlocked?: boolean;
  isRestricted?: boolean;
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
  estimatedMrrUsd: number;
  events: AdminEvent[];
  auditEvents: AdminEvent[];
  profiles?: AdminProfile[];
  source?: string;
};

type Tab = "overview" | "users" | "payments" | "marketplace" | "audit" | "events" | "flags" | "escrow";

type FeatureFlag = {
  id?: string;
  key: string;
  value: unknown;
  description?: string | null;
  updated_at?: string | null;
};

type EscrowMilestone = {
  id: string;
  request_id: string;
  title: string;
  amount?: number | null;
  currency?: string | null;
  status: string;
  created_at?: string | null;
};

type PaymentRequest = {
  id: string;
  email: string;
  full_name: string;
  plan: string;
  amount_pkr?: number;
  amount_usd?: number;
  currency?: string;
  payment_method: string;
  payment_reference: string;
  status: string;
  created_at: string;
  country?: string;
  account_type?: string;
  notes?: string;
};

type ConnectProfile = {
  id: string;
  user_id: string;
  display_title: string;
  headline?: string;
  skills?: string[];
  rate_band?: string;
  is_listed: boolean;
  is_verified: boolean;
  moderation_status: string;
  account_type?: string;
  updated_at?: string;
};

type ConnectNeed = {
  id: string;
  client_user_id: string;
  title: string;
  summary?: string;
  skills?: string[];
  budget_band?: string;
  is_open: boolean;
  moderation_status: string;
  created_at?: string;
};

type ConnectAutoApproveSettings = {
  profiles: boolean;
  needs: boolean;
};

const EMPTY = "N/A";
const ADMIN_VERSION = "v2.10.5";
const DEFAULT_CONNECT_SETTINGS: ConnectAutoApproveSettings = {
  profiles: true,
  needs: true,
};

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
  const [connectProfiles, setConnectProfiles] = useState<ConnectProfile[]>([]);
  const [connectNeeds, setConnectNeeds] = useState<ConnectNeed[]>([]);
  const [connectSettings, setConnectSettings] = useState<ConnectAutoApproveSettings>(DEFAULT_CONNECT_SETTINGS);
  const [connectBusy, setConnectBusy] = useState(false);
  const [flags, setFlags] = useState<FeatureFlag[]>([]);
  const [flagsBusy, setFlagsBusy] = useState(false);
  const [newFlagKey, setNewFlagKey] = useState("");
  const [newFlagValue, setNewFlagValue] = useState("");
  const [newFlagDesc, setNewFlagDesc] = useState("");
  const [escrowMilestones, setEscrowMilestones] = useState<EscrowMilestone[]>([]);
  const [escrowBusy, setEscrowBusy] = useState(false);
  const [escrowReleaseId, setEscrowReleaseId] = useState("");
  const [escrowReleaseAmount, setEscrowReleaseAmount] = useState("");
  const [sessionToken, setSessionToken] = useState("");
  const [newPanelPassword, setNewPanelPassword] = useState("");
  const [confirmPanelPassword, setConfirmPanelPassword] = useState("");

  const adminAuthBody = useCallback(() => {
    return { adminEmail: email.trim().toLowerCase(), adminToken: "" };
  }, [email]);

  const loadStats = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const res = await fetch("/api/admin/stats", {
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
      const auth = adminAuthBody();
      const res = await fetch("/api/admin/payment-requests", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(auth),
      });
      if (!res.ok) return;
      const data = (await res.json()) as { requests?: PaymentRequest[] };
      setPaymentRequests(Array.isArray(data.requests) ? data.requests : []);
    } catch {
      /* optional panel */
    }
  }, [adminAuthBody]);

  const loadEscrow = useCallback(async () => {
    setEscrowBusy(true);
    try {
      const auth = adminAuthBody();
      const res = await fetch("/api/admin/escrow", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ action: "list_milestones", ...auth }),
      });
      if (!res.ok) return;
      const data = (await res.json()) as { milestones?: EscrowMilestone[] };
      setEscrowMilestones(Array.isArray(data.milestones) ? data.milestones : []);
    } catch {
      /* optional */
    } finally {
      setEscrowBusy(false);
    }
  }, [adminAuthBody]);

  const loadFlags = useCallback(async () => {
    setFlagsBusy(true);
    try {
      const auth = adminAuthBody();
      const res = await fetch("/api/admin/feature-flags", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ action: "list", ...auth }),
      });
      if (!res.ok) return;
      const data = (await res.json()) as { flags?: FeatureFlag[] };
      setFlags(Array.isArray(data.flags) ? data.flags : []);
    } catch {
      /* optional */
    } finally {
      setFlagsBusy(false);
    }
  }, [adminAuthBody]);

  const loadConnect = useCallback(async () => {
    try {
      const auth = adminAuthBody();
      const [marketplaceRes, settingsRes] = await Promise.all([
        fetch("/api/admin/marketplace", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            action: "list",
            ...auth,
          }),
        }),
        fetch("/api/admin/moderation", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            action: "get_settings",
            ...auth,
          }),
        }),
      ]);
      if (marketplaceRes.ok) {
        const data = (await marketplaceRes.json()) as {
          profiles?: ConnectProfile[];
          needs?: ConnectNeed[];
        };
        setConnectProfiles(Array.isArray(data.profiles) ? data.profiles : []);
        setConnectNeeds(Array.isArray(data.needs) ? data.needs : []);
      }
      if (settingsRes.ok) {
        const data = (await settingsRes.json()) as {
          settings?: Record<string, boolean>;
        };
        setConnectSettings({
          profiles:
            typeof data.settings?.connect_auto_approve_profiles === "boolean"
              ? data.settings.connect_auto_approve_profiles
              : DEFAULT_CONNECT_SETTINGS.profiles,
          needs:
            typeof data.settings?.connect_auto_approve_needs === "boolean"
              ? data.settings.connect_auto_approve_needs
              : DEFAULT_CONNECT_SETTINGS.needs,
        });
      }
    } catch {
      /* optional panel */
    }
  }, [adminAuthBody]);

  async function runGrant(body: Record<string, unknown>) {
    setActionBusy(true);
    setActionMsg("");
    try {
      const auth = adminAuthBody();
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

  async function runUserModerationAction(
    profile: AdminProfile,
    action: "block" | "unblock" | "restrict" | "unrestrict",
  ) {
    setActionBusy(true);
    setActionMsg("");
    try {
      const auth = adminAuthBody();
      const res = await fetch("/api/admin/moderation", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          action,
          userId: profile.id,
          ...auth,
        }),
      });
      const json = await res.json();
      if (!res.ok) throw new Error(json.error || "Moderation action failed");
      setActionMsg(`${action[0].toUpperCase()}${action.slice(1)} ok for ${profile.email || profile.id}`);
      await loadStats();
    } catch (e) {
      setActionMsg(e instanceof Error ? e.message : "Moderation action failed");
    } finally {
      setActionBusy(false);
    }
  }

  useEffect(() => {
    if (typeof window === "undefined") return;
    createBrowserSupabaseClient().auth.getUser().then(({ data }) => {
      if (data.user) {
        setEmail(data.user.email ?? "");
        setLoggedIn(true);
      }
    });
  }, []);

  async function runConnectAction(body: Record<string, unknown>) {
    setConnectBusy(true);
    setActionMsg("");
    try {
      const auth = adminAuthBody();
      const res = await fetch("/api/admin/marketplace", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ ...body, ...auth }),
      });
      const json = await res.json();
      if (!res.ok) throw new Error(json.error || "Connect action failed");
      setActionMsg(`Connect: ${String(body.action)} ok`);
      await loadConnect();
    } catch (e) {
      setActionMsg(e instanceof Error ? e.message : "Connect action failed");
    } finally {
      setConnectBusy(false);
    }
  }

  async function runSetAutoApprove(target: keyof ConnectAutoApproveSettings, enabled: boolean) {
    setConnectBusy(true);
    setActionMsg("");
    try {
      const auth = adminAuthBody();
      const res = await fetch("/api/admin/moderation", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          action: "set_auto_approve",
          target,
          enabled,
          ...auth,
        }),
      });
      const json = await res.json();
      if (!res.ok) throw new Error(json.error || "Auto-approve update failed");
      setConnectSettings((current) => ({ ...current, [target]: enabled }));
      setActionMsg(`Connect auto-approve ${target === "profiles" ? "listings" : "job posts"} ${enabled ? "on" : "off"}`);
      await loadConnect();
    } catch (e) {
      setActionMsg(e instanceof Error ? e.message : "Auto-approve update failed");
    } finally {
      setConnectBusy(false);
    }
  }

  useEffect(() => {
    if (!loggedIn) return;
    loadStats();
    loadPayments();
    loadConnect();
    loadFlags();
    loadEscrow();
  }, [loggedIn, loadStats, loadPayments, loadConnect, loadFlags, loadEscrow]);

  async function login() {
    setError("");
    const em = email.trim().toLowerCase();
    if (!em || !password) {
      setError("Enter your CLIVORA account email and password.");
      return;
    }
    try {
      const supabase = createBrowserSupabaseClient();
      const { error: authErr } = await supabase.auth.signInWithPassword({
        email: em,
        password,
      });
      if (authErr) {
        setError(authErr.message || "Sign-in failed");
        return;
      }
      // Hard navigate so admin layout re-checks role + MFA gate
      window.location.href = "/admin";
    } catch (e) {
      setError(e instanceof Error ? e.message : "Sign-in failed");
    }
  }

  async function changePanelPassword() {
    setActionMsg("Admin passwords are managed by Supabase Auth. Use the account security settings.");
  }

  function logout() {
    void createBrowserSupabaseClient().auth.signOut();
    setSessionToken("");
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
          <div className="mb-4 inline-flex rounded-2xl bg-navy px-3 py-2">
            <Logo size="sm" variant="onDark" />
          </div>
          <h1 className="text-2xl font-bold text-slate-900">CLIVORA Admin</h1>
          <p className="text-slate-600 text-sm mt-2 mb-4">
            Sign in with your CLIVORA account (same password as the app). Admin access requires an
            admin role on your profile, then Google Authenticator MFA.
          </p>
          {error && (
            <p className="text-red-700 text-sm mb-4 bg-red-50 border border-red-100 rounded-lg px-3 py-2">{error}</p>
          )}
          <label className="block text-sm font-semibold text-slate-800 mb-1">Admin email</label>
          <input
            className="w-full border border-slate-300 rounded-lg px-3 py-2.5 mb-4 text-slate-900 bg-white focus:outline-none focus:ring-2 focus:ring-teal-500"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="usmanghias1@gmail.com"
            autoComplete="email"
          />
          <label className="block text-sm font-semibold text-slate-800 mb-1">Account password</label>
          <input
            type="password"
            className="w-full border border-slate-300 rounded-lg px-3 py-2.5 mb-4 text-slate-900 bg-white focus:outline-none focus:ring-2 focus:ring-teal-500"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            autoComplete="current-password"
            onKeyDown={(e) => e.key === "Enter" && void login()}
          />
          <button
            onClick={() => void login()}
            className="w-full bg-teal-600 hover:bg-teal-700 text-white rounded-lg py-3 font-semibold transition-colors"
          >
            Sign in to Admin
          </button>
          <p className="text-xs text-slate-500 mt-4 text-center">
            Allowed admins: usmanghias1@gmail.com · iusmanghias@gmail.com · admin@codcrafters.org
          </p>
          <p className="text-xs text-slate-500 text-center mt-2">{ADMIN_VERSION} · Supabase Auth + MFA</p>
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
    { id: "flags", label: `Flags (${flags.length})` },
    { id: "escrow", label: "Escrow" },
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
                label="Est. MRR (USD)"
                value={stats ? `$${stats.estimatedMrrUsd}` : EMPTY}
                sub={`$${PRO_PRICE_USD} / Pro · $${PRO_PLUS_PRICE_USD} / Plus`}
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

            <div className="bg-white border border-slate-200 rounded-xl p-5 shadow-sm">
              <h2 className="font-semibold text-slate-900 mb-2">Admin account security</h2>
              <p className="text-sm text-slate-600 mb-3">
                Admin access uses Supabase Auth and authenticator-app MFA. Password changes belong in
                the account security flow; this legacy panel-password form is disabled.
              </p>
              <div className="flex flex-col sm:flex-row gap-2">
                <input
                  type="password"
                  className="flex-1 border border-slate-300 rounded-lg px-3 py-2 text-slate-900"
                  placeholder="New password (min 10)"
                  value={newPanelPassword}
                  onChange={(e) => setNewPanelPassword(e.target.value)}
                  autoComplete="new-password"
                />
                <input
                  type="password"
                  className="flex-1 border border-slate-300 rounded-lg px-3 py-2 text-slate-900"
                  placeholder="Confirm new password"
                  value={confirmPanelPassword}
                  onChange={(e) => setConfirmPanelPassword(e.target.value)}
                  autoComplete="new-password"
                />
                <button
                  type="button"
                  onClick={changePanelPassword}
                  className="bg-slate-900 hover:bg-slate-800 text-white px-4 py-2 rounded-lg text-sm font-semibold"
                >
                  Update password
                </button>
              </div>
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
                        <td className={tdClass}>
                          ${(r.amount_usd ?? r.amount_pkr ?? 0).toLocaleString()}
                          {r.currency ? ` ${r.currency}` : ""}
                        </td>
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
          <div className="space-y-5">
            <div className="bg-white border border-slate-200 rounded-xl p-5 shadow-sm space-y-2">
              <div className="flex items-center justify-between gap-3 flex-wrap">
                <div>
                  <h2 className="font-semibold text-slate-900">CLIVORA Connect moderation</h2>
                  <p className="text-sm text-slate-600 mt-1">
                    Approve, verify, or hide Pro Plus listings and need posts. Anonymous until mutual accept · $
                    {PRO_PLUS_PRICE_USD.toLocaleString()}/mo.
                  </p>
                </div>
                <div className="flex items-center gap-2 flex-wrap">
                  <button
                    type="button"
                    aria-pressed={connectSettings.profiles}
                    disabled={connectBusy}
                    onClick={() => runSetAutoApprove("profiles", !connectSettings.profiles)}
                    className="inline-flex items-center gap-2 text-sm border border-slate-300 bg-white text-slate-800 px-3 py-1.5 rounded-lg disabled:opacity-50"
                  >
                    <span
                      className={`inline-flex h-5 w-9 items-center rounded-full p-0.5 transition-colors ${
                        connectSettings.profiles ? "bg-teal-600" : "bg-slate-300"
                      }`}
                    >
                      <span
                        className={`h-4 w-4 rounded-full bg-white shadow transition-transform ${
                          connectSettings.profiles ? "translate-x-4" : "translate-x-0"
                        }`}
                      />
                    </span>
                    Auto-approve listings
                  </button>
                  <button
                    type="button"
                    aria-pressed={connectSettings.needs}
                    disabled={connectBusy}
                    onClick={() => runSetAutoApprove("needs", !connectSettings.needs)}
                    className="inline-flex items-center gap-2 text-sm border border-slate-300 bg-white text-slate-800 px-3 py-1.5 rounded-lg disabled:opacity-50"
                  >
                    <span
                      className={`inline-flex h-5 w-9 items-center rounded-full p-0.5 transition-colors ${
                        connectSettings.needs ? "bg-teal-600" : "bg-slate-300"
                      }`}
                    >
                      <span
                        className={`h-4 w-4 rounded-full bg-white shadow transition-transform ${
                          connectSettings.needs ? "translate-x-4" : "translate-x-0"
                        }`}
                      />
                    </span>
                    Auto-approve job posts
                  </button>
                  <button
                    type="button"
                    disabled={connectBusy}
                    onClick={() => loadConnect()}
                    className="text-sm bg-slate-900 text-white px-3 py-1.5 rounded-lg disabled:opacity-50"
                  >
                    Refresh
                  </button>
                </div>
              </div>
            </div>

            <TableShell title="Freelancer listings" count={connectProfiles.length}>
              {connectProfiles.length > 0 ? (
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead className="bg-slate-50 border-b border-slate-200">
                      <tr>
                        <th className={thClass}>Title</th>
                        <th className={thClass}>Rate</th>
                        <th className={thClass}>Status</th>
                        <th className={thClass}>Listed</th>
                        <th className={thClass}>Verified</th>
                        <th className={thClass}>Actions</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-100">
                      {connectProfiles.map((p) => (
                        <tr key={p.id} className="hover:bg-slate-50">
                          <td className={`${tdClass} font-medium`}>
                            <div>{p.display_title || EMPTY}</div>
                            <div className="text-xs text-slate-500 mt-0.5">{p.headline || EMPTY}</div>
                          </td>
                          <td className={tdClass}>{p.rate_band || EMPTY}</td>
                          <td className={tdClass}>
                            <span className="inline-block px-2 py-0.5 rounded text-xs font-medium bg-slate-100 text-slate-700">
                              {p.moderation_status}
                            </span>
                          </td>
                          <td className={tdClass}>{p.is_listed ? "Yes" : "No"}</td>
                          <td className={tdClass}>{p.is_verified ? "Yes" : "No"}</td>
                          <td className={tdClass}>
                            <div className="flex flex-wrap gap-1">
                              <button
                                type="button"
                                disabled={connectBusy}
                                onClick={() =>
                                  runConnectAction({
                                    action: "approve",
                                    table: "connect_profiles",
                                    id: p.id,
                                    verify: true,
                                  })
                                }
                                className="text-xs bg-teal-600 text-white px-2 py-1 rounded"
                              >
                                Approve + verify
                              </button>
                              <button
                                type="button"
                                disabled={connectBusy}
                                onClick={() =>
                                  runConnectAction({
                                    action: "hide",
                                    table: "connect_profiles",
                                    id: p.id,
                                  })
                                }
                                className="text-xs bg-slate-700 text-white px-2 py-1 rounded"
                              >
                                Hide
                              </button>
                            </div>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              ) : (
                <p className="px-5 py-10 text-center text-slate-500 text-sm">No Connect listings yet.</p>
              )}
            </TableShell>

            <TableShell title="Need posts" count={connectNeeds.length}>
              {connectNeeds.length > 0 ? (
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead className="bg-slate-50 border-b border-slate-200">
                      <tr>
                        <th className={thClass}>Title</th>
                        <th className={thClass}>Budget</th>
                        <th className={thClass}>Status</th>
                        <th className={thClass}>Open</th>
                        <th className={thClass}>Actions</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-100">
                      {connectNeeds.map((n) => (
                        <tr key={n.id} className="hover:bg-slate-50">
                          <td className={`${tdClass} font-medium`}>
                            <div>{n.title || EMPTY}</div>
                            <div className="text-xs text-slate-500 mt-0.5 line-clamp-2">{n.summary || EMPTY}</div>
                          </td>
                          <td className={tdClass}>{n.budget_band || EMPTY}</td>
                          <td className={tdClass}>{n.moderation_status}</td>
                          <td className={tdClass}>{n.is_open ? "Yes" : "No"}</td>
                          <td className={tdClass}>
                            <div className="flex flex-wrap gap-1">
                              <button
                                type="button"
                                disabled={connectBusy}
                                onClick={() =>
                                  runConnectAction({
                                    action: "approve",
                                    table: "connect_need_posts",
                                    id: n.id,
                                  })
                                }
                                className="text-xs bg-teal-600 text-white px-2 py-1 rounded"
                              >
                                Approve
                              </button>
                              <button
                                type="button"
                                disabled={connectBusy}
                                onClick={() =>
                                  runConnectAction({
                                    action: "hide",
                                    table: "connect_need_posts",
                                    id: n.id,
                                  })
                                }
                                className="text-xs bg-slate-700 text-white px-2 py-1 rounded"
                              >
                                Hide
                              </button>
                            </div>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              ) : (
                <p className="px-5 py-10 text-center text-slate-500 text-sm">No need posts yet.</p>
              )}
            </TableShell>
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
                      <th className={thClass}>Status</th>
                      <th className={thClass}>Joined</th>
                      <th className={thClass}>User ID</th>
                      <th className={thClass}>Actions</th>
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
                        <td className={tdClass}>
                          <div className="flex flex-wrap gap-1">
                            {p.isBlocked && (
                              <span className="inline-block px-2 py-0.5 rounded text-xs font-medium bg-red-100 text-red-800">
                                Blocked
                              </span>
                            )}
                            {p.isRestricted && (
                              <span className="inline-block px-2 py-0.5 rounded text-xs font-medium bg-orange-100 text-orange-800">
                                Restricted
                              </span>
                            )}
                            {!p.isBlocked && !p.isRestricted && (
                              <span className="inline-block px-2 py-0.5 rounded text-xs font-medium bg-emerald-100 text-emerald-800">
                                Active
                              </span>
                            )}
                          </div>
                        </td>
                        <td className={`${tdClass} text-slate-600 whitespace-nowrap`}>{formatDate(p.createdAt)}</td>
                        <td className={`${tdClass} text-xs text-slate-500 font-mono`}>{p.id.slice(0, 8)}...</td>
                        <td className={tdClass}>
                          <div className="flex flex-wrap gap-1">
                            <button
                              type="button"
                              disabled={actionBusy}
                              onClick={() => runUserModerationAction(p, p.isBlocked ? "unblock" : "block")}
                              className={`text-xs text-white px-2 py-1 rounded disabled:opacity-50 ${
                                p.isBlocked ? "bg-slate-700 hover:bg-slate-800" : "bg-red-600 hover:bg-red-700"
                              }`}
                            >
                              {p.isBlocked ? "Unblock" : "Block"}
                            </button>
                            <button
                              type="button"
                              disabled={actionBusy}
                              onClick={() =>
                                runUserModerationAction(p, p.isRestricted ? "unrestrict" : "restrict")
                              }
                              className={`text-xs text-white px-2 py-1 rounded disabled:opacity-50 ${
                                p.isRestricted
                                  ? "bg-slate-700 hover:bg-slate-800"
                                  : "bg-orange-600 hover:bg-orange-700"
                              }`}
                            >
                              {p.isRestricted ? "Unrestrict" : "Restrict"}
                            </button>
                          </div>
                        </td>
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

        {tab === "flags" && (
          <div className="space-y-5">
            <div className="bg-white border border-slate-200 rounded-xl p-5 shadow-sm space-y-3">
              <div className="flex items-center justify-between gap-3">
                <div>
                  <h2 className="font-semibold text-slate-900">Feature flags</h2>
                  <p className="text-sm text-slate-600 mt-0.5">
                    Toggle platform capabilities stored in <code className="text-xs">app_feature_flags</code>.
                  </p>
                </div>
                <button
                  type="button"
                  disabled={flagsBusy}
                  onClick={() => loadFlags()}
                  className="text-sm bg-slate-900 text-white px-3 py-1.5 rounded-lg disabled:opacity-50"
                >
                  Refresh
                </button>
              </div>
              <div className="flex flex-col sm:flex-row gap-2">
                <input
                  className="flex-1 border border-slate-300 rounded-lg px-3 py-2 text-slate-900 text-sm"
                  placeholder="flag.key"
                  value={newFlagKey}
                  onChange={(e) => setNewFlagKey(e.target.value)}
                />
                <input
                  className="flex-1 border border-slate-300 rounded-lg px-3 py-2 text-slate-900 text-sm"
                  placeholder="value (true / false / text)"
                  value={newFlagValue}
                  onChange={(e) => setNewFlagValue(e.target.value)}
                />
                <input
                  className="flex-1 border border-slate-300 rounded-lg px-3 py-2 text-slate-900 text-sm"
                  placeholder="description (optional)"
                  value={newFlagDesc}
                  onChange={(e) => setNewFlagDesc(e.target.value)}
                />
                <button
                  type="button"
                  disabled={flagsBusy || !newFlagKey.trim()}
                  onClick={async () => {
                    setFlagsBusy(true);
                    const auth = adminAuthBody();
                    let parsedValue: unknown = newFlagValue;
                    if (newFlagValue === "true") parsedValue = true;
                    else if (newFlagValue === "false") parsedValue = false;
                    else if (newFlagValue !== "" && !isNaN(Number(newFlagValue))) parsedValue = Number(newFlagValue);
                    try {
                      await fetch("/api/admin/feature-flags", {
                        method: "POST",
                        headers: { "Content-Type": "application/json" },
                        body: JSON.stringify({ action: "set", key: newFlagKey, value: parsedValue, description: newFlagDesc || null, ...auth }),
                      });
                      setNewFlagKey(""); setNewFlagValue(""); setNewFlagDesc("");
                      await loadFlags();
                    } finally { setFlagsBusy(false); }
                  }}
                  className="bg-teal-600 hover:bg-teal-700 disabled:opacity-50 text-white px-4 py-2 rounded-lg text-sm font-semibold whitespace-nowrap"
                >
                  {flagsBusy ? "…" : "Set flag"}
                </button>
              </div>
            </div>
            <TableShell title="App feature flags" count={flags.length}>
              {flags.length > 0 ? (
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead className="bg-slate-50 border-b border-slate-200">
                      <tr>
                        <th className={thClass}>Key</th>
                        <th className={thClass}>Value</th>
                        <th className={thClass}>Description</th>
                        <th className={thClass}>Updated</th>
                        <th className={thClass}>Actions</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-100">
                      {flags.map((f) => (
                        <tr key={f.key} className="hover:bg-slate-50">
                          <td className={`${tdClass} font-mono text-xs font-semibold`}>{f.key}</td>
                          <td className={tdClass}>
                            <span className={`inline-block px-2 py-0.5 rounded text-xs font-medium ${
                              f.value === true ? "bg-emerald-100 text-emerald-800" :
                              f.value === false ? "bg-slate-100 text-slate-600" :
                              "bg-amber-50 text-amber-800"
                            }`}>
                              {JSON.stringify(f.value)}
                            </span>
                          </td>
                          <td className={`${tdClass} text-slate-500`}>{f.description ?? "-"}</td>
                          <td className={`${tdClass} text-slate-500 whitespace-nowrap`}>{formatDate(f.updated_at ?? undefined)}</td>
                          <td className={tdClass}>
                            <button
                              type="button"
                              disabled={flagsBusy}
                              onClick={async () => {
                                if (!confirm(`Delete flag "${f.key}"?`)) return;
                                setFlagsBusy(true);
                                const auth = adminAuthBody();
                                try {
                                  await fetch("/api/admin/feature-flags", {
                                    method: "POST",
                                    headers: { "Content-Type": "application/json" },
                                    body: JSON.stringify({ action: "delete", key: f.key, ...auth }),
                                  });
                                  await loadFlags();
                                } finally { setFlagsBusy(false); }
                              }}
                              className="text-xs bg-red-600 text-white px-2 py-1 rounded disabled:opacity-50"
                            >
                              Delete
                            </button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              ) : (
                <p className="px-5 py-10 text-center text-slate-500 text-sm">
                  No feature flags yet. Add one above to toggle platform features at runtime.
                </p>
              )}
            </TableShell>
          </div>
        )}

        {tab === "escrow" && (
          <div className="space-y-5">
            <div className="bg-white border border-slate-200 rounded-xl p-5 shadow-sm space-y-3">
              <div className="flex items-center justify-between gap-3">
                <div>
                  <h2 className="font-semibold text-slate-900">Escrow milestones</h2>
                  <p className="text-sm text-slate-600 mt-0.5">
                    Admin-release a milestone and insert an escrow ledger entry.
                  </p>
                </div>
                <button
                  type="button"
                  disabled={escrowBusy}
                  onClick={() => loadEscrow()}
                  className="text-sm bg-slate-900 text-white px-3 py-1.5 rounded-lg disabled:opacity-50"
                >
                  Refresh
                </button>
              </div>
              <div className="flex flex-col sm:flex-row gap-2">
                <input
                  className="flex-1 border border-slate-300 rounded-lg px-3 py-2 text-slate-900 text-sm font-mono"
                  placeholder="Milestone ID (UUID)"
                  value={escrowReleaseId}
                  onChange={(e) => setEscrowReleaseId(e.target.value)}
                />
                <input
                  type="number"
                  min="0"
                  className="w-36 border border-slate-300 rounded-lg px-3 py-2 text-slate-900 text-sm"
                  placeholder="Amount (USD)"
                  value={escrowReleaseAmount}
                  onChange={(e) => setEscrowReleaseAmount(e.target.value)}
                />
                <button
                  type="button"
                  disabled={escrowBusy || !escrowReleaseId.trim()}
                  onClick={async () => {
                    setEscrowBusy(true);
                    setActionMsg("");
                    const auth = adminAuthBody();
                    try {
                      const res = await fetch("/api/admin/escrow", {
                        method: "POST",
                        headers: { "Content-Type": "application/json" },
                        body: JSON.stringify({
                          action: "admin_release",
                          milestoneId: escrowReleaseId.trim(),
                          amount: escrowReleaseAmount ? Number(escrowReleaseAmount) : undefined,
                          ...auth,
                        }),
                      });
                      const json = await res.json();
                      if (!res.ok) throw new Error(json.error || "Release failed");
                      setActionMsg(`Milestone ${escrowReleaseId.trim().slice(0, 8)}… released.`);
                      setEscrowReleaseId("");
                      setEscrowReleaseAmount("");
                      await loadEscrow();
                    } catch (e) {
                      setActionMsg(e instanceof Error ? e.message : "Release failed");
                    } finally {
                      setEscrowBusy(false);
                    }
                  }}
                  className="bg-emerald-600 hover:bg-emerald-700 disabled:opacity-50 text-white px-4 py-2 rounded-lg text-sm font-semibold whitespace-nowrap"
                >
                  {escrowBusy ? "…" : "Admin release"}
                </button>
              </div>
            </div>
            <TableShell title="Connect milestones" count={escrowMilestones.length}>
              {escrowMilestones.length > 0 ? (
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead className="bg-slate-50 border-b border-slate-200">
                      <tr>
                        <th className={thClass}>ID</th>
                        <th className={thClass}>Title</th>
                        <th className={thClass}>Status</th>
                        <th className={thClass}>Amount</th>
                        <th className={thClass}>Created</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-100">
                      {escrowMilestones.map((m) => (
                        <tr key={m.id} className="hover:bg-slate-50">
                          <td className={`${tdClass} font-mono text-xs text-slate-500`}>{m.id.slice(0, 8)}…</td>
                          <td className={`${tdClass} font-medium`}>{m.title || EMPTY}</td>
                          <td className={tdClass}>
                            <span className={`inline-block px-2 py-0.5 rounded text-xs font-medium ${
                              m.status === "released" ? "bg-emerald-100 text-emerald-800" :
                              m.status === "funded" ? "bg-blue-100 text-blue-800" :
                              m.status === "disputed" ? "bg-red-100 text-red-800" :
                              "bg-slate-100 text-slate-700"
                            }`}>
                              {m.status}
                            </span>
                          </td>
                          <td className={tdClass}>
                            {m.amount != null ? `$${m.amount} ${m.currency ?? "USD"}` : EMPTY}
                          </td>
                          <td className={`${tdClass} whitespace-nowrap text-slate-500`}>{formatDate(m.created_at ?? undefined)}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              ) : (
                <p className="px-5 py-10 text-center text-slate-500 text-sm">
                  No milestones found. They appear here once freelancers add them to accepted Connect requests.
                </p>
              )}
            </TableShell>
          </div>
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
