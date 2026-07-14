import { NextResponse } from "next/server";
import { adminErrorResponse, adminJson, requireAdmin } from "@/lib/admin-auth";
import {
  AdminServiceConfigurationError,
  adminServiceHeaders,
  requireAdminServiceConfig,
} from "@/lib/admin-service";
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

async function loadOdooCfg(): Promise<{
  cfg: OdooCfg | null;
  source: "env" | "db" | null;
  missing: string[];
}> {
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
      const { data, error } = await supabase.rpc("admin_get_integration_secret", {
        p_key: key,
      });
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

async function authenticateOdoo(cfg: OdooCfg): Promise<number> {
  const uid = (await odooJsonRpc(cfg.url, "common", "authenticate", [
    cfg.db,
    cfg.username,
    cfg.apiKey,
    {},
  ])) as number | false;
  if (!uid || typeof uid !== "number") {
    throw new Error(
      "Odoo authentication failed — regenerate an API key in Odoo (Preferences → Account Security → New API Key) and save it here or on Vercel as ODOO_API_KEY.",
    );
  }
  return uid;
}

async function fetchAllCrmCustomers(): Promise<
  Array<{
    id: string;
    contact_person: string | null;
    company: string | null;
    emails: unknown;
    phones: unknown;
    owner_uid: string | null;
  }>
> {
  try {
    const cfg = requireAdminServiceConfig();
    const res = await fetch(
      `${cfg.url}/rest/v1/crm_customers?select=id,contact_person,company,emails,phones,owner_uid&order=updated_at.desc&limit=1000`,
      {
        headers: adminServiceHeaders(cfg.serviceRoleKey),
        cache: "no-store",
      },
    );
    if (!res.ok) {
      throw new Error(`CRM fetch failed (${res.status})`);
    }
    return (await res.json()) as Array<{
      id: string;
      contact_person: string | null;
      company: string | null;
      emails: unknown;
      phones: unknown;
      owner_uid: string | null;
    }>;
  } catch (e) {
    if (e instanceof AdminServiceConfigurationError) {
      // Fallback: admin-owned rows only via RLS session
      const supabase = await createClient();
      const { data, error } = await supabase
        .from("crm_customers")
        .select("id, contact_person, company, emails, phones, owner_uid")
        .limit(500);
      if (error) throw new Error(error.message);
      return data ?? [];
    }
    throw e;
  }
}

/**
 * Admin-only: sync ALL CLIVORA CRM customers → Odoo Contacts (existing free app only).
 */
export async function POST(request: Request) {
  try {
    await requireAdmin({ requireAal2: false });
  } catch (e) {
    return adminErrorResponse(e);
  }

  const body = (await request.json().catch(() => ({}))) as { action?: string };
  if (body.action === "test") {
    const { cfg: odoo, source, missing } = await loadOdooCfg();
    if (!odoo) {
      return adminJson(
        {
          ok: false,
          configured: false,
          missing,
          error: "Odoo is not configured",
        },
        { status: 503 },
      );
    }
    try {
      const uid = await authenticateOdoo(odoo);
      const partnerCount = (await odooJsonRpc(odoo.url, "object", "execute_kw", [
        odoo.db,
        uid,
        odoo.apiKey,
        "res.partner",
        "search_count",
        [[]],
      ])) as number;
      return adminJson({
        ok: true,
        configured: true,
        source,
        url: odoo.url,
        db: odoo.db,
        username: odoo.username,
        uid,
        partnerCount,
      });
    } catch (e) {
      return adminJson(
        {
          ok: false,
          configured: true,
          source,
          url: odoo.url,
          error: e instanceof Error ? e.message : "Odoo test failed",
        },
        { status: 502 },
      );
    }
  }

  const { cfg: odoo, missing } = await loadOdooCfg();
  if (!odoo) {
    return adminJson(
      {
        error: "Odoo is not configured",
        missing,
        hint: "Set ODOO_URL, ODOO_DB, ODOO_USERNAME, ODOO_API_KEY on Vercel and redeploy, or save them in Admin → Integrations.",
      },
      { status: 503 },
    );
  }

  try {
    const customers = await fetchAllCrmCustomers();
    const uid = await authenticateOdoo(odoo);

    let created = 0;
    let skipped = 0;
    let updated = 0;
    for (const c of customers) {
      const emailList = Array.isArray(c.emails) ? c.emails : [];
      const phoneList = Array.isArray(c.phones) ? c.phones : [];
      const email = String(emailList[0] ?? "").trim();
      const phone = String(phoneList[0] ?? "").trim();
      const name = (c.contact_person || c.company || "CLIVORA contact").trim();
      const vals = {
        name,
        email: email || false,
        phone: phone || false,
        comment: `Synced from CLIVORA customer ${c.id}${c.owner_uid ? ` (owner ${c.owner_uid})` : ""}`,
      };

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
          await odooJsonRpc(odoo.url, "object", "execute_kw", [
            odoo.db,
            uid,
            odoo.apiKey,
            "res.partner",
            "write",
            [existing, vals],
          ]);
          updated += 1;
          skipped += 1; // kept for UI compatibility (deduped)
          continue;
        }
      }

      await odooJsonRpc(odoo.url, "object", "execute_kw", [
        odoo.db,
        uid,
        odoo.apiKey,
        "res.partner",
        "create",
        [vals],
      ]);
      created += 1;
    }

    return adminJson({
      ok: true,
      created,
      updated,
      skipped,
      total: customers.length,
      apps: ["Contacts"],
      note: "Platform-wide CRM → Odoo Contacts. Existing Contacts app only — no new modules.",
    });
  } catch (e) {
    return adminJson(
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
  let authOk: boolean | null = null;
  let authError: string | null = null;
  let partnerCount: number | null = null;
  if (odoo) {
    try {
      const uid = await authenticateOdoo(odoo);
      authOk = true;
      partnerCount = (await odooJsonRpc(odoo.url, "object", "execute_kw", [
        odoo.db,
        uid,
        odoo.apiKey,
        "res.partner",
        "search_count",
        [[]],
      ])) as number;
    } catch (e) {
      authOk = false;
      authError = e instanceof Error ? e.message : "Odoo auth failed";
    }
  }

  return adminJson({
    configured: !!odoo,
    ready: !!odoo && authOk === true,
    source,
    missing,
    envPresence: envPresence(),
    url: odoo?.url ?? null,
    db: odoo?.db ?? null,
    username: odoo?.username ?? null,
    authOk,
    authError,
    partnerCount,
    allowedApps: ["Contacts"],
    surface: "admin-only",
  });
}

/** Save / refresh Odoo secrets into admin_integration_secrets (admin session). */
export async function PUT(request: Request) {
  try {
    await requireAdmin({ requireAal2: false });
  } catch (e) {
    return adminErrorResponse(e);
  }

  const body = (await request.json().catch(() => ({}))) as {
    url?: string;
    db?: string;
    username?: string;
    apiKey?: string;
  };

  const url = (body.url ?? "https://clivora.odoo.com").trim().replace(/\/$/, "");
  const db = (body.db ?? "clivora").trim();
  const username = (body.username ?? "").trim();
  const apiKey = (body.apiKey ?? "").trim();

  if (!username || !apiKey) {
    return adminJson(
      { error: "username and apiKey are required" },
      { status: 400 },
    );
  }

  // Verify before saving
  try {
    await authenticateOdoo({ url, db, username, apiKey });
  } catch (e) {
    return adminJson(
      {
        error: e instanceof Error ? e.message : "Odoo authentication failed",
        saved: false,
      },
      { status: 401 },
    );
  }

  const supabase = await createClient();
  const pairs: Array<[string, string]> = [
    ["ODOO_URL", url],
    ["ODOO_DB", db],
    ["ODOO_USERNAME", username],
    ["ODOO_API_KEY", apiKey],
  ];
  for (const [key, value] of pairs) {
    const { error } = await supabase.rpc("admin_upsert_integration_secret", {
      p_key: key,
      p_value: value,
    });
    if (error) {
      return adminJson(
        { error: `Could not save ${key}: ${error.message}`, saved: false },
        { status: 500 },
      );
    }
  }

  return adminJson({
    ok: true,
    saved: true,
    url,
    db,
    username,
    note: "Secrets stored in admin_integration_secrets. Prefer also setting the same ODOO_* keys on Vercel for env-first loads.",
  });
}
