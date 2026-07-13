import type { Metadata } from "next";
import { MarketingShell } from "@/components/marketing/MarketingShell";
import { HomeHero } from "@/components/marketing/HomeHero";
import { TrustLogos } from "@/components/marketing/TrustLogos";
import { PlatformSection } from "@/components/marketing/PlatformSection";
import { FreelancerOSSection } from "@/components/marketing/FreelancerOSSection";
import { SocialProofSection } from "@/components/marketing/SocialProofSection";
import { ConnectSection } from "@/components/marketing/ConnectSection";
import { FAQSection } from "@/components/marketing/FAQSection";
import { CTASection } from "@/components/marketing/CTASection";
import { site } from "@/lib/site";

export const metadata: Metadata = {
  title: `${site.name} | Early-Access Freelancer OS`,
  description: site.description,
};

export default function Home() {
  return (
    <MarketingShell>
      <HomeHero />
      <TrustLogos />
      <PlatformSection />
      <FreelancerOSSection />
      <SocialProofSection />
      <ConnectSection />
      <FAQSection />
      <CTASection />
    </MarketingShell>
  );
}
