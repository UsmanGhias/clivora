import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

type OdooCfg = {
  url: string;
  db: string;
  username: string;
  apiKey: string;
};

function cfg(): OdooCfg | null {
  const url = process.env.ODOO_URL?.replace(/\/$/, "");
  const db = process.env.ODOO_DB;
  const username = process.env.ODOO_USERNAME;
  const apiKey = process.env.ODOO_API_KEY;
  if (!url || !db || !username || !apiKey) return null;
  return { url, db, username, apiKey };
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
 * Sync CLIVORA CRM customers → Odoo Contacts (existing free app only).
 * Requires ODOO_* env vars. Does not install new Odoo modules.
 */
export async function POST() {
  const odoo = cfg();
  if (!odoo) {
    return NextResponse.json(
      {
        error: "Odoo is not configured",
        hint: "Set ODOO_URL, ODOO_DB, ODOO_USERNAME, ODOO_API_KEY on the server.",
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
    .select("id, name, email, phone, company")
    .eq("owner_uid", user.id)
    .limit(200);
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
  const odoo = cfg();
  return NextResponse.json({
    configured: !!odoo,
    url: odoo?.url ?? null,
    allowedApps: ["Contacts", "CRM", "Calendar", "Discuss"],
    docs: "/docs/integrations/odoo.md",
  });
}
