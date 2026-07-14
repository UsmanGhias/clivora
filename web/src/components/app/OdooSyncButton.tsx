"use client";

import { useEffect, useState } from "react";

/** Admin-only Odoo Contacts sync control. */
export function OdooSyncButton() {
  const [busy, setBusy] = useState(false);
  const [configured, setConfigured] = useState<boolean | null>(null);
  const [msg, setMsg] = useState<string | null>(null);
  const [url, setUrl] = useState<string | null>(null);

  useEffect(() => {
    (async () => {
      try {
        const res = await fetch("/api/integrations/odoo/sync-contacts", { cache: "no-store" });
        const json = (await res.json()) as {
          configured?: boolean;
          error?: string;
          code?: string;
          url?: string | null;
          hint?: string;
          missing?: string[];
        };
        if (res.status === 401 || res.status === 403) {
          setConfigured(false);
          setMsg(json.error || "Admin sign-in required");
          return;
        }
        if (res.status >= 500 && json.code) {
          setConfigured(false);
          setMsg(json.error || `Admin auth error (${json.code})`);
          return;
        }
        setConfigured(!!json.configured);
        setUrl(json.url ?? null);
        if (!json.configured) {
          setMsg(
            json.hint ||
              (json.missing?.length
                ? `Missing: ${json.missing.join(", ")}`
                : "Odoo env/secrets not visible to this deployment yet — redeploy after setting ODOO_*."),
          );
        } else {
          setMsg(null);
        }
      } catch {
        setConfigured(false);
        setMsg("Could not reach Odoo status endpoint");
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
        total?: number;
        error?: string;
        hint?: string;
      };
      if (!res.ok) {
        setMsg(json.hint || json.error || "Sync failed");
        return;
      }
      setConfigured(true);
      setMsg(
        `Synced to Odoo Contacts · created ${json.created ?? 0}, skipped ${json.skipped ?? 0}, scanned ${json.total ?? 0}`,
      );
    } catch (e) {
      setMsg(e instanceof Error ? e.message : "Sync failed");
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="space-y-2">
      <div className="flex flex-wrap items-center gap-2">
        <button
          type="button"
          disabled={busy || configured !== true}
          onClick={() => void sync()}
          className="inline-flex rounded-xl bg-teal-600 px-4 py-2 text-sm font-semibold text-white disabled:opacity-50"
        >
          {busy ? "Syncing…" : configured === true ? "Sync CRM → Odoo Contacts" : "Odoo not ready"}
        </button>
        {configured === true && (
          <span className="rounded-full bg-emerald-50 px-2.5 py-1 text-[11px] font-bold text-emerald-700">
            Configured{url ? ` · ${url.replace(/^https?:\/\//, "")}` : ""}
          </span>
        )}
        {configured === false && (
          <span className="rounded-full bg-amber-50 px-2.5 py-1 text-[11px] font-bold text-amber-800">
            Not configured
          </span>
        )}
      </div>
      {msg && <p className="text-xs text-slate-600">{msg}</p>}
      <p className="text-[11px] text-slate-500">
        Uses Vercel <code>ODOO_*</code> env first, then admin integration secrets. Existing Contacts
        app only.
      </p>
    </div>
  );
}
