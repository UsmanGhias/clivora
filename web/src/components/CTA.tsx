"use client";

import Image from "next/image";
import Link from "next/link";
import { motion } from "framer-motion";
import { AnimatedSection } from "./ui/AnimatedSection";
import { site } from "@/lib/site";
import { ArrowRight, Smartphone, Shield, Zap } from "lucide-react";

const highlights = [
  { icon: Smartphone, text: "Android · v" + site.appVersion },
  { icon: Shield, text: "Works Offline" },
  { icon: Zap, text: "All Features Free" },
];

export function CTA() {
  return (
    <section id="download" className="relative py-24 lg:py-32 overflow-hidden">
      <div className="absolute inset-0">
        <div className="absolute inset-0 bg-gradient-to-br from-primary/20 via-dark-bg to-primary-dark/20" />
        <div className="absolute top-0 left-1/2 -translate-x-1/2 h-px w-3/4 bg-gradient-to-r from-transparent via-primary/50 to-transparent" />
      </div>

      <div className="relative mx-auto max-w-4xl px-6 text-center lg:px-8">
        <AnimatedSection>
          <motion.div
            initial={{ scale: 0.9, opacity: 0 }}
            whileInView={{ scale: 1, opacity: 1 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6 }}
            className="relative overflow-hidden rounded-3xl glass-strong p-10 lg:p-16 glow-purple"
          >
            <div className="absolute top-0 right-0 h-64 w-64 rounded-full bg-primary/10 blur-[80px]" />
            <div className="absolute bottom-0 left-0 h-48 w-48 rounded-full bg-blue-500/10 blur-[60px]" />

            <div className="relative">
              <h2 className="text-3xl font-bold sm:text-4xl lg:text-5xl">
                Ready to Run Your Business
                <br />
                <span className="text-gradient">Like a Pro?</span>
              </h2>
              <p className="mx-auto mt-4 max-w-xl text-lg text-white/60">
                Join freelancers and agencies who are taking control of their
                business with CLIVORA. Download free and start in minutes.
              </p>

              <div className="mt-8 flex flex-wrap justify-center gap-6">
                {highlights.map((item) => (
                  <div
                    key={item.text}
                    className="flex items-center gap-2 text-white/60"
                  >
                    <item.icon className="h-5 w-5 text-primary" />
                    <span className="text-sm font-medium">{item.text}</span>
                  </div>
                ))}
              </div>

              <div className="mt-10 flex flex-col items-center gap-4 sm:flex-row sm:justify-center">
                <motion.a
                  href={site.playStoreUrl}
                  whileHover={{ scale: 1.03 }}
                  whileTap={{ scale: 0.98 }}
                  className="group flex items-center gap-3 rounded-2xl bg-white px-8 py-4 text-navy shadow-xl transition-shadow hover:shadow-2xl"
                >
                  <div className="relative h-10 w-10 overflow-hidden rounded-xl">
                    <Image
                      src="/app-icon.png"
                      alt="CLIVORA app icon"
                      fill
                      className="object-cover"
                    />
                  </div>
                  <div className="text-left">
                    <div className="text-xs text-navy/60">Get it on</div>
                    <div className="text-lg font-bold">Google Play</div>
                  </div>
                  <ArrowRight className="ml-2 h-5 w-5 transition-transform group-hover:translate-x-1" />
                </motion.a>

                <motion.a
                  href="#"
                  whileHover={{ scale: 1.03 }}
                  whileTap={{ scale: 0.98 }}
                  className="group flex items-center gap-3 rounded-2xl glass px-8 py-4 text-white transition-colors hover:bg-white/10"
                >
                  <svg className="h-8 w-8" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z" />
                  </svg>
                  <div className="text-left">
                    <div className="text-xs text-white/50">Coming to</div>
                    <div className="text-lg font-bold">App Store</div>
                  </div>
                </motion.a>
              </div>

              <p className="mt-8 text-sm text-white/40">
                Free to download. No credit card required. Your data stays on
                your device. Developed by{" "}
                <Link
                  href="/about"
                  className="text-white/60 hover:text-white underline underline-offset-2"
                >
                  {site.company.name}
                </Link>
                .
              </p>
              <p className="mt-3 text-xs text-white/30">
                <Link href="/privacy" className="hover:text-white/50">
                  Privacy Policy
                </Link>
                {" · "}
                <Link href="/terms" className="hover:text-white/50">
                  Terms
                </Link>
                {" · "}
                <Link href="/support" className="hover:text-white/50">
                  Support
                </Link>
              </p>
            </div>
          </motion.div>
        </AnimatedSection>
      </div>
    </section>
  );
}
