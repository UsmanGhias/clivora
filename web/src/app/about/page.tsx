import type { Metadata } from "next";
import Link from "next/link";
import { LegalPageShell } from "@/components/legal/LegalPageShell";
import { site } from "@/lib/site";
import { Code2, Rocket, Shield, Users } from "lucide-react";

export const metadata: Metadata = {
  title: `About - ${site.name}`,
  description: `About ${site.name} — an independently developed Freelancer OS from ${site.company.name}.`,
};

export default function AboutPage() {
  return (
    <LegalPageShell
      title={`About ${site.name}`}
      description={`An independently developed Freelancer OS from ${site.company.name}.`}
    >
      <p>
        <strong>{site.name}</strong> is an independent product created by{" "}
        <strong>{site.company.name}</strong> and founded by Muhammad Usman Khan,
        professionally known as Usman Ghias. It was created from a simple idea:
        freelancers should not need ten disconnected applications to manage one
        business.
      </p>

      <p>
        Launched in early access in July 2026, Clivora is being developed as a
        unified operating system for freelancers, independent professionals,
        small agencies, and their clients.
      </p>

      <h2>Our mission</h2>
      <p>
        To make running an independent business simpler, more organized, and
        more professional by bringing clients, projects, finances,
        communication, and growth tools into one connected platform.
      </p>

      <h2>Where we are today</h2>
      <p>
        Clivora is currently in active early development. Core features are
        available across web and Android, while additional capabilities—including
        AI assistance, marketplace improvements, cloud synchronization, and team
        collaboration—are being developed progressively.
      </p>

      <div className="not-prose my-8 grid gap-4 sm:grid-cols-2">
        {[
          {
            icon: Code2,
            title: "Crafted with care",
            text: "Every screen and workflow is designed for clarity and speed.",
          },
          {
            icon: Shield,
            title: "Privacy-minded",
            text: "We collect and process only what is required for authentication, sync, and communication.",
          },
          {
            icon: Users,
            title: "Built for independents",
            text: "Tuned for freelancers, consultants, small agencies, and their clients.",
          },
          {
            icon: Rocket,
            title: "Always improving",
            text: "Feedback from early users directly shapes the roadmap.",
          },
        ].map((item) => (
          <div key={item.title} className="rounded-2xl glass p-6">
            <item.icon className="mb-3 h-8 w-8 text-primary" />
            <h3 className="font-bold text-white">{item.title}</h3>
            <p className="mt-2 text-sm text-white/60">{item.text}</p>
          </div>
        ))}
      </div>

      <h2>Founder note</h2>
      <p>
        I built Clivora from my own experience working as a freelancer and
        software developer. I understand how difficult it is to manage clients,
        deadlines, invoices, communication, and growth across separate tools.
        Clivora is my attempt to create the workspace I always wanted to use.
      </p>
      <p>
        — Muhammad Usman Khan
        <br />
        Founder, {site.company.name} and Clivora
        <br />
        Professionally known as Usman Ghias
      </p>

      <h2>Company information</h2>
      <ul>
        <li>
          <strong>Company:</strong> {site.company.name}
        </li>
        <li>
          <strong>Website:</strong>{" "}
          <a href={site.company.url}>{site.company.url}</a>
        </li>
        <li>
          <strong>Product:</strong> {site.name} ({site.appPackage})
        </li>
        <li>
          <strong>Support:</strong>{" "}
          <a href={`mailto:${site.company.email}`}>{site.company.email}</a>
        </li>
      </ul>

      <h2>Get in touch</h2>
      <p>
        Have questions, feedback, or partnership inquiries? Visit our{" "}
        <Link href="/contact">contact page</Link> or email{" "}
        <a href={`mailto:${site.company.email}`}>{site.company.email}</a>.
      </p>
    </LegalPageShell>
  );
}
