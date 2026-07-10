import Link from "next/link";
import { Network, Shield, MessageCircle, Search, Sparkles } from "lucide-react";
import { site } from "@/lib/site";

export function ConnectMarketplace() {
  return (
    <section id="connect" className="relative overflow-hidden bg-navy py-16 text-white sm:py-20">
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,_rgba(13,148,136,0.25),_transparent_50%)]" />
      <div className="relative mx-auto max-w-6xl px-5 sm:px-6 lg:px-8">
        <p className="text-xs font-bold uppercase tracking-[0.2em] text-teal-300">CLIVORA Connect</p>
        <h2 className="mt-3 max-w-2xl text-3xl font-extrabold sm:text-4xl">
          A private marketplace — not another open feed
        </h2>
        <p className="mt-4 max-w-2xl text-white/75 leading-relaxed">
          Discover freelancers and jobs, send Connect requests, and unlock contact details only after
          mutual accept. Then keep the relationship inside your CLIVORA CRM on web and Android.
        </p>
        <div className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {[
            {
              icon: Search,
              title: "Search talent & jobs",
              body: "Filter by skills, rate, location, and budget — built for serious work.",
            },
            {
              icon: Network,
              title: "Request to connect",
              body: "Reach out without exposing your email until both sides say yes.",
            },
            {
              icon: Shield,
              title: "Private by default",
              body: "Safer than open marketplaces where spam and scraped contacts are normal.",
            },
            {
              icon: MessageCircle,
              title: "CRM after match",
              body: "Accepted partners flow into the same clients, projects, and invoices stack.",
            },
          ].map((item) => (
            <div key={item.title} className="rounded-2xl border border-white/10 bg-white/5 p-5">
              <item.icon className="h-6 w-6 text-teal-300" />
              <h3 className="mt-3 font-bold">{item.title}</h3>
              <p className="mt-1 text-sm text-white/70">{item.body}</p>
            </div>
          ))}
        </div>
        <div className="mt-8 flex flex-wrap items-center gap-3">
          <Link
            href="/connect"
            className="inline-flex items-center gap-2 rounded-full bg-primary px-5 py-2.5 text-sm font-semibold text-white"
          >
            <Sparkles className="h-4 w-4" />
            Open Connect marketplace
          </Link>
          <Link
            href="/pro?plan=pro_plus"
            className="rounded-full border border-white/20 px-5 py-2.5 text-sm font-semibold text-white"
          >
            Pro Plus · {site.pricing.proPlusMonthlyLabel}/mo
          </Link>
        </div>
      </div>
    </section>
  );
}
