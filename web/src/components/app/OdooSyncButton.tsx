"use client";

import { useEffect, useState } from "react";

/** Admin-only Odoo Contacts sync control. */
export function OdooSyncButton() {
  const [busy, setBusy] = useState(false);
  const [configured, setConfigured] = useState<boolean | null>(null);
  const [msg, setMsg] = useState<string | null>(null);

  useEffect(() => {
    (async () => {
      try {
        const res = await fetch("/api/integrations/odoo/sync-contacts");
        const json = (await res.json()) as { configured?: boolean; error?: string };
        if (res.status === 401 || res.status === 403) {
          setConfigured(false);
          setMsg("Admin sign-in required");
          return;
        }
        setConfigured(!!json.configured);
      } catch {
        setConfigured(false);
      }
    })();
  }, []);

  async function sync() {
    setBusy(true);
    setMsg(null);
    try {
      const res = await fetch("/api/integrations/odoo/sync-contacts", { method: "POST" });
      const json = (await res.json()) as {
        ok?: boolean;
        created?: number;
        skipped?: number;
        error?: string;
        hint?: string;
      };
      if (!res.ok) {
        setMsg(json.hint || json.error || "Sync failed");
        return;
      }
      setMsg(`Synced to Odoo Contacts · created ${json.created ?? 0}, skipped ${json.skipped ?? 0}`);
      setConfigured(true);
    } catch (e) {
      setMsg(e instanceof Error ? e.message : "Sync failed");
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="space-y-2">
      <button
        type="button"
        disabled={busy || configured === false}
        onClick={() => void sync()}
        className="inline-flex rounded-xl bg-teal-600 px-4 py-2 text-sm font-semibold text-white disabled:opacity-50"
      >
        {busy ? "Syncing…" : configured === false ? "Odoo not configured" : "Sync CRM → Odoo Contacts"}
      </button>
      {configured === false && (
        <p className="text-[11px] text-slate-500">
          Configure ODOO_* on Vercel or store secrets via admin integration secrets (server-side only).
        </p>
      )}
      {configured === true && (
        <p className="text-[11px] text-slate-500">
          Connected · existing Contacts app only · no new Odoo modules.
        </p>
      )}
      {msg && <p className="text-xs text-slate-600">{msg}</p>}
    </div>
  );
}
