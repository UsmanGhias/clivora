"use client";

import Link from "next/link";
import { motion } from "framer-motion";
import { ArrowUpRight, Users } from "lucide-react";
import { marketing } from "@/lib/marketing";
import { ClientDashMock } from "./mockups/ClientDashMock";

export function HomeHero() {
  const h = marketing.hero;

  return (
    <section className="hero-asymmetric relative overflow-hidden pb-14 pt-8 sm:pb-20 lg:pb-28 lg:pt-12">
      <div className="hero-ink pointer-events-none absolute inset-0" aria-hidden />
      <div
        className="pointer-events-none absolute -right-24 top-16 hidden h-[28rem] w-[28rem] rounded-[40%_60%_55%_45%] bg-teal-200/30 blur-3xl lg:block"
        aria-hidden
      />

      <div className="relative mx-auto max-w-7xl px-5 lg:px-8">
        <div className="grid items-end gap-10 lg:grid-cols-[minmax(0,0.92fr)_minmax(0,1.08fr)] lg:gap-6">
          <div className="lg:pb-8 lg:pr-4">
            <motion.div
              initial={{ opacity: 0, x: -12 }}
              animate={{ opacity: 1, x: 0 }}
              className="inline-flex items-center gap-2 border-l-2 border-teal-500 pl-3"
            >
              <Users className="h-3.5 w-3.5 text-teal-700" />
              <p className="text-[11px] font-bold uppercase tracking-[0.16em] text-teal-800">
                {h.badge}
              </p>
            </motion.div>

            <motion.h1
              initial={{ opacity: 0, y: 18 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.04, duration: 0.55 }}
              className="mt-5 font-display text-[2.35rem] font-extrabold leading-[1.05] tracking-tight text-navy sm:text-5xl lg:text-[3.4rem]"
            >
              <span className="block">{h.headline[0]}</span>
              <span className="hero-mark mt-1 inline-block">{h.headline[1]}</span>
            </motion.h1>

            <motion.p
              initial={{ opacity: 0, y: 14 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.1 }}
              className="mt-5 max-w-[36rem] text-[15px] leading-relaxed text-slate-600 sm:text-lg"
            >
              {h.body}
            </motion.p>

            <motion.div
              initial={{ opacity: 0, y: 14 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.16 }}
              className="mt-8 flex flex-col gap-3 sm:flex-row sm:items-stretch"
            >
              <Link
                href={h.primaryCta.href}
                className="group inline-flex min-h-12 items-center justify-center gap-2 rounded-xl bg-navy px-6 text-sm font-bold text-white shadow-lg shadow-navy/20 transition hover:bg-navy/90"
              >
                {h.primaryCta.label}
                <ArrowUpRight className="h-4 w-4 transition group-hover:translate-x-0.5 group-hover:-translate-y-0.5" />
              </Link>
              <Link
                href={h.secondaryCta.href}
                className="inline-flex min-h-12 items-center justify-center gap-2 rounded-xl border border-navy/15 bg-white/90 px-6 text-sm font-bold text-navy backdrop-blur transition hover:border-teal-400 hover:text-teal-800"
              >
                {h.secondaryCta.label}
              </Link>
            </motion.div>

            <motion.ul
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.22 }}
              className="mt-8 grid gap-2 sm:grid-cols-3"
            >
              {h.trusts.map((t) => (
                <li
                  key={t}
                  className="rounded-lg border border-navy/8 bg-white/60 px-3 py-2.5 text-[12px] font-semibold leading-snug text-slate-700 backdrop-blur-sm"
                >
                  {t}
                </li>
              ))}
            </motion.ul>

            <motion.p
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.28 }}
              className="mt-5 text-xs font-medium text-slate-500"
            >
              {h.socialLine}
            </motion.p>
          </div>

          <motion.div
            initial={{ opacity: 0, y: 28, rotate: -1.5 }}
            animate={{ opacity: 1, y: 0, rotate: 0 }}
            transition={{ duration: 0.7, delay: 0.12, ease: [0.22, 1, 0.36, 1] }}
            className="relative lg:-mr-4 lg:translate-x-2 lg:translate-y-4"
          >
            <div className="pointer-events-none absolute -left-6 top-10 hidden h-24 w-24 border border-teal-400/40 lg:block" />
            <div className="relative overflow-hidden rounded-tl-[2.5rem] rounded-br-[2.5rem] rounded-tr-lg rounded-bl-lg border border-navy/10 bg-white shadow-[12px_18px_0_0_rgba(11,31,42,0.08)]">
              <ClientDashMock />
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
}
