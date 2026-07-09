"use client";

import { motion } from "framer-motion";
import {
  ArrowRight,
  Sparkles,
  Play,
  TrendingUp,
  Users,
  FileText,
} from "lucide-react";
import { GlowOrb } from "./ui/AnimatedSection";
import { PhoneMockup } from "./PhoneMockup";
import { site } from "@/lib/site";

const floatingStats = [
  {
    icon: TrendingUp,
    label: "Revenue",
    value: "245K",
    prefix: "Rs ",
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
              <span className="text-white/80">{site.shortDescription}</span>
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
              Run freelancing
              <br />
              <span className="text-gradient">like a real business</span>
            </motion.h1>

            <motion.p
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.7, delay: 0.2 }}
              className="mt-6 max-w-xl text-lg text-white/60 lg:text-xl"
            >
              Clients, projects, invoices, contracts, and workflows in one private app.
              Works offline. Your data stays on your device.
            </motion.p>

            <motion.div
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.7, delay: 0.3 }}
              className="mt-10 flex flex-col items-center gap-4 sm:flex-row lg:justify-start"
            >
              <motion.a
                href="/pro"
                whileHover={{ scale: 1.03 }}
                whileTap={{ scale: 0.98 }}
                className="group flex items-center gap-2 rounded-full bg-primary px-8 py-4 text-base font-semibold text-white shadow-xl shadow-primary/30 transition-shadow hover:shadow-primary/50"
              >
                Get Pro Plus
                <ArrowRight className="h-5 w-5 transition-transform group-hover:translate-x-1" />
              </motion.a>
              <motion.a
                href="#features"
                whileHover={{ scale: 1.03 }}
                whileTap={{ scale: 0.98 }}
                className="flex items-center gap-2 rounded-full glass px-8 py-4 text-base font-semibold text-white/90 transition-colors hover:bg-white/10"
              >
                <Play className="h-5 w-5 fill-white/80 text-white/80" />
                Explore Features
              </motion.a>
            </motion.div>

            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.7, delay: 0.5 }}
              className="mt-12 flex flex-wrap items-center justify-center gap-8 lg:justify-start"
            >
              {[
                { value: "19", label: "Business Tools" },
                { value: "100%", label: "Offline & Private" },
                { value: "Pro", label: "Web Checkout" },
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
              className="absolute -bottom-2 left-1/2 z-20 w-[min(100%,300px)] -translate-x-1/2 sm:w-[300px] lg:-bottom-4 lg:w-[320px]"
            >
              <div className="flex items-stretch overflow-hidden rounded-2xl border border-white/10 bg-dark-surface/75 shadow-2xl shadow-black/50 backdrop-blur-2xl">
                {floatingStats.map((stat, i) => (
                  <motion.div
                    key={stat.label}
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    transition={{ delay: 1.1 + i * 0.08 }}
                    className="relative flex flex-1 items-center justify-center gap-2.5 px-3 py-3 sm:px-4"
                  >
                    {i > 0 && (
                      <div className="absolute left-0 top-1/2 h-8 w-px -translate-y-1/2 bg-white/10" />
                    )}
                    <div className="relative flex h-8 w-8 shrink-0 items-center justify-center rounded-lg bg-white/5">
                      <stat.icon className={`h-3.5 w-3.5 ${stat.color}`} />
                      <span
                        className={`absolute -right-0.5 -top-0.5 h-1.5 w-1.5 rounded-full ${stat.dot} ring-2 ring-dark-surface`}
                      />
                    </div>
                    <div className="min-w-0">
                      <p className="text-[10px] font-medium leading-none text-white/40">
                        {stat.label}
                      </p>
                      <p className={`mt-1 text-sm font-bold leading-none tabular-nums ${stat.color}`}>
                        {stat.prefix}
                        {stat.value}
                      </p>
                    </div>
                  </motion.div>
                ))}
              </div>
            </motion.div>
          </motion.div>
        </div>
      </div>

      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 1.2 }}
        className="absolute bottom-8 left-1/2 -translate-x-1/2"
      >
        <motion.div
          animate={{ y: [0, 8, 0] }}
          transition={{ duration: 2, repeat: Infinity }}
          className="flex flex-col items-center gap-2 text-white/40"
        >
          <span className="text-xs uppercase tracking-widest">Scroll</span>
          <div className="h-8 w-5 rounded-full border border-white/20 p-1">
            <motion.div
              animate={{ y: [0, 12, 0] }}
              transition={{ duration: 2, repeat: Infinity }}
              className="h-2 w-full rounded-full bg-white/40"
            />
          </div>
        </motion.div>
      </motion.div>
    </section>
  );
}
