import { site } from "@/lib/site";

/**
 * Single source of truth for marketing site copy, navigation, and section data.
 * Edit this file to reconfigure the public website without touching components.
 *
 * Honesty policy: never invent users, revenue, ratings, jobs, logos, or uptime.
 * Demo mockups may show sample dashboard data — always label them as illustrative.
 */
export const marketing = {
  brand: {
    name: site.name,
    productLine: "FREELANCER OS",
    badge: "Early Access · Freelancer OS",
    tagline: "Run Your Entire Freelance Business From One Workspace.",
    description: site.description,
  },

  nav: {
    links: [
      {
        label: "For Freelancers",
        href: "/for-freelancers",
        children: [
          { label: "Freelancer Workspace", href: "/for-freelancers" },
          { label: "Connect", href: "/connect" },
          { label: "Features", href: "/features" },
        ],
      },
      {
        label: "For Clients",
        href: "/for-clients",
        children: [
          { label: "Client Workspace", href: "/for-clients" },
          { label: "Hire Talent", href: "/connect" },
          { label: "Pricing", href: "/pricing" },
        ],
      },
      {
        label: "Features",
        href: "/features",
        children: [
          { label: "All Features", href: "/features" },
          { label: "Connect Marketplace", href: "/connect" },
          { label: "Pro Plans", href: "/pro" },
        ],
      },
      {
        label: "Resources",
        href: "/docs",
        children: [
          { label: "Documentation", href: "/docs" },
          { label: "Support", href: "/support" },
          { label: "About", href: "/about" },
          { label: "Contact", href: "/contact" },
        ],
      },
      { label: "Pricing", href: "/pricing" },
    ],
    cta: { label: "Get Started Free", href: "/signup" },
    login: { label: "Login", href: "/login" },
    locale: "EN",
  },

  hero: {
    badge: "Early Access · All-in-One Freelancer OS",
    headline: ["Run Your Entire Freelance Business", "From One Workspace."],
    body:
      "Clivora brings your clients, projects, proposals, invoices, expenses, time tracking, and business insights into one connected workspace—so you spend less time managing tools and more time doing great work.",
    primaryCta: { label: "Start as a Freelancer", href: "/signup?role=freelancer" },
    secondaryCta: { label: "Explore as a Client", href: "/signup?role=client" },
    trusts: ["Free to start", "No credit card required", "Set up in minutes"],
    mockCaption: "Illustrative dashboard shown with sample data.",
  },

  trustBar: {
    title: "Built for the way independent professionals actually work.",
    body: "Whether you manage one client or a growing freelance business, Clivora keeps your work, communication, documents, and finances organized in one place.",
    audiences: [
      "Freelancers",
      "Independent consultants",
      "Small agencies",
      "Clients and project owners",
    ],
  },

  /** Compact product capabilities — replaces inflated dual-portal showcase */
  platform: {
    badge: "ONE WORKSPACE",
    headline: ["One workspace.", "Every part of your freelance business."],
    body: "Stop switching between separate tools for CRM, projects, invoices, tasks, expenses, and communication. Clivora connects the complete freelance workflow from first contact to final payment.",
    features: [
      { title: "Client CRM", description: "Leads, contacts, notes, and history in one place.", status: "Available now" as const },
      { title: "Projects & tasks", description: "Milestones, deadlines, files, and progress.", status: "Available now" as const },
      { title: "Proposals", description: "Send proposals and track responses.", status: "Available now" as const },
      { title: "Invoices & expenses", description: "Professional invoices and expense tracking.", status: "Available now" as const },
      { title: "Time tracking", description: "Timers and billable hours on projects.", status: "Available now" as const },
      { title: "Messages & files", description: "Project-linked chat and shared files.", status: "Available now" as const },
      { title: "Business reports", description: "Earnings and activity insights.", status: "Available now" as const },
      { title: "Clivora AI", description: "Assisted drafting for everyday business writing.", status: "Beta" as const },
      { title: "Connect marketplace", description: "Discover opportunities and professional connections.", status: "Beta" as const },
      { title: "Calendar & reminders", description: "Deadlines and follow-ups in one view.", status: "Available now" as const },
    ],
  },

  freelancerOs: {
    eyebrow: "Freelancer workspace",
    headline: "Everything You Need to Run Your Freelance Business.",
    body: "Manage leads, clients, proposals, active projects, time, expenses, invoices, and business performance without juggling multiple subscriptions and disconnected apps.",
    cta: { label: "Explore Freelancer Workspace", href: "/for-freelancers" },
    features: [
      {
        title: "Keep every client relationship organized",
        description: "CRM with contacts, notes, and project history.",
      },
      {
        title: "Turn proposals into active projects",
        description: "Track status from draft to accepted work.",
      },
      {
        title: "Track tasks, milestones, files, and deadlines",
        description: "One place for delivery, not five apps.",
      },
      {
        title: "Create professional invoices",
        description: "Draft, send, and track payment status.",
      },
      {
        title: "Record income and business expenses",
        description: "Clearer books when tax season arrives.",
      },
      {
        title: "Understand performance through reports",
        description: "See what is earning and what needs attention.",
      },
    ],
    /** Honest product proofs — not invented user metrics */
    proofs: [
      { value: "Web + Android", label: "One account across platforms" },
      { value: "Free plan", label: "Start without a credit card" },
      { value: "Early access", label: "Feedback shapes every release" },
      { value: "CODCrafters", label: "Independently built product" },
    ],
    mockCaption: "Illustrative dashboard shown with sample data.",
  },

  socialProof: {
    badge: "BUILT OPENLY. IMPROVED CONTINUOUSLY.",
    headline: ["Built independently.", "Improved with real feedback."],
    body: "Clivora is an independently developed Freelancer OS from CODCrafters. The platform is currently in early access, and feedback from freelancers and clients directly influences what we build next.",
    features: [
      {
        title: "Transparent early-access development",
        description: "We ship openly and improve based on real usage.",
        tone: "violet" as const,
      },
      {
        title: "Privacy-focused product design",
        description: "We collect only what is needed for auth, sync, and communication.",
        tone: "blue" as const,
      },
      {
        title: "Web and Android experience",
        description: "Same account on clivora.codcrafters.org and the Android app.",
        tone: "teal" as const,
      },
      {
        title: "Feedback-driven roadmap",
        description: "Direct feedback shapes features and priorities.",
        tone: "violet" as const,
      },
      {
        title: "Direct support from the builder",
        description: "Reach the CODCrafters team when you need help.",
        tone: "orange" as const,
      },
      {
        title: "Free plan for early users",
        description: "Generous free limits while Clivora grows with you.",
        tone: "green" as const,
      },
    ],
    trustedBy: {
      title: "DESIGNED FOR INDEPENDENT PROFESSIONALS.",
      body: "Whether you are solo, consulting, or running a small agency, Clivora keeps work and finances in one workspace.",
      link: { label: "Learn about CODCrafters", href: "/about" },
      audiences: [
        "Freelancers",
        "Consultants",
        "Small agencies",
        "Clients",
      ],
    },
    metrics: [
      { value: "Early access", label: "Active development" },
      { value: "Web + Android", label: "Cross-platform" },
      { value: "Free plan", label: "No card required" },
      { value: "Connect", label: "Marketplace (beta)" },
      { value: "Support", label: "Email help desk" },
    ],
  },

  connect: {
    eyebrow: "Connect marketplace · Beta",
    headline: ["Discover Opportunities.", "Build Professional Connections."],
    body: "Clivora Connect is an emerging professional network where freelancers can discover relevant opportunities and clients can connect with suitable talent. Opportunity availability may vary as the community grows.",
    feeNote:
      "Clivora does not deduct a commission from rates independently negotiated between freelancers and clients. Subscription or payment-processing fees may still apply.",
    features: [
      {
        title: "Direct connections",
        description: "Freelancer–client introductions without noisy marketplace noise.",
      },
      {
        title: "Professional profiles",
        description: "Showcase skills, rates, and availability.",
      },
      {
        title: "Job discovery & proposals",
        description: "Browse opportunities and manage proposals in one place.",
      },
      {
        title: "Private messaging",
        description: "Communicate after mutual connect.",
      },
      {
        title: "No commission on negotiated rates",
        description: "Keep what you agree with your client.",
      },
    ],
    primaryCta: { label: "I want to hire", href: "/signup?role=client&next=/connect" },
    secondaryCta: { label: "I want to get hired", href: "/signup?role=freelancer&next=/connect" },
    categories: [
      { title: "Web Development", jobs: "Category", tone: "green" as const },
      { title: "Mobile Apps", jobs: "Category", tone: "violet" as const },
      { title: "Design & Creative", jobs: "Category", tone: "orange" as const },
      { title: "Writing & Content", jobs: "Category", tone: "blue" as const },
      { title: "Marketing", jobs: "Category", tone: "green" as const },
      { title: "Business", jobs: "Category", tone: "violet" as const },
    ],
  },

  workspace: {
    headline: ["Your Freelance", "Business Operating System."],
    body: "Clivora gives freelancers the tools to manage clients, projects, invoices, and growth — in one early-access workspace.",
    cta: { label: "Explore Freelancer Workspace", href: "/for-freelancers" },
    features: [
      { title: "Project Management", description: "Plan and deliver projects.", status: "Available now" as const },
      { title: "Invoicing", description: "Create invoices and track status.", status: "Available now" as const },
      { title: "Time Tracking", description: "Track billable hours.", status: "Available now" as const },
      { title: "Client Communication", description: "Chat and share files.", status: "Available now" as const },
      { title: "CRM & Clients", description: "Manage leads and relationships.", status: "Available now" as const },
      { title: "AI Assistance", description: "Draft everyday business writing.", status: "Beta" as const },
      { title: "Contracts & Docs", description: "Store agreements with projects.", status: "Available now" as const },
      { title: "Analytics & Reports", description: "Business growth insights.", status: "Available now" as const },
    ],
    workflow: {
      title: "Your Workflow. Simplified.",
      steps: [
        { title: "Find Client", description: "Discover opportunities." },
        { title: "Send Proposal", description: "Create & send proposals." },
        { title: "Get Hired", description: "Client accepts proposal." },
        { title: "Work & Collaborate", description: "Complete project tasks." },
        { title: "Send Invoice", description: "Bill for your work." },
        { title: "Get Paid", description: "Record payments." },
        { title: "Grow Business", description: "Review reports & improve." },
      ],
    },
    mockCaption: "Illustrative dashboard shown with sample data.",
  },

  pricingPage: {
    badge: "Simple, transparent pricing",
    headline: "Start free. Upgrade when you grow.",
    body: "Start organizing your freelance business today and help shape the future of Clivora.",
    plans: [
      {
        id: "free",
        name: "Free",
        price: "$0",
        period: "/month",
        description: "Everything you need to start managing your freelance business.",
        cta: { label: "Get Started Free", href: "/signup" },
        highlighted: false,
        features: [
          `Up to ${site.freeLimits.clients} clients`,
          `Up to ${site.freeLimits.projects} projects`,
          `${site.freeLimits.invoicesPerMonth} invoices per month`,
          `Up to ${site.freeLimits.templates} smart templates`,
          `${site.freeLimits.fileVaultMb} MB File Vault`,
          "Tasks, expenses & notes",
          "Calendar & follow-up alerts",
          "Financial reports & PDF invoices",
          "AI insights (beta)",
          "Web + Android sync",
        ],
      },
      {
        id: "pro",
        name: "Pro",
        price: site.pricing.proMonthlyLabel,
        listPrice: site.pricing.proListLabel,
        period: "/month",
        description: "Unlimited tools for freelancers ready to scale.",
        cta: { label: "Upgrade to Pro", href: "/pro" },
        highlighted: true,
        features: [
          "Unlimited clients & projects",
          "Unlimited invoices & tasks",
          "Unlimited smart templates",
          "Client contracts & tracking",
          "Business workflows & automations",
          `${site.proLimits.fileVaultGb} GB File Vault`,
          "Invoice branding & PDF export",
          "Project time tracking",
          "Priority email support",
          "All future Pro features",
        ],
      },
      {
        id: "pro-plus",
        name: "Pro Plus",
        price: site.pricing.proPlusMonthlyLabel,
        listPrice: site.pricing.proPlusListLabel,
        period: "/month",
        description: "Connect marketplace access, AI tools, and team collaboration.",
        cta: { label: "Get Pro Plus", href: "/pro" },
        highlighted: false,
        badge: "Best for growth",
        features: [
          "Everything in Pro",
          "Connect marketplace access",
          "AI proposal & writing assistance (beta)",
          "Team seats & collaboration",
          `${site.proPlusLimits.fileVaultGb} GB File Vault`,
          "Advanced analytics & reports",
          "Priority marketplace visibility",
        ],
      },
    ],
    note: "Android subscriptions are billed through Google Play. Web billing will be introduced separately. Cancel anytime.",
  },

  featuresPage: {
    badge: "Product capabilities",
    headline: "Every tool. One Freelancer OS.",
    body: "From first lead to final payment — Clivora replaces the patchwork of apps freelancers and clients juggle every day. Features are labeled honestly as they ship.",
    groups: [
      {
        title: "Core business OS",
        items: [
          {
            title: "Business Command Center",
            description:
              "Revenue, outstanding amounts, active projects, and your morning snapshot in seconds.",
          },
          {
            title: "Client CRM",
            description:
              "Business name, contact, email, phone, WhatsApp, address, and notes.",
          },
          {
            title: "Projects & Time Tracking",
            description:
              "Budgets, deadlines, status filters, and a built-in project timer.",
          },
          {
            title: "Professional Invoicing",
            description:
              "Tax, discounts, draft/sent/paid/overdue workflow linked to clients and projects.",
          },
        ],
      },
      {
        title: "Connect & growth",
        items: [
          {
            title: "Clivora Connect (beta)",
            description:
              "Emerging marketplace to discover opportunities and connect with talent. No commission on independently negotiated rates.",
          },
          {
            title: "Proposals",
            description:
              "Send proposals, track status, and convert wins into projects.",
          },
          {
            title: "Messages",
            description: "Realtime chat with clients or freelancers, tied to work.",
          },
          {
            title: "Reviews",
            description: "Collect feedback after completed work as the community grows.",
          },
        ],
      },
      {
        title: "Money & documents",
        items: [
          {
            title: "Payments records",
            description: "Track invoice status, outstanding balances, and payment history.",
          },
          {
            title: "Contracts & Documents",
            description: "Store and manage agreements alongside your projects.",
          },
          {
            title: "Expenses & reports",
            description: "Log expenses and export financial reports.",
          },
          {
            title: "File Vault",
            description: "Cloud storage for briefs, deliverables, and client files.",
          },
        ],
      },
      {
        title: "Intelligence & platforms",
        items: [
          {
            title: "Clivora AI (beta)",
            description:
              "Draft proposals, improve replies, and prepare professional business content. Not legal advice.",
          },
          {
            title: "Analytics",
            description: "Earnings trends and activity insights for your business.",
          },
          {
            title: "Web + Android",
            description: "One account across the web app and Android — cloud sync.",
          },
          {
            title: "Team collaboration",
            description: "Invite teammates and assign work with Pro Plus.",
          },
        ],
      },
    ],
  },

  forFreelancers: {
    badge: "FREELANCER WORKSPACE",
    headline: "Run your freelance business from one workspace.",
    body: "Dashboard, CRM, projects, invoices, Connect opportunities, time tracking, and AI assistance — purpose-built for freelancers who want one OS, not ten tabs.",
    cta: { label: "Start as Freelancer", href: "/signup?role=freelancer" },
    secondaryCta: { label: "See pricing", href: "/pricing" },
  },

  forClients: {
    badge: "CLIENT WORKSPACE",
    headline: "Hire, collaborate, and manage work with confidence.",
    body: "Post opportunities, review proposals, organize projects, communicate with freelancers, approve milestones, and keep project records together in one client workspace.",
    cta: { label: "Start as Client", href: "/signup?role=client" },
    secondaryCta: { label: "Browse Connect", href: "/connect" },
  },

  faq: [
    {
      q: "Is Clivora free to start?",
      a: `Yes. Start on the Free plan with up to ${site.freeLimits.clients} clients and ${site.freeLimits.projects} projects. Upgrade to Pro (${site.pricing.proMonthlyLabel}/mo) or Pro Plus (${site.pricing.proPlusMonthlyLabel}/mo) when you need unlimited tools and Connect.`,
    },
    {
      q: "What is Clivora Connect?",
      a: "Connect is our emerging professional network (currently in beta) to discover opportunities and talent. Clivora does not deduct a commission from rates independently negotiated between freelancers and clients. Subscription or payment-processing fees may still apply.",
    },
    {
      q: "Does it work on web and Android?",
      a: "Yes. Use the web app at clivora.codcrafters.org and the Android app with the same account. Data syncs in the cloud.",
    },
    {
      q: "Can clients and freelancers both use Clivora?",
      a: "Yes. Freelancers get a business OS; clients get a workspace to post opportunities, manage projects, and review invoices. Role-aware UI keeps each experience clear.",
    },
    {
      q: "How does billing work?",
      a: "Android subscriptions are billed through Google Play. Web billing will be introduced separately. Cancel anytime.",
    },
    {
      q: "Is my data secure?",
      a: "Clivora is designed with privacy in mind. We collect and process only the information required for authentication, synchronization, and communication. See our Privacy Policy and Data Safety page for details.",
    },
  ],

  cta: {
    headline: "Build a Better-Organized Freelance Business.",
    body: "Clivora is currently in early access. Create your workspace, explore the available tools, and help us build a Freelancer OS shaped by real professionals.",
    primary: { label: "Create Your Free Workspace", href: "/signup" },
    secondary: { label: "See What's Available", href: "/features" },
  },

  footer: {
    blurb:
      "Early-access Freelancer OS from CODCrafters — clients, projects, invoices, Connect, and more on web and Android.",
    columns: {
      Product: [
        { label: "Features", href: "/features" },
        { label: "Connect", href: "/connect" },
        { label: "Pricing", href: "/pricing" },
        { label: "Pro Plans", href: "/pro" },
        { label: "Documentation", href: "/docs" },
        { label: "Sign in", href: "/login" },
      ],
      Solutions: [
        { label: "For Freelancers", href: "/for-freelancers" },
        { label: "For Clients", href: "/for-clients" },
        { label: "Marketplace", href: "/connect" },
        { label: "FAQ", href: "/#faq" },
      ],
      Company: [
        { label: "About CODCrafters", href: "/about" },
        { label: "Contact", href: "/contact" },
        { label: "Support", href: "/support" },
      ],
      Legal: [
        { label: "Privacy Policy", href: "/privacy" },
        { label: "Terms of Service", href: "/terms" },
        { label: "Cookie Policy", href: "/cookies" },
        { label: "Data Safety", href: "/data-safety" },
        { label: "Delete Account", href: "/delete-account" },
      ],
    },
  },
} as const;

export type MarketingConfig = typeof marketing;
