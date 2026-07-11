import Link from "next/link";
import { Logo } from "@/components/ui/Logo";
import { DOC_CATALOG } from "@/lib/docs";
import { site } from "@/lib/site";

export function DocsShell({
  currentSlug,
  children,
}: {
  currentSlug: string;
  children: React.ReactNode;
}) {
  const sorted = [...DOC_CATALOG].sort((a, b) => a.order - b.order);

  return (
    <div className="min-h-screen bg-background text-text-primary">
      <header className="sticky top-0 z-40 border-b border-border bg-navy text-white">
        <div className="mx-auto flex max-w-6xl items-center justify-between gap-4 px-4 py-3">
          <div className="flex items-center gap-4">
            <Link href="/" aria-label="CLIVORA home">
              <Logo size="sm" variant="onDark" />
            </Link>
            <span className="hidden text-sm text-white/60 sm:inline">Help center</span>
          </div>
          <div className="flex items-center gap-2 text-sm">
            <Link href="/connect" className="rounded-lg px-3 py-1.5 text-white/80 hover:bg-white/10">
              Connect
            </Link>
            <Link href="/app" className="rounded-lg px-3 py-1.5 text-white/80 hover:bg-white/10">
              Web app
            </Link>
            <Link
              href="/support"
              className="hidden rounded-lg bg-primary px-3 py-1.5 font-semibold text-white sm:inline"
            >
              Support
            </Link>
          </div>
        </div>
      </header>

      <div className="mx-auto flex max-w-6xl gap-8 px-4 py-8">
        <aside className="hidden w-56 shrink-0 md:block">
          <nav className="sticky top-20 space-y-1">
            {sorted.map((doc) => (
              <Link
                key={doc.slug}
                href={doc.slug === "index" ? "/docs" : `/docs/${doc.slug}`}
                className={`block rounded-lg px-3 py-2 text-sm font-medium transition ${
                  currentSlug === doc.slug
                    ? "bg-primary/10 text-primary-dark"
                    : "text-text-secondary hover:bg-surface hover:text-navy"
                }`}
              >
                {doc.title}
              </Link>
            ))}
            <div className="mt-6 border-t border-border pt-4">
              <p className="px-3 text-xs font-bold uppercase tracking-wide text-text-muted">
                Resources
              </p>
              <Link
                href="/support"
                className="mt-2 block rounded-lg px-3 py-2 text-sm text-text-secondary hover:bg-surface"
              >
                Contact support
              </Link>
              <Link
                href={site.playStoreUrl}
                className="block rounded-lg px-3 py-2 text-sm text-text-secondary hover:bg-surface"
              >
                Android app
              </Link>
            </div>
          </nav>
        </aside>

        <main className="min-w-0 flex-1">{children}</main>
      </div>
    </div>
  );
}
