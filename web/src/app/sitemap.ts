import type { MetadataRoute } from "next";
import { site, legalLinks } from "@/lib/site";
import { DOC_CATALOG } from "@/lib/docs";
import { createClient } from "@/lib/supabase/server";

type SitemapEntry = {
  path: string;
  priority: number;
  changeFrequency: MetadataRoute.Sitemap[0]["changeFrequency"];
  lastModified?: Date | string;
};

const CATEGORIES = [
  "software-development",
  "design",
  "devops-sysadmin",
  "data-science",
  "marketing",
  "product",
  "customer-support",
  "management",
  "general",
];

const POPULAR_SKILLS: Record<string, string[]> = {
  "software-development": [
    "react",
    "nextjs",
    "typescript",
    "javascript",
    "python",
    "nodejs",
    "flutter",
    "golang",
    "rust",
    "full-stack",
    "frontend",
    "backend",
    "ios",
    "android",
  ],
  design: ["ui-ux", "figma", "product-design", "brand-identity", "web-design", "illustration", "motion-design"],
  "devops-sysadmin": ["aws", "kubernetes", "docker", "terraform", "ci-cd", "cloud", "linux", "gcp"],
  "data-science": ["ai", "machine-learning", "llm", "data-engineering", "sql", "analytics", "deep-learning"],
  marketing: ["seo", "content-marketing", "growth", "social-media", "copywriting", "paid-ads", "email-marketing"],
  product: ["product-manager", "technical-pm", "scrum-master", "roadmapping", "user-research"],
  "customer-support": ["customer-success", "technical-support", "support-lead", "helpdesk"],
  management: ["engineering-management", "operations", "project-management", "team-lead"],
  general: ["remote", "contract", "freelance"],
};

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const now = new Date();

  const core: SitemapEntry[] = [
    { path: "", priority: 1.0, changeFrequency: "daily" },
    { path: "/jobs", priority: 0.95, changeFrequency: "hourly" },
    { path: "/connect", priority: 0.95, changeFrequency: "daily" },
    { path: "/for-freelancers", priority: 0.9, changeFrequency: "weekly" },
    { path: "/for-clients", priority: 0.9, changeFrequency: "weekly" },
    { path: "/features", priority: 0.9, changeFrequency: "weekly" },
    { path: "/pricing", priority: 0.9, changeFrequency: "weekly" },
    { path: "/calculator", priority: 0.85, changeFrequency: "monthly" },
    { path: "/tools/invoice-generator", priority: 0.85, changeFrequency: "monthly" },
    { path: "/tools/proposal-generator", priority: 0.85, changeFrequency: "monthly" },
    { path: "/tools/contract-generator", priority: 0.85, changeFrequency: "monthly" },
    { path: "/tools/rate-calculator", priority: 0.85, changeFrequency: "monthly" },
    { path: "/agency", priority: 0.8, changeFrequency: "monthly" },
    { path: "/compare", priority: 0.85, changeFrequency: "monthly" },
    { path: "/pro", priority: 0.8, changeFrequency: "monthly" },
    { path: "/docs", priority: 0.8, changeFrequency: "weekly" },
    { path: "/about", priority: 0.7, changeFrequency: "monthly" },
    { path: "/careers", priority: 0.7, changeFrequency: "monthly" },
    { path: "/changelog", priority: 0.7, changeFrequency: "weekly" },
    { path: "/support", priority: 0.6, changeFrequency: "monthly" },
    { path: "/contact", priority: 0.6, changeFrequency: "monthly" },
    { path: "/login", priority: 0.5, changeFrequency: "monthly" },
    { path: "/signup", priority: 0.7, changeFrequency: "monthly" },
  ];

  const docs: SitemapEntry[] = DOC_CATALOG.filter((d) => d.slug !== "index").map((d) => ({
    path: `/docs/${d.slug}`,
    priority: 0.6,
    changeFrequency: "monthly" as const,
  }));

  const legal: SitemapEntry[] = [
    legalLinks.privacy,
    legalLinks.terms,
    legalLinks.cookies,
    legalLinks.deleteAccount,
    legalLinks.dataSafety,
  ].map((path) => ({
    path,
    priority: 0.3,
    changeFrequency: "yearly" as const,
  }));

  // Categories
  const categoryUrls: SitemapEntry[] = CATEGORIES.map((cat) => ({
    path: `/jobs/${cat}`,
    priority: 0.85,
    changeFrequency: "daily" as const,
  }));

  // Skill sub-pages for SEO
  const skillUrls: SitemapEntry[] = [];
  for (const [cat, skills] of Object.entries(POPULAR_SKILLS)) {
    for (const skill of skills) {
      skillUrls.push({
        path: `/jobs/${cat}/${skill}`,
        priority: 0.8,
        changeFrequency: "daily" as const,
      });
    }
  }

  // Fetch all published jobs from Supabase
  let jobUrls: SitemapEntry[] = [];
  try {
    const supabase = await createClient();
    const { data: jobs } = await supabase
      .from("connect_jobs")
      .select("seo_slug, created_at")
      .eq("is_public", true)
      .eq("status", "published")
      .order("created_at", { ascending: false })
      .limit(2000);

    if (jobs && jobs.length > 0) {
      jobUrls = jobs.map((job) => ({
        path: `/jobs/view/${job.seo_slug}`,
        priority: 0.75,
        changeFrequency: "weekly" as const,
        lastModified: new Date(job.created_at),
      }));
    }
  } catch (e) {
    console.error("[sitemap] Failed to load jobs for sitemap:", e);
  }

  const allRoutes: SitemapEntry[] = [
    ...core,
    ...categoryUrls,
    ...skillUrls,
    ...jobUrls,
    ...docs,
    ...legal,
  ];

  return allRoutes.map(({ path, priority, changeFrequency, lastModified }) => ({
    url: `${site.url}${path}`,
    lastModified: lastModified || now,
    changeFrequency,
    priority,
  }));
}
