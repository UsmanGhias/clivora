import { NextResponse } from "next/server";
import { adminErrorResponse, requireAdmin } from "@/lib/admin-auth";
import { createClient } from "@/lib/supabase/server";

type OdooCfg = {
  url: string;
  db: string;
  username: string;
  apiKey: string;
};

async function loadOdooCfg(): Promise<OdooCfg | null> {
  const fromEnv = (): OdooCfg | null => {
    const url = process.env.ODOO_URL?.replace(/\/$/, "");
    const db = process.env.ODOO_DB;
    const username = process.env.ODOO_USERNAME;
    const apiKey = process.env.ODOO_API_KEY;
    if (!url || !db || !username || !apiKey) return null;
    return { url, db, username, apiKey };
  };

  const envCfg = fromEnv();
  if (envCfg) return envCfg;

  // Fallback: admin-only secrets table (no values returned to clients except via this server route).
  try {
    const supabase = await createClient();
    const keys = ["ODOO_URL", "ODOO_DB", "ODOO_USERNAME", "ODOO_API_KEY"] as const;
    const values: Partial<Record<(typeof keys)[number], string>> = {};
    for (const key of keys) {
      const { data, error } = await supabase.rpc("admin_get_integration_secret", { p_key: key });
      if (error || !data) return null;
      values[key] = String(data);
    }
    const url = values.ODOO_URL?.replace(/\/$/, "");
    if (!url || !values.ODOO_DB || !values.ODOO_USERNAME || !values.ODOO_API_KEY) return null;
    return {
      url,
      db: values.ODOO_DB,
      username: values.ODOO_USERNAME,
      apiKey: values.ODOO_API_KEY,
    };
  } catch {
    return null;
  }
}

async function odooJsonRpc(
  baseUrl: string,
  service: string,
  method: string,
  args: unknown[],
) {
  const res = await fetch(`${baseUrl}/jsonrpc`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      jsonrpc: "2.0",
      method: "call",
      params: { service, method, args },
      id: Date.now(),
    }),
  });
  const json = (await res.json()) as { result?: unknown; error?: { message?: string } };
  if (json.error) throw new Error(json.error.message || "Odoo RPC error");
  return json.result;
}

/**
 * Admin-only: sync CLIVORA CRM customers → Odoo Contacts (existing free app only).
 * Prefers ODOO_* env vars; falls back to admin_integration_secrets via SECURITY DEFINER RPC.
 */
export async function POST() {
  try {
    await requireAdmin({ requireAal2: false });
  } catch (e) {
    return adminErrorResponse(e);
  }

  const odoo = await loadOdooCfg();
  if (!odoo) {
    return NextResponse.json(
      {
        error: "Odoo is not configured",
        hint: "Set ODOO_URL, ODOO_DB, ODOO_USERNAME, ODOO_API_KEY (Vercel env or Admin → Integrations).",
      },
      { status: 503 },
    );
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "Sign in required" }, { status: 401 });
  }

  // Admin syncs their CRM customers into the existing Odoo Contacts app only.
  const { data: customers, error } = await supabase
    .from("crm_customers")
    .select("id, name, email, phone, company")
    .eq("owner_uid", user.id)
    .limit(500);
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 400 });
  }

  try {
    const uid = (await odooJsonRpc(odoo.url, "common", "authenticate", [
      odoo.db,
      odoo.username,
      odoo.apiKey,
      {},
    ])) as number | false;
    if (!uid) {
      return NextResponse.json({ error: "Odoo authentication failed" }, { status: 401 });
    }

    let created = 0;
    let skipped = 0;
    for (const c of customers ?? []) {
      const email = (c.email || "").trim();
      const name = (c.name || c.company || "CLIVORA contact").trim();
      if (email) {
        const existing = (await odooJsonRpc(odoo.url, "object", "execute_kw", [
          odoo.db,
          uid,
          odoo.apiKey,
          "res.partner",
          "search",
          [[["email", "=", email]]],
          { limit: 1 },
        ])) as number[];
        if (existing?.length) {
          skipped += 1;
          continue;
        }
      }
      await odooJsonRpc(odoo.url, "object", "execute_kw", [
        odoo.db,
        uid,
        odoo.apiKey,
        "res.partner",
        "create",
        [
          {
            name,
            email: email || false,
            phone: (c.phone || "").trim() || false,
            comment: `Synced from CLIVORA customer ${c.id}`,
          },
        ],
      ]);
      created += 1;
    }

    return NextResponse.json({
      ok: true,
      created,
      skipped,
      total: customers?.length ?? 0,
      apps: ["Contacts"],
      note: "Only existing Odoo Contacts app is used — no new modules installed.",
    });
  } catch (e) {
    return NextResponse.json(
      { error: e instanceof Error ? e.message : "Odoo sync failed" },
      { status: 502 },
    );
  }
}

export async function GET() {
  try {
    await requireAdmin({ requireAal2: false });
  } catch (e) {
    return adminErrorResponse(e);
  }

  const odoo = await loadOdooCfg();
  return NextResponse.json({
    configured: !!odoo,
    url: odoo?.url ?? null,
    allowedApps: ["Contacts"],
    surface: "admin-only",
  });
}
