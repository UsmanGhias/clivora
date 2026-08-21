import { NextRequest, NextResponse } from "next/server";
import { redeemPromoCode } from "@/lib/promo-codes";

export const runtime = "nodejs";

// Spend one use of a promo code, after a payment request has been recorded.
//
// This used to happen in the browser as a select-then-update on promo_codes.
// That never worked (the table has no client UPDATE policy, and the error was
// swallowed), and would have been wrong anyway: read-then-write is not atomic.
// The increment now runs here and the cap is enforced inside the SQL statement.

export async function POST(req: NextRequest) {
  try {
    const body = (await req.json().catch(() => null)) as { code?: string } | null;
    const code = String(body?.code ?? "").trim();
    if (!code) return NextResponse.json({ error: "code_required" }, { status: 400 });

    const redeemed = await redeemPromoCode(code);
    return NextResponse.json({ redeemed });
  } catch (err) {
    console.error("[promo/redeem]", err);
    return NextResponse.json({ error: "redeem_failed" }, { status: 500 });
  }
}
