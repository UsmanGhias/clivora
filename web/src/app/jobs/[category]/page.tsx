import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { site } from "@/lib/site";
import { MapPin, Clock, DollarSign, Briefcase, ChevronRight } from "lucide-react";

export const revalidate = 3600;

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

export function generateStaticParams() {
  return CATEGORIES.map((category) => ({ category }));
}

function formatTitle(slug: string) {
  return slug.split('-').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
}

type Props = {
  params: Promise<{ category: string }>;
};

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { category } = await params;
  if (!CATEGORIES.includes(category)) return {};

  const title = `${formatTitle(category)} Remote Jobs | CLIVORA`;
  const description = `Find the best remote ${formatTitle(category)} jobs. Apply directly with $0 platform fees.`;
  
  return {
    title,
    description,
    alternates: { canonical: `${site.url}/jobs/${category}` },
    openGraph: { title, description },
  };
}

function formatSalary(min?: number, max?: number, currency: string = "USD") {
  if (!min && !max) return "Competitive";
  const curr = currency || "USD";
  if (min && !max) return `From ${min.toLocaleString()} ${curr}`;
  if (!min && max) return `Up to ${max.toLocaleString()} ${curr}`;
  return `${min?.toLocaleString()} - ${max?.toLocaleString()} ${curr}`;
}

export default async function CategoryPage({ params }: Props) {
  const { category } = await params;

  if (!CATEGORIES.includes(category)) {
    notFound();
  }

  const supabase = await createClient();
  const { data: jobs } = await supabase
    .from("connect_jobs")
    .select("*")
    .eq("is_public", true)
    .eq("status", "published")
    .eq("category", category)
    .order("created_at", { ascending: false })
    .limit(50);

  const titleName = formatTitle(category);

  return (
    <main className="mx-auto max-w-7xl px-5 py-12 lg:px-8">
      <div className="mb-8">
        <Link href="/jobs" className="text-sm font-medium text-slate-500 hover:text-[#0F766E]">
          &larr; Back to all jobs
        </Link>
      </div>
      
      <div className="mb-12">
        <h1 className="text-4xl font-bold tracking-tight text-[#0F172A] sm:text-5xl">
          {titleName} Remote Jobs
        </h1>
        <p className="mt-4 text-lg text-slate-600">
          Browse the latest remote opportunities in {titleName}. Work from anywhere, with zero platform fees on your earnings.
        </p>
      </div>

      <div className="grid gap-4">
        {jobs && jobs.length > 0 ? (
          jobs.map((job) => (
            <Link
              key={job.id}
              href={`/jobs/view/${job.seo_slug}`}
              className="group flex flex-col justify-between gap-4 rounded-2xl border border-slate-200 bg-white p-6 transition-shadow hover:shadow-md sm:flex-row sm:items-center"
            >
              <div className="flex-1 space-y-3">
                <div>
                  <h2 className="text-xl font-semibold text-[#0F172A] group-hover:text-[#0F766E]">
                    {job.title}
                  </h2>
                  <p className="text-slate-600">{job.company_name}</p>
                </div>
                
                <div className="flex flex-wrap gap-x-6 gap-y-2 text-sm text-slate-500">
                  {job.location && (
                    <div className="flex items-center gap-1.5">
                      <MapPin className="h-4 w-4" />
                      {job.location}
                    </div>
                  )}
                  <div className="flex items-center gap-1.5">
                    <DollarSign className="h-4 w-4" />
                    {formatSalary(job.salary_min, job.salary_max, job.currency)}
                  </div>
                  {job.job_type && (
                    <div className="flex items-center gap-1.5 capitalize">
                      <Briefcase className="h-4 w-4" />
                      {job.job_type.replace('_', ' ')}
                    </div>
                  )}
                  <div className="flex items-center gap-1.5">
                    <Clock className="h-4 w-4" />
                    {new Date(job.created_at).toLocaleDateString()}
                  </div>
                </div>

                {job.tags && job.tags.length > 0 && (
                  <div className="flex flex-wrap gap-2">
                    {job.tags.slice(0, 5).map((tag: string) => (
                      <span key={tag} className="rounded-md bg-slate-100 px-2.5 py-1 text-xs font-medium text-slate-600">
                        {tag}
                      </span>
                    ))}
                    {job.tags.length > 5 && (
                      <span className="text-xs text-slate-500">+{job.tags.length - 5} more</span>
                    )}
                  </div>
                )}
              </div>
              <div className="hidden sm:block">
                <ChevronRight className="h-6 w-6 text-slate-400 group-hover:text-[#0F766E]" />
              </div>
            </Link>
          ))
        ) : (
          <div className="py-12 text-center text-slate-500">
            No jobs found for this category at the moment.
          </div>
        )}
      </div>
    </main>
  );
}
