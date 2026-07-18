import Link from "next/link";
import { Briefcase, Handshake, ShieldCheck } from "lucide-react";

const pillars = [
  {
    icon: Briefcase,
    audience: "Freelancers",
    title: "Keep the rate you negotiate",
    body: "Big marketplaces take a cut from every invoice. On CLIVORA Connect, platform fee on your deal stays $0 - then you invoice the client directly from your workspace.",
  },
  {
    icon: Handshake,
    audience: "Clients",
    title: "Hire without fee stacking",
    body: "You already pay for the work. You should not also fund a marketplace tax on both sides. Post needs, review talent, accept privately, and manage delivery in one portal.",
  },
  {
    icon: ShieldCheck,
    audience: "Both sides",
    title: "Private until you both say yes",
    body: "Emails unlock only after mutual accept. No cold contact spam. After the match, CRM, projects, messages, and invoices live in the same account on web and Android.",
  },
];

export function DualAudienceSection() {
  return (
    <section className="relative bg-[#F4F8F7] py-16 sm:py-20">
      <div className="mx-auto max-w-7xl px-5 lg:px-8">
        <div className="max-w-2xl">
          <p className="text-[11px] font-bold uppercase tracking-[0.18em] text-teal-800">
            Built for both desks
          </p>
          <h2 className="mt-3 font-display text-3xl font-extrabold tracking-tight text-navy sm:text-4xl">
            Current platforms charge freelancers and clients. CLIVORA was built to stop that.
          </h2>
          <p className="mt-4 text-base leading-relaxed text-slate-600">
            Whether you sell services or hire talent, you get a complete business OS - Connect,
            CRM, delivery, and invoicing - without the marketplace middleman taking a slice of every
            deal.
          </p>
        </div>

        <div className="mt-10 grid gap-4 md:grid-cols-3">
          {pillars.map((p) => {
            const Icon = p.icon;
            return (
              <article
                key={p.title}
                className="flex h-full flex-col rounded-2xl border border-slate-200/90 bg-white p-6 shadow-sm"
              >
                <span className="inline-flex w-fit items-center gap-2 rounded-full bg-teal-50 px-2.5 py-1 text-[10px] font-bold uppercase tracking-wide text-teal-800">
                  <Icon className="h-3.5 w-3.5" />
                  {p.audience}
                </span>
                <h3 className="mt-4 font-display text-lg font-bold text-navy">{p.title}</h3>
                <p className="mt-2 flex-1 text-sm leading-relaxed text-slate-600">{p.body}</p>
              </article>
            );
          })}
        </div>

        <div className="mt-8 flex flex-wrap gap-3">
          <Link
            href="/compare"
            className="inline-flex rounded-xl bg-navy px-5 py-3 text-sm font-bold text-white transition hover:bg-navy/90"
          >
            Compare vs Upwork, Fiverr & more
          </Link>
          <Link
            href="/signup"
            className="inline-flex rounded-xl border border-navy/15 bg-white px-5 py-3 text-sm font-bold text-navy transition hover:border-teal-500"
          >
            Open a free workspace
          </Link>
        </div>
      </div>
    </section>
  );
}
