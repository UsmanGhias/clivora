import { NextRequest, NextResponse } from "next/server";
import { assertAdminPanelAuth } from "@/lib/admin-auth";

const SUPABASE_URL =
  process.env.SUPABASE_URL ?? "https://jtzjwgovqczlccyeujhq.supabase.co";

function serviceKey(): string | null {
  return process.env.SUPABASE_SERVICE_ROLE_KEY ?? null;
}

function restHeaders(key: string) {
  return {
    apikey: key,
    Authorization: `Bearer ${key}`,
    "Content-Type": "application/json",
  };
}

export async function POST(req: NextRequest) {
  try {
    const body = (await req.json()) as {
      action: "admin_release" | "list_milestones";
      adminEmail?: string;
      adminToken?: string;
      milestoneId?: string;
      requestId?: string;
      amount?: number;
      currency?: string;
      notes?: string;
    };

    const { action, adminEmail, adminToken } = body;
    await assertAdminPanelAuth(adminEmail, adminToken, { preferToken: true });

    const svcKey = serviceKey();
    if (!svcKey) {
      return NextResponse.json(
        { error: "SUPABASE_SERVICE_ROLE_KEY not configured" },
        { status: 503 },
      );
    }
    const headers = restHeaders(svcKey);

    if (action === "list_milestones") {
      const res = await fetch(
        `${SUPABASE_URL}/rest/v1/connect_milestones?select=*&order=created_at.desc&limit=100`,
        { headers, cache: "no-store" },
      );
      const milestones = res.ok ? await res.json() : [];
      return NextResponse.json({ milestones });
    }

    if (action === "admin_release") {
      const { milestoneId, amount, currency = "USD", notes } = body;
      if (!milestoneId) {
        return NextResponse.json({ error: "milestoneId required" }, { status: 400 });
      }

      // Update milestone status to released
      const patchRes = await fetch(
        `${SUPABASE_URL}/rest/v1/connect_milestones?id=eq.${encodeURIComponent(milestoneId)}`,
        {
          method: "PATCH",
          headers: { ...headers, Prefer: "return=minimal" },
          body: JSON.stringify({ status: "released" }),
        },
      );
      if (!patchRes.ok) {
        const err = await patchRes.text();
        throw new Error(err || "Milestone update failed");
      }

      // Insert escrow ledger entry
      if (amount != null) {
        const ledgerRes = await fetch(`${SUPABASE_URL}/rest/v1/connect_escrow_ledger`, {
          method: "POST",
          headers: { ...headers, Prefer: "return=minimal" },
          body: JSON.stringify({
            milestone_id: milestoneId,
            amount,
            currency,
            type: "release",
            notes: notes ?? "Admin release",
            created_at: new Date().toISOString(),
          }),
        });
        if (!ledgerRes.ok) {
          // Non-fatal if ledger table doesn't exist yet
          console.warn("Escrow ledger insert failed:", await ledgerRes.text());
        }
      }

      return NextResponse.json({ ok: true, milestoneId, status: "released" });
    }

    return NextResponse.json({ error: "Unknown action" }, { status: 400 });
  } catch (err) {
    return NextResponse.json(
      { error: err instanceof Error ? err.message : "Request failed" },
      { status: 400 },
    );
  }
}
