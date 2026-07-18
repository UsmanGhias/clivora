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
import { EarlyAccessRewardPopup } from "@/components/marketing/EarlyAccessRewardPopup";
import { site } from "@/lib/site";

export const metadata: Metadata = {
  title: `${site.name} | Complete Freelancer OS - $0 deal fees`,
  description: site.description,
};

export default function Home() {
  return (
    <MarketingShell>
      <EarlyAccessRewardPopup />
      <HomeHero />
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
