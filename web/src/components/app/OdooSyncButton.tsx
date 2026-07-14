"use client";

import { useEffect, useState } from "react";

/** Admin-only Odoo Contacts sync + credential save. */
export function OdooSyncButton() {
  const [busy, setBusy] = useState(false);
  const [configured, setConfigured] = useState<boolean | null>(null);
  const [ready, setReady] = useState(false);
  const [msg, setMsg] = useState<string | null>(null);
  const [url, setUrl] = useState<string | null>(null);
  const [showForm, setShowForm] = useState(false);
  const [formUrl, setFormUrl] = useState("https://clivora.odoo.com");
  const [formDb, setFormDb] = useState("clivora");
  const [formUser, setFormUser] = useState("usmanghias1@gmail.com");
  const [formKey, setFormKey] = useState("");

  async function refreshStatus() {
    try {
      const res = await fetch("/api/integrations/odoo/sync-contacts", { cache: "no-store" });
      const json = (await res.json()) as {
        configured?: boolean;
        ready?: boolean;
        error?: string;
        code?: string;
        url?: string | null;
        hint?: string;
        missing?: string[];
        authOk?: boolean | null;
        authError?: string | null;
        partnerCount?: number | null;
        envPresence?: Record<string, boolean>;
        source?: string | null;
      };
      if (res.status === 401 || res.status === 403) {
        setConfigured(false);
        setReady(false);
        setMsg(json.error || "Admin sign-in required");
        return;
      }
      if (res.status >= 500 && json.code) {
        setConfigured(false);
        setReady(false);
        setMsg(json.error || `Admin auth error (${json.code})`);
        return;
      }
      setConfigured(!!json.configured);
      setReady(!!json.ready);
      setUrl(json.url ?? null);
      if (json.configured && json.authOk === false) {
        setMsg(
          json.authError ||
            "Odoo credentials are saved but authentication failed. Paste a fresh API key below.",
        );
        setShowForm(true);
      } else if (!json.configured) {
        setMsg(
          json.hint ||
            (json.missing?.length
              ? `Missing: ${json.missing.join(", ")}`
              : "Odoo not configured — save API key below or set Vercel ODOO_* env."),
        );
        setShowForm(true);
      } else {
        setMsg(
          `Connected · source ${json.source ?? "?"} · ${json.partnerCount ?? 0} Odoo contacts`,
        );
      }
    } catch {
      setConfigured(false);
      setReady(false);
      setMsg("Could not reach Odoo status endpoint");
    }
  }

  useEffect(() => {
    void refreshStatus();
  }, []);

  async function saveCredentials() {
    setBusy(true);
    setMsg(null);
    try {
      const res = await fetch("/api/integrations/odoo/sync-contacts", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          url: formUrl,
          db: formDb,
          username: formUser,
          apiKey: formKey,
        }),
      });
      const json = (await res.json()) as { ok?: boolean; error?: string; saved?: boolean };
      if (!res.ok) {
        setMsg(json.error || "Could not save Odoo credentials");
        return;
      }
      setFormKey("");
      setShowForm(false);
      setMsg("Odoo credentials saved and verified.");
      await refreshStatus();
    } catch (e) {
      setMsg(e instanceof Error ? e.message : "Save failed");
    } finally {
      setBusy(false);
    }
  }

  async function sync() {
    setBusy(true);
    setMsg(null);
    try {
      const res = await fetch("/api/integrations/odoo/sync-contacts", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({}),
      });
      const json = (await res.json()) as {
        ok?: boolean;
        created?: number;
        updated?: number;
        skipped?: number;
        total?: number;
        error?: string;
        hint?: string;
      };
      if (!res.ok) {
        setMsg(json.hint || json.error || "Sync failed");
        return;
      }
      setConfigured(true);
      setReady(true);
      setMsg(
        `Synced CRM → Odoo Contacts · created ${json.created ?? 0}, updated ${json.updated ?? 0}, scanned ${json.total ?? 0}`,
      );
    } catch (e) {
      setMsg(e instanceof Error ? e.message : "Sync failed");
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="space-y-3">
      <div className="flex flex-wrap items-center gap-2">
        <button
          type="button"
          disabled={busy || !ready}
          onClick={() => void sync()}
          className="inline-flex rounded-xl bg-teal-600 px-4 py-2 text-sm font-semibold text-white disabled:opacity-50"
        >
          {busy ? "Working…" : ready ? "Sync all CRM → Odoo Contacts" : "Odoo not ready"}
        </button>
        <button
          type="button"
          disabled={busy}
          onClick={() => setShowForm((v) => !v)}
          className="inline-flex rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm font-medium text-slate-700"
        >
          {showForm ? "Hide credentials" : "Update API key"}
        </button>
        {ready && (
          <span className="rounded-full bg-emerald-50 px-2.5 py-1 text-[11px] font-bold text-emerald-700">
            Ready{url ? ` · ${url.replace(/^https?:\/\//, "")}` : ""}
          </span>
        )}
        {configured === false && (
          <span className="rounded-full bg-amber-50 px-2.5 py-1 text-[11px] font-bold text-amber-800">
            Not configured
          </span>
        )}
        {configured === true && !ready && (
          <span className="rounded-full bg-rose-50 px-2.5 py-1 text-[11px] font-bold text-rose-700">
            Auth failed
          </span>
        )}
      </div>

      {showForm && (
        <div className="grid gap-2 rounded-xl border border-slate-200 bg-slate-50 p-3 sm:grid-cols-2">
          <label className="text-xs font-medium text-slate-600">
            URL
            <input
              className="mt-1 w-full rounded-lg border border-slate-200 px-2 py-1.5 text-sm"
              value={formUrl}
              onChange={(e) => setFormUrl(e.target.value)}
            />
          </label>
          <label className="text-xs font-medium text-slate-600">
            Database
            <input
              className="mt-1 w-full rounded-lg border border-slate-200 px-2 py-1.5 text-sm"
              value={formDb}
              onChange={(e) => setFormDb(e.target.value)}
            />
          </label>
          <label className="text-xs font-medium text-slate-600">
            Username (email)
            <input
              className="mt-1 w-full rounded-lg border border-slate-200 px-2 py-1.5 text-sm"
              value={formUser}
              onChange={(e) => setFormUser(e.target.value)}
            />
          </label>
          <label className="text-xs font-medium text-slate-600">
            API key (not interactive password)
            <input
              type="password"
              className="mt-1 w-full rounded-lg border border-slate-200 px-2 py-1.5 text-sm"
              value={formKey}
              onChange={(e) => setFormKey(e.target.value)}
              placeholder="Paste Odoo API key"
              autoComplete="off"
            />
          </label>
          <div className="sm:col-span-2">
            <button
              type="button"
              disabled={busy || !formKey.trim()}
              onClick={() => void saveCredentials()}
              className="rounded-xl bg-slate-900 px-4 py-2 text-sm font-semibold text-white disabled:opacity-50"
            >
              Verify & save
            </button>
            <p className="mt-1 text-[11px] text-slate-500">
              Create a key in Odoo → Preferences → Account Security → New API Key. Do not paste your
              login password. Keys are stored server-side only.
            </p>
          </div>
        </div>
      )}

      {msg && <p className="text-xs text-slate-600">{msg}</p>}
      <p className="text-[11px] text-slate-500">
        Uses Vercel <code>ODOO_*</code> env first, then admin integration secrets. Syncs every CRM
        customer (all owners) into the existing Contacts app only.
      </p>
    </div>
  );
}
