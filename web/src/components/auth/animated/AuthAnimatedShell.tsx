"use client";

import Image from "next/image";
import Link from "next/link";
import { useEffect, useState, type ReactNode } from "react";
import { AuthAnimProvider } from "./AuthAnimContext";
import { AuthCharacters } from "./AuthCharacters";
import "./auth-animated.css";

const THEME_KEY = "clivora.auth-animated.theme";

function BrandMark({ className }: { className?: string }) {
  return (
    <span className={className ?? "aa-brand-mark"}>
      <Image src="/brand/clivora-mark.png" alt="" width={28} height={28} className="h-7 w-7" />
    </span>
  );
}

export function AuthAnimatedShell({ children }: { children: ReactNode }) {
  const [theme, setTheme] = useState<"light" | "dark">("light");

  useEffect(() => {
    // Default is always light/white. Only honor an explicit user toggle choice.
    try {
      const saved = localStorage.getItem(THEME_KEY);
      if (saved === "dark" || saved === "light") {
        setTheme(saved);
      }
    } catch {
      /* ignore */
    }
  }, []);

  function toggleTheme() {
    setTheme((prev) => {
      const next = prev === "dark" ? "light" : "dark";
      try {
        localStorage.setItem(THEME_KEY, next);
      } catch {
        /* ignore */
      }
      return next;
    });
  }

  return (
    <AuthAnimProvider>
      <div className={`auth-animated${theme === "dark" ? " theme-dark" : ""}`}>
        <main className="aa-page">
          <section className="aa-stage" aria-hidden={false}>
            <div className="aa-stage-top">
              <Link href="/" className="aa-brand">
                <BrandMark />
                <span className="aa-brand-text">
                  <span className="aa-brand-name">CLIVORA</span>
                  <span className="aa-brand-sub">Freelancer OS</span>
                </span>
              </Link>
              <div className="aa-stage-actions">
                <Link href="/" className="aa-stage-home">
                  Home
                </Link>
                <button
                  type="button"
                  className="aa-theme-toggle aa-theme-toggle-stage"
                  onClick={toggleTheme}
                  aria-label={theme === "dark" ? "Switch to light theme" : "Switch to dark theme"}
                  title="Toggle theme"
                >
                  {theme === "dark" ? (
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
                      <circle cx="12" cy="12" r="4" />
                      <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" />
                    </svg>
                  ) : (
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
                      <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
                    </svg>
                  )}
                </button>
              </div>
            </div>

            <div className="aa-stage-inner">
              <AuthCharacters />
            </div>

            <nav className="aa-footer-links aa-footer-links-desktop">
              <Link href="/privacy">Privacy Policy</Link>
              <Link href="/terms">Terms of Service</Link>
              <Link href="/support">Contact</Link>
            </nav>
          </section>

          <section className="aa-panel">
            <Link href="/" className="aa-back-home aa-back-home-desktop">
              ← Home
            </Link>
            <button
              type="button"
              className="aa-theme-toggle aa-theme-toggle-panel"
              onClick={toggleTheme}
              aria-label={theme === "dark" ? "Switch to light theme" : "Switch to dark theme"}
              title="Toggle theme"
            >
              {theme === "dark" ? (
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
                  <circle cx="12" cy="12" r="4" />
                  <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" />
                </svg>
              ) : (
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
                  <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
                </svg>
              )}
            </button>

            <div className="aa-panel-inner">
              {children}
              <nav className="aa-footer-links aa-footer-links-mobile">
                <Link href="/privacy">Privacy</Link>
                <Link href="/terms">Terms</Link>
                <Link href="/support">Contact</Link>
              </nav>
            </div>
          </section>
        </main>
      </div>
    </AuthAnimProvider>
  );
}
