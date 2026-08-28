// CLIVORA autonomous job crawler — fetches from free APIs and inserts into connect_jobs.
// Sources: Remotive API, Arbeitnow API, Hacker News "Who Is Hiring".
// Trigger: pg_cron every 3 hours, or manually via clivora_trigger_job_crawler MCP tool.
// Secrets: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, CRON_SECRET

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";

// ── Types ────────────────────────────────────────────────────────────────────

interface NormalizedJob {
  title: string;
  company_name: string;
  company_domain: string | null;
  company_email: string | null;
  description: string;
  category: string;
  tags: string[];
  salary_min: number | null;
  salary_max: number | null;
  currency: string;
  location: string;
  job_type: string;
  source: string;
  source_id: string;
  source_url: string;
  seo_slug: string;
}

// ── Helpers ──────────────────────────────────────────────────────────────────

function slugify(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^a-z0-9\s-]/g, "")
    .replace(/[\s_]+/g, "-")
    .replace(/-+/g, "-")
    .replace(/^-|-$/g, "")
    .slice(0, 120);
}

function extractDomain(url: string | null | undefined): string | null {
  if (!url) return null;
  try {
    const hostname = new URL(url.startsWith("http") ? url : `https://${url}`).hostname;
    return hostname.replace(/^www\./, "");
  } catch {
    return null;
  }
}

function mapCategory(rawCategory: string): string {
  const lower = (rawCategory || "").toLowerCase();
  const categoryMap: Record<string, string> = {
    software: "software-development",
    "software-dev": "software-development",
    devops: "devops-sysadmin",
    "devops / sysadmin": "devops-sysadmin",
    "sysadmin": "devops-sysadmin",
    design: "design",
    "product": "product",
    marketing: "marketing",
    "customer support": "customer-support",
    "customer-support": "customer-support",
    writing: "writing",
    "data": "data-science",
    "data science": "data-science",
    "qa": "quality-assurance",
    "quality assurance": "quality-assurance",
    hr: "human-resources",
    "human resources": "human-resources",
    finance: "finance-legal",
    legal: "finance-legal",
    sales: "sales",
    management: "management",
    "project management": "management",
    teaching: "education",
    education: "education",
    "all others": "general",
  };
  return categoryMap[lower] || "general";
}

function secureEqual(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  let result = 0;
  for (let i = 0; i < a.length; i++) {
    result |= a.charCodeAt(i) ^ b.charCodeAt(i);
  }
  return result === 0;
}

// ── Fetchers ─────────────────────────────────────────────────────────────────

async function fetchRemotiveJobs(): Promise<NormalizedJob[]> {
  try {
    const res = await fetch("https://remotive.com/api/remote-jobs?limit=100", {
      headers: { "User-Agent": "CLIVORA-JobCrawler/1.0" },
    });
    if (!res.ok) {
      console.error(`[remotive] HTTP ${res.status}`);
      return [];
    }
    const data = await res.json();
    const jobs = data.jobs || [];

    return jobs.map((j: any) => ({
      title: (j.title || "").trim(),
      company_name: (j.company_name || "").trim(),
      company_domain: extractDomain(j.url),
      company_email: null,
      description: (j.description || "").slice(0, 10000),
      category: mapCategory(j.category || ""),
      tags: (j.tags || []).map((t: string) => t.toLowerCase().trim()).filter(Boolean),
      salary_min: null,
      salary_max: null,
      currency: "USD",
      location: (j.candidate_required_location || "Worldwide").trim(),
      job_type: j.job_type === "contract" ? "contract"
        : j.job_type === "part_time" ? "part_time"
        : j.job_type === "freelance" ? "freelance"
        : "full_time",
      source: "remotive",
      source_id: String(j.id),
      source_url: j.url || `https://remotive.com/remote-jobs/${j.id}`,
      seo_slug: slugify(`${j.company_name}-${j.title}-${j.id}`),
    }));
  } catch (e) {
    console.error("[remotive] Fetch error:", e);
    return [];
  }
}

async function fetchArbeitnowJobs(): Promise<NormalizedJob[]> {
  try {
    const res = await fetch("https://www.arbeitnow.com/api/job-board-api", {
      headers: { "User-Agent": "CLIVORA-JobCrawler/1.0" },
    });
    if (!res.ok) {
      console.error(`[arbeitnow] HTTP ${res.status}`);
      return [];
    }
    const data = await res.json();
    const jobs = data.data || [];

    return jobs.map((j: any) => ({
      title: (j.title || "").trim(),
      company_name: (j.company_name || "").trim(),
      company_domain: extractDomain(j.url),
      company_email: null,
      description: (j.description || "").slice(0, 10000),
      category: mapCategory(j.tags?.[0] || "general"),
      tags: (j.tags || []).map((t: string) => t.toLowerCase().trim()).filter(Boolean),
      salary_min: null,
      salary_max: null,
      currency: "EUR",
      location: (j.location || "Remote").trim(),
      job_type: j.remote ? "full_time" : "full_time",
      source: "arbeitnow",
      source_id: String(j.slug || j.title).slice(0, 200),
      source_url: j.url || `https://www.arbeitnow.com/view/${j.slug}`,
      seo_slug: slugify(`${j.company_name}-${j.title}-an-${j.slug || Date.now()}`),
    }));
  } catch (e) {
    console.error("[arbeitnow] Fetch error:", e);
    return [];
  }
}

async function fetchHackerNewsJobs(): Promise<NormalizedJob[]> {
  try {
    // Search for the latest "Who is Hiring?" post
    const searchRes = await fetch(
      "https://hn.algolia.com/api/v1/search?query=%22Who%20is%20hiring%22&tags=ask_hn&hitsPerPage=1",
      { headers: { "User-Agent": "CLIVORA-JobCrawler/1.0" } }
    );
    if (!searchRes.ok) return [];
    const searchData = await searchRes.json();
    const parentId = searchData.hits?.[0]?.objectID;
    if (!parentId) return [];

    // Fetch comments (job listings) from the thread
    const commentsRes = await fetch(
      `https://hn.algolia.com/api/v1/search?tags=comment,story_${parentId}&hitsPerPage=100`,
      { headers: { "User-Agent": "CLIVORA-JobCrawler/1.0" } }
    );
    if (!commentsRes.ok) return [];
    const commentsData = await commentsRes.json();
    const comments = commentsData.hits || [];

    return comments
      .filter((c: any) => c.comment_text && c.comment_text.length > 50)
      .map((c: any, idx: number) => {
        const text = (c.comment_text || "").replace(/<[^>]*>/g, " ").trim();
        // Try to extract company name from first line (typical format: "Company Name | Role | Location | ...")
        const firstLine = text.split("\n")[0] || "";
        const parts = firstLine.split("|").map((p: string) => p.trim());
        const companyName = parts[0]?.slice(0, 100) || "Unknown";
        const title = parts[1]?.slice(0, 200) || `HN Hiring: ${companyName}`;
        const location = parts.find((p: string) =>
          /remote|onsite|hybrid|sf|nyc|london|berlin/i.test(p)
        ) || "Remote";

        return {
          title,
          company_name: companyName,
          company_domain: null,
          company_email: null,
          description: text.slice(0, 10000),
          category: "software-development",
          tags: ["hackernews", "who-is-hiring"],
          salary_min: null,
          salary_max: null,
          currency: "USD",
          location: location.trim(),
          job_type: "full_time" as const,
          source: "hackernews",
          source_id: String(c.objectID),
          source_url: `https://news.ycombinator.com/item?id=${c.objectID}`,
          seo_slug: slugify(`hn-${companyName}-${c.objectID}`),
        };
      });
  } catch (e) {
    console.error("[hackernews] Fetch error:", e);
    return [];
  }
}

// ── Main Handler ─────────────────────────────────────────────────────────────

serve(async (req) => {
  // Auth: require CRON_SECRET or service role key
  const authHeader = req.headers.get("Authorization");
  const cronSecret = Deno.env.get("CRON_SECRET") ?? "";
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

  const token = authHeader?.replace(/^Bearer\s+/i, "") ?? "";
  const isAuthorized =
    (cronSecret && secureEqual(token, cronSecret)) ||
    (serviceKey && secureEqual(token, serviceKey));

  if (!isAuthorized) {
    return new Response(JSON.stringify({ error: "unauthorized" }), { status: 401 });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  if (!supabaseUrl || !serviceKey) {
    return new Response(JSON.stringify({ error: "missing_config" }), { status: 503 });
  }

  const db = createClient(supabaseUrl, serviceKey);

  // Fetch from all sources in parallel
  const [remotiveJobs, arbeitnowJobs, hnJobs] = await Promise.all([
    fetchRemotiveJobs(),
    fetchArbeitnowJobs(),
    fetchHackerNewsJobs(),
  ]);

  const allJobs = [...remotiveJobs, ...arbeitnowJobs, ...hnJobs];

  if (allJobs.length === 0) {
    return new Response(
      JSON.stringify({ ok: true, ingested: 0, message: "No jobs fetched from sources" }),
      { status: 200 }
    );
  }

  // Deduplicate by (source, source_id)
  const seen = new Set<string>();
  const uniqueJobs = allJobs.filter((j) => {
    const key = `${j.source}:${j.source_id}`;
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  });

  // Upsert into connect_jobs in batches of 50
  let ingested = 0;
  let errors = 0;
  const batchSize = 50;

  for (let i = 0; i < uniqueJobs.length; i += batchSize) {
    const batch = uniqueJobs.slice(i, i + batchSize).map((j) => ({
      ...j,
      status: "published",
      is_public: true,
    }));

    const { error } = await db
      .from("connect_jobs")
      .upsert(batch, {
        onConflict: "source,source_id",
        ignoreDuplicates: false,
      });

    if (error) {
      console.error(`[upsert] Batch ${i}:`, error.message);
      errors++;
    } else {
      ingested += batch.length;
    }
  }

  console.log(
    `[sync-external-jobs] Ingested ${ingested} jobs (remotive: ${remotiveJobs.length}, arbeitnow: ${arbeitnowJobs.length}, hn: ${hnJobs.length})`
  );

  return new Response(
    JSON.stringify({
      ok: true,
      ingested,
      errors,
      sources: {
        remotive: remotiveJobs.length,
        arbeitnow: arbeitnowJobs.length,
        hackernews: hnJobs.length,
      },
    }),
    { status: 200 }
  );
});
