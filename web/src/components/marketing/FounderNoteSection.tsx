import Link from "next/link";

/** Short founder note - concrete product story, not template marketing. */
export function FounderNoteSection() {
  return (
    <section
      aria-labelledby="founder-note-heading"
      className="founder-note relative overflow-hidden border-y border-navy/10 bg-[#0B1F2A] py-12 text-white sm:py-16"
    >
      <div className="pointer-events-none absolute -left-16 top-0 h-40 w-40 rounded-full bg-teal-400/15 blur-3xl" />
      <div className="pointer-events-none absolute -right-10 bottom-0 h-48 w-48 rotate-12 bg-gradient-to-br from-amber-400/10 to-transparent" />

      <div className="relative mx-auto grid max-w-7xl gap-8 px-5 lg:grid-cols-[minmax(0,0.9fr)_minmax(0,1.1fr)] lg:items-end lg:gap-14 lg:px-8">
        <div className="lg:-mb-2 lg:translate-y-2">
          <p className="text-[11px] font-bold uppercase tracking-[0.22em] text-teal-300/90">
            From the builder
          </p>
          <h2
            id="founder-note-heading"
            className="mt-3 font-display text-2xl font-extrabold leading-tight sm:text-3xl"
          >
            I built CLIVORA because Upwork cut my invoice, WhatsApp lost my project files, and Excel lied about what I was owed.
          </h2>
        </div>

        <div className="space-y-4 text-[15px] leading-relaxed text-white/75 sm:text-base">
          <p>
            I&apos;m Usman at CODCrafters in Lahore. Between client work and shipping Android builds, I kept
            switching tabs: CRM in one place, invoices in another, proposals in a Google Doc, and hiring
            through a marketplace that took a chunk of every rupee.
          </p>
          <p>
            CLIVORA is the opposite bet: <strong className="font-semibold text-white">$0 platform fee</strong> on
            Connect deals, contact emails stay private until both sides accept, JazzCash/manual Pro upgrades
            for PK freelancers, and the same Supabase account on web + Android so your CRM doesn&apos;t reset
            when you leave the desk.
          </p>
          <p className="text-sm text-white/55">
            Still early. If something feels broken, email{" "}
            <a className="underline decoration-teal-400/60 underline-offset-2 hover:text-white" href="mailto:iusmanghias@gmail.com">
              iusmanghias@gmail.com
            </a>
            {" "}
            - I read those. Or open a free workspace and tell me what you actually need next.
          </p>
          <div className="flex flex-wrap gap-3 pt-2">
            <Link
              href="/signup?role=freelancer"
              className="inline-flex rounded-lg bg-teal-400 px-4 py-2.5 text-sm font-bold text-navy transition hover:bg-teal-300"
            >
              Start free workspace
            </Link>
            <Link
              href="/about"
              className="inline-flex rounded-lg border border-white/25 px-4 py-2.5 text-sm font-semibold text-white/90 transition hover:bg-white/5"
            >
              Read the story
            </Link>
          </div>
        </div>
      </div>
    </section>
  );
}
