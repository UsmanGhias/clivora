// CLIVORA transactional email — Hostinger SMTP (clivora.io mailbox).
// Secrets: SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS, SMTP_FROM
// Resend is removed — do not set RESEND_*.

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";
import { renderTemplate } from "./email_brand.ts";
import {
  sendSmtpEmail,
  smtpConfigured,
  smtpFromAddress,
} from "./smtp_send.ts";

const ALLOWED = new Set([
  "password_reset",
  "admin_notice",
  "client_invite",
  "team_invite",
  "task_completed",
  "welcome",
  "job_claim",
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
  companyName?: string;
  jobTitle?: string;
  claimUrl?: string;
  wrapBrand?: boolean;
};

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405 });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

  if (!smtpConfigured()) {
    return new Response(
      JSON.stringify({
        error:
          "Email not configured. Set SMTP_HOST, SMTP_USER, SMTP_PASS (Hostinger mailbox) on Edge Function secrets.",
      }),
      { status: 503 },
    );
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

  if (purpose === "admin_notice") {
    if (!serviceKey) {
      return new Response(JSON.stringify({ error: "Admin email not configured" }), { status: 503 });
    }
    const adminCheck = createClient(supabaseUrl, serviceKey);
    const { data: profile } = await adminCheck
      .from("profiles")
      .select("role, account_type")
      .eq("id", userData.user.id)
      .maybeSingle();
    const isAdmin = profile?.role === "admin" || profile?.account_type === "admin";
    if (!isAdmin) {
      return new Response(JSON.stringify({ error: "Admin only" }), { status: 403 });
    }
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
    await sendSmtpEmail({ to, subject, html });
    if (adminClient) {
      await adminClient.from("email_send_log").insert({
        purpose,
        recipient: to,
        sender_uid: userData.user.id,
      });
    }
    return new Response(
      JSON.stringify({ ok: true, from: smtpFromAddress() }),
      { status: 200 },
    );
  } catch (e) {
    console.error("[send-clivora-email] SMTP failure:", e);
    return new Response(
      JSON.stringify({ error: "email_send_failed", message: "Failed to dispatch email notification" }),
      { status: 500 },
    );
  }
});
