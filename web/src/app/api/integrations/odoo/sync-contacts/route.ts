import { adminErrorResponse, adminJson, requireAdmin } from "@/lib/admin-auth";
import {
  authenticateOdoo,
  checkOdooHealth,
  envPresence,
  isOdooSyncEnabled,
  loadOdooCfg,
  runBidirectionalSync,
  type OdooTarget,
  type OdooSyncDirection,
} from "@/lib/odoo-sync";
import { createClient } from "@/lib/supabase/server";

/**
 * Admin-only Odoo Contacts status + explicitly forced legacy write sync.
 * POST body: { direction?: "push"|"pull"|"both", action?: "test", includeTracking?: boolean, force?: boolean }
 */
export async function POST(request: Request) {
  try {
    await requireAdmin({ requireAal2: false });
  } catch (e) {
    return adminErrorResponse(e);
  }

  const body = (await request.json().catch(() => ({}))) as {
    action?: string;
    direction?: OdooSyncDirection;
    includeTracking?: boolean;
    force?: boolean;
    target?: OdooTarget;
  };

  if (body.action === "test") {
    const [main, social] = await Promise.all([checkOdooHealth("main"), checkOdooHealth("social")]);
    return adminJson({
      ok: main.ready || social.ready,
      syncEnabled: isOdooSyncEnabled(),
      envPresence: envPresence(),
      targets: { main, social },
    });
  }

  if (!isOdooSyncEnabled() && !body.force) {
    return adminJson(
      {
        error: "Odoo write sync is disabled by default.",
        syncEnabled: false,
        hint: "Phase 1-2 exposes read-only health checks. Set ODOO_SYNC_ENABLED=true or use the explicit admin force action to run the legacy write sync.",
      },
      { status: 403 },
    );
  }

  let admin;
  try {
    admin = await requireAdmin({ requireAal2: true });
  } catch (e) {
    return adminErrorResponse(e);
  }

  const target = body.target === "legacy" ? "legacy" : "main";
  if (body.target === "social") {
    return adminJson(
      { error: "The Social Odoo database is read-only in Phase 1-2." },
      { status: 400 },
    );
  }

  const { cfg: odoo, missing } = await loadOdooCfg(target);
  if (!odoo) {
    return adminJson(
      {
        error: "Odoo is not configured",
        missing,
        hint: "Set ODOO_MAIN_* (or legacy ODOO_* for main fallback) on Vercel, or save credentials in Admin -> Integrations.",
      },
      { status: 503 },
    );
  }

  const direction: OdooSyncDirection =
    body.direction === "push" || body.direction === "pull" || body.direction === "both"
      ? body.direction
      : "both";

  try {
    const uid = await authenticateOdoo(odoo);
    const result = await runBidirectionalSync({
      cfg: odoo,
      uid,
      adminUserId: admin.id,
      direction,
      includeTracking: body.includeTracking !== false,
    });
    return adminJson({
      ...result,
      target: odoo.target ?? target,
      warnings: [
        ...(!isOdooSyncEnabled()
          ? ["ODOO_SYNC_ENABLED is false; sync was run only because an admin explicitly forced it."]
          : []),
        ...result.warnings,
      ],
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

  const [main, social] = await Promise.all([checkOdooHealth("main"), checkOdooHealth("social")]);

  return adminJson({
    configured: main.configured || social.configured,
    ready: main.ready || social.ready,
    syncEnabled: isOdooSyncEnabled(),
    envPresence: envPresence(),
    targets: { main, social },
    allowedApps: ["Contacts"],
    modes: ["push", "pull", "both"],
    surface: "admin-only",
    note: "Phase 1-2 is read-only by default. Health checks authenticate and count active Odoo partners. Legacy write sync requires explicit admin force.",
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
    target?: OdooTarget;
  };

  const target: OdooTarget =
    body.target === "social" || body.target === "legacy" ? body.target : "main";
  const url = (body.url ?? "").trim().replace(/\/$/, "");
  const db = (body.db ?? "").trim();
  const username = (body.username ?? "").trim();
  const apiKey = (body.apiKey ?? "").trim();

  if (!url || !db || !username || !apiKey) {
    return adminJson({ error: "url, db, username, and apiKey are required" }, { status: 400 });
  }

  try {
    await authenticateOdoo({ url, db, username, apiKey, target });
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
  const prefix =
    target === "social" ? "ODOO_SOCIAL" : target === "legacy" ? "ODOO" : "ODOO_MAIN";
  const pairs: Array<[string, string]> = [
    [`${prefix}_URL`, url],
    [`${prefix}_DB`, db],
    [`${prefix}_USERNAME`, username],
    [`${prefix}_API_KEY`, apiKey],
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
    target,
    url,
    db,
    username,
    note: `Secrets stored in admin_integration_secrets as ${prefix}_*. Prefer Vercel env for production env-first loads.`,
  });
}
