import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { DocsShell } from "@/components/docs/DocsShell";
import { Markdown } from "@/components/docs/Markdown";
import { getDocBySlug, stripLeadingH1 } from "@/lib/docs";
import { site } from "@/lib/site";

type Props = { params: Promise<{ slug: string }> };

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const doc = getDocBySlug(slug);
  if (!doc) return { title: "Not found" };
  return {
    title: `${doc.meta.title} — Docs`,
    description: `CLIVORA documentation: ${doc.meta.title}`,
    openGraph: {
      title: `${doc.meta.title} — ${site.name} Docs`,
      url: `${site.url}/docs/${slug}`,
    },
  };
}

export function generateStaticParams() {
  return [
    { slug: "product-overview" },
    { slug: "user-guide" },
    { slug: "connect" },
    { slug: "plans-and-billing" },
    { slug: "web-and-android" },
    { slug: "architecture" },
    { slug: "ai-research-brief" },
  ];
}

export default async function DocPage({ params }: Props) {
  const { slug } = await params;
  const doc = getDocBySlug(slug);
  if (!doc) notFound();

  return (
    <DocsShell currentSlug={slug}>
      <div className="rounded-2xl border border-border bg-surface p-6 shadow-sm sm:p-10">
        <Markdown content={stripLeadingH1(doc.content)} />
        {slug === "ai-research-brief" && (
          <div className="mt-8 rounded-xl border border-primary/30 bg-primary/5 p-4">
            <p className="text-sm text-text-secondary">
              <strong className="text-navy">PDF version:</strong>{" "}
              <a
                href="/docs/CLIVORA-AI-Research-Brief.pdf"
                className="font-semibold text-primary hover:underline"
              >
                Download CLIVORA AI Research Brief (PDF)
              </a>{" "}
              — give this to your AI for GitHub repo research.
            </p>
          </div>
        )}
      </div>
    </DocsShell>
  );
}
