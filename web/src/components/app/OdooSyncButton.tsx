"use client";

import { useEffect, useState } from "react";

export function OdooSyncButton() {
  const [busy, setBusy] = useState(false);
  const [configured, setConfigured] = useState<boolean | null>(null);
  const [msg, setMsg] = useState<string | null>(null);

  useEffect(() => {
    (async () => {
      try {
        const res = await fetch("/api/integrations/odoo/sync-contacts");
        const json = (await res.json()) as { configured?: boolean };
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
        className="inline-flex rounded-xl border border-border bg-white px-3 py-2 text-sm font-semibold text-navy disabled:opacity-50"
      >
        {busy ? "Syncing…" : configured === false ? "Configure env first" : "Sync CRM → Contacts"}
      </button>
      {configured === false && (
        <p className="text-[11px] text-text-muted">
          Set ODOO_URL, ODOO_DB, ODOO_USERNAME, ODOO_API_KEY on the server.
        </p>
      )}
      {msg && <p className="text-xs text-text-secondary">{msg}</p>}
    </div>
  );
}
