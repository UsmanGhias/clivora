import { Navbar } from "@/components/Navbar";
import { Hero } from "@/components/Hero";
import { ProblemSolution } from "@/components/ProblemSolution";
import { Stats } from "@/components/Stats";
import { Features } from "@/components/Features";
import { DashboardPreview } from "@/components/DashboardPreview";
import { Audience } from "@/components/Audience";
import { Testimonials } from "@/components/Testimonials";
import { ConnectMarketplace } from "@/components/ConnectMarketplace";
import { Pricing } from "@/components/Pricing";
import { FAQ } from "@/components/FAQ";
import { Roadmap } from "@/components/Roadmap";
import { DeveloperSection } from "@/components/DeveloperSection";
import { CTA } from "@/components/CTA";
import { Footer } from "@/components/Footer";

export default function Home() {
  return (
    <main className="relative">
      <Navbar />
      <Hero />
      <ProblemSolution />
      <Stats />
      <Features />
      <DashboardPreview />
      <Audience />
      <Testimonials />
      <ConnectMarketplace />
      <Pricing />
      <FAQ />
      <Roadmap />
      <DeveloperSection />
      <CTA />
      <Footer />
    </main>
  );
}
