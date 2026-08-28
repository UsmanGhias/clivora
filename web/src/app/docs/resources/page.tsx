import type { Metadata } from "next";
import Link from "next/link";
import { FileText, Download, ExternalLink, Shield, Calculator, FileCheck } from "lucide-react";

export const metadata: Metadata = {
  title: "Free Freelancer Resources & Templates",
  description:
    "Download free contract templates, scope of work documents, NDAs, rate calculators, and more. Everything you need to run a professional freelance business.",
  openGraph: {
    title: "Free Freelancer Resources — CLIVORA",
    description: "Professional templates and tools for freelancers. 100% free, no signup required.",
  },
};

interface Resource {
  title: string;
  description: string;
  category: string;
  icon: React.ComponentType<{ className?: string }>;
  formats: string[];
  downloadUrl: string;
}

const resources: Resource[] = [
  {
    title: "Freelance Service Contract Template",
    description:
      "A comprehensive, lawyer-reviewed contract template covering scope, payment terms, intellectual property, confidentiality, and termination clauses. Ready to customize for any project.",
    category: "Contracts",
    icon: FileText,
    formats: ["DOCX", "PDF"],
    downloadUrl: "#", // Will be replaced with Google Drive / MediaFire links
  },
  {
    title: "Scope of Work (SOW) Template",
    description:
      "Define project deliverables, milestones, timelines, and acceptance criteria. Prevents scope creep and keeps both parties aligned.",
    category: "Project Management",
    icon: FileCheck,
    formats: ["DOCX", "PDF"],
    downloadUrl: "#",
  },
  {
    title: "Non-Disclosure Agreement (NDA)",
    description:
      "Mutual and one-way NDA templates for protecting confidential information during client engagements and pre-project discussions.",
    category: "Legal",
    icon: Shield,
    formats: ["DOCX", "PDF"],
    downloadUrl: "#",
  },
  {
    title: "Freelancer Rate Calculator",
    description:
      "Calculate your ideal hourly, daily, and project rates based on expenses, desired salary, utilization rate, and profit margin. Works for any currency.",
    category: "Finance",
    icon: Calculator,
    formats: ["XLSX", "Google Sheets"],
    downloadUrl: "#",
  },
  {
    title: "Client Onboarding Checklist",
    description:
      "Step-by-step checklist for onboarding new clients: from initial discovery call to signed contract, first invoice, and project kickoff.",
    category: "Operations",
    icon: FileCheck,
    formats: ["PDF", "Notion"],
    downloadUrl: "#",
  },
  {
    title: "Invoice Template Pack",
    description:
      "Professional invoice templates with itemized billing, tax calculations, payment terms, and late fee clauses. Branded with your business identity.",
    category: "Finance",
    icon: FileText,
    formats: ["DOCX", "PDF", "XLSX"],
    downloadUrl: "#",
  },
];

const categories = [...new Set(resources.map((r) => r.category))];

export default function ResourcesPage() {
  return (
    <main className="min-h-screen bg-white">
      {/* Hero */}
      <section className="bg-gradient-to-br from-[#0F172A] to-[#0F766E] text-white py-20 px-4">
        <div className="max-w-4xl mx-auto text-center">
          <h1 className="text-4xl md:text-5xl font-extrabold tracking-tight">
            Free Freelancer Resources
          </h1>
          <p className="mt-4 text-lg text-gray-300 max-w-2xl mx-auto">
            Professional templates, calculators, and tools to run your freelance business.
            100% free, no signup required. Built by freelancers, for freelancers.
          </p>
          <div className="mt-6 flex items-center justify-center gap-2 text-sm text-teal-200">
            <Download className="w-4 h-4" />
            <span>All resources are free to download and customize</span>
          </div>
        </div>
      </section>

      {/* Category Filter */}
      <section className="border-b border-gray-200">
        <div className="max-w-6xl mx-auto px-4 py-4 flex flex-wrap gap-2">
          <span className="px-4 py-2 rounded-full bg-teal-700 text-white text-sm font-medium">
            All Resources
          </span>
          {categories.map((cat) => (
            <span
              key={cat}
              className="px-4 py-2 rounded-full bg-gray-100 text-gray-700 text-sm font-medium hover:bg-gray-200 cursor-pointer transition-colors"
            >
              {cat}
            </span>
          ))}
        </div>
      </section>

      {/* Resource Grid */}
      <section className="max-w-6xl mx-auto px-4 py-12">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {resources.map((resource) => {
            const Icon = resource.icon;
            return (
              <div
                key={resource.title}
                className="border border-gray-200 rounded-2xl p-6 hover:shadow-lg hover:border-teal-200 transition-all group"
              >
                <div className="flex items-start gap-4">
                  <div className="w-12 h-12 rounded-xl bg-teal-50 text-teal-700 flex items-center justify-center flex-shrink-0 group-hover:bg-teal-100 transition-colors">
                    <Icon className="w-6 h-6" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <span className="text-xs font-semibold text-teal-700 uppercase tracking-wider">
                      {resource.category}
                    </span>
                    <h3 className="text-lg font-bold text-gray-900 mt-1 leading-snug">
                      {resource.title}
                    </h3>
                  </div>
                </div>
                <p className="text-sm text-gray-600 mt-4 leading-relaxed">
                  {resource.description}
                </p>
                <div className="mt-4 flex items-center justify-between">
                  <div className="flex gap-1.5">
                    {resource.formats.map((fmt) => (
                      <span
                        key={fmt}
                        className="px-2 py-0.5 text-xs font-medium bg-gray-100 text-gray-600 rounded"
                      >
                        {fmt}
                      </span>
                    ))}
                  </div>
                  <a
                    href={resource.downloadUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center gap-1.5 text-sm font-semibold text-teal-700 hover:text-teal-900 transition-colors"
                  >
                    Download
                    <ExternalLink className="w-3.5 h-3.5" />
                  </a>
                </div>
              </div>
            );
          })}
        </div>
      </section>

      {/* CTA */}
      <section className="bg-gray-50 py-16 px-4">
        <div className="max-w-2xl mx-auto text-center">
          <h2 className="text-2xl font-bold text-gray-900">
            Want to automate your freelance workflow?
          </h2>
          <p className="text-gray-600 mt-3">
            CLIVORA gives you CRM, invoicing, project management, and a client marketplace — all for
            $0. No commissions, no hidden fees.
          </p>
          <div className="mt-6 flex flex-col sm:flex-row gap-3 justify-center">
            <Link
              href="/signup"
              className="px-6 py-3 bg-teal-700 text-white font-semibold rounded-xl hover:bg-teal-800 transition-colors"
            >
              Get Started Free
            </Link>
            <Link
              href="/features"
              className="px-6 py-3 border border-gray-300 text-gray-700 font-medium rounded-xl hover:bg-gray-100 transition-colors"
            >
              See All Features
            </Link>
          </div>
        </div>
      </section>
    </main>
  );
}
