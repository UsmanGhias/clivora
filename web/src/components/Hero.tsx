"use client";

import Link from "next/link";
import { motion } from "framer-motion";
import { ArrowRight, Smartphone, Network } from "lucide-react";
import { PhoneMockup } from "./PhoneMockup";
import { site } from "@/lib/site";

/**
 * Marketing hero — one composition, brand-first, mobile Chrome friendly.
 * Phone mockup is desktop-only so the first viewport stays readable on phones.
 */
export function Hero() {
  return (
    <section className="relative overflow-hidden pt-24 pb-12 sm:pt-28 sm:pb-16 lg:pt-32 lg:pb-24">
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top,_rgba(13,148,136,0.18),_transparent_55%)]" />
      <div className="absolute inset-0 bg-[linear-gradient(180deg,rgba(15,23,42,0.2),transparent_40%)]" />

      <div className="relative mx-auto max-w-7xl px-5 sm:px-6 lg:px-8">
        <div className="grid items-center gap-10 lg:grid-cols-2 lg:gap-12">
          <div className="text-center lg:text-left">
            <motion.p
              initial={{ opacity: 0, y: 12 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.45 }}
              className="text-sm font-extrabold uppercase tracking-[0.28em] text-teal-300"
            >
              {site.name}
            </motion.p>

            <motion.h1
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.55, delay: 0.05 }}
              className="mt-3 text-[2.15rem] font-extrabold leading-[1.1] tracking-tight text-white sm:text-5xl lg:text-6xl"
            >
              Run your freelance
              <br />
              <span className="bg-gradient-to-r from-teal-300 via-teal-200 to-emerald-300 bg-clip-text text-transparent">
                business OS
              </span>
            </motion.h1>

            <motion.p
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.55, delay: 0.12 }}
              className="mx-auto mt-4 max-w-lg text-base leading-relaxed text-white/65 sm:text-lg lg:mx-0"
            >
              Clients, projects, invoices, and{" "}
              <strong className="font-semibold text-white/90">CLIVORA Connect</strong> — one
              account on web and Android. Built for freelancers and the clients who hire them.
            </motion.p>

            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.55, delay: 0.2 }}
              className="mt-8 flex flex-col items-stretch gap-3 sm:flex-row sm:items-center sm:justify-center lg:justify-start"
            >
              <Link
                href="/signup"
                className="inline-flex items-center justify-center gap-2 rounded-full bg-primary px-7 py-3.5 text-sm font-bold text-white shadow-lg shadow-primary/30"
              >
                Start free
                <ArrowRight className="h-4 w-4" />
              </Link>
              <Link
                href="/connect"
                className="inline-flex items-center justify-center gap-2 rounded-full border border-white/20 bg-white/5 px-7 py-3.5 text-sm font-bold text-white backdrop-blur"
              >
                <Network className="h-4 w-4 text-teal-300" />
                Open Connect
              </Link>
            </motion.div>

            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.5, delay: 0.3 }}
              className="mt-5 flex flex-wrap items-center justify-center gap-x-4 gap-y-2 text-sm text-white/55 lg:justify-start"
            >
              <Link href="/login" className="hover:text-white">
                Sign in
              </Link>
              <span className="text-white/25">·</span>
              <a
                href={site.playStoreUrl}
                target="_blank"
                rel="noreferrer"
                className="inline-flex items-center gap-1.5 hover:text-white"
              >
                <Smartphone className="h-3.5 w-3.5" />
                Get Android app
              </a>
              <span className="text-white/25">·</span>
              <Link href="/pro" className="hover:text-white">
                Pro from {site.pricing.proMonthlyLabel}/mo
              </Link>
            </motion.div>

            <motion.ul
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.5, delay: 0.38 }}
              className="mt-8 grid grid-cols-3 gap-2 text-center lg:max-w-md lg:text-left"
            >
              {[
                { k: "Web", v: "Live CRM" },
                { k: "App", v: "Offline" },
                { k: "Plus", v: "Connect" },
              ].map((item) => (
                <li
                  key={item.k}
                  className="rounded-2xl border border-white/10 bg-white/[0.04] px-2 py-3"
                >
                  <p className="text-sm font-extrabold text-white">{item.k}</p>
                  <p className="text-[11px] text-white/50">{item.v}</p>
                </li>
              ))}
            </motion.ul>
          </div>

          {/* Desktop visual only — keeps mobile first viewport clean */}
          <motion.div
            initial={{ opacity: 0, y: 24 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.25 }}
            className="relative hidden justify-center lg:flex"
          >
            <PhoneMockup />
          </motion.div>
        </div>
      </div>
    </section>
  );
}
