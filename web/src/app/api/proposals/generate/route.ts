import { NextRequest, NextResponse } from "next/server";
import { callGemini, sanitizeDashes } from "@/lib/gemini";
import { createClient } from "@/lib/supabase/server";

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const {
      clientName,
      email,
      company,
      projectType,
      budget,
      timeline,
      scopeDescription,
    } = body;

    if (!clientName || !email || !scopeDescription) {
      return NextResponse.json(
        { error: "Client name, email, and scope description are required" },
        { status: 400 }
      );
    }

    const systemPrompt = `You are the Principal Solutions Architect at CODCrafters and Clivora, founded by Usman Ghias.
Your task is to generate a concise, production-grade Statement of Work (SOW) and Technical Architecture Brief for an incoming enterprise client project.

Strict Rules:
- Never use em dashes or en dashes anywhere. Use standard hyphens -, colons, commas, or parentheses.
- Keep the breakdown structured into:
  1. Executive Scope & Objective
  2. Recommended Technical Architecture & Stack (Next.js, TypeScript, Flutter 3.x, Odoo 17/18 ERP, Supabase/PostgreSQL, Gemini AI where applicable)
  3. Phased Milestones & Key Deliverables
  4. Estimated Timeline & Budget Alignment
  5. Next Steps for 1-Click Review & Kickoff`;

    const userPrompt = `Client Details:
Name: ${clientName}
Email: ${email}
Company: ${company || "Not specified"}
Project Type: ${projectType || "Full Stack & ERP Solution"}
Target Budget: ${budget || "Competitive Scope"}
Target Timeline: ${timeline || "Standard Agile Sprint (2 to 6 weeks)"}

Project Scope Brief:
${scopeDescription}

Please generate a professional, high-impact Statement of Work (SOW) ready for client review.`;

    const generatedSow = await callGemini({
      prompt: userPrompt,
      systemInstruction: systemPrompt,
      maxOutputTokens: 750,
      temperature: 0.5,
    });

    const finalSow = generatedSow || `### Statement of Work: ${projectType || "Custom Software Architecture"}
**Client:** ${clientName} (${company || "Direct Engagement"})
**Architect:** Usman Ghias · CODCrafters & Clivora

#### 1. Scope Overview
Delivery of a scalable ${projectType || "enterprise system"} addressing core workflow automation and business objectives.

#### 2. Technical Stack
- Frontend / Mobile: Next.js, React, TailwindCSS, Flutter 3.x
- Backend & ERP: Odoo 17/18, Python, PostgreSQL, Supabase
- Infrastructure: Docker, Hostinger Cloud, CI/CD Pipeline

#### 3. Milestones & Delivery
- Phase 1: Techno-functional discovery, database schema & wireframes
- Phase 2: Core modules, API integrations, and milestone demo on staging
- Phase 3: QA verification, production deployment, and client handover`;

    // Optionally record lead in Supabase if database is connected
    try {
      const supabase = await createClient();
      await supabase.from("contacts").insert({
        name: clientName,
        email,
        company: company || null,
        type: "client",
        status: "lead",
        notes: `Inbound Portfolio Project (${projectType}):\n${scopeDescription}`,
      });
    } catch {
      // Gracefully continue even if database table is not active
    }

    return NextResponse.json({
      success: true,
      sow: sanitizeDashes(finalSow),
      client: {
        name: clientName,
        email,
        company,
        projectType,
      },
    });
  } catch (err: unknown) {
    const errorMsg = err instanceof Error ? err.message : "Internal Server Error";
    return NextResponse.json(
      { error: "Failed to generate statement of work", details: errorMsg },
      { status: 500 }
    );
  }
}
