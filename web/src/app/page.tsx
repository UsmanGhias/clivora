import type { Metadata } from "next";
import { MarketingShell } from "@/components/marketing/MarketingShell";
import { HomeHero } from "@/components/marketing/HomeHero";
import { TractionStrip } from "@/components/marketing/TractionStrip";
import { DualAudienceSection } from "@/components/marketing/DualAudienceSection";
import { FounderNoteSection } from "@/components/marketing/FounderNoteSection";
import { DualPortalSection } from "@/components/marketing/DualPortalSection";
import { FreelancerOSSection } from "@/components/marketing/FreelancerOSSection";
import { SocialProofSection } from "@/components/marketing/SocialProofSection";
import { ConnectSection } from "@/components/marketing/ConnectSection";
import { WorkspaceSection } from "@/components/marketing/WorkspaceSection";
import { FAQSection } from "@/components/marketing/FAQSection";
import { PlayStorePromoSection } from "@/components/marketing/PlayStorePromoSection";
import { CTASection } from "@/components/marketing/CTASection";
import { site } from "@/lib/site";

/** Keep homepage fresh on Hostinger CDN after deploys. */
export const revalidate = 60;

export const metadata: Metadata = {
  title: `${site.name} | Complete Freelancer OS - $0 deal fees`,
  description: site.description,
  openGraph: {
    title: `${site.name} — Freelancer OS for hire, CRM & invoices`,
    description: site.description,
    url: site.url,
    siteName: site.name,
    type: "website",
  },
};

export default function Home() {
  return (
    <MarketingShell>
      <HomeHero />
      {/* Public, no-login purpose copy for Google OAuth branding verification */}
      <section
        className="border-y border-navy/8 bg-white py-10 sm:py-12"
        aria-labelledby="clivora-purpose"
      >
        <div className="mx-auto max-w-3xl px-5 text-center lg:px-8">
          <p className="text-[11px] font-bold uppercase tracking-[0.16em] text-teal-800">
            About Clivora
          </p>
          <h2
            id="clivora-purpose"
            className="mt-3 font-display text-2xl font-extrabold tracking-tight text-navy sm:text-3xl"
          >
            Clivora is a Freelancer OS
          </h2>
          <p className="mt-4 text-[15px] leading-relaxed text-slate-600 sm:text-base">
            The purpose of Clivora is to help freelancers and clients hire and get hired on a
            private Connect board, then run CRM, projects, timesheets, messages, and invoices on
            web and Android — with $0 platform fees on negotiated deals. Anyone can read this page
            without signing in.
          </p>
        </div>
      </section>
      <TractionStrip />
      <DualAudienceSection />
      <ConnectSection />
      <FounderNoteSection />
      <SocialProofSection />
      <DualPortalSection />
      <FreelancerOSSection />
      <WorkspaceSection />
      <FAQSection />
      <PlayStorePromoSection />
      <CTASection />
    </MarketingShell>
  );
}
