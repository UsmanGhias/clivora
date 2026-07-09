"use client";

import { useCallback, useEffect, useState, type CSSProperties, type FormEvent, type ReactNode } from "react";
import { createBrowserSupabaseClient } from "@/lib/supabase";
import { CLIVORA_NAVY, CLIVORA_PURPLE, PRO_PRICE_PKR } from "@/lib/admin";

type Profile = {
  id: string;
  email: string;
  name: string;
  account_type: string;
  role: string;
  subscription_plan: string;
  updated_at: string;
};

type ClivoraEvent = {
  id: string;
  event_type: string;
  user_email: string;
  user_name: string;
  plan: string;
  amount: number;
  source: string;
  created_at: string;
};

type Subscription = {
  id: string;
  status: string;
  product_id: string;
  verified_at: string;
};

type Stats = {
  totalUsers: number;
  freelancers: number;
  clients: number;
  admins: number;
  proUsers: number;
  activeSubscriptions: number;
  emailsThisMonth: number;
  signups: number;
  proActivations: number;
  auditEvents: number;
  mrr: number;
};

type Props = {
  adminEmails: string[];
};

function formatDate(value: string | null | undefined) {
  if (!value) return "—";
  return new Date(value).toLocaleString();
}

function badge(text: string, variant: "pro" | "admin" | "free" | "default") {
  const colors: Record<string, { bg: string; fg: string }> = {
    pro: { bg: "#ede9fe", fg: "#6d28d9" },
    admin: { bg: "#ede9fe", fg: CLIVORA_PURPLE },
    free: { bg: "#f1f5f9", fg: "#475569" },
    default: { bg: "#f1f5f9", fg: "#475569" },
  };
  const c = colors[variant] ?? colors.default;
  return (
    <span
      style={{
        display: "inline-block",
        padding: "2px 8px",
        borderRadius: 6,
        fontSize: "0.75rem",
        fontWeight: 600,
        background: c.bg,
        color: c.fg,
      }}
    >
      {text}
    </span>
  );
}

export default function AdminDashboard({ adminEmails }: Props) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [sessionEmail, setSessionEmail] = useState<string | null>(null);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [profiles, setProfiles] = useState<Profile[]>([]);
  const [events, setEvents] = useState<ClivoraEvent[]>([]);
  const [subscriptions, setSubscriptions] = useState<Subscription[]>([]);
  const [emailsThisMonth, setEmailsThisMonth] = useState(0);
  const [search, setSearch] = useState("");
  const [actionEmail, setActionEmail] = useState("");
  const [actionMsg, setActionMsg] = useState("");
  const [actionBusy, setActionBusy] = useState(false);

  const supabase = createBrowserSupabaseClient();

  async function runAdminAction(path: "/api/admin/grant-pro" | "/api/admin/grant-admin", body: Record<string, unknown>) {
    setActionBusy(true);
    setActionMsg("");
    try {
      const { data } = await supabase.auth.getSession();
      const token = data.session?.access_token;
      if (!token) throw new Error("Session expired. Sign in again.");
      const res = await fetch(path, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(body),
      });
      const json = await res.json();
      if (!res.ok) throw new Error(json.error || "Action failed");
      setActionMsg(path.includes("grant-admin") ? `Admin granted to ${body.email}` : body.revoke ? `Pro revoked for ${body.email}` : `Pro granted to ${body.email}`);
      setActionEmail("");
      await loadDashboard();
    } catch (err) {
      setActionMsg(err instanceof Error ? err.message : "Action failed");
    } finally {
      setActionBusy(false);
    }
  }

  const loadDashboard = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      const monthStart = new Date();
      monthStart.setDate(1);
      monthStart.setHours(0, 0, 0, 0);

      const [profilesRes, eventsRes, subsRes, emailRes] = await Promise.all([
        supabase
          .from("profiles")
          .select("id,email,name,account_type,role,subscription_plan,updated_at")
          .order("updated_at", { ascending: false })
          .limit(500),
        supabase
          .from("clivora_events")
          .select("id,event_type,user_email,user_name,plan,amount,source,created_at")
          .order("created_at", { ascending: false })
          .limit(100),
        supabase
          .from("subscriptions")
          .select("id,status,product_id,verified_at")
          .order("verified_at", { ascending: false })
          .limit(200),
        supabase
          .from("email_send_log")
          .select("id", { count: "exact", head: true })
          .gte("sent_at", monthStart.toISOString()),
      ]);

      if (profilesRes.error) throw profilesRes.error;
      if (eventsRes.error) throw eventsRes.error;
      if (subsRes.error) throw subsRes.error;
      if (emailRes.error) throw emailRes.error;

      setProfiles((profilesRes.data ?? []) as Profile[]);
      setEvents((eventsRes.data ?? []) as ClivoraEvent[]);
      setSubscriptions((subsRes.data ?? []) as Subscription[]);
      setEmailsThisMonth(emailRes.count ?? 0);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to load dashboard data");
    } finally {
      setLoading(false);
    }
  }, [supabase]);

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      const userEmail = session?.user?.email?.toLowerCase() ?? null;
      if (userEmail && adminEmails.includes(userEmail)) {
        setSessionEmail(userEmail);
        loadDashboard();
      }
    });

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      const userEmail = session?.user?.email?.toLowerCase() ?? null;
      if (userEmail && adminEmails.includes(userEmail)) {
        setSessionEmail(userEmail);
        loadDashboard();
      } else if (!session) {
        setSessionEmail(null);
      }
    });

    return () => subscription.unsubscribe();
  }, [adminEmails, loadDashboard, supabase.auth]);

  async function handleLogin(e: FormEvent) {
    e.preventDefault();
    setError("");
    setLoading(true);

    const normalized = email.trim().toLowerCase();
    if (!adminEmails.includes(normalized)) {
      setError("This email is not authorized for admin access.");
      setLoading(false);
      return;
    }

    const { error: signInError } = await supabase.auth.signInWithPassword({
      email: normalized,
      password,
    });

    if (signInError) {
      setError(signInError.message);
      setLoading(false);
      return;
    }

    setSessionEmail(normalized);
    await loadDashboard();
    setLoading(false);
  }

  async function handleLogout() {
    await supabase.auth.signOut();
    setSessionEmail(null);
    setPassword("");
    setProfiles([]);
    setEvents([]);
    setSubscriptions([]);
    setEmailsThisMonth(0);
  }

  const stats: Stats = {
    totalUsers: profiles.length,
    freelancers: profiles.filter(
      (p) => p.account_type === "freelancer" || p.account_type === "user"
    ).length,
    clients: profiles.filter((p) => p.account_type === "client").length,
    admins: profiles.filter(
      (p) => p.account_type === "admin" || p.role === "admin"
    ).length,
    proUsers: profiles.filter((p) => p.subscription_plan === "pro").length,
    activeSubscriptions: subscriptions.filter((s) => s.status === "active").length,
    emailsThisMonth,
    signups: events.filter((e) => e.event_type === "signup").length,
    proActivations: events.filter((e) => e.event_type === "pro_activate").length,
    auditEvents: events.filter((e) => e.event_type.startsWith("audit_")).length,
    mrr:
      Math.max(
        profiles.filter((p) => p.subscription_plan === "pro").length,
        subscriptions.filter((s) => s.status === "active").length
      ) * PRO_PRICE_PKR,
  };

  const filteredProfiles = profiles.filter((p) => {
    const q = search.trim().toLowerCase();
    if (!q) return true;
    return (
      p.name.toLowerCase().includes(q) || p.email.toLowerCase().includes(q)
    );
  });

  const auditEvents = events.filter((e) => e.event_type.startsWith("audit_"));

  if (!sessionEmail) {
    return (
      <div
        style={{
          minHeight: "100vh",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          padding: 24,
          background: `linear-gradient(135deg, ${CLIVORA_NAVY} 0%, #312e81 100%)`,
        }}
      >
        <form
          onSubmit={handleLogin}
          style={{
            background: "#fff",
            borderRadius: 20,
            padding: 32,
            width: "100%",
            maxWidth: 400,
            boxShadow: "0 20px 50px rgba(0,0,0,0.25)",
          }}
        >
          <div
            style={{
              width: 48,
              height: 48,
              borderRadius: 14,
              background: CLIVORA_PURPLE,
              color: "#fff",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              fontWeight: 800,
              fontSize: "1.4rem",
              marginBottom: 16,
            }}
          >
            C
          </div>
          <h1 style={{ margin: "0 0 8px", fontSize: "1.5rem" }}>CLIVORA Admin</h1>
          <p style={{ color: "#64748b", margin: "0 0 24px", fontSize: "0.9rem" }}>
            Production console for signups, Pro activations, cloud profiles, and audit trail.
          </p>
          {error && (
            <p style={{ color: "#dc2626", fontSize: "0.85rem", marginBottom: 12 }}>{error}</p>
          )}
          <label style={{ display: "block", fontSize: "0.85rem", fontWeight: 600, marginBottom: 6 }}>
            Admin email
          </label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="admin@codcrafters.org"
            autoComplete="username"
            required
            style={inputStyle}
          />
          <label style={{ display: "block", fontSize: "0.85rem", fontWeight: 600, marginBottom: 6 }}>
            Password
          </label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Supabase account password"
            autoComplete="current-password"
            required
            style={inputStyle}
          />
          <button
            type="submit"
            disabled={loading}
            style={{
              width: "100%",
              background: CLIVORA_PURPLE,
              color: "#fff",
              border: "none",
              borderRadius: 10,
              padding: "12px 16px",
              fontWeight: 600,
              cursor: loading ? "wait" : "pointer",
              fontSize: "0.95rem",
            }}
          >
            {loading ? "Signing in…" : "Sign in"}
          </button>
          <p style={{ marginTop: 16, fontSize: "0.8rem", color: "#64748b" }}>
            v2.6.6 · Supabase live · Vercel
          </p>
        </form>
      </div>
    );
  }

  return (
    <div>
      <header
        style={{
          background: CLIVORA_NAVY,
          color: "#fff",
          padding: "16px 24px",
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          flexWrap: "wrap",
          gap: 12,
        }}
      >
        <div>
          <h1 style={{ margin: 0, fontSize: "1.2rem" }}>CLIVORA Admin Panel</h1>
          <span style={{ color: "#94a3b8", fontSize: "0.85rem" }}>{sessionEmail}</span>
        </div>
        <div style={{ display: "flex", gap: 8 }}>
          <button type="button" onClick={loadDashboard} disabled={loading} style={secondaryBtn}>
            Refresh
          </button>
          <button type="button" onClick={handleLogout} style={secondaryBtn}>
            Sign Out
          </button>
        </div>
      </header>

      <main style={{ maxWidth: 1100, margin: "0 auto", padding: 24 }}>
        {error && (
          <p style={{ color: "#dc2626", marginBottom: 16, fontSize: "0.9rem" }}>{error}</p>
        )}

        <div
          style={{
            display: "grid",
            gridTemplateColumns: "repeat(auto-fit, minmax(160px, 1fr))",
            gap: 16,
            marginBottom: 24,
          }}
        >
          <StatCard label="Total Users" value={stats.totalUsers} />
          <StatCard label="Freelancers" value={stats.freelancers} />
          <StatCard label="Clients" value={stats.clients} />
          <StatCard label="Pro Users" value={stats.proUsers} />
          <StatCard label="Active Subs" value={stats.activeSubscriptions} />
          <StatCard label="Sign-ups" value={stats.signups} />
          <StatCard label="Pro Activations" value={stats.proActivations} />
          <StatCard label="Audit Events" value={stats.auditEvents} />
          <StatCard label="Emails (month)" value={stats.emailsThisMonth} />
          <StatCard label="Est. MRR (PKR)" value={`Rs ${stats.mrr.toLocaleString()}`} />
        </div>

        <Panel title="Admin Controls">
          <p style={{ color: "#64748b", fontSize: "0.9rem", marginTop: 0 }}>
            Grant Pro or Admin access by email. User must already have a CLIVORA account.
          </p>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 10, alignItems: "center" }}>
            <input
              type="email"
              placeholder="user@email.com"
              value={actionEmail}
              onChange={(e) => setActionEmail(e.target.value)}
              style={{ ...inputStyle, maxWidth: 320, marginBottom: 0 }}
            />
            <button
              type="button"
              disabled={actionBusy || !actionEmail.includes("@")}
              onClick={() => runAdminAction("/api/admin/grant-pro", { email: actionEmail.trim().toLowerCase(), revoke: false })}
              style={{ ...secondaryBtn, background: CLIVORA_PURPLE }}
            >
              Grant Pro
            </button>
            <button
              type="button"
              disabled={actionBusy || !actionEmail.includes("@")}
              onClick={() => runAdminAction("/api/admin/grant-pro", { email: actionEmail.trim().toLowerCase(), revoke: true })}
              style={secondaryBtn}
            >
              Revoke Pro
            </button>
            <button
              type="button"
              disabled={actionBusy || !actionEmail.includes("@")}
              onClick={() => runAdminAction("/api/admin/grant-admin", { email: actionEmail.trim().toLowerCase() })}
              style={secondaryBtn}
            >
              Grant Admin
            </button>
          </div>
          {actionMsg && (
            <p style={{ marginTop: 12, fontSize: "0.9rem", color: actionMsg.toLowerCase().includes("fail") || actionMsg.toLowerCase().includes("error") || actionMsg.toLowerCase().includes("not") ? "#dc2626" : "#059669" }}>
              {actionMsg}
            </p>
          )}
        </Panel>

        <Panel title="Cloud Profiles">
          <input
            type="search"
            placeholder="Search name or email…"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={{ ...inputStyle, maxWidth: 280, marginBottom: 16 }}
          />
          <Table
            headers={["Name", "Email", "Type", "Plan", "Updated", "Actions"]}
            rows={
              filteredProfiles.length
                ? filteredProfiles.map((p) => [
                    p.name || "—",
                    p.email,
                    p.account_type === "admin" || p.role === "admin"
                      ? badge("Admin", "admin")
                      : badge(p.account_type, "default"),
                    p.subscription_plan === "pro" ? badge("Pro", "pro") : badge("Free", "free"),
                    formatDate(p.updated_at),
                    <div key={p.id} style={{ display: "flex", gap: 6 }}>
                      <button
                        type="button"
                        style={{ ...secondaryBtn, padding: "4px 8px", fontSize: "0.75rem" }}
                        onClick={() => runAdminAction("/api/admin/grant-pro", { email: p.email, revoke: p.subscription_plan === "pro" })}
                      >
                        {p.subscription_plan === "pro" ? "Revoke Pro" : "Grant Pro"}
                      </button>
                    </div>,
                  ])
                : [["No Supabase profiles yet", "", "", "", "", ""]]
            }
          />
        </Panel>

        <Panel title="Audit Trail">
          <p style={{ color: "#64748b", fontSize: "0.9rem", marginTop: 0 }}>
            Invoice status changes, admin grants, payments, and notifications synced from the mobile app.
          </p>
          <Table
            headers={["Action", "User", "Source", "Date"]}
            rows={
              auditEvents.length
                ? auditEvents.slice(0, 50).map((e) => [
                    e.event_type.replace("audit_", "").replace(/_/g, " "),
                    e.user_email || e.user_name || "—",
                    e.source,
                    formatDate(e.created_at),
                  ])
                : [["No audit events yet", "", "", ""]]
            }
          />
        </Panel>

        <Panel title="Recent Events">
          <Table
            headers={["Event", "User", "Plan", "Amount", "Date"]}
            rows={
              events.length
                ? events.map((e) => [
                    e.event_type.replace(/_/g, " "),
                    e.user_email || e.user_name || "—",
                    e.plan || "—",
                    e.amount > 0 ? `Rs ${e.amount}` : "—",
                    formatDate(e.created_at),
                  ])
                : [["No events synced yet", "", "", "", ""]]
            }
          />
        </Panel>

        <Panel title="Subscriptions">
          <Table
            headers={["Product", "Status", "Verified"]}
            rows={
              subscriptions.length
                ? subscriptions.slice(0, 50).map((s) => [
                    s.product_id,
                    s.status === "active" ? badge("Active", "pro") : badge(s.status, "free"),
                    formatDate(s.verified_at),
                  ])
                : [["No subscriptions yet", "", ""]]
            }
          />
        </Panel>
      </main>

      <footer style={{ textAlign: "center", color: "#64748b", fontSize: "0.8rem", padding: 32 }}>
        CLIVORA by CodCrafters · Admin panel v2.7.0
      </footer>
    </div>
  );
}

const inputStyle: CSSProperties = {
  width: "100%",
  padding: "10px 12px",
  border: "1px solid #e2e8f0",
  borderRadius: 10,
  fontSize: "0.95rem",
  marginBottom: 16,
};

const secondaryBtn: CSSProperties = {
  background: CLIVORA_NAVY,
  color: "#fff",
  border: "1px solid #334155",
  borderRadius: 10,
  padding: "8px 14px",
  fontWeight: 600,
  cursor: "pointer",
  fontSize: "0.85rem",
};

function StatCard({ label, value }: { label: string; value: string | number }) {
  return (
    <div
      style={{
        background: "#fff",
        border: "1px solid #e2e8f0",
        borderRadius: 16,
        padding: 20,
      }}
    >
      <div style={{ fontSize: "1.6rem", fontWeight: 800, color: CLIVORA_PURPLE }}>{value}</div>
      <div style={{ color: "#64748b", fontSize: "0.85rem", marginTop: 4 }}>{label}</div>
    </div>
  );
}

function Panel({ title, children }: { title: string; children: ReactNode }) {
  return (
    <section
      style={{
        background: "#fff",
        border: "1px solid #e2e8f0",
        borderRadius: 16,
        padding: 20,
        marginBottom: 20,
      }}
    >
      <h2 style={{ margin: "0 0 16px", fontSize: "1.1rem" }}>{title}</h2>
      {children}
    </section>
  );
}

function Table({ headers, rows }: { headers: string[]; rows: ReactNode[][] }) {
  return (
    <div style={{ overflowX: "auto" }}>
      <table style={{ width: "100%", borderCollapse: "collapse", fontSize: "0.9rem" }}>
        <thead>
          <tr>
            {headers.map((h) => (
              <th
                key={h}
                style={{
                  textAlign: "left",
                  padding: "10px 8px",
                  borderBottom: "1px solid #e2e8f0",
                  color: "#64748b",
                  fontWeight: 600,
                  fontSize: "0.8rem",
                  textTransform: "uppercase",
                }}
              >
                {h}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((row, i) => (
            <tr key={i}>
              {row.map((cell, j) => (
                <td
                  key={j}
                  style={{
                    padding: "10px 8px",
                    borderBottom: "1px solid #e2e8f0",
                    maxWidth: j === 0 ? 220 : undefined,
                    overflow: "hidden",
                    textOverflow: "ellipsis",
                  }}
                >
                  {cell}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
