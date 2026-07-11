import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

const SUPABASE_URL =
  process.env.SUPABASE_URL ?? "https://jtzjwgovqczlccyeujhq.supabase.co";
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;

async function hasEmbeddings(ownerUid: string): Promise<boolean> {
  if (!SUPABASE_SERVICE_ROLE_KEY) return false;
  try {
    const res = await fetch(
      `${SUPABASE_URL}/rest/v1/crm_embeddings?owner_uid=eq.${encodeURIComponent(ownerUid)}&select=id&limit=1`,
      {
        headers: {
          apikey: SUPABASE_SERVICE_ROLE_KEY,
          Authorization: `Bearer ${SUPABASE_SERVICE_ROLE_KEY}`,
        },
        cache: "no-store",
      },
    );
    if (!res.ok) return false;
    const rows = (await res.json()) as unknown[];
    return rows.length > 0;
  } catch {
    return false;
  }
}

async function callOpenAi(query: string, context: string): Promise<string | null> {
  if (!OPENAI_API_KEY) return null;
  const res = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${OPENAI_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: process.env.OPENAI_MODEL || "gpt-4o-mini",
      temperature: 0.3,
      messages: [
        {
          role: "system",
          content:
            "You are CLIVORA Ask AI for freelancers. Answer briefly from the user's CRM context. If context is thin, say what is missing. Never invent invoice amounts.",
        },
        {
          role: "user",
          content: context
            ? `Context:\n${context}\n\nQuestion: ${query}`
            : `Question: ${query}\n(No CRM embeddings yet. Give a short helpful tip.)`,
        },
      ],
    }),
  });
  if (!res.ok) return null;
  const json = (await res.json()) as {
    choices?: Array<{ message?: { content?: string } }>;
  };
  return json.choices?.[0]?.message?.content?.trim() || null;
}

async function callAnthropic(query: string, context: string): Promise<string | null> {
  if (!ANTHROPIC_API_KEY) return null;
  const res = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: process.env.ANTHROPIC_MODEL || "claude-3-5-haiku-latest",
      max_tokens: 512,
      messages: [
        {
          role: "user",
          content: context
            ? `You are CLIVORA Ask AI. Context:\n${context}\n\nQuestion: ${query}`
            : `You are CLIVORA Ask AI. Question: ${query}`,
        },
      ],
    }),
  });
  if (!res.ok) return null;
  const json = (await res.json()) as {
    content?: Array<{ type?: string; text?: string }>;
  };
  return json.content?.find((c) => c.type === "text")?.text?.trim() || null;
}

export async function POST(req: NextRequest) {
  try {
    const supabase = await createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      return NextResponse.json({ error: "Sign in required" }, { status: 401 });
    }

    const { data: profile } = await supabase
      .from("profiles")
      .select("subscription_plan")
      .eq("id", user.id)
      .maybeSingle();

    const plan = (profile?.subscription_plan ?? "free").toLowerCase();
    if (plan !== "pro" && plan !== "pro_plus" && plan !== "plus" && plan !== "proplus") {
      return NextResponse.json(
        { error: "AI assistant is a Pro feature. Upgrade to access smart search and summaries." },
        { status: 403 },
      );
    }

    const body = (await req.json()) as { query?: string };
    const query = body.query?.trim();
    if (!query) {
      return NextResponse.json({ error: "query is required" }, { status: 400 });
    }

    const llmConfigured = Boolean(OPENAI_API_KEY || ANTHROPIC_API_KEY);
    if (!llmConfigured) {
      return NextResponse.json({
        mode: "app_required",
        answer:
          "Cloud Ask AI needs an LLM key on the server. Use the CLIVORA Android app for offline AI insights on your CRM data, or ask your admin to set OPENAI_API_KEY.",
        source: "app_required",
      });
    }

    let context = "";
    if (SUPABASE_SERVICE_ROLE_KEY && (await hasEmbeddings(user.id))) {
      try {
        const res = await fetch(
          `${SUPABASE_URL}/rest/v1/crm_embeddings?owner_uid=eq.${encodeURIComponent(user.id)}&select=content,source_type&limit=8`,
          {
            headers: {
              apikey: SUPABASE_SERVICE_ROLE_KEY,
              Authorization: `Bearer ${SUPABASE_SERVICE_ROLE_KEY}`,
            },
            cache: "no-store",
          },
        );
        if (res.ok) {
          const rows = (await res.json()) as Array<{ content?: string; source_type?: string }>;
          context = rows
            .map((r) => `[${r.source_type ?? "crm"}] ${r.content ?? ""}`)
            .join("\n")
            .slice(0, 4000);
        }
      } catch {
        context = "";
      }
    }

    const answer =
      (await callOpenAi(query, context)) ||
      (await callAnthropic(query, context));

    if (!answer) {
      return NextResponse.json({
        mode: "app_required",
        answer:
          "The AI provider did not respond. Download the Android app for offline CRM insights, or try again later.",
        source: "provider_error",
      });
    }

    return NextResponse.json({
      answer,
      source: context ? "llm_with_context" : "llm",
    });
  } catch (err) {
    return NextResponse.json(
      { error: err instanceof Error ? err.message : "AI request failed" },
      { status: 500 },
    );
  }
}
