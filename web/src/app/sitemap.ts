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

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const now = new Date();

  const core: SitemapEntry[] = [
    { path: "", priority: 1, changeFrequency: "weekly" },
    { path: "/features", priority: 0.9, changeFrequency: "weekly" },
    { path: "/pricing", priority: 0.9, changeFrequency: "weekly" },
    { path: "/for-freelancers", priority: 0.9, changeFrequency: "weekly" },
    { path: "/for-clients", priority: 0.9, changeFrequency: "weekly" },
    { path: "/connect", priority: 0.9, changeFrequency: "weekly" },
    { path: "/jobs", priority: 0.9, changeFrequency: "daily" },
    { path: "/compare", priority: 0.85, changeFrequency: "monthly" },
    { path: "/pro", priority: 0.8, changeFrequency: "monthly" },
    { path: "/docs", priority: 0.8, changeFrequency: "weekly" },
    { path: "/login", priority: 0.5, changeFrequency: "monthly" },
    { path: "/signup", priority: 0.7, changeFrequency: "monthly" },
    { path: "/about", priority: 0.6, changeFrequency: "monthly" },
    { path: "/support", priority: 0.6, changeFrequency: "monthly" },
    { path: "/contact", priority: 0.6, changeFrequency: "monthly" },
  ];

  const docs: SitemapEntry[] = DOC_CATALOG.filter((d) => d.slug !== "index").map((d) => ({
    path: `/docs/${d.slug}`,
    priority: 0.55,
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

  // Fetch jobs
  const supabase = await createClient();
  const { data: jobs } = await supabase
    .from("connect_jobs")
    .select("seo_slug, created_at")
    .eq("is_public", true)
    .eq("status", "published");

  const jobUrls: SitemapEntry[] = (jobs || []).map((job) => ({
    path: `/jobs/view/${job.seo_slug}`,
    priority: 0.7,
    changeFrequency: "weekly" as const,
    lastModified: new Date(job.created_at),
  }));

  const CATEGORIES = [
    "software-development",
    "design",
    "devops-sysadmin",
    "data-science",
    "marketing",
    "product",
    "customer-support",
    "management",
    "general"
  ];
  
  const categoryUrls: SitemapEntry[] = CATEGORIES.map((cat) => ({
    path: `/jobs/${cat}`,
    priority: 0.8,
    changeFrequency: "daily" as const,
  }));

  const allRoutes: SitemapEntry[] = [...core, ...docs, ...legal, ...categoryUrls, ...jobUrls];

  return allRoutes.map(({ path, priority, changeFrequency, lastModified }) => ({
    url: `${site.url}${path}`,
    lastModified: lastModified || now,
    changeFrequency,
    priority,
  }));
}
