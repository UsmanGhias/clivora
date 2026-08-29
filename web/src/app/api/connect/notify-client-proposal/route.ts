import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

/**
 * POST /api/connect/notify-client-proposal
 * Automatically notifies hiring clients of newly submitted proposals on CLIVORA.
 * Dispatches Hostinger SMTP email with 1-click magic review token.
 */
export async function POST(request: Request) {
  try {
    const supabase = await createClient();
    const { data: { user }, error: authErr } = await supabase.auth.getUser();
    if (authErr || !user) {
      return NextResponse.json({ error: "unauthorized" }, { status: 401 });
    }

    const body = (await request.json().catch(() => ({}))) as {
      proposalId?: string;
      jobId?: string;
      toUserId?: string;
      companyEmail?: string;
      companyName?: string;
      amount?: number;
      timelineDays?: number;
      pitchMessage?: string;
      jobTitle?: string;
    };

    const proposalId = body.proposalId;
    if (!proposalId) {
      return NextResponse.json({ error: "missing_proposal_id" }, { status: 400 });
    }

    // Generate unique review token
    const reviewToken = crypto.randomUUID();
    const reviewUrl = `https://clivora.io/connect/review?token=${reviewToken}`;

    // Update proposal with review token and client metadata
    await supabase
      .from("connect_proposals")
      .update({
        review_token: reviewToken,
        job_id: body.jobId || null,
        client_email: body.companyEmail || null,
        client_name: body.companyName || null,
      })
      .eq("id", proposalId);

    // Get freelancer's display name
    const { data: freelancerProfile } = await supabase
      .from("profiles")
      .select("name, email")
      .eq("id", user.id)
      .single();

    const freelancerName = freelancerProfile?.name || "CLIVORA Freelancer";

    // If client email exists, dispatch transactional notification email via send-clivora-email edge function
    if (body.companyEmail && body.companyEmail.includes("@")) {
      const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
      const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

      if (supabaseUrl && serviceRoleKey) {
        await fetch(`${supabaseUrl}/functions/v1/send-clivora-email`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${serviceRoleKey}`,
          },
          body: JSON.stringify({
            to: body.companyEmail.trim().toLowerCase(),
            subject: `New $0-Fee Proposal for "${body.jobTitle || "Your Project"}" from ${freelancerName}`,
            purpose: "proposal_received",
            freelancerName,
            companyName: body.companyName || "Hiring Team",
            jobTitle: body.jobTitle || "Open Role",
            amount: body.amount || 0,
            timelineDays: body.timelineDays || 7,
            pitchMessage: body.pitchMessage || "",
            reviewUrl,
          }),
        }).catch((err) => console.error("[notify-client-proposal] Email error:", err));
      }
    }

    return NextResponse.json({
      ok: true,
      reviewToken,
      reviewUrl,
    });
  } catch (error) {
    console.error("[notify-client-proposal]", error);
    return NextResponse.json({ error: "notification_failed" }, { status: 500 });
  }
}
