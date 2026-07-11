"use client";

import Link from "next/link";
import { ArrowLeft } from "lucide-react";
import { Logo } from "@/components/ui/Logo";
import { Breadcrumbs, type Crumb } from "@/components/app/Breadcrumbs";
import { SmartAppCtaButton } from "@/components/app/SmartAppCta";
import { cn } from "@/lib/utils";

/**
 * Compact shared chrome for Connect / Pro, no tall empty header band.
 */
export function SubPageChrome({
  title,
  crumbs,
  backHref = "/app",
  backLabel = "Back to app",
  isClient = false,
  showOpenApp = true,
  children,
  rightSlot,
}: {
  title?: string;
  crumbs: Crumb[];
  backHref?: string;
  backLabel?: string;
  isClient?: boolean;
  showOpenApp?: boolean;
  children: React.ReactNode;
  rightSlot?: React.ReactNode;
}) {
  const headerBg = isClient ? "bg-client-header" : "bg-navy";

  return (
    <div className={cn("min-h-screen bg-background text-text-primary", isClient && "theme-client")}>
      <header className={cn("sticky top-0 z-40 border-b border-white/10 text-white shadow-lg", headerBg)}>
        <div className="mx-auto flex max-w-6xl items-center justify-between gap-3 px-4 py-2.5">
          <div className="flex min-w-0 items-center gap-3">
            <Link href={backHref.startsWith("/app") ? "/app" : "/"} aria-label="CLIVORA">
              <Logo size="sm" variant="onDark" />
            </Link>
            <div className="hidden min-w-0 sm:block">
              <Breadcrumbs items={crumbs} light />
              {title && (
                <p className="truncate text-sm font-bold tracking-tight text-white/95">{title}</p>
              )}
            </div>
          </div>
          <div className="flex shrink-0 items-center gap-2">
            <Link
              href={backHref}
              className="inline-flex items-center gap-1 rounded-full bg-white/10 px-3 py-1.5 text-xs font-semibold text-white/90 hover:bg-white/15"
            >
              <ArrowLeft className="h-3.5 w-3.5" />
              <span className="hidden xs:inline sm:inline">{backLabel.replace("Back to ", "")}</span>
              <span className="sm:hidden">Back</span>
            </Link>
            {rightSlot}
            {showOpenApp && <SmartAppCtaButton size="sm" />}
          </div>
        </div>
        <div className="border-t border-white/5 px-4 py-1.5 sm:hidden">
          <Breadcrumbs items={crumbs} light />
        </div>
      </header>
      <main className="mx-auto max-w-6xl px-4 py-6 sm:py-8">{children}</main>
    </div>
  );
}
