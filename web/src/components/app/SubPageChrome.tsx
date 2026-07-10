"use client";

import Link from "next/link";
import { ArrowLeft } from "lucide-react";
import { Logo } from "@/components/ui/Logo";
import { Breadcrumbs, type Crumb } from "@/components/app/Breadcrumbs";
import { SmartAppCtaButton } from "@/components/app/SmartAppCta";
import { cn } from "@/lib/utils";

/**
 * Shared chrome for pages outside AppShell (Connect, Pro, manage).
 * Always provides: logo, back link, breadcrumbs, optional open-app CTA.
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
      <header className={cn("border-b border-white/10 text-white", headerBg)}>
        <div className="mx-auto flex max-w-6xl flex-col gap-3 px-4 py-3 sm:py-4">
          <div className="flex items-center justify-between gap-3">
            <Link href={backHref.startsWith("/app") ? "/app" : "/"} aria-label="CLIVORA home">
              <Logo size="sm" variant="onDark" />
            </Link>
            <div className="flex items-center gap-2">
              {rightSlot}
              {showOpenApp && <SmartAppCtaButton size="sm" />}
            </div>
          </div>
          <div className="flex flex-wrap items-center justify-between gap-2">
            <div className="space-y-1">
              <Link
                href={backHref}
                className="inline-flex items-center gap-1.5 text-xs font-semibold text-white/75 hover:text-white"
              >
                <ArrowLeft className="h-3.5 w-3.5" />
                {backLabel}
              </Link>
              <Breadcrumbs items={crumbs} light />
              {title && <h1 className="text-lg font-extrabold tracking-tight sm:text-xl">{title}</h1>}
            </div>
          </div>
        </div>
      </header>
      <main className="mx-auto max-w-6xl px-4 py-8">{children}</main>
    </div>
  );
}
