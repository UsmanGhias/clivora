"use client";

import Link from "next/link";
import { motion } from "framer-motion";
import {
  ArrowRight,
  Sparkles,
  Play,
  TrendingUp,
  Users,
  FileText,
  Globe2,
  Smartphone,
} from "lucide-react";
import { GlowOrb } from "./ui/AnimatedSection";
import { PhoneMockup } from "./PhoneMockup";
import { site } from "@/lib/site";

const floatingStats = [
  {
    icon: TrendingUp,
    label: "Revenue",
    value: "245K",
    prefix: "$",
    color: "text-success",
    dot: "bg-success",
  },
  {
    icon: Users,
    label: "Clients",
    value: "48",
    prefix: "",
    color: "text-primary",
    dot: "bg-primary",
  },
  {
    icon: FileText,
    label: "Invoices",
    value: "127",
    prefix: "",
    color: "text-warning",
    dot: "bg-warning",
  },
];

export function Hero() {
  return (
    <section className="relative min-h-screen overflow-hidden pt-32 pb-20 lg:pt-40 lg:pb-32">
      <div className="absolute inset-0 grid-pattern" />
      <GlowOrb className="top-20 -left-32 h-96 w-96" color="purple" />
      <GlowOrb className="top-40 -right-32 h-80 w-80" color="blue" />
      <GlowOrb className="bottom-0 left-1/3 h-64 w-64" color="pink" />

      <div className="relative mx-auto max-w-7xl px-6 lg:px-8">
        <div className="grid items-center gap-16 lg:grid-cols-2 lg:gap-8">
          <div className="text-center lg:text-left">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6 }}
              className="mb-6 inline-flex items-center gap-2 rounded-full glass px-4 py-2 text-sm"
            >
              <Sparkles className="h-4 w-4 text-primary" />
              <span className="text-white/80">
                Web + Android · one Supabase account for freelancers & clients
              </span>
            </motion.div>

            <motion.p
              initial={{ opacity: 0, y: 16 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.55, delay: 0.05 }}
              className="mb-3 text-sm font-bold uppercase tracking-[0.28em] text-teal-300/90"
            >
              {site.name}
            </motion.p>

            <motion.h1
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.7, delay: 0.1 }}
              className="text-4xl font-extrabold leading-tight tracking-tight sm:text-5xl lg:text-6xl xl:text-7xl"
            >
              Your business OS
              <br />
              <span className="text-gradient">on web &amp; mobile</span>
            </motion.h1>

            <motion.p
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.7, delay: 0.2 }}
              className="mt-6 max-w-xl text-lg text-white/60 lg:text-xl"
            >
              Sign in once. Manage clients, projects, invoices, Connect marketplace, and messages
              from the browser — with the full offline CRM power in the Android app.
            </motion.p>

            <motion.div
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.7, delay: 0.3 }}
              className="mt-10 flex flex-col items-center gap-4 sm:flex-row lg:justify-start"
            >
              <motion.div whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.98 }}>
                <Link
                  href="/signup"
                  className="group flex items-center gap-2 rounded-full bg-primary px-8 py-4 text-base font-semibold text-white shadow-xl shadow-primary/30 transition-shadow hover:shadow-primary/50"
                >
                  Start free on web
                  <ArrowRight className="h-5 w-5 transition-transform group-hover:translate-x-1" />
                </Link>
              </motion.div>
              <motion.div whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.98 }}>
                <Link
                  href="/connect"
                  className="flex items-center gap-2 rounded-full glass px-8 py-4 text-base font-semibold text-white/90 transition-colors hover:bg-white/10"
                >
                  <Play className="h-5 w-5 fill-white/80 text-white/80" />
                  Explore Connect
                </Link>
              </motion.div>
            </motion.div>

            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.7, delay: 0.45 }}
              className="mt-6 flex flex-wrap items-center justify-center gap-3 lg:justify-start"
            >
              <Link
                href="/login"
                className="inline-flex items-center gap-2 rounded-full border border-white/15 px-4 py-2 text-sm font-medium text-white/80 hover:bg-white/5"
              >
                <Globe2 className="h-4 w-4 text-primary" /> Sign in to web app
              </Link>
              <a
                href={site.playStoreUrl}
                target="_blank"
                rel="noreferrer"
                className="inline-flex items-center gap-2 rounded-full border border-white/15 px-4 py-2 text-sm font-medium text-white/80 hover:bg-white/5"
              >
                <Smartphone className="h-4 w-4 text-primary" /> Get Android app
              </a>
            </motion.div>

            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.7, delay: 0.55 }}
              className="mt-12 flex flex-wrap items-center justify-center gap-8 lg:justify-start"
            >
              {[
                { value: "Web", label: "Live dashboard" },
                { value: "App", label: "Offline CRM" },
                { value: "Plus", label: `Connect · ${site.pricing.proPlusMonthlyLabel}` },
              ].map((stat) => (
                <div key={stat.label} className="text-center lg:text-left">
                  <div className="text-2xl font-bold text-white">{stat.value}</div>
                  <div className="text-sm text-white/50">{stat.label}</div>
                </div>
              ))}
            </motion.div>
          </div>

          <motion.div
            initial={{ opacity: 0, x: 60 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.9, delay: 0.3, ease: [0.22, 1, 0.36, 1] }}
            className="relative flex justify-center pb-14 lg:pb-16"
          >
            <PhoneMockup />

            <motion.div
              initial={{ opacity: 0, y: 16 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: 1, ease: [0.22, 1, 0.36, 1] }}
              className="absolute bottom-0 left-1/2 z-20 flex w-[min(100%,340px)] -translate-x-1/2 items-center justify-between gap-2 rounded-2xl border border-white/10 bg-navy/80 px-4 py-3 shadow-2xl backdrop-blur-xl"
            >
              {floatingStats.map((s) => (
                <div key={s.label} className="flex flex-col items-center">
                  <div className="flex items-center gap-1">
                    <span className={`h-1.5 w-1.5 rounded-full ${s.dot}`} />
                    <s.icon className={`h-3.5 w-3.5 ${s.color}`} />
                  </div>
                  <p className="mt-1 text-sm font-bold text-white">
                    {s.prefix}
                    {s.value}
                  </p>
                  <p className="text-[10px] text-white/50">{s.label}</p>
                </div>
              ))}
            </motion.div>
          </motion.div>
        </div>
      </div>
    </section>
  );
}
