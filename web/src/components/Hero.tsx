"use client";

import Link from "next/link";
import { motion } from "framer-motion";
import { ArrowRight, Network, Smartphone } from "lucide-react";
import { PhoneMockup } from "./PhoneMockup";
import { site } from "@/lib/site";

/**
 * Marketing hero — one composition, brand-first, mobile Chrome friendly.
 * Phone mockup is desktop-only so the first viewport stays readable on phones.
 */
export function Hero() {
  return (
    <section className="relative min-h-[100svh] overflow-hidden pt-20 pb-10 sm:pt-24 sm:pb-14 lg:flex lg:min-h-[100svh] lg:items-center lg:pt-28 lg:pb-20">
      {/* Full-bleed atmosphere */}
      <div className="absolute inset-0 bg-dark-bg" />
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_120%_80%_at_50%_-10%,rgba(13,148,136,0.35),transparent_55%)]" />
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_60%_50%_at_100%_40%,rgba(15,118,110,0.2),transparent_50%)]" />
      <div className="absolute inset-0 grid-pattern opacity-40" />
      <div className="absolute inset-x-0 bottom-0 h-32 bg-gradient-to-t from-dark-bg to-transparent" />

      <div className="relative mx-auto w-full max-w-7xl px-5 sm:px-6 lg:px-8">
        <div className="grid items-center gap-8 lg:grid-cols-[1.05fr_0.95fr] lg:gap-10">
          <div className="text-center lg:text-left">
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.45 }}
              className="inline-flex items-center gap-2"
            >
              <span className="font-display text-2xl font-extrabold tracking-[0.18em] text-white sm:text-3xl lg:text-4xl">
                {site.name}
              </span>
            </motion.div>

            <motion.h1
              initial={{ opacity: 0, y: 18 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.55, delay: 0.06 }}
              className="mt-4 font-display text-[1.85rem] font-extrabold leading-[1.12] tracking-tight text-white sm:text-4xl lg:text-[3.25rem]"
            >
              Hire & get hired
              <br className="hidden sm:block" />{" "}
              <span className="text-gradient">inside your business OS</span>
            </motion.h1>

            <motion.p
              initial={{ opacity: 0, y: 18 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.55, delay: 0.12 }}
              className="mx-auto mt-4 max-w-md text-[15px] leading-relaxed text-white/65 sm:text-base lg:mx-0 lg:max-w-lg"
            >
              CLIVORA Connect is a private marketplace for freelancers and clients —
              plus CRM, projects, and invoices on web and Android. One account. No
              spammy open contact lists.
            </motion.p>

            <motion.div
              initial={{ opacity: 0, y: 18 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.55, delay: 0.2 }}
              className="mt-7 flex flex-col items-stretch gap-3 sm:mt-8 sm:flex-row sm:items-center sm:justify-center lg:justify-start"
            >
              <Link
                href="/connect"
                className="inline-flex items-center justify-center gap-2 rounded-2xl bg-primary px-6 py-3.5 text-sm font-bold text-white shadow-lg shadow-primary/25 transition hover:bg-primary-dark"
              >
                <Network className="h-4 w-4" />
                Open Connect
                <ArrowRight className="h-4 w-4" />
              </Link>
              <Link
                href="/signup"
                className="inline-flex items-center justify-center gap-2 rounded-2xl border border-white/20 bg-white/[0.06] px-6 py-3.5 text-sm font-bold text-white backdrop-blur transition hover:bg-white/10"
              >
                Start free on web
              </Link>
            </motion.div>

            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.45, delay: 0.3 }}
              className="mt-5 flex flex-wrap items-center justify-center gap-x-3 gap-y-1.5 text-sm text-white/50 lg:justify-start"
            >
              <Link href="/login" className="hover:text-white">
                Sign in
              </Link>
              <span className="text-white/20">·</span>
              <a
                href={site.playStoreUrl}
                target="_blank"
                rel="noreferrer"
                className="inline-flex items-center gap-1.5 hover:text-white"
              >
                <Smartphone className="h-3.5 w-3.5" />
                Android app
              </a>
              <span className="text-white/20">·</span>
              <Link href="/pro" className="hover:text-white">
                Pro from {site.pricing.proMonthlyLabel}/mo
              </Link>
            </motion.div>
          </div>

          <motion.div
            initial={{ opacity: 0, y: 28 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.22 }}
            className="relative hidden justify-center lg:flex"
          >
            <PhoneMockup />
          </motion.div>
        </div>

        {/* Mobile visual strip — not a second hero column */}
        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.35 }}
          className="mt-8 grid grid-cols-3 gap-2 border-t border-white/10 pt-6 text-center lg:hidden"
        >
          {[
            { k: "Private", v: "Contact unlock" },
            { k: "CRM", v: "After you match" },
            { k: "Plus", v: `${site.pricing.proPlusMonthlyLabel}/mo` },
          ].map((item) => (
            <div key={item.k}>
              <p className="font-display text-sm font-bold text-teal-200">{item.k}</p>
              <p className="mt-0.5 text-[11px] text-white/45">{item.v}</p>
            </div>
          ))}
        </motion.div>
      </div>
    </section>
  );
}
