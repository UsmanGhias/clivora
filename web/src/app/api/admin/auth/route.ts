import { NextRequest, NextResponse } from "next/server";
import {
  assertAdminPanelAuth,
  getStoredPanelPasswordHash,
  hashPanelPassword,
  isAdminEmail,
  issueAdminSessionToken,
  passwordConfigFingerprint,
  setStoredPanelPasswordHash,
  verifyPanelPassword,
} from "@/lib/admin-auth";

export const runtime = "nodejs";

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const action = String(body.action ?? "login");
    const email = String(body.adminEmail ?? body.email ?? "")
      .trim()
      .toLowerCase();

    if (action === "login") {
      if (!isAdminEmail(email)) {
        return NextResponse.json({ error: "This email is not authorized." }, { status: 403 });
      }
      const password = String(body.adminPassword ?? body.password ?? "");
      const ok = await verifyPanelPassword(password);
      if (!ok) {
        return NextResponse.json({ error: "Incorrect password." }, { status: 401 });
      }
      const stored = await getStoredPanelPasswordHash();
      // First successful login with bootstrap password: persist a hash so password is backend-owned.
      if (!stored) {
        await setStoredPanelPasswordHash(hashPanelPassword(password));
      }
      const token = issueAdminSessionToken(email);
      return NextResponse.json({
        ok: true,
        token,
        email,
        passwordSource: stored ? "app_settings" : "bootstrap_persisted",
        fingerprint: passwordConfigFingerprint(stored ?? (await getStoredPanelPasswordHash())),
      });
    }

    if (action === "change_password") {
      await assertAdminPanelAuth(email, String(body.adminToken ?? body.adminPassword ?? ""));
      const nextPassword = String(body.newPassword ?? "");
      if (nextPassword.length < 10) {
        return NextResponse.json(
          { error: "New password must be at least 10 characters." },
          { status: 400 },
        );
      }
      await setStoredPanelPasswordHash(hashPanelPassword(nextPassword));
      const token = issueAdminSessionToken(email);
      return NextResponse.json({
        ok: true,
        token,
        message: "Admin panel password updated in backend (app_settings).",
      });
    }

    return NextResponse.json({ error: "Unknown action" }, { status: 400 });
  } catch (e) {
    return NextResponse.json(
      { error: e instanceof Error ? e.message : "Auth failed" },
      { status: 401 },
    );
  }
}
