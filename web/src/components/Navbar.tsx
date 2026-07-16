"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { motion, AnimatePresence } from "framer-motion";
import { Menu, X } from "lucide-react";
import { Logo } from "./ui/Logo";
import { cn } from "@/lib/utils";

const navLinks = [
  { label: "Features", href: "/#features" },
  { label: "Connect", href: "/connect" },
  { label: "Docs", href: "/docs" },
  { label: "Pricing", href: "/#pricing" },
  { label: "FAQ", href: "/#faq" },
];

export function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 20);
    window.addEventListener("scroll", onScroll);
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  return (
    <>
      <motion.header
        initial={{ y: -100, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ duration: 0.6, ease: [0.22, 1, 0.36, 1] }}
        className={cn(
          "fixed top-0 left-0 right-0 z-50 transition-all duration-300",
          scrolled
            ? "glass-strong py-3 shadow-lg shadow-black/20"
            : "bg-transparent py-5"
        )}
      >
        <div className="mx-auto flex max-w-7xl items-center justify-between gap-3 px-5 sm:px-6 lg:px-8">
          <Link href="/" aria-label="CLIVORA Home">
            <Logo size="sm" />
          </Link>

          <nav className="hidden items-center gap-8 lg:flex">
            {navLinks.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                className="text-sm font-medium text-white/70 transition-colors hover:text-white"
              >
                {link.label}
              </Link>
            ))}
          </nav>

          <div className="hidden items-center gap-4 lg:flex">
            <Link
              href="/connect"
              className="text-sm font-medium text-white/70 transition-colors hover:text-white"
            >
              Marketplace
            </Link>
            <Link
              href="/login"
              className="text-sm font-medium text-white/70 transition-colors hover:text-white"
            >
              Sign in
            </Link>
            <Link
              href="/pro"
              className="text-sm font-medium text-white/70 transition-colors hover:text-white"
            >
              Get Pro
            </Link>
            <motion.a
              href="/signup"
              whileHover={{ scale: 1.03 }}
              whileTap={{ scale: 0.98 }}
              className="rounded-full bg-primary px-5 py-2.5 text-sm font-semibold text-white shadow-lg shadow-primary/25 transition-shadow hover:shadow-primary/40"
            >
              Get Started Free
            </motion.a>
          </div>

          <button
            className="lg:hidden text-white"
            onClick={() => setMobileOpen(!mobileOpen)}
            aria-label="Toggle menu"
          >
            {mobileOpen ? <X size={24} /> : <Menu size={24} />}
          </button>
        </div>
      </motion.header>

      <AnimatePresence>
        {mobileOpen && (
          <motion.div
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            className="fixed inset-x-0 top-[72px] z-40 glass-strong border-t border-white/10 p-6 lg:hidden"
          >
            <nav className="flex flex-col gap-4">
              {navLinks.map((link) => (
                <Link
                  key={link.href}
                  href={link.href}
                  onClick={() => setMobileOpen(false)}
                  className="text-lg font-medium text-white/80 py-2"
                >
                  {link.label}
                </Link>
              ))}
              <Link
                href="/connect"
                onClick={() => setMobileOpen(false)}
                className="text-lg font-medium text-white/80 py-2"
              >
                Marketplace
              </Link>
              <Link
                href="/pro"
                onClick={() => setMobileOpen(false)}
                className="text-lg font-medium text-white/80 py-2"
              >
                Get Pro
              </Link>
              <Link
                href="/login"
                onClick={() => setMobileOpen(false)}
                className="text-lg font-medium text-white/80 py-2"
              >
                Sign in
              </Link>
              <Link
                href="/signup"
                onClick={() => setMobileOpen(false)}
                className="mt-2 rounded-full bg-primary px-5 py-3 text-center font-semibold text-white"
              >
                Get Started Free
              </Link>
            </nav>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
}
