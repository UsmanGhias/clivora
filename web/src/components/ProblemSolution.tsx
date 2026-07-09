"use client";

import { AnimatedSection, FadeIn } from "./ui/AnimatedSection";
import {
  Layers,
  Smartphone,
  Puzzle,
  Clock,
  AlertTriangle,
} from "lucide-react";

const problems = [
  {
    icon: Puzzle,
    title: "Too Many Tools",
    description:
      "Spreadsheets for clients, separate apps for invoices, another for tasks. Context switching kills productivity.",
  },
  {
    icon: Clock,
    title: "Wasted Time",
    description:
      "Hours spent copying data between tools, chasing payments, and hunting for project details across platforms.",
  },
  {
    icon: AlertTriangle,
    title: "Missed Opportunities",
    description:
      "Overdue invoices slip through, follow-ups get forgotten, and financial blind spots hurt your bottom line.",
  },
];

export function ProblemSolution() {
  return (
    <section className="relative py-24 lg:py-32">
      <div className="mx-auto max-w-7xl px-6 lg:px-8">
        <AnimatedSection className="text-center">
          <span className="text-sm font-semibold uppercase tracking-widest text-primary">
            The Problem
          </span>
          <h2 className="mt-4 text-3xl font-bold sm:text-4xl lg:text-5xl">
            Freelancers Deserve Better
          </h2>
          <p className="mx-auto mt-4 max-w-2xl text-lg text-white/60">
            Running a freelance business shouldn&apos;t mean managing five
            different apps. You need one system that understands how you work.
          </p>
        </AnimatedSection>

        <div className="mt-16 grid gap-6 md:grid-cols-3">
          {problems.map((problem, i) => (
            <FadeIn key={problem.title} delay={i * 0.1}>
              <div className="group h-full rounded-3xl glass p-8 transition-all duration-300 hover:bg-white/5 hover:border-white/15">
                <div className="mb-5 flex h-14 w-14 items-center justify-center rounded-2xl bg-red-500/10 transition-colors group-hover:bg-red-500/20">
                  <problem.icon className="h-7 w-7 text-red-400" />
                </div>
                <h3 className="text-xl font-bold text-white">{problem.title}</h3>
                <p className="mt-3 text-white/60 leading-relaxed">
                  {problem.description}
                </p>
              </div>
            </FadeIn>
          ))}
        </div>

        <AnimatedSection className="mt-20" delay={0.2}>
          <div className="relative overflow-hidden rounded-3xl bg-gradient-to-br from-primary/20 via-navy to-primary-dark/20 p-1">
            <div className="rounded-[1.4rem] bg-dark-bg/90 p-8 lg:p-12">
              <div className="grid items-center gap-8 lg:grid-cols-2">
                <div>
                  <div className="mb-4 inline-flex items-center gap-2 rounded-full bg-success/10 px-4 py-2 text-sm text-success">
                    <Layers className="h-4 w-4" />
                    The Solution
                  </div>
                  <h3 className="text-3xl font-bold lg:text-4xl">
                    One App.{" "}
                    <span className="text-gradient">Entire Business.</span>
                  </h3>
                  <p className="mt-4 text-lg text-white/60 leading-relaxed">
                    CLIVORA brings CRM, project management, invoicing, expense
                    tracking, tasks, calendar, and financial reports into a
                    single, beautifully designed mobile experience. Your data
                    stays on your device - private, fast, and always accessible.
                  </p>
                </div>
                <div className="grid grid-cols-2 gap-4">
                  {[
                    { icon: Smartphone, label: "Mobile-First Design" },
                    { icon: Layers, label: "All-in-One Platform" },
                  ].map((item) => (
                    <div
                      key={item.label}
                      className="flex flex-col items-center rounded-2xl glass p-6 text-center"
                    >
                      <item.icon className="mb-3 h-8 w-8 text-primary" />
                      <span className="text-sm font-medium text-white/80">
                        {item.label}
                      </span>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </AnimatedSection>
      </div>
    </section>
  );
}
