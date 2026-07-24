import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { isFeatureEnabled } from "@/lib/feature-flags";
import { randomBytes } from "crypto";

function randomToken(length = 32): string {
  return randomBytes(Math.ceil(length * 0.75))
    .toString("base64url")
    .slice(0, length);
}

export async function POST(req: NextRequest) {
  try {
    const vaultOn =
      (await isFeatureEnabled("vault_cloud")) || (await isFeatureEnabled("phase5_vault_cloud"));
    if (!vaultOn) {
      return NextResponse.json({ error: "Vault cloud sharing is not enabled" }, { status: 503 });
    }

    const supabase = await createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      return NextResponse.json({ error: "Sign in required" }, { status: 401 });
    }

    const body = (await req.json()) as {
      file_path?: string;
      file_id?: string;
      expires_in_hours?: number;
    };

    const { file_path, file_id, expires_in_hours = 72 } = body;
    if (!file_path && !file_id) {
      return NextResponse.json({ error: "file_path or file_id required" }, { status: 400 });
    }

    const token = randomToken(40);
    const expiresAt = new Date(Date.now() + expires_in_hours * 3600 * 1000).toISOString();

    const { data, error } = await supabase
      .from("vault_share_links")
      .insert({
        owner_uid: user.id,
        file_path: file_path ?? null,
        file_id: file_id ?? null,
        storage_path: file_path ?? file_id ?? "",
        file_name: (file_path || file_id || "file").split("/").pop() || "file",
        token,
        expires_at: expiresAt,
      })
      .select("id, token, expires_at")
      .single();

    if (error) {
      const missing =
        /schema cache|does not exist|Could not find the table/i.test(error.message || "");
      return NextResponse.json(
        {
          error: missing
            ? "Vault share links are not enabled on this project yet"
            : error.message,
        },
        { status: missing ? 503 : 400 },
      );
    }

    const origin = req.headers.get("origin") ?? "https://clivora.codcrafters.org";
    const shareUrl = `${origin}/vault/s/${token}`;

    return NextResponse.json({
      id: data.id,
      token: data.token,
      expires_at: data.expires_at,
      url: shareUrl,
    });
  } catch (err) {
    return NextResponse.json(
      { error: err instanceof Error ? err.message : "Share failed" },
      { status: 500 },
    );
  }
}
