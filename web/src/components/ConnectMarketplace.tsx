import Link from "next/link";
import { Network, Shield, MessageCircle } from "lucide-react";
import { site } from "@/lib/site";

export function ConnectMarketplace() {
  return (
    <section id="connect" className="bg-navy py-20 text-white">
      <div className="mx-auto max-w-6xl px-6 lg:px-8">
        <p className="text-xs font-bold uppercase tracking-[0.2em] text-primary">CLIVORA Connect</p>
        <h2 className="mt-3 max-w-2xl text-3xl font-extrabold sm:text-4xl">
          Marketplace for freelancers & clients
        </h2>
        <p className="mt-4 max-w-2xl text-white/75 leading-relaxed">
          Browse listings and open needs on the web. Post, request, and message with Pro Plus —
          same Supabase data as the mobile app.
        </p>
        <div className="mt-8 grid gap-4 sm:grid-cols-3">
          {[
            {
              icon: Network,
              title: "Discover matches",
              body: "Freelancer listings and client briefs in one private marketplace.",
            },
            {
              icon: Shield,
              title: "Contact privacy",
              body: "Share details only after both sides accept a Connect request.",
            },
            {
              icon: MessageCircle,
              title: "Pro Plus unlock",
              body: `Posting & requests included with Pro Plus (${site.pricing.proPlusMonthlyLabel}/mo).`,
            },
          ].map((item) => (
            <div key={item.title} className="rounded-2xl border border-white/10 bg-white/5 p-5">
              <item.icon className="h-6 w-6 text-primary" />
              <h3 className="mt-3 font-bold">{item.title}</h3>
              <p className="mt-1 text-sm text-white/70">{item.body}</p>
            </div>
          ))}
        </div>
        <div className="mt-8 flex flex-wrap gap-3">
          <Link
            href="/connect"
            className="rounded-full bg-primary px-5 py-2.5 text-sm font-semibold text-white"
          >
            Open marketplace
          </Link>
          <Link
            href="/signup"
            className="rounded-full border border-white/20 px-5 py-2.5 text-sm font-semibold text-white"
          >
            Create web account
          </Link>
        </div>
      </div>
    </section>
  );
}
