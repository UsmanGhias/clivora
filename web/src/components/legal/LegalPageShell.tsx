import { MarketingNav } from "@/components/marketing/MarketingNav";
import { MarketingFooter } from "@/components/marketing/MarketingFooter";
import { site } from "@/lib/site";

interface LegalPageShellProps {
  children: React.ReactNode;
  title: string;
  description?: string;
  lastUpdated?: string;
}

/** Light legal chrome aligned with the marketing site. */
export function LegalPageShell({
  children,
  title,
  description,
  lastUpdated = "July 13, 2026",
}: LegalPageShellProps) {
  return (
    <div className="min-h-screen bg-[#F8FAFC] text-navy">
      <MarketingNav variant="light" />

      <main className="mx-auto max-w-4xl px-6 py-14 lg:py-16">
        <div className="mb-10">
          <p className="text-xs font-bold uppercase tracking-[0.16em] text-primary">
            {site.company.name}
          </p>
          <h1 className="mt-3 font-display text-3xl font-extrabold text-navy sm:text-4xl">
            {title}
          </h1>
          {description ? (
            <p className="mt-3 max-w-2xl text-base leading-relaxed text-slate-600">{description}</p>
          ) : null}
          <p className="mt-3 text-sm text-slate-400">Last updated: {lastUpdated}</p>
        </div>

        <article className="legal-prose rounded-3xl border border-slate-200 bg-white p-6 shadow-sm sm:p-10">
          {children}
        </article>
      </main>

      <MarketingFooter />
    </div>
  );
}
