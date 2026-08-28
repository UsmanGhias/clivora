import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { site } from "@/lib/site";
import { MapPin, Clock, DollarSign, Briefcase, Globe, ExternalLink } from "lucide-react";

type Props = {
  params: Promise<{ slug: string }>;
};

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const supabase = await createClient();
  const { data: job } = await supabase
    .from("connect_jobs")
    .select("*")
    .eq("seo_slug", slug)
    .single();

  if (!job) return {};

  const title = `${job.title} at ${job.company_name} | CLIVORA`;
  const description = `Apply for ${job.title} at ${job.company_name}. Remote opportunity with $0 platform fees on CLIVORA.`;

  return {
    title,
    description,
    alternates: { canonical: `${site.url}/jobs/view/${slug}` },
    openGraph: {
      title,
      description,
      type: "article",
      publishedTime: job.created_at,
    },
  };
}

function formatSalary(min?: number, max?: number, currency: string = "USD") {
  if (!min && !max) return "Competitive";
  const curr = currency || "USD";
  if (min && !max) return `From ${min.toLocaleString()} ${curr}`;
  if (!min && max) return `Up to ${max.toLocaleString()} ${curr}`;
  return `${min?.toLocaleString()} - ${max?.toLocaleString()} ${curr}`;
}

export default async function JobViewPage({ params }: Props) {
  const { slug } = await params;
  
  const supabase = await createClient();
  const { data: job } = await supabase
    .from("connect_jobs")
    .select("*")
    .eq("seo_slug", slug)
    .single();

  if (!job || !job.is_public || job.status !== "published") {
    notFound();
  }

  // Build JSON-LD
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "JobPosting",
    title: job.title,
    description: job.description,
    datePosted: job.created_at,
    validThrough: new Date(new Date(job.created_at).getTime() + 30 * 24 * 60 * 60 * 1000).toISOString(),
    employmentType: job.job_type ? (job.job_type === "full_time" ? "FULL_TIME" : "CONTRACTOR") : "FULL_TIME",
    hiringOrganization: {
      "@type": "Organization",
      name: job.company_name,
      sameAs: job.company_domain ? `https://${job.company_domain}` : undefined,
    },
    jobLocation: {
      "@type": "Place",
      address: {
        "@type": "PostalAddress",
        addressLocality: job.location || "Remote",
        addressCountry: "Anywhere",
      },
    },
    applicantLocationRequirements: {
      "@type": "Country",
      name: "Worldwide",
    },
    jobLocationType: "TELECOMMUTE",
    ...(job.salary_min && {
      baseSalary: {
        "@type": "MonetaryAmount",
        currency: job.currency || "USD",
        value: {
          "@type": "QuantitativeValue",
          ...(job.salary_min && { minValue: job.salary_min }),
          ...(job.salary_max && { maxValue: job.salary_max }),
          unitText: "YEAR",
        },
      },
    }),
  };

  return (
    <main className="mx-auto max-w-7xl px-5 py-12 lg:px-8">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      
      <div className="mb-8">
        <Link href="/jobs" className="text-sm font-medium text-slate-500 hover:text-[#0F766E]">
          &larr; Back to jobs
        </Link>
      </div>

      <div className="grid gap-8 lg:grid-cols-3 lg:gap-12">
        {/* Main Content */}
        <div className="lg:col-span-2">
          <div className="mb-8 border-b border-slate-200 pb-8">
            <h1 className="text-3xl font-bold tracking-tight text-[#0F172A] sm:text-4xl">
              {job.title}
            </h1>
            <div className="mt-4 flex flex-wrap items-center gap-x-6 gap-y-3 text-sm text-slate-600">
              <div className="flex items-center gap-1.5 font-medium text-[#0F172A]">
                <Globe className="h-4 w-4 text-slate-400" />
                {job.company_name}
              </div>
              {job.location && (
                <div className="flex items-center gap-1.5">
                  <MapPin className="h-4 w-4 text-slate-400" />
                  {job.location}
                </div>
              )}
              <div className="flex items-center gap-1.5">
                <DollarSign className="h-4 w-4 text-slate-400" />
                {formatSalary(job.salary_min, job.salary_max, job.currency)}
              </div>
              {job.job_type && (
                <div className="flex items-center gap-1.5 capitalize">
                  <Briefcase className="h-4 w-4 text-slate-400" />
                  {job.job_type.replace('_', ' ')}
                </div>
              )}
              <div className="flex items-center gap-1.5">
                <Clock className="h-4 w-4 text-slate-400" />
                Posted {new Date(job.created_at).toLocaleDateString()}
              </div>
            </div>

            {job.tags && job.tags.length > 0 && (
              <div className="mt-6 flex flex-wrap gap-2">
                {job.tags.map((tag: string) => (
                  <Link
                    key={tag}
                    href={`/jobs/${job.category}/${tag}`}
                    className="rounded-full bg-slate-100 px-3 py-1 text-xs font-medium text-slate-600 hover:bg-slate-200"
                  >
                    {tag}
                  </Link>
                ))}
              </div>
            )}
          </div>

          <div className="prose prose-slate max-w-none">
            {/* Split description by newlines for basic formatting */}
            {job.description.split('\n').map((paragraph: string, idx: number) => (
              <p key={idx} className={paragraph.trim() === '' ? 'h-4' : 'mb-4'}>
                {paragraph}
              </p>
            ))}
          </div>
        </div>

        {/* Sidebar */}
        <div className="lg:col-span-1">
          <div className="sticky top-24 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
            <h3 className="text-lg font-semibold text-[#0F172A]">Apply for this role</h3>
            <p className="mt-2 text-sm text-slate-600">
              Apply via CLIVORA to securely share your profile and negotiate with $0 platform fees.
            </p>
            
            <div className="mt-6 space-y-3">
              {job.source_url ? (
                <a
                  href={job.source_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex w-full items-center justify-center gap-2 rounded-xl bg-[#0F766E] px-4 py-3 font-medium text-white hover:bg-[#0F766E]/90"
                >
                  Apply Externally
                  <ExternalLink className="h-4 w-4" />
                </a>
              ) : (
                <Link
                  href={`/connect?tab=talent&apply=${job.id}`}
                  className="flex w-full items-center justify-center gap-2 rounded-xl bg-[#0F766E] px-4 py-3 font-medium text-white hover:bg-[#0F766E]/90"
                >
                  Submit Proposal
                </Link>
              )}
            </div>

            <div className="mt-8 border-t border-slate-200 pt-6">
              <h4 className="font-medium text-[#0F172A]">About {job.company_name}</h4>
              {job.company_domain && (
                <a
                  href={`https://${job.company_domain}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="mt-2 flex items-center gap-1.5 text-sm text-[#0F766E] hover:underline"
                >
                  {job.company_domain}
                  <ExternalLink className="h-3 w-3" />
                </a>
              )}
            </div>
            
            <div className="mt-8 rounded-xl bg-slate-50 p-4">
              <div className="flex items-start gap-3">
                <div className="mt-0.5 rounded-full bg-[#0F766E]/10 p-1.5 text-[#0F766E]">
                  <DollarSign className="h-4 w-4" />
                </div>
                <div>
                  <h5 className="text-sm font-semibold text-[#0F172A]">100% Free for Freelancers</h5>
                  <p className="mt-1 text-xs text-slate-500">
                    CLIVORA charges $0 platform fees on your earnings. What you negotiate is what you keep.
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  );
}
