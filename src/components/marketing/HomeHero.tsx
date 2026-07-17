"use client";

import Link from "next/link";
import { motion } from "framer-motion";
import { ArrowRight, Check, Sparkles } from "lucide-react";
import { marketing } from "@/lib/marketing";
import { ClientDashMock } from "./mockups/ClientDashMock";

export function HomeHero() {
  const h = marketing.hero;

  return (
    <section className="relative overflow-hidden pb-12 pt-8 sm:pb-16 sm:pt-10 lg:pb-24 lg:pt-14">
      <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(ellipse_80%_60%_at_10%_-10%,rgba(13,148,136,0.14),transparent_55%)]" />
      <div className="pointer-events-none absolute inset-x-0 bottom-0 h-24 bg-gradient-to-t from-[#F8FAFC] to-transparent lg:h-32" />

      <div className="relative mx-auto grid max-w-7xl items-center gap-10 px-4 sm:gap-12 sm:px-5 lg:grid-cols-[1fr_1.12fr] lg:gap-10 lg:px-8">
        <div className="text-center lg:text-left">
          <motion.p
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            className="font-display text-3xl font-extrabold tracking-[0.14em] text-navy sm:text-4xl lg:text-[2.75rem]"
          >
            {marketing.brand.name}
          </motion.p>
          <motion.p
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.04 }}
            className="mt-1 text-[11px] font-bold uppercase tracking-[0.22em] text-primary sm:text-xs"
          >
            {marketing.brand.productLine}
          </motion.p>

          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.08 }}
            className="mt-5 inline-flex items-center gap-2 rounded-full border border-teal-200 bg-teal-50 px-3.5 py-1.5 text-xs font-semibold text-primary"
          >
            <Sparkles className="h-3.5 w-3.5 shrink-0" />
            <span className="text-left">{h.badge}</span>
          </motion.div>

          <motion.h1
            initial={{ opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1 }}
            className="mt-5 font-display text-[1.85rem] font-extrabold leading-[1.12] tracking-tight text-navy sm:text-5xl lg:text-[3.35rem]"
          >
            {h.headline[0]}{" "}
            <span className="bg-gradient-to-r from-primary to-teal-400 bg-clip-text text-transparent">
              {h.headline[1]}
            </span>
          </motion.h1>

          <motion.p
            initial={{ opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.14 }}
            className="mx-auto mt-4 max-w-xl text-[15px] leading-relaxed text-slate-600 sm:mt-5 sm:text-lg lg:mx-0"
          >
            {h.body}
          </motion.p>

          <motion.div
            initial={{ opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.18 }}
            className="mt-7 flex flex-col gap-3 sm:mt-8 sm:flex-row sm:items-center sm:justify-center lg:justify-start"
          >
            <Link
              href={h.primaryCta.href}
              className="inline-flex min-h-12 items-center justify-center gap-2 rounded-xl bg-primary px-6 py-3.5 text-sm font-bold text-white shadow-lg shadow-primary/25 transition hover:bg-primary-dark"
            >
              {h.primaryCta.label}
              <ArrowRight className="h-4 w-4" />
            </Link>
            <Link
              href={h.secondaryCta.href}
              className="inline-flex min-h-12 items-center justify-center gap-2 rounded-xl border border-navy/15 bg-white px-6 py-3.5 text-sm font-bold text-navy transition hover:bg-slate-50"
            >
              {h.secondaryCta.label}
              <ArrowRight className="h-4 w-4" />
            </Link>
          </motion.div>

          <motion.ul
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.22 }}
            className="mt-6 flex flex-wrap items-center justify-center gap-x-5 gap-y-2 lg:justify-start"
          >
            {h.trusts.map((t) => (
              <li key={t} className="inline-flex items-center gap-1.5 text-sm font-medium text-slate-600">
                <Check className="h-4 w-4 text-emerald-500" strokeWidth={2.5} />
                {t}
              </li>
            ))}
          </motion.ul>
        </div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.65, delay: 0.12 }}
          className="relative mx-auto w-full max-w-xl lg:max-w-none"
          aria-hidden="true"
        >
          <div className="pointer-events-none absolute -inset-4 rounded-[2rem] bg-gradient-to-tr from-teal-100/40 to-slate-100/30 blur-2xl" />
          <div className="relative overflow-hidden rounded-2xl border border-slate-200/80 bg-white shadow-xl shadow-slate-200/50">
            <div className="max-h-[min(52vh,420px)] overflow-hidden sm:max-h-none">
              <ClientDashMock />
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  );
}
