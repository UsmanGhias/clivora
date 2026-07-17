"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { AnimatePresence, motion } from "framer-motion";
import { ChevronDown, Globe, Menu, X } from "lucide-react";
import { Logo } from "@/components/ui/Logo";
import { marketing } from "@/lib/marketing";
import { cn } from "@/lib/utils";

export function MarketingNav({ variant = "light" }: { variant?: "light" | "overlay" }) {
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const [openMenu, setOpenMenu] = useState<string | null>(null);
  const light = variant === "light";

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 12);
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  useEffect(() => {
    if (!mobileOpen) return;
    const prev = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    return () => {
      document.body.style.overflow = prev;
    };
  }, [mobileOpen]);

  return (
    <>
      <header
        className={cn(
          "sticky top-0 z-50 transition-all duration-300",
          light
            ? scrolled
              ? "border-b border-slate-200/80 bg-white/95 shadow-sm backdrop-blur-xl"
              : "border-b border-transparent bg-[#F8FAFC]/92 backdrop-blur-md"
            : scrolled
              ? "border-b border-white/10 bg-navy/90 backdrop-blur-xl"
              : "bg-transparent",
        )}
      >
        <div className="mx-auto flex h-14 max-w-7xl items-center justify-between gap-3 px-4 sm:h-[68px] sm:gap-4 sm:px-5 lg:px-8">
          <Link href="/" className="flex min-w-0 shrink-0 items-center gap-2 sm:gap-2.5" aria-label="CLIVORA Home">
            <Logo size="sm" showText={false} variant={light ? "onLight" : "onDark"} />
            <span className="flex min-w-0 flex-col leading-none">
              <span
                className={cn(
                  "font-display text-sm font-extrabold tracking-wide",
                  light ? "text-navy" : "text-white",
                )}
              >
                {marketing.brand.name}
              </span>
              <span className="hidden text-[9px] font-semibold uppercase tracking-[0.18em] text-primary xs:inline sm:inline">
                {marketing.brand.productLine}
              </span>
            </span>
          </Link>

          <nav className="hidden items-center gap-1 lg:flex" aria-label="Primary">
            {marketing.nav.links.map((link) => {
              const hasChildren = "children" in link && link.children?.length;
              return (
                <div
                  key={link.label}
                  className="relative"
                  onMouseEnter={() => hasChildren && setOpenMenu(link.label)}
                  onMouseLeave={() => setOpenMenu(null)}
                >
                  <Link
                    href={link.href}
                    className={cn(
                      "inline-flex items-center gap-1 rounded-lg px-3 py-2 text-sm font-medium transition-colors",
                      light
                        ? "text-slate-600 hover:bg-slate-100 hover:text-navy"
                        : "text-white/75 hover:bg-white/10 hover:text-white",
                    )}
                  >
                    {link.label}
                    {hasChildren ? <ChevronDown className="h-3.5 w-3.5 opacity-60" /> : null}
                  </Link>
                  {hasChildren && openMenu === link.label ? (
                    <div className="absolute left-0 top-full pt-2">
                      <div className="min-w-[200px] rounded-xl border border-slate-200 bg-white p-2 shadow-xl shadow-slate-900/10">
                        {link.children!.map((child) => (
                          <Link
                            key={child.href + child.label}
                            href={child.href}
                            className="block rounded-lg px-3 py-2 text-sm text-slate-600 transition hover:bg-teal-50 hover:text-navy"
                          >
                            {child.label}
                          </Link>
                        ))}
                      </div>
                    </div>
                  ) : null}
                </div>
              );
            })}
          </nav>

          <div className="hidden items-center gap-3 lg:flex">
            <span
              className={cn(
                "inline-flex items-center gap-1.5 rounded-lg px-2.5 py-2 text-sm font-medium",
                light ? "text-slate-500" : "text-white/70",
              )}
              aria-hidden="true"
            >
              <Globe className="h-4 w-4" />
              {marketing.nav.locale}
            </span>
            <Link
              href={marketing.nav.login.href}
              className={cn(
                "text-sm font-semibold",
                light ? "text-navy hover:text-primary" : "text-white/80 hover:text-white",
              )}
            >
              {marketing.nav.login.label}
            </Link>
            <Link
              href={marketing.nav.cta.href}
              className={cn(
                "rounded-xl px-4 py-2.5 text-sm font-bold transition",
                light
                  ? "bg-navy text-white hover:bg-navy/90"
                  : "bg-white text-navy hover:bg-white/90",
              )}
            >
              {marketing.nav.cta.label}
            </Link>
          </div>

          <button
            type="button"
            className={cn(
              "inline-flex h-11 w-11 items-center justify-center rounded-xl lg:hidden",
              light ? "text-navy hover:bg-slate-100" : "text-white hover:bg-white/10",
            )}
            onClick={() => setMobileOpen((v) => !v)}
            aria-expanded={mobileOpen}
            aria-controls="marketing-mobile-nav"
            aria-label={mobileOpen ? "Close menu" : "Open menu"}
          >
            {mobileOpen ? <X size={22} /> : <Menu size={22} />}
          </button>
        </div>
      </header>

      <AnimatePresence>
        {mobileOpen ? (
          <motion.div
            id="marketing-mobile-nav"
            initial={{ opacity: 0, y: -8 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -8 }}
            className="fixed inset-x-0 top-14 z-40 max-h-[calc(100svh-3.5rem)] overflow-y-auto border-b border-slate-200 bg-white p-4 pb-[max(1.25rem,env(safe-area-inset-bottom))] shadow-xl sm:top-[68px] sm:max-h-[calc(100svh-68px)] sm:p-5 lg:hidden"
          >
            <nav className="flex flex-col gap-1" aria-label="Mobile">
              {marketing.nav.links.map((link) => (
                <div key={link.label} className="border-b border-slate-100 py-2">
                  <Link
                    href={link.href}
                    onClick={() => setMobileOpen(false)}
                    className="block py-2.5 text-base font-semibold text-navy"
                  >
                    {link.label}
                  </Link>
                  {"children" in link && link.children
                    ? link.children.map((child) => (
                        <Link
                          key={child.href + child.label}
                          href={child.href}
                          onClick={() => setMobileOpen(false)}
                          className="block py-2 pl-3 text-sm text-slate-500"
                        >
                          {child.label}
                        </Link>
                      ))
                    : null}
                </div>
              ))}
              <Link
                href={marketing.nav.login.href}
                onClick={() => setMobileOpen(false)}
                className="mt-3 py-3 text-base font-semibold text-navy"
              >
                {marketing.nav.login.label}
              </Link>
              <Link
                href={marketing.nav.cta.href}
                onClick={() => setMobileOpen(false)}
                className="mt-1 inline-flex min-h-12 items-center justify-center rounded-xl bg-navy px-4 py-3 text-center text-sm font-bold text-white"
              >
                {marketing.nav.cta.label}
              </Link>
            </nav>
          </motion.div>
        ) : null}
      </AnimatePresence>
    </>
  );
}
