import type { Metadata } from "next";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { site } from "@/lib/site";
import { MapPin, Clock, DollarSign, Briefcase, Search, ChevronRight } from "lucide-react";

export const metadata: Metadata = {
  title: "Browse Remote Jobs | $0 Platform Fee - CLIVORA",
  description: "Find your next remote job on CLIVORA. No platform fees, direct contact with clients.",
  alternates: { canonical: `${site.url}/jobs` },
  openGraph: {
    title: "Browse Remote Jobs | $0 Platform Fee - CLIVORA",
    description: "Find your next remote job on CLIVORA. No platform fees.",
  },
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
  "general"
];

function formatSalary(min?: number, max?: number, currency: string = "USD") {
  if (!min && !max) return "Competitive";
  const curr = currency || "USD";
  if (min && !max) return `From ${min.toLocaleString()} ${curr}`;
  if (!min && max) return `Up to ${max.toLocaleString()} ${curr}`;
  return `${min?.toLocaleString()} - ${max?.toLocaleString()} ${curr}`;
}

export default async function JobsIndexPage({
  searchParams,
}: {
  searchParams?: Promise<{ q?: string; page?: string }>;
}) {
  const sp = searchParams ? await searchParams : undefined;
  const q = sp?.q || "";
  const page = parseInt(sp?.page || "1", 10) || 1;
  const perPage = 20;

  const supabase = await createClient();
  let query = supabase
    .from("connect_jobs")
    .select("*", { count: "exact" })
    .eq("is_public", true)
    .eq("status", "published")
    .order("created_at", { ascending: false });

  if (q) {
    // Basic text search if q is present
    query = query.or(`title.ilike.%${q}%,description.ilike.%${q}%,company_name.ilike.%${q}%`);
  }

  const { data: jobs, count } = await query.range((page - 1) * perPage, page * perPage - 1);

  return (
    <main className="mx-auto max-w-7xl px-5 py-12 lg:px-8">
      {/* Hero Section */}
      <div className="mb-12 text-center">
        <h1 className="text-4xl font-bold tracking-tight text-[#0F172A] sm:text-5xl">
          Browse Remote Jobs — $0 Platform Fee
        </h1>
        <p className="mx-auto mt-4 max-w-2xl text-lg text-slate-600">
          Find top remote opportunities with companies that respect your craft. 
          Apply directly or through our secure CRM.
        </p>
      </div>

      {/* Search and Filters */}
      <div className="mb-10 flex flex-col gap-6 md:flex-row md:items-center md:justify-between">
        <form method="get" action="/jobs" className="flex w-full max-w-md items-center gap-2">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 h-5 w-5 -translate-y-1/2 text-slate-400" />
            <input
              type="search"
              name="q"
              defaultValue={q}
              placeholder="Search jobs, skills, or companies..."
              className="w-full rounded-xl border border-slate-200 py-3 pl-10 pr-4 outline-none focus:border-[#0F766E] focus:ring-1 focus:ring-[#0F766E]"
            />
          </div>
          <button type="submit" className="rounded-xl bg-[#0F766E] px-6 py-3 font-medium text-white hover:bg-[#0F766E]/90">
            Search
          </button>
        </form>

        <div className="flex flex-wrap gap-2">
          {CATEGORIES.map((cat) => (
            <Link
              key={cat}
              href={`/jobs/${cat}`}
              className="rounded-full border border-slate-200 bg-white px-4 py-1.5 text-sm font-medium text-slate-600 hover:border-[#0F766E] hover:text-[#0F766E]"
            >
              {cat.split('-').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ')}
            </Link>
          ))}
        </div>
      </div>

      {/* Job Grid */}
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
            No jobs found matching your criteria.
          </div>
        )}
      </div>

      {/* Pagination */}
      {count && count > perPage && (
        <div className="mt-8 flex justify-center gap-2">
          {page > 1 && (
            <Link
              href={`/jobs?q=${q}&page=${page - 1}`}
              className="rounded-lg border border-slate-200 px-4 py-2 text-sm font-medium hover:bg-slate-50"
            >
              Previous
            </Link>
          )}
          {page * perPage < count && (
            <Link
              href={`/jobs?q=${q}&page=${page + 1}`}
              className="rounded-lg border border-slate-200 px-4 py-2 text-sm font-medium hover:bg-slate-50"
            >
              Next
            </Link>
          )}
        </div>
      )}
    </main>
  );
}
