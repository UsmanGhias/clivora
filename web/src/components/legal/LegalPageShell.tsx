import Link from "next/link";
import { Logo } from "@/components/ui/Logo";
import { site } from "@/lib/site";

interface LegalPageShellProps {
  children: React.ReactNode;
  title: string;
  description?: string;
  lastUpdated?: string;
}

export function LegalPageShell({
  children,
  title,
  description,
  lastUpdated = "July 3, 2026",
}: LegalPageShellProps) {
  return (
    <div className="min-h-screen bg-dark-bg">
      <header className="border-b border-white/5 glass-strong">
        <div className="mx-auto flex max-w-4xl items-center justify-between px-6 py-5">
          <Link href="/" aria-label="CLIVORA Home">
            <Logo size="sm" />
          </Link>
          <Link
            href="/"
            className="text-sm font-medium text-white/60 transition-colors hover:text-white"
          >
            Back to Home
          </Link>
        </div>
      </header>

      <main className="mx-auto max-w-4xl px-6 py-16 lg:py-20">
        <div className="mb-10">
          <p className="text-sm font-semibold uppercase tracking-widest text-primary">
            {site.company.name}
          </p>
          <h1 className="mt-3 text-3xl font-bold text-white sm:text-4xl lg:text-5xl">
            {title}
          </h1>
          {description && (
            <p className="mt-4 text-lg text-white/60">{description}</p>
          )}
          <p className="mt-4 text-sm text-white/40">
            Last updated: {lastUpdated}
          </p>
        </div>

        <article className="legal-prose">{children}</article>
      </main>

      <footer className="border-t border-white/5 bg-dark-bg py-8">
        <div className="mx-auto flex max-w-4xl flex-col items-center justify-between gap-4 px-6 text-center sm:flex-row sm:text-left">
          <p className="text-sm text-white/40">
            &copy; {new Date().getFullYear()} {site.company.name}. {site.name}{" "}
            is a product of {site.company.name}.
          </p>
          <div className="flex flex-wrap justify-center gap-4 text-sm">
            <Link href="/privacy" className="text-white/50 hover:text-white">
              Privacy
            </Link>
            <Link href="/terms" className="text-white/50 hover:text-white">
              Terms
            </Link>
            <Link href="/contact" className="text-white/50 hover:text-white">
              Contact
            </Link>
          </div>
        </div>
      </footer>
    </div>
  );
}
