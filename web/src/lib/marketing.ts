import { site } from "@/lib/site";

/**
 * Single source of truth for marketing site copy, navigation, and section data.
 * Edit this file to reconfigure the public website without touching components.
 */
export const marketing = {
  brand: {
    name: site.name,
    productLine: "FREELANCER OS",
    badge: "Built in Lahore · Web + Android",
    tagline: "Clients, invoices, and hiring - without the marketplace tax.",
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
    cta: { label: "Open free workspace", href: "/signup" },
    login: { label: "Login", href: "/login" },
    locale: "EN",
  },

  hero: {
    badge: "CODCrafters · clivora.codcrafters.org",
    headline: ["Stop losing 20%", "to marketplace fees."],
    body:
      "CLIVORA is a freelancer OS from Lahore: private Connect (emails unlock only after mutual accept), CRM, invoices, timesheets, and Android sync on one Supabase account. Platform fee on your deals stays $0 - keep JazzCash, bank, or Play Billing for upgrades.",
    primaryCta: { label: "I'm a Freelancer", href: "/signup?role=freelancer" },
    secondaryCta: { label: "I'm hiring", href: "/signup?role=client" },
    trusts: [
      "$0 Connect platform fee",
      "Private until both accept",
      "Web + Android, one login",
    ],
  },

  trustBar: {
    title: "Built for freelancers who already ship for real clients - not demo dashboards.",
    logos: [
      "CODCrafters",
      "Lahore studios",
      "Karachi freelancers",
      "Dubai remote teams",
      "Islamabad agencies",
      "PK Play Billing",
      "JazzCash Pro",
      "Supabase cloud",
    ],
  },

  dualPortal: {
    badge: "TWO PORTALS · ONE ACCOUNT",
    headline: ["Freelancer desk.", "Client desk."],
    body: "Same product, different home screens. Freelancers run CRM and money. Clients post needs, review talent, and track shared projects - without another SaaS login.",
    tabs: [
      { id: "freelancer" as const, label: "For Freelancers" },
      { id: "client" as const, label: "For Clients" },
    ],
    sideFeatures: {
      left: [
        {
          title: "Morning money view",
          description: "Paid invoices, open balances, and active projects before your first coffee.",
          tone: "violet" as const,
        },
        {
          title: "Projects with real rates",
          description: "Fixed or hourly budgets. Timer uses the client-approved rate - not a made-up number.",
          tone: "green" as const,
        },
        {
          title: "Invoices that match the work",
          description: "Draft → sent → paid. Link to clients and projects you already track.",
          tone: "orange" as const,
        },
      ],
      right: [
        {
          title: "Messages that stick",
          description: "Threads per contact from Connect matches and CRM emails - not a separate chat app.",
          tone: "blue" as const,
        },
        {
          title: "Connect hiring",
          description: "Post a need or apply with cover letter + bid. Contact stays hidden until accept.",
          tone: "violet" as const,
        },
        {
          title: "Ask AI on your CRM",
          description: "Answers from your invoices and projects when keys are set - or honest offline tips.",
          tone: "teal" as const,
        },
      ],
    },
    bottomStrip: [
      "Analytics",
      "Expenses",
      "Contracts",
      "Timesheets",
      "Meetings (Jitsi)",
      "File vault",
    ],
    socialProof: "Shipped by CODCrafters. Used by freelancers who invoice in PKR and USD.",
    activeUsers: "Early access cohort",
  },

  freelancerOs: {
    headline: "The desk you open when a client says “send the invoice tonight.”",
    body: "Clients, projects, proposals, invoices, and tracked hours in one workspace - so you are not copying numbers between WhatsApp, Sheets, and a third tool at 11pm.",
    cta: { label: "See the full toolkit", href: "/features" },
    features: [
      {
        title: "Dashboard that tells the truth",
        description: "Revenue and pending from your invoices - not vanity “success score” widgets.",
      },
      {
        title: "Kanban + CRM projects",
        description: "Drag status on mobile-wide columns. Budget and hourly type live on the project.",
      },
      {
        title: "Invoicing",
        description: "Create, send, mark paid. Payout methods show Not connected until you actually set them.",
      },
      {
        title: "Timesheets",
        description: "Live timer tied to approved hourly rates ($3–$500). Empty state if the client never set one.",
      },
      {
        title: "Client records",
        description: "Emails, phones, notes, and custom fields that save to your CRM - not a fake form.",
      },
      {
        title: "Ask AI",
        description: "Ask about plans, Connect, overdue invoices, or Android vs web - grounded in your data.",
      },
    ],
    stats: [
      { value: "Free", label: "to start CRM" },
      { value: "$0", label: "Connect deal fee" },
      { value: "$9", label: "Pro / month" },
      { value: "$19", label: "Pro Plus / month" },
      { value: "PK", label: "JazzCash upgrades" },
      { value: "2", label: "platforms · web+app" },
    ],
  },

  socialProof: {
    badge: "WHY PEOPLE STAY",
    headline: ["Private hiring.", "Honest money tools."],
    body: "CLIVORA is not another “revolutionary OS” pitch. It is Connect without contact spam, invoices without fake Stripe Connected badges, and an Android app that shares the same account as the website.",
    features: [
      {
        title: "Talent you can verify",
        description: "Connect cards show rate, skills, and ratings from real reviews - load more as the list grows.",
        tone: "violet" as const,
      },
      {
        title: "Privacy by default",
        description: "Emails reveal only after mutual accept. Decline and the other side never gets your inbox.",
        tone: "teal" as const,
      },
      {
        title: "Proposal → project → invoice",
        description: "Win a Connect job, keep the thread, open the project, bill from the same workspace.",
        tone: "orange" as const,
      },
      {
        title: "Ratings from finished work",
        description: "Reviews attach after delivery - we do not invent 4.9 stars on empty profiles.",
        tone: "blue" as const,
      },
      {
        title: "Works across time zones",
        description: "Lahore mornings, Dubai client calls, remote US handoffs - one login on phone and laptop.",
        tone: "violet" as const,
      },
      {
        title: "Grow past one-off gigs",
        description: "CRM + analytics for retainers and repeat clients, not only marketplace one-shots.",
        tone: "green" as const,
      },
    ],
    floatingStats: [
      { value: "$0", label: "Platform fee", hint: "On negotiated Connect deals" },
      { value: "Mutual", label: "Accept to unlock email", hint: "No cold contact spam" },
      { value: "PK + global", label: "Billing paths", hint: "JazzCash · Play · portal" },
      { value: "Same DB", label: "Web & Android", hint: "Supabase-backed sync" },
    ],
    trustedBy: {
      title: "FROM CODCRAFTERS CLIENT WORK TO YOUR FREELANCE DESK",
      body: "We built CLIVORA while shipping real projects - the product mirrors how we already run client delivery.",
      link: { label: "About CODCrafters", href: "/about" },
      logos: [
        "CODCrafters",
        "Play Store app",
        "Supabase",
        "Next.js web",
        "Flutter Android",
        "JazzCash",
        "Jitsi meetings",
        "Connect marketplace",
      ],
    },
    metrics: [
      { value: "Free→Pro", label: "Clear plan ladder" },
      { value: "Connect", label: "Jobs · talent · inbox" },
      { value: "Honest UI", label: "No fake Connected" },
      { value: "Email", label: "Support from Usman" },
      { value: "Docs", label: "Product guides" },
    ],
  },

  connect: {
    headline: ["Hire without buying leads.", "Get hired without selling your rate."],
    body: "Connect is a private board: clients post needs, freelancers apply with cover letter and bid, inbox shows accept/decline. Zero CLIVORA cut on the fee you negotiate.",
    features: [
      {
        title: "Private contact",
        description: "Email appears only after both sides accept.",
      },
      {
        title: "$0 platform fee",
        description: "Keep the rate you agree - we are not Upwork tokens.",
      },
      {
        title: "CRM after match",
        description: "Turn the hire into a project, tasks, and invoices.",
      },
    ],
    primaryCta: { label: "I want to hire", href: "/signup?role=client&next=/connect" },
    secondaryCta: { label: "I want work", href: "/signup?role=freelancer&next=/connect" },
    ribbon: [
      { value: "Jobs", label: "Feed + filters" },
      { value: "Talent", label: "Paginated cards" },
      { value: "Inbox", label: "Accept / decline" },
      { value: "$0", label: "Deal fee" },
      { value: "Pro+", label: "Credits & listing" },
    ],
    categories: [
      { title: "Web Development", jobs: "Open roles", tone: "green" as const },
      { title: "Mobile Apps", jobs: "Flutter & native", tone: "violet" as const },
      { title: "Design & Creative", jobs: "Brand & UI", tone: "orange" as const },
      { title: "AI & Automation", jobs: "Agents & pipelines", tone: "blue" as const },
      { title: "Writing & Content", jobs: "Briefs & SEO", tone: "green" as const },
      { title: "Marketing", jobs: "Campaigns", tone: "violet" as const },
      { title: "Video", jobs: "Edit & motion", tone: "orange" as const },
      { title: "Business ops", jobs: "Ops & VA", tone: "blue" as const },
    ],
  },

  workspace: {
    headline: ["Your freelance", "operating desk."],
    body: "Open /app after signup: projects, clients, invoices, timesheets, messages, meetings. Upgrade only when Connect credits or unlimited CRM limits matter.",
    cta: { label: "Tour freelancer workspace", href: "/for-freelancers" },
    features: [
      { title: "Projects", description: "Pipeline + kanban status." },
      { title: "Invoices", description: "Bill and mark paid." },
      { title: "Timesheets", description: "Approved hourly rates." },
      { title: "Messages", description: "Compact threads." },
      { title: "Clients CRM", description: "Custom fields that save." },
      { title: "Ask AI", description: "CRM + product FAQ." },
      { title: "Contracts", description: "Clean body, no meta dump." },
      { title: "Meetings", description: "Jitsi rooms + Calendar OAuth." },
    ],
    workflow: {
      title: "How a typical week looks",
      steps: [
        { title: "Browse Connect", description: "Jobs or talent." },
        { title: "Send proposal", description: "Cover letter + bid." },
        { title: "Mutual accept", description: "Emails unlock." },
        { title: "Share project", description: "Budget / hourly rate." },
        { title: "Track time", description: "Timer uses that rate." },
        { title: "Invoice", description: "Send and chase." },
        { title: "Repeat", description: "Keep the CRM." },
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
    body: "From first lead to final payment - CLIVORA replaces the patchwork of apps freelancers and clients juggle every day.",
    groups: [
      {
        title: "Core business OS",
        items: [
          {
            title: "Business Command Center",
            description:
              "Paid revenue, outstanding amounts, active projects, and onboarding checklist - your morning snapshot in seconds.",
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
            description: "One account across clivora.codcrafters.org and the Android app - cloud-first sync.",
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
    body: "Dashboard, CRM, projects, invoices, Connect jobs, time tracking, and AI - purpose-built for freelancers who want one OS, not ten tabs.",
    cta: { label: "Start as Freelancer", href: "/signup?role=freelancer" },
    secondaryCta: { label: "See pricing", href: "/pricing" },
  },

  forClients: {
    badge: "CLIENT PORTAL",
    headline: "Hire talent. Manage projects. Pay with confidence.",
    body: "Post jobs, review proposals, track active work, hold escrow, and collaborate with freelancers - all inside CLIVORA.",
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
    headline: "Open a free workspace before your next invoice is due.",
    body: "Freelancer or client - same signup. Connect stays private until mutual accept. Upgrade with JazzCash or Play when you need Pro.",
    primary: { label: "Create free account", href: "/signup" },
    secondary: { label: "Read docs", href: "/docs" },
  },

  footer: {
    blurb:
      "CLIVORA by CODCrafters (Lahore): private Connect, CRM, invoices, timesheets. Web + Android. $0 platform fee on negotiated deals.",
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
