import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

const SUPABASE_URL =
  process.env.SUPABASE_URL ?? "https://jtzjwgovqczlccyeujhq.supabase.co";
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

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

    const plan = profile?.subscription_plan ?? "free";
    if (plan !== "pro" && plan !== "pro_plus") {
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

    const embeddingsReady = await hasEmbeddings(user.id);

    if (!embeddingsReady) {
      return NextResponse.json({
        answer:
          "RAG (retrieval-augmented generation) is coming online for your workspace. " +
          "Once your CRM data is embedded you will be able to ask questions like " +
          '"What did I invoice client X last month?" or "Summarise project Y". ' +
          "Please check back after your first full sync.",
        source: "stub",
      });
    }

    // Placeholder for real embedding + LLM pipeline.
    return NextResponse.json({
      answer:
        `Your workspace has embeddings ready. A full RAG pipeline will answer: "${query}". ` +
        "Connect an LLM API key (OPENAI_API_KEY or ANTHROPIC_API_KEY) to enable semantic responses.",
      source: "stub_with_embeddings",
    });
  } catch (err) {
    return NextResponse.json(
      { error: err instanceof Error ? err.message : "AI request failed" },
      { status: 500 },
    );
  }
}
