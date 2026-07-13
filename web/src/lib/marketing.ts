import { site } from "@/lib/site";

/**
 * Single source of truth for marketing site copy, navigation, and section data.
 * Edit this file to reconfigure the public website without touching components.
 */
export const marketing = {
  brand: {
    name: site.name,
    productLine: "FREELANCER OS",
    badge: "All-in-One Freelance Management Platform",
    tagline: "Work Smarter. Manage Everything. Grow Faster.",
    description: site.description,
  },

  nav: {
    links: [
      {
        label: "For Freelancers",
        href: "/for-freelancers",
        children: [
          { label: "Freelancer OS", href: "/for-freelancers" },
          { label: "Find Jobs", href: "/connect" },
          { label: "Features", href: "/features" },
        ],
      },
      {
        label: "For Clients",
        href: "/for-clients",
        children: [
          { label: "Client Portal", href: "/for-clients" },
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
    badge: "All-in-One Freelance Management Platform",
    headline: ["Work Smarter. Manage Everything.", "Grow Faster."],
    body:
      "CLIVORA is the operating system for freelancers and clients — manage people, projects, proposals, invoices, and payments in one beautiful workspace. Web and Android. One account.",
    primaryCta: { label: "I'm a Freelancer", href: "/signup?role=freelancer" },
    secondaryCta: { label: "I'm a Client", href: "/signup?role=client" },
    trusts: ["Free Forever", "No Credit Card", "Setup in 60 Seconds"],
  },

  trustBar: {
    title: "Trusted by 10,000+ freelancers and businesses worldwide.",
    logos: [
      "Google",
      "Microsoft",
      "Airbnb",
      "Payoneer",
      "Upwork",
      "Stripe",
      "AWS",
      "Shopify",
    ],
  },

  dualPortal: {
    badge: "ALL-IN-ONE FREELANCE OS",
    headline: ["Everything You Need.", "One Powerful Platform."],
    body: "CLIVORA brings every tool, every workflow, and every connection together in one seamless operating system.",
    tabs: [
      { id: "freelancer" as const, label: "For Freelancers" },
      { id: "client" as const, label: "For Clients" },
    ],
    sideFeatures: {
      left: [
        {
          title: "Smart Dashboard",
          description: "Real-time overview of earnings, projects, proposals and more.",
          tone: "violet" as const,
        },
        {
          title: "Project Management",
          description: "Organize tasks, milestones, files and deadlines effortlessly.",
          tone: "green" as const,
        },
        {
          title: "Invoicing & Payments",
          description: "Create professional invoices and get paid on time.",
          tone: "orange" as const,
        },
      ],
      right: [
        {
          title: "Messages",
          description: "Communicate with clients or freelancers in real-time.",
          tone: "blue" as const,
        },
        {
          title: "Connect Marketplace",
          description: "Find work, hire talent and grow your network.",
          tone: "violet" as const,
        },
        {
          title: "AI Assistant",
          description: "Smart AI tools to write proposals, contracts, invoices and more.",
          tone: "teal" as const,
        },
      ],
    },
    bottomStrip: [
      "Analytics & Reports",
      "Expenses Tracking",
      "Contracts & Documents",
      "Time Tracking",
      "Backup & Security",
      "Workflows",
    ],
    socialProof: "Built for freelancers. Loved by teams. Trusted by thousands.",
    activeUsers: "10K+ Active Users",
  },

  freelancerOs: {
    headline: "Everything Freelancers Need to Succeed. All in One Workspace.",
    body: "Manage clients, projects, proposals, invoices, and payments from a beautiful, powerful dashboard.",
    cta: { label: "Explore All Features", href: "/features" },
    features: [
      {
        title: "Complete Dashboard",
        description: "Track earnings, projects, proposals, and performance in real-time.",
      },
      {
        title: "Project Management",
        description: "Organize tasks, milestones, files, and deadlines effortlessly.",
      },
      {
        title: "Invoicing & Payments",
        description: "Create professional invoices, get paid on time, every time.",
      },
      {
        title: "Time Tracking",
        description: "Track time, log hours, and boost productivity.",
      },
      {
        title: "Client Management",
        description: "Manage clients, contracts, communications in one place.",
      },
      {
        title: "AI Assistant",
        description: "Write proposals, contracts, replies and more with CLIVORA AI.",
      },
    ],
    stats: [
      { value: "50K+", label: "Active Freelancers" },
      { value: "120K+", label: "Projects Completed" },
      { value: "98%", label: "Client Satisfaction" },
      { value: "$24M+", label: "Paid to Freelancers" },
      { value: "150+", label: "Countries Supported" },
      { value: "4.9/5", label: "Average Rating" },
    ],
  },

  socialProof: {
    badge: "TRUSTED BY THOUSANDS WORLDWIDE.",
    headline: ["Built for Top Talent.", "Trusted by Leading Companies."],
    body: "CLIVORA powers the work of thousands of freelancers and businesses worldwide. Join the community of top performers and innovative teams.",
    features: [
      {
        title: "Top 1% Talent",
        description: "Access pre-vetted and highly skilled freelancers across 120+ categories.",
        tone: "violet" as const,
      },
      {
        title: "Proven Quality",
        description: "4.9/5 average rating from 10,000+ clients across 150+ countries.",
        tone: "blue" as const,
      },
      {
        title: "Secure & Reliable",
        description: "Enterprise-grade security, escrow protection, and 24/7 support you can count on.",
        tone: "teal" as const,
      },
      {
        title: "Global Reach",
        description: "Work with clients and talent from anywhere in the world, anytime.",
        tone: "violet" as const,
      },
      {
        title: "Faster Delivery",
        description: "Get projects done faster with smart matching and AI-powered workflows.",
        tone: "orange" as const,
      },
      {
        title: "Business Growth",
        description: "Power your business with the tools, insights and connections you need to scale.",
        tone: "green" as const,
      },
    ],
    floatingStats: [
      { value: "10K+", label: "Active Freelancers", hint: "Ready to work on your projects." },
      { value: "120K+", label: "Projects Completed", hint: "↑ 28% this month" },
      { value: "$24M+", label: "Total Paid", hint: "↑ 32% this month" },
      { value: "150+", label: "Countries Supported", hint: "Across the globe" },
    ],
    trustedBy: {
      title: "TRUSTED BY LEADING COMPANIES AND STARTUPS.",
      body: "From innovative startups to global enterprises, teams trust CLIVORA to get work done.",
      link: { label: "See all customer stories", href: "/about" },
      logos: [
        "Toptal",
        "Upwork",
        "Microsoft",
        "Airbnb",
        "Payoneer",
        "Stripe",
        "Shopify",
        "Automattic",
      ],
    },
    metrics: [
      { value: "10,000+", label: "Active Clients" },
      { value: "50,000+", label: "Jobs Posted" },
      { value: "98%", label: "Client Satisfaction" },
      { value: "99.9%", label: "Uptime & Reliability" },
      { value: "24/7", label: "Expert Support" },
    ],
  },

  connect: {
    headline: ["Find Work. Hire Talent.", "Grow Together."],
    body: "Access thousands of verified freelancers and exciting projects. All without platform fees on your negotiated rates.",
    features: [
      {
        title: "No Platform Fees",
        description: "Keep 100% of what you earn. No hidden charges, ever.",
      },
      {
        title: "Verified Professionals",
        description: "Every freelancer is verified for skills, experience, and reliability.",
      },
      {
        title: "Smart Matching",
        description: "Our AI matches you with the perfect talent or projects instantly.",
      },
    ],
    primaryCta: { label: "Browse Jobs", href: "/connect" },
    secondaryCta: { label: "Find Freelancers", href: "/connect" },
    ribbon: [
      { value: "5,000+", label: "Active Jobs" },
      { value: "20,000+", label: "Freelancers" },
      { value: "98%", label: "Success Rate" },
      { value: "150+", label: "Countries" },
      { value: "50,000+", label: "Projects Completed" },
    ],
    categories: [
      { title: "Web Development", jobs: "1,200+ Jobs", tone: "green" as const },
      { title: "Mobile Apps", jobs: "980+ Jobs", tone: "violet" as const },
      { title: "Design & Creative", jobs: "860+ Jobs", tone: "orange" as const },
      { title: "AI & Machine Learning", jobs: "750+ Jobs", tone: "blue" as const },
      { title: "Writing & Content", jobs: "650+ Jobs", tone: "green" as const },
      { title: "Marketing", jobs: "520+ Jobs", tone: "violet" as const },
      { title: "Video & Animation", jobs: "420+ Jobs", tone: "orange" as const },
      { title: "Business", jobs: "310+ Jobs", tone: "blue" as const },
    ],
  },

  workspace: {
    headline: ["Your Freelance", "Business Operating System."],
    body: "CLIVORA gives freelancers everything they need to manage clients, projects, payments, and growth — all in one place.",
    cta: { label: "Explore Freelancer Workspace", href: "/for-freelancers" },
    features: [
      { title: "Project Management", description: "Plan and deliver projects." },
      { title: "Invoicing & Payments", description: "Create invoices and track earnings." },
      { title: "Time Tracking", description: "Track billable hours." },
      { title: "Client Communication", description: "Chat and share files." },
      { title: "CRM & Clients", description: "Manage leads and build relationships." },
      { title: "AI Assistant", description: "Write proposals and contracts." },
      { title: "Contracts & Docs", description: "Create and e-sign contracts." },
      { title: "Analytics & Reports", description: "Get business growth insights." },
    ],
    workflow: {
      title: "Your Workflow. Simplified.",
      steps: [
        { title: "Find Client", description: "Discover opportunities." },
        { title: "Send Proposal", description: "Create & send proposals." },
        { title: "Get Hired", description: "Client accepts proposal." },
        { title: "Work & Collaborate", description: "Complete project tasks." },
        { title: "Send Invoice", description: "Bill for your work." },
        { title: "Get Paid", description: "Receive payments." },
        { title: "Grow Business", description: "Build long-term success." },
      ],
    },
  },

  pricingPage: {
    badge: "Simple, transparent pricing",
    headline: "Start free. Upgrade when you grow.",
    body: site.pricing.earlyAccessNote,
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
          "CLIVORA AI insights",
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
        description: "Unlimited Connect, AI tools, and team collaboration.",
        cta: { label: "Get Pro Plus", href: "/pro" },
        highlighted: false,
        badge: "Best for growth",
        features: [
          "Everything in Pro",
          "Unlimited Connect credits",
          "AI proposal & contract writer",
          "Team seats & collaboration",
          `${site.proPlusLimits.fileVaultGb} GB File Vault`,
          "Advanced analytics & reports",
          "Priority marketplace visibility",
          "Dedicated onboarding",
        ],
      },
    ],
    note: site.pricing.billingNote,
  },

  featuresPage: {
    badge: "Product capabilities",
    headline: "Every tool. One Freelancer OS.",
    body: "From first lead to final payment — CLIVORA replaces the patchwork of apps freelancers and clients juggle every day.",
    groups: [
      {
        title: "Core business OS",
        items: [
          {
            title: "Business Command Center",
            description:
              "Paid revenue, outstanding amounts, active projects, and onboarding checklist — your morning snapshot in seconds.",
          },
          {
            title: "Client CRM",
            description:
              "Business name, contact, email, phone, WhatsApp, address, and notes. Search and manage your entire client base.",
          },
          {
            title: "Projects & Time Tracking",
            description:
              "Budgets, deadlines, status filters, and a built-in project timer. Track hours and earned revenue per project.",
          },
          {
            title: "Professional Invoicing",
            description:
              "Tax, discounts, draft/sent/paid/overdue workflow. Link invoices to clients and projects effortlessly.",
          },
        ],
      },
      {
        title: "Connect & growth",
        items: [
          {
            title: "CLIVORA Connect",
            description:
              "Private marketplace to find work and hire talent. Contact stays private until mutual accept. $0 platform fees on your deals.",
          },
          {
            title: "Proposals",
            description:
              "Send polished proposals, track status, and convert wins into projects without leaving CLIVORA.",
          },
          {
            title: "Messages",
            description: "Real-time chat with clients or freelancers, tied to projects and jobs.",
          },
          {
            title: "Reviews & reputation",
            description: "Build trust with verified reviews after completed work.",
          },
        ],
      },
      {
        title: "Money & documents",
        items: [
          {
            title: "Payments Hub",
            description: "Track payments, payouts, escrow, and outstanding balances in one place.",
          },
          {
            title: "Contracts & Documents",
            description: "Create, store, and manage contracts alongside your projects.",
          },
          {
            title: "Expenses & reports",
            description: "Log expenses and export financial reports for tax season.",
          },
          {
            title: "File Vault",
            description: "Secure cloud storage for briefs, deliverables, and client files.",
          },
        ],
      },
      {
        title: "Intelligence & platforms",
        items: [
          {
            title: "CLIVORA AI",
            description: "Draft proposals, contracts, replies, and invoices with AI assistance.",
          },
          {
            title: "Analytics",
            description: "Earnings trends, utilization, and growth insights for freelancers and teams.",
          },
          {
            title: "Web + Android",
            description: "One account across clivora.codcrafters.org and the Android app — cloud-first sync.",
          },
          {
            title: "Team collaboration",
            description: "Invite teammates, assign work, and grow beyond solo freelancing with Pro Plus.",
          },
        ],
      },
    ],
  },

  forFreelancers: {
    badge: "FREELANCER PORTAL",
    headline: "Run your freelance business like a pro.",
    body: "Dashboard, CRM, projects, invoices, Connect jobs, time tracking, and AI — purpose-built for freelancers who want one OS, not ten tabs.",
    cta: { label: "Start as Freelancer", href: "/signup?role=freelancer" },
    secondaryCta: { label: "See pricing", href: "/pricing" },
  },

  forClients: {
    badge: "CLIENT PORTAL",
    headline: "Hire talent. Manage projects. Pay with confidence.",
    body: "Post jobs, review proposals, track active work, hold escrow, and collaborate with freelancers — all inside CLIVORA.",
    cta: { label: "Start as Client", href: "/signup?role=client" },
    secondaryCta: { label: "Browse Connect", href: "/connect" },
  },

  faq: [
    {
      q: "Is CLIVORA free to start?",
      a: `Yes. Start on the Free plan with up to ${site.freeLimits.clients} clients and ${site.freeLimits.projects} projects. Upgrade to Pro (${site.pricing.proMonthlyLabel}/mo) or Pro Plus (${site.pricing.proPlusMonthlyLabel}/mo) when you need unlimited tools and Connect.`,
    },
    {
      q: "What is CLIVORA Connect?",
      a: "Connect is our private marketplace to find work and hire talent. Browse free; contact stays private until both sides accept. Negotiated rates have $0 platform fees.",
    },
    {
      q: "Does it work on web and Android?",
      a: "Yes. Use the full web app at clivora.codcrafters.org and the Android app with the same account. Data syncs in the cloud.",
    },
    {
      q: "Can clients and freelancers both use CLIVORA?",
      a: "Absolutely. Freelancers get a business OS; clients get a portal to post jobs, manage projects, and pay. Role-aware UI keeps each experience clear.",
    },
    {
      q: "How do Pro and Pro Plus billing work?",
      a: site.pricing.billingNote,
    },
    {
      q: "Is my data secure?",
      a: "We use enterprise-grade cloud infrastructure with authenticated access, role-based permissions, and documented privacy / data-safety policies.",
    },
  ],

  cta: {
    headline: "Ready to run your freelance business on one OS?",
    body: "Join freelancers and clients who manage work, money, and growth inside CLIVORA.",
    primary: { label: "Get Started Free", href: "/signup" },
    secondary: { label: "Explore documentation", href: "/docs" },
  },

  footer: {
    blurb:
      "The all-in-one Freelancer OS — Connect marketplace, CRM, projects, invoices, and payments. Web and Android.",
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
