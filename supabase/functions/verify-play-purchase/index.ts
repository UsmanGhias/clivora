// CLIVORA — verify Google Play subscription via Developer API
// Secrets: GOOGLE_PLAY_SERVICE_ACCOUNT_JSON (full service account JSON string)
// Package: org.codcrafters.clivora

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";

const PACKAGE_NAME = "org.codcrafters.clivora";

interface ServiceAccount {
  client_email: string;
  private_key: string;
  token_uri?: string;
}

/** JWT / OAuth requires Base64URL (no +, /, or = padding). */
function base64UrlEncode(bytes: Uint8Array | string): string {
  const raw =
    typeof bytes === "string"
      ? btoa(bytes)
      : btoa(String.fromCharCode(...bytes));
  return raw.replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/g, "");
}

async function getGoogleAccessToken(sa: ServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = base64UrlEncode(JSON.stringify({ alg: "RS256", typ: "JWT" }));
  const claim = base64UrlEncode(
    JSON.stringify({
      iss: sa.client_email,
      scope: "https://www.googleapis.com/auth/androidpublisher",
      aud: sa.token_uri ?? "https://oauth2.googleapis.com/token",
      exp: now + 3600,
      iat: now,
    }),
  );
  const unsigned = `${header}.${claim}`;
  const key = await crypto.subtle.importKey(
    "pkcs8",
    pemToArrayBuffer(sa.private_key),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const sig = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    new TextEncoder().encode(unsigned),
  );
  const jwt = `${unsigned}.${base64UrlEncode(new Uint8Array(sig))}`;
  const res = await fetch(sa.token_uri ?? "https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
  });
  const data = await res.json();
  if (!data.access_token) throw new Error("Google OAuth failed");
  return data.access_token as string;
}

function pemToArrayBuffer(pem: string): ArrayBuffer {
  const b64 = pem.replace(/-----[^-]+-----/g, "").replace(/\s/g, "");
  const raw = atob(b64);
  const buf = new Uint8Array(raw.length);
  for (let i = 0; i < raw.length; i++) buf[i] = raw.charCodeAt(i);
  return buf.buffer;
}

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405 });
  }

  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401 });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY") ?? "";
  const saJson = Deno.env.get("GOOGLE_PLAY_SERVICE_ACCOUNT_JSON") ?? "";

  if (!supabaseUrl || !serviceKey || !anonKey || !saJson) {
    return new Response(
      JSON.stringify({ error: "Play purchase verification is not configured" }),
      { status: 503, headers: { "Content-Type": "application/json" } },
    );
  }

  const userClient = createClient(supabaseUrl, anonKey, {
    global: { headers: { Authorization: authHeader } },
  });
  const { data: userData, error: userErr } = await userClient.auth.getUser();
  if (userErr || !userData.user) {
    return new Response(JSON.stringify({ error: "Invalid session" }), { status: 401 });
  }

  let body: { productId?: string; purchaseToken?: string; packageName?: string };
  try {
    body = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: "Invalid JSON" }), { status: 400 });
  }

  const productId = (body.productId ?? "").trim();
  const purchaseToken = (body.purchaseToken ?? "").trim();
  const packageName = (body.packageName ?? PACKAGE_NAME).trim();

  if (!productId || !purchaseToken) {
    return new Response(JSON.stringify({ error: "Missing productId or purchaseToken" }), { status: 400 });
  }

  if (packageName !== PACKAGE_NAME) {
    return new Response(JSON.stringify({ error: "Invalid package name" }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }

  let sa: ServiceAccount;
  try {
    sa = JSON.parse(saJson);
  } catch {
    return new Response(JSON.stringify({ error: "Invalid service account JSON" }), { status: 500 });
  }

  const accessToken = await getGoogleAccessToken(sa);
  const url =
    `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${packageName}/purchases/subscriptions/${productId}/tokens/${purchaseToken}`;
  const playRes = await fetch(url, {
    headers: { Authorization: `Bearer ${accessToken}` },
  });
  const playData = await playRes.json();

  if (!playRes.ok) {
    return new Response(JSON.stringify({ error: "Play API verification failed", detail: playData }), {
      status: 400,
    });
  }

  const expiryMs = Number(playData.expiryTimeMillis ?? 0);
  const active = expiryMs > Date.now() && playData.paymentState !== 0;
  const expiresAt = expiryMs > 0 ? new Date(expiryMs).toISOString() : null;
  const status = active ? "active" : "expired";
  const isPlus =
    productId.includes("pro_plus") || productId.includes("plus");
  const plan = active ? (isPlus ? "pro_plus" : "pro") : "free";

  const admin = createClient(supabaseUrl, serviceKey);
  const { error: subscriptionError } = await admin.from("subscriptions").upsert(
    {
      user_id: userData.user.id,
      product_id: productId,
      purchase_token: purchaseToken,
      package_name: packageName,
      expires_at: expiresAt,
      verified_at: new Date().toISOString(),
      status,
      updated_at: new Date().toISOString(),
    },
    { onConflict: "purchase_token" },
  );
  if (subscriptionError) {
    return new Response(JSON.stringify({ error: "Could not persist verified purchase" }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }

  const { error: profileError } = await admin.from("profiles").update({ subscription_plan: plan }).eq(
    "id",
    userData.user.id,
  );
  if (profileError) {
    return new Response(JSON.stringify({ error: "Could not update verified plan" }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }

  return new Response(
    JSON.stringify({ active, expiresAt, productId, verified: true, status, plan }),
    { status: 200, headers: { "Content-Type": "application/json" } },
  );
});
