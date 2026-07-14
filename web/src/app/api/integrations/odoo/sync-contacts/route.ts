import { NextResponse } from "next/server";
import { adminErrorResponse, requireAdmin } from "@/lib/admin-auth";
import { createClient } from "@/lib/supabase/server";

type OdooCfg = {
  url: string;
  db: string;
  username: string;
  apiKey: string;
};

function envPresence() {
  return {
    ODOO_URL: Boolean(process.env.ODOO_URL?.trim()),
    ODOO_DB: Boolean(process.env.ODOO_DB?.trim()),
    ODOO_USERNAME: Boolean(process.env.ODOO_USERNAME?.trim()),
    ODOO_API_KEY: Boolean(process.env.ODOO_API_KEY?.trim()),
  };
}

async function loadOdooCfg(): Promise<{ cfg: OdooCfg | null; source: "env" | "db" | null; missing: string[] }> {
  const presence = envPresence();
  const missingEnv = Object.entries(presence)
    .filter(([, ok]) => !ok)
    .map(([k]) => k);

  const url = process.env.ODOO_URL?.trim().replace(/\/$/, "");
  const db = process.env.ODOO_DB?.trim();
  const username = process.env.ODOO_USERNAME?.trim();
  const apiKey = process.env.ODOO_API_KEY?.trim();
  if (url && db && username && apiKey) {
    return { cfg: { url, db, username, apiKey }, source: "env", missing: [] };
  }

  try {
    const supabase = await createClient();
    const keys = ["ODOO_URL", "ODOO_DB", "ODOO_USERNAME", "ODOO_API_KEY"] as const;
    const values: Partial<Record<(typeof keys)[number], string>> = {};
    const missingDb: string[] = [];
    for (const key of keys) {
      const { data, error } = await supabase.rpc("admin_get_integration_secret", { p_key: key });
      if (error || data == null || String(data).trim() === "") {
        missingDb.push(key);
        continue;
      }
      values[key] = String(data).trim();
    }
    const dbUrl = values.ODOO_URL?.replace(/\/$/, "");
    if (dbUrl && values.ODOO_DB && values.ODOO_USERNAME && values.ODOO_API_KEY) {
      return {
        cfg: {
          url: dbUrl,
          db: values.ODOO_DB,
          username: values.ODOO_USERNAME,
          apiKey: values.ODOO_API_KEY,
        },
        source: "db",
        missing: [],
      };
    }
    return { cfg: null, source: null, missing: missingEnv.length ? missingEnv : missingDb };
  } catch {
    return { cfg: null, source: null, missing: missingEnv };
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
 */
export async function POST() {
  try {
    await requireAdmin({ requireAal2: false });
  } catch (e) {
    return adminErrorResponse(e);
  }

  const { cfg: odoo, missing } = await loadOdooCfg();
  if (!odoo) {
    return NextResponse.json(
      {
        error: "Odoo is not configured",
        missing,
        hint: "Set ODOO_URL, ODOO_DB, ODOO_USERNAME, ODOO_API_KEY on Vercel and redeploy, or store them via admin_integration_secrets.",
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

  const { data: customers, error } = await supabase
    .from("crm_customers")
    .select("id, contact_person, company, emails, phones")
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
      const emailList = Array.isArray(c.emails) ? c.emails : [];
      const phoneList = Array.isArray(c.phones) ? c.phones : [];
      const email = String(emailList[0] ?? "").trim();
      const phone = String(phoneList[0] ?? "").trim();
      const name = (c.contact_person || c.company || "CLIVORA contact").trim();
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
            phone: phone || false,
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

  const { cfg: odoo, source, missing } = await loadOdooCfg();
  return NextResponse.json({
    configured: !!odoo,
    source,
    missing,
    envPresence: envPresence(),
    url: odoo?.url ?? null,
    allowedApps: ["Contacts"],
    surface: "admin-only",
  });
}
