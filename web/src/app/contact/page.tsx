import type { Metadata } from "next";
import { LegalPageShell } from "@/components/legal/LegalPageShell";
import { site } from "@/lib/site";
import { Mail, MessageSquare, Clock } from "lucide-react";

export const metadata: Metadata = {
  title: `Contact - ${site.company.name}`,
  description: `Get in touch with the ${site.company.name} team for support, privacy, or business inquiries.`,
  alternates: { canonical: `${site.url}/contact` },
};

export default function ContactPage() {
  return (
    <LegalPageShell
      title="Contact Us"
      description={`We're here to help. Reach out for support, privacy requests, or general inquiries.`}
    >
      <p>
        Whether you need help with {site.name}, have a privacy request, or want
        to explore a partnership - the {site.company.name} team is ready to
        assist.
      </p>

      <div className="not-prose my-10 grid gap-6 sm:grid-cols-2">
        <div className="rounded-2xl border border-slate-200/90 bg-slate-50/60 p-6 shadow-xs hover:border-teal-500/40 hover:bg-white transition-all">
          <div className="mb-3 flex h-10 w-10 items-center justify-center rounded-xl bg-teal-50 text-teal-700">
            <Mail className="h-5 w-5" />
          </div>
          <h3 className="text-base font-bold text-navy">General Support</h3>
          <p className="mt-1.5 text-sm text-slate-600 leading-relaxed">
            App issues, feature questions, and account assistance.
          </p>
          <a
            href={`mailto:${site.company.email}`}
            className="mt-3 inline-block text-sm font-bold text-teal-700 hover:text-teal-800"
          >
            {site.company.email}
          </a>
        </div>

        <div className="rounded-2xl border border-slate-200/90 bg-slate-50/60 p-6 shadow-xs hover:border-teal-500/40 hover:bg-white transition-all">
          <div className="mb-3 flex h-10 w-10 items-center justify-center rounded-xl bg-teal-50 text-teal-700">
            <MessageSquare className="h-5 w-5" />
          </div>
          <h3 className="text-base font-bold text-navy">Privacy and Data</h3>
          <p className="mt-1.5 text-sm text-slate-600 leading-relaxed">
            Privacy requests, data safety, and GDPR inquiries.
          </p>
          <a
            href={`mailto:${site.company.privacyEmail}`}
            className="mt-3 inline-block text-sm font-bold text-teal-700 hover:text-teal-800"
          >
            {site.company.privacyEmail}
          </a>
        </div>

        <div className="rounded-2xl border border-slate-200/90 bg-slate-50/60 p-6 shadow-xs hover:border-teal-500/40 hover:bg-white transition-all">
          <div className="mb-3 flex h-10 w-10 items-center justify-center rounded-xl bg-teal-50 text-teal-700">
            <Mail className="h-5 w-5" />
          </div>
          <h3 className="text-base font-bold text-navy">Legal</h3>
          <p className="mt-1.5 text-sm text-slate-600 leading-relaxed">
            Terms, licensing, and compliance matters.
          </p>
          <a
            href={`mailto:${site.company.legalEmail}`}
            className="mt-3 inline-block text-sm font-bold text-teal-700 hover:text-teal-800"
          >
            {site.company.legalEmail}
          </a>
        </div>

        <div className="rounded-2xl border border-slate-200/90 bg-slate-50/60 p-6 shadow-xs hover:border-teal-500/40 hover:bg-white transition-all">
          <div className="mb-3 flex h-10 w-10 items-center justify-center rounded-xl bg-teal-50 text-teal-700">
            <Clock className="h-5 w-5" />
          </div>
          <h3 className="text-base font-bold text-navy">Response Time</h3>
          <p className="mt-1.5 text-sm text-slate-600 leading-relaxed">
            We typically respond within 1-2 business days. Direct support available.
          </p>
        </div>
      </div>

      <h2>Company Details</h2>
      <ul>
        <li>
          <strong>Developer:</strong> {site.company.name}
        </li>
        <li>
          <strong>Website:</strong>{" "}
          <a href={site.company.url}>{site.company.url}</a>
        </li>
        <li>
          <strong>App:</strong> {site.name}
        </li>
        <li>
          <strong>Package ID:</strong> {site.appPackage}
        </li>
      </ul>

      <h2>Before You Contact Us</h2>
      <p>Check these resources - your answer might already be there:</p>
      <ul>
        <li>
          <a href="/support">Support & FAQ</a> - Common questions and
          troubleshooting
        </li>
        <li>
          <a href="/delete-account">Account Deletion</a> - How to remove your
          data
        </li>
        <li>
          <a href="/privacy">Privacy Policy</a> - How we handle your data
        </li>
        <li>
          <a href="/data-safety">Data Safety</a> - Data collection summary
        </li>
      </ul>

      <h2>Business Inquiries</h2>
      <p>
        For partnerships, press, or enterprise inquiries, email{" "}
        <a href={`mailto:${site.company.email}?subject=Business%20Inquiry`}>
          {site.company.email}
        </a>{" "}
        with the subject line &quot;Business Inquiry&quot;.
      </p>
    </LegalPageShell>
  );
}
