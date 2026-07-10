import "jsr:@supabase/functions-js/edge-runtime.d.ts";

/**
 * Sends FCM data+notification pushes to a user's registered device_tokens.
 * Requires secret FCM_SERVER_KEY (legacy) or leave unset to no-op gracefully.
 * Body: { user_uid, title, body, kind?, entity_id? }
 */
Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "POST only" }), { status: 405 });
  }

  const fcmKey = Deno.env.get("FCM_SERVER_KEY") ?? "";
  const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

  let payload: {
    user_uid?: string;
    title?: string;
    body?: string;
    kind?: string;
    entity_id?: string;
  };
  try {
    payload = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: "invalid json" }), { status: 400 });
  }

  const userUid = payload.user_uid?.trim();
  const title = payload.title?.trim() || "CLIVORA";
  const body = payload.body?.trim() || "";
  if (!userUid) {
    return new Response(JSON.stringify({ error: "user_uid required" }), { status: 400 });
  }

  const tokensRes = await fetch(
    `${supabaseUrl}/rest/v1/device_tokens?user_uid=eq.${userUid}&select=token`,
    {
      headers: {
        apikey: serviceKey,
        Authorization: `Bearer ${serviceKey}`,
      },
    },
  );
  const tokens = (await tokensRes.json()) as Array<{ token: string }>;
  if (!Array.isArray(tokens) || tokens.length === 0) {
    return new Response(JSON.stringify({ sent: 0, reason: "no_tokens" }), {
      headers: { "Content-Type": "application/json" },
    });
  }

  if (!fcmKey) {
    return new Response(
      JSON.stringify({ sent: 0, reason: "FCM_SERVER_KEY not configured", tokens: tokens.length }),
      { headers: { "Content-Type": "application/json" } },
    );
  }

  let sent = 0;
  const errors: string[] = [];
  for (const row of tokens) {
    const res = await fetch("https://fcm.googleapis.com/fcm/send", {
      method: "POST",
      headers: {
        Authorization: `key=${fcmKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        to: row.token,
        notification: { title, body },
        data: {
          kind: payload.kind ?? "info",
          entity_id: payload.entity_id ?? "",
          title,
          body,
        },
        priority: "high",
      }),
    });
    if (res.ok) sent++;
    else errors.push(await res.text());
  }

  return new Response(JSON.stringify({ sent, errors }), {
    headers: { "Content-Type": "application/json" },
  });
});
