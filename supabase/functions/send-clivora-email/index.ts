// CLIVORA transactional email — Resend API with branded HTML templates.
// Secrets: RESEND_API_KEY, RESEND_FROM (e.g. "CLIVORA <onboarding@resend.dev>")

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";
import { renderTemplate } from "./email_brand.ts";

const ALLOWED = new Set([
  "password_reset",
  "admin_notice",
  "client_invite",
  "team_invite",
  "task_completed",
  "welcome",
]);
const MONTHLY_LIMIT = 3000;

type EmailBody = {
  to?: string;
  subject?: string;
  html?: string;
  purpose?: string;
  freelancerName?: string;
  clientName?: string;
  ownerName?: string;
  inviteeName?: string;
  projectName?: string;
  role?: string;
  taskTitle?: string;
  userName?: string;
  accountType?: string;
  adminMessage?: string;
  wrapBrand?: boolean;
};

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405 });
  }

  const resendKey = Deno.env.get("RESEND_API_KEY");
  const from = Deno.env.get("RESEND_FROM") ?? "CLIVORA <onboarding@resend.dev>";
  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

  if (!resendKey) {
    return new Response(JSON.stringify({ error: "Email not configured (RESEND_API_KEY)" }), { status: 503 });
  }

  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401 });
  }

  const userClient = createClient(supabaseUrl, Deno.env.get("SUPABASE_ANON_KEY") ?? "", {
    global: { headers: { Authorization: authHeader } },
  });
  const { data: userData, error: userErr } = await userClient.auth.getUser();
  if (userErr || !userData.user) {
    return new Response(JSON.stringify({ error: "Invalid session" }), { status: 401 });
  }

  let body: EmailBody;
  try {
    body = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: "Invalid JSON" }), { status: 400 });
  }

  const to = (body.to ?? "").trim().toLowerCase();
  const subject = (body.subject ?? "").trim();
  const purpose = (body.purpose ?? "").trim();

  if (!to.includes("@") || !subject) {
    return new Response(JSON.stringify({ error: "Missing to or subject" }), { status: 400 });
  }
  if (!ALLOWED.has(purpose)) {
    return new Response(JSON.stringify({ error: "Purpose not allowed" }), { status: 403 });
  }

  const html = renderTemplate(purpose, body);
  if (!html) {
    return new Response(JSON.stringify({ error: "Missing template fields or html" }), { status: 400 });
  }

  const adminClient = serviceKey ? createClient(supabaseUrl, serviceKey) : null;
  if (adminClient) {
    const monthStart = new Date();
    monthStart.setUTCDate(1);
    monthStart.setUTCHours(0, 0, 0, 0);
    const { count } = await adminClient
      .from("email_send_log")
      .select("id", { count: "exact", head: true })
      .gte("sent_at", monthStart.toISOString());
    if ((count ?? 0) >= MONTHLY_LIMIT) {
      return new Response(JSON.stringify({ error: "Monthly email limit reached" }), { status: 429 });
    }
  }

  try {
    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${resendKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ from, to, subject, html }),
    });
    if (!res.ok) {
      const errText = await res.text();
      return new Response(JSON.stringify({ error: errText }), { status: 500 });
    }

    if (adminClient) {
      await adminClient.from("email_send_log").insert({
        purpose,
        recipient: to,
        sender_uid: userData.user.id,
      });
    }

    return new Response(JSON.stringify({ ok: true }), { status: 200 });
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), { status: 500 });
  }
});
