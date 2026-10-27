// CLIVORA autonomous job crawler - fetches from free APIs and inserts into connect_jobs.
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
  language: string;
}

function detectLanguage(title: string, desc: string): string {
  const sample = (title + " " + (desc || "").slice(0, 1000)).toLowerCase();
  if (/\b(der|die|das|und|von|mit|sich|für|eine|einer|einem|unser|ihre|aufgaben|wir suchen|über uns|standort)\b/i.test(sample)) {
    return "de";
  }
  if (/\b(le|la|les|des|du|dans|pour|avec|vous|nous|missions|équipe|entreprise|gestionnaire|poste|notre)\b/i.test(sample)) {
    return "fr";
  }
  if (/\b(el|los|las|para|con|por|requisitos|empresa|nuestro|equipo|experiencia)\b/i.test(sample)) {
    return "es";
  }
  return "en";
}

// ── HTML Entity Decoder ──────────────────────────────────────────────────────

function decodeHtmlEntities(str: string): string {
  if (!str) return "";
  return str
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/&#x27;/g, "'")
    .replace(/&#39;/g, "'")
    .replace(/&#x2F;/gi, "/")
    .replace(/&#47;/g, "/")
    .replace(/&nbsp;/g, " ")
    .replace(/&#(\d+);/g, (_, code) => String.fromCharCode(parseInt(code, 10)))
    .replace(/&#x([a-f0-9]+);/gi, (_, code) => String.fromCharCode(parseInt(code, 16)))
    .trim();
}

function stripHtmlTags(html: string): string {
  if (!html) return "";
  return html
    .replace(/<style[^>]*>[\s\S]*?<\/style>/gi, "")
    .replace(/<script[^>]*>[\s\S]*?<\/script>/gi, "")
    .replace(/<li>/gi, "\n• ")
    .replace(/<\/li>/gi, "")
    .replace(/<br\s*[\/]?>/gi, "\n")
    .replace(/<\/(p|div|h1|h2|h3|h4|h5|h6|tr|table|ul|ol)>/gi, "\n\n")
    .replace(/<[^>]+>/g, " ")
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/&#x27;/g, "'")
    .replace(/&#39;/g, "'")
    .replace(/&apos;/g, "'")
    .replace(/&#x2F;/gi, "/")
    .replace(/&#47;/g, "/")
    .replace(/&nbsp;/g, " ")
    .replace(/&bull;/g, "•")
    .replace(/&middot;/g, "·")
    .replace(/&#(\d+);/g, (_, code) => String.fromCharCode(parseInt(code, 10)))
    .replace(/&#x([a-f0-9]+);/gi, (_, code) => String.fromCharCode(parseInt(code, 16)))
    .replace(/[\u2014\u2013]/g, "-")
    .replace(/[ \t]+/g, " ")
    .replace(/\n\s*\n\s*\n+/g, "\n\n")
    .trim();
}

// ── Helpers ──────────────────────────────────────────────────────────────────

function slugify(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^a-z0-9\s-]/g, "")
    .replace(/[\s_]+/g, "-")
    .replace(/-+/g, "-")
    .replace(/^-|-$/g, "")
    .slice(0, 100);
}

const EXCLUDED_AGGREGATOR_DOMAINS = [
  "whatjobs.com",
  "adzuna.com",
  "adzuna.co.uk",
  "jobleads.com",
  "jobleads.de",
  "arbeitsagentur.de",
  "nofluffjobs.com",
  "djinni.co",
  "wantapply.com",
];

function isAggregatorDomain(domain: string | null): boolean {
  if (!domain) return false;
  const d = domain.toLowerCase();
  return EXCLUDED_AGGREGATOR_DOMAINS.some((agg) => d === agg || d.endsWith(`.${agg}`));
}

function extractDomain(url: string | null | undefined): string | null {
  if (!url) return null;
  try {
    const hostname = new URL(url.startsWith("http") ? url : `https://${url}`).hostname;
    const cleanHost = hostname.replace(/^www\./, "");
    if (isAggregatorDomain(cleanHost)) return null;
    return cleanHost;
  } catch {
    return null;
  }
}

function mapCategory(rawCategory: string): string {
  const lower = (rawCategory || "").toLowerCase();
  const categoryMap: Record<string, string> = {
    software: "software-development",
    "software-dev": "software-development",
    "software-development": "software-development",
    devops: "devops-sysadmin",
    "devops-sysadmin": "devops-sysadmin",
    "devops / sysadmin": "devops-sysadmin",
    sysadmin: "devops-sysadmin",
    design: "design",
    product: "product",
    marketing: "marketing",
    "customer support": "customer-support",
    "customer-support": "customer-support",
    writing: "writing",
    data: "data-science",
    "data science": "data-science",
    "data-science": "data-science",
    qa: "quality-assurance",
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
    general: "general",
  };
  return categoryMap[lower] || "software-development";
}

function secureEqual(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  let result = 0;
  for (let i = 0; i < a.length; i++) {
    result |= a.charCodeAt(i) ^ b.charCodeAt(i);
  }
  return result === 0;
}

function extractContactEmail(text: string): string | null {
  if (!text) return null;
  const matches = text.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g);
  if (!matches) return null;
  const filtered = matches.filter((e) => {
    const lower = e.toLowerCase();
    return (
      !lower.includes("ycombinator") &&
      !lower.includes("example.com") &&
      !lower.includes("w3.org") &&
      !lower.includes("remotive") &&
      !lower.includes("arbeitnow") &&
      !lower.includes("sentry") &&
      !lower.includes(".png") &&
      !lower.includes(".jpg")
    );
  });
  return filtered.length > 0 ? filtered[0].toLowerCase().trim() : null;
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

    return jobs.map((j: any) => {
      const cleanTitle = decodeHtmlEntities(j.title || "").trim();
      const cleanCompany = decodeHtmlEntities(j.company_name || "").trim();
      const cleanDesc = stripHtmlTags(j.description || "").slice(0, 10000);
      return {
        title: cleanTitle,
        company_name: cleanCompany,
        company_domain: extractDomain(j.url),
        company_email: extractContactEmail(j.description || ""),
        description: cleanDesc,
        category: mapCategory(j.category || ""),
        tags: (j.tags || []).map((t: string) => decodeHtmlEntities(t).toLowerCase().trim()).filter(Boolean),
        salary_min: null,
        salary_max: null,
        currency: "USD",
        location: decodeHtmlEntities(j.candidate_required_location || "Worldwide").trim(),
        job_type: j.job_type === "contract" ? "contract"
          : j.job_type === "part_time" ? "part_time"
          : j.job_type === "freelance" ? "freelance"
          : "full_time",
        source: "remotive",
        source_id: String(j.id),
        source_url: j.url || `https://remotive.com/remote-jobs/${j.id}`,
        seo_slug: slugify(`${cleanCompany}-${cleanTitle}-${j.id}`),
        language: detectLanguage(cleanTitle, cleanDesc),
      };
    });
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
    const results: NormalizedJob[] = [];

    const ALLOWED_CATEGORIES = new Set([
      "software-development",
      "devops-sysadmin",
      "data-science",
      "product",
      "design",
      "quality-assurance",
      "marketing",
    ]);

    const TITLE_EXCLUDES = /\b(werkstudent|praktik|intern\b|internship|ausbildung|landwirt|pflege|arzt|buchhalter|assistenz|rezeption|facility|driver|fahrer)\b/i;

    for (const j of jobs) {
      const cleanTitle = decodeHtmlEntities(j.title || "").trim();
      const cleanCompany = decodeHtmlEntities(j.company_name || "").trim();
      const cleanDesc = stripHtmlTags(j.description || "").slice(0, 10000);
      const cleanLocation = decodeHtmlEntities(j.location || "Remote").trim();
      const lang = detectLanguage(cleanTitle, cleanDesc);

      // 1. Strictly English only
      if (lang !== "en") continue;

      // 2. Strictly Remote (location must explicitly state remote or worldwide)
      const locLower = cleanLocation.toLowerCase();
      const isExplicitlyRemote =
        locLower.includes("remote") ||
        locLower.includes("worldwide") ||
        locLower.includes("telework");
      if (!isExplicitlyRemote) continue;

      // 3. Exclude non-tech / student / non-relevant titles
      if (TITLE_EXCLUDES.test(cleanTitle)) continue;

      // 4. Require approved tech/digital category
      const category = mapCategory(j.tags?.[0] || "");
      if (!ALLOWED_CATEGORIES.has(category)) continue;

      results.push({
        title: cleanTitle,
        company_name: cleanCompany,
        company_domain: extractDomain(j.url),
        company_email: extractContactEmail(j.description || ""),
        description: cleanDesc,
        category,
        tags: (j.tags || []).map((t: string) => decodeHtmlEntities(t).toLowerCase().trim()).filter(Boolean),
        salary_min: null,
        salary_max: null,
        currency: "USD",
        location: cleanLocation || "Remote",
        job_type: "full_time",
        source: "arbeitnow",
        source_id: String(j.slug || j.title).slice(0, 200),
        source_url: j.url || `https://www.arbeitnow.com/view/${j.slug}`,
        seo_slug: slugify(`${cleanCompany}-${cleanTitle}-an-${j.slug || Date.now()}`),
        language: lang,
      });

      // Cap at top 40 freshest verified matches per run
      if (results.length >= 40) break;
    }

    return results;
  } catch (e) {
    console.error("[arbeitnow] Fetch error:", e);
    return [];
  }
}

async function fetchHackerNewsJobs(): Promise<NormalizedJob[]> {
  try {
    // Search for the latest "Who is Hiring?" Ask HN post
    const searchRes = await fetch(
      "https://hn.algolia.com/api/v1/search?query=%22Who%20is%20hiring%22&tags=ask_hn&hitsPerPage=1",
      { headers: { "User-Agent": "CLIVORA-JobCrawler/1.0" } }
    );
    if (!searchRes.ok) return [];
    const searchData = await searchRes.json();
    const parentId = searchData.hits?.[0]?.objectID;
    if (!parentId) return [];

    // Fetch top comments from the thread
    const commentsRes = await fetch(
      `https://hn.algolia.com/api/v1/search?tags=comment,story_${parentId}&hitsPerPage=100`,
      { headers: { "User-Agent": "CLIVORA-JobCrawler/1.0" } }
    );
    if (!commentsRes.ok) return [];
    const commentsData = await commentsRes.json();
    const comments = commentsData.hits || [];

    const parsedJobs: NormalizedJob[] = [];

    for (const c of comments) {
      if (!c.comment_text || c.comment_text.length < 80) continue;

      const rawText = decodeHtmlEntities(c.comment_text);
      const cleanText = stripHtmlTags(rawText);
      const firstLine = cleanText.split("\n")[0] || "";

      // Strict validation: A genuine HN hiring post MUST have '|' in the first line
      // format: Company Name | Role | Location | Full-time/Remote/Salary
      if (!firstLine.includes("|")) continue;

      const parts = firstLine.split("|").map((p: string) => p.trim());
      if (parts.length < 2) continue;

      const rawCompany = parts[0];
      const rawTitle = parts[1];

      // Reject non-job replies / complaints / commentary
      if (
        /^(note:|fyi:|hello|basically|are you|it'?s|i'?ll|when|why|what|you should|commenters|screening)/i.test(rawCompany) ||
        rawCompany.length > 50 ||
        rawCompany.length < 2 ||
        /^(note:|fyi:|hello|basically|are you|it'?s|i'?ll|when|why|what|you should)/i.test(rawTitle)
      ) {
        continue;
      }

      const companyName = rawCompany.replace(/^[-\s*]+/, "").slice(0, 60).trim();
      const title = rawTitle.slice(0, 100).trim() || `${companyName} Engineer`;
      const location = parts.find((p: string) =>
        /remote|onsite|hybrid|sf|nyc|london|berlin|europe|us|worldwide|canada|singapore/i.test(p)
      ) || "Remote";

      // Tag extraction
      const tags: string[] = ["hackernews", "who-is-hiring"];
      if (/react|frontend|front-end/i.test(cleanText)) tags.push("react");
      if (/node|backend|back-end/i.test(cleanText)) tags.push("nodejs");
      if (/python/i.test(cleanText)) tags.push("python");
      if (/rust/i.test(cleanText)) tags.push("rust");
      if (/golang|go /i.test(cleanText)) tags.push("golang");
      if (/flutter|mobile|ios|android/i.test(cleanText)) tags.push("mobile");

      parsedJobs.push({
        title,
        company_name: companyName,
        company_domain: null,
        company_email: extractContactEmail(cleanText),
        description: cleanText.slice(0, 10000),
        category: "software-development",
        tags,
        salary_min: null,
        salary_max: null,
        currency: "USD",
        location: location.slice(0, 60).trim(),
        job_type: "full_time",
        source: "hackernews",
        source_id: String(c.objectID),
        source_url: `https://news.ycombinator.com/item?id=${c.objectID}`,
        seo_slug: slugify(`hn-${companyName}-${title}-${c.objectID}`),
        language: "en",
      });
    }

    return parsedJobs;
  } catch (e) {
    console.error("[hackernews] Fetch error:", e);
    return [];
  }
}

async function fetchFreeHireJobs(): Promise<NormalizedJob[]> {
  try {
    const clusters = [
      "remote",
      "python",
      "flutter",
      "react",
      "golang",
      "devops",
      "typescript",
      "nextjs",
      "fullstack",
      "ai",
      "frontend",
      "backend",
      "rust",
      "mobile",
      "solidity",
      "data-science",
      "vue",
      "aws",
      "kubernetes",
      "nodejs",
    ];
    const results: NormalizedJob[] = [];

    for (const cluster of clusters) {
      try {
        const url = `https://freehire.me/api/v1/jobs/search?q=${encodeURIComponent(cluster)}&work_mode=remote&reality=fresh&limit=30`;
        const res = await fetch(url, {
          headers: { "User-Agent": "CLIVORA-JobCrawler/1.0" },
        });
        if (!res.ok) continue;
        const json = await res.json();
        const items = json.data || [];
        for (const j of items) {
          const rawUrl = j.url || "";
          const domain = extractDomain(rawUrl);
          if (isAggregatorDomain(domain)) continue;

          const cleanTitle = decodeHtmlEntities(j.title || "").trim();
          const cleanCompany = decodeHtmlEntities(j.company || "Direct Client").trim();
          if (isAggregatorDomain(cleanCompany.toLowerCase())) continue;

          const cleanDesc = stripHtmlTags(j.description || "").slice(0, 10000);
          const enrichment = j.enrichment || {};
          const salaryMin = enrichment.salary_min || null;
          const salaryMax = enrichment.salary_max || null;
          const location = decodeHtmlEntities(j.location || "Remote").trim();
          const skills = Array.isArray(j.skills) ? j.skills : [];

          results.push({
            title: cleanTitle,
            company_name: cleanCompany,
            company_domain: domain,
            company_email: extractContactEmail(cleanDesc),
            description: cleanDesc,
            category: mapCategory(enrichment.category || "software-development"),
            tags: ["freehire", ...skills].map((s: string) => s.toLowerCase().trim()).filter(Boolean),
            salary_min: typeof salaryMin === "number" ? salaryMin : null,
            salary_max: typeof salaryMax === "number" ? salaryMax : null,
            currency: "USD",
            location: location || "Remote",
            job_type: "contract",
            source: "freehire",
            source_id: String(j.public_slug || j.external_id || cleanTitle).slice(0, 200),
            source_url: j.url || `https://freehire.me/jobs/${j.public_slug}`,
            seo_slug: slugify(`fh-${cleanCompany}-${cleanTitle}-${j.public_slug || Date.now()}`),
            language: detectLanguage(cleanTitle, cleanDesc),
          });
        }
      } catch (err) {
        console.error(`[freehire] Error fetching cluster ${cluster}:`, err);
      }
    }
    return results;
  } catch (e) {
    console.error("[freehire] General fetch error:", e);
    return [];
  }
}

async function fetchGithubOssJobs(): Promise<NormalizedJob[]> {
  try {
    const url = "https://raw.githubusercontent.com/poteto/hiring-without-whiteboards/master/README.md";
    const res = await fetch(url, {
      headers: { "User-Agent": "CLIVORA-JobCrawler/1.0" },
    });
    if (!res.ok) return [];
    const text = await res.text();
    const results: NormalizedJob[] = [];
    const seen = new Set<string>();

    for (const line of text.split("\n")) {
      const trimmed = line.trim();
      if (!trimmed.startsWith("- [")) continue;
      const match = trimmed.match(/^-\s*\[([^\]]+)\]\((https?:\/\/[^\)]+)\)\s*(?:\|\s*([^|]+))?(?:\|\s*(.+))?$/);
      if (!match) continue;

      const companyName = match[1].trim();
      const careersUrl = match[2].trim();
      const location = (match[3] || "Remote").trim();
      const details = (match[4] || "").trim();

      if (companyName.length < 2 || /hackernews|finding a better|how to hire/i.test(companyName)) continue;
      const slug = slugify(companyName);
      if (seen.has(slug)) continue;
      seen.add(slug);

      const domain = extractDomain(careersUrl);
      const desc = `### Role Overview\nEngineering opportunity at ${companyName}. This team evaluates candidates using practical engineering discussions and real-world work-sample assessments instead of traditional whiteboard puzzles.\n\n### Location & Work Mode\n${location}\n\n### Hiring Process Notes\n${details || "Practical technical discussion and team culture alignment."}\n\n### How to Apply\nVisit the official company portal to review current open roles: ${careersUrl}`;

      results.push({
        title: `Software Engineer at ${companyName}`,
        company_name: companyName,
        company_domain: domain,
        company_email: null,
        description: desc,
        category: "software-development",
        tags: ["github-oss", "no-whiteboard", "software-development"],
        salary_min: null,
        salary_max: null,
        currency: "USD",
        location: location.slice(0, 60),
        job_type: "full_time",
        source: "github-oss",
        source_id: `hww-${slug}`,
        source_url: careersUrl,
        seo_slug: slugify(`oss-${slug}-software-engineer`),
        language: "en",
      });
    }
    return results;
  } catch (e) {
    console.error("[github-oss] Fetch error:", e);
    return [];
  }
}

// ── Main Handler ─────────────────────────────────────────────────────────────

serve(async (req) => {
  const authHeader = req.headers.get("Authorization") ?? "";
  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

  if (!supabaseUrl || !serviceKey) {
    return new Response(JSON.stringify({ error: "missing_config" }), { status: 503 });
  }

  const db = createClient(supabaseUrl, serviceKey);

  let cronSecret = Deno.env.get("CRON_SECRET") ?? "";
  if (!cronSecret) {
    const { data: secRow } = await db
      .from("_internal_secrets")
      .select("value")
      .eq("key", "cron_secret")
      .maybeSingle();
    if (secRow?.value) cronSecret = secRow.value as string;
  }

  const anonKey = Deno.env.get("SUPABASE_ANON_KEY") ?? "";
  const token = authHeader.replace(/^Bearer\s+/i, "").trim();
  const isAuthorized =
    token.length > 0 &&
    ((cronSecret && secureEqual(token, cronSecret)) ||
      (serviceKey && secureEqual(token, serviceKey)) ||
      (anonKey && secureEqual(token, anonKey)) ||
      token.startsWith("eyJ"));

  if (!isAuthorized) {
    return new Response(JSON.stringify({ error: "unauthorized" }), { status: 401 });
  }

  // 1. Fetch from all sources in parallel (jobs are kept permanently, no auto-archive or deletion)
  const [remotiveJobs, arbeitnowJobs, hnJobs, freehireJobs, ossJobs] = await Promise.all([
    fetchRemotiveJobs(),
    fetchArbeitnowJobs(),
    fetchHackerNewsJobs(),
    fetchFreeHireJobs(),
    fetchGithubOssJobs(),
  ]);

  const allJobs = [...remotiveJobs, ...arbeitnowJobs, ...hnJobs, ...freehireJobs, ...ossJobs];

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
      console.warn(`[upsert] Batch ${i} conflict (${error.message}); running single-row upsert with slug salting.`);
      for (const singleJob of batch) {
        const { error: singleErr } = await db
          .from("connect_jobs")
          .upsert(singleJob, { onConflict: "source,source_id" });
        if (singleErr) {
          const saltedSlug = `${singleJob.seo_slug.slice(0, 80)}-${crypto.randomUUID().slice(0, 8)}`;
          const { error: saltedErr } = await db
            .from("connect_jobs")
            .upsert({ ...singleJob, seo_slug: saltedSlug }, { onConflict: "source,source_id" });
          if (!saltedErr) {
            ingested++;
          } else {
            console.error(`[upsert-single] ${singleJob.source}:${singleJob.source_id}:`, saltedErr.message);
            errors++;
          }
        } else {
          ingested++;
        }
      }
    } else {
      ingested += batch.length;
    }
  }

  console.log(
    `[sync-external-jobs] Ingested ${ingested} clean jobs (remotive: ${remotiveJobs.length}, arbeitnow: ${arbeitnowJobs.length}, hn: ${hnJobs.length}, freehire: ${freehireJobs.length}, oss: ${ossJobs.length})`
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
        freehire: freehireJobs.length,
        oss: ossJobs.length,
      },
    }),
    { status: 200 }
  );
});
