export const site = {
  name: "CLIVORA",
  tagline: "Freelancer OS — Connect, CRM & Invoices",
  shortDescription:
    "Early-access Freelancer OS: clients, projects, invoices, Connect, and business tools on web and Android — one account.",
  description:
    "Clivora is an early-access Freelancer OS from CODCrafters. Manage clients, projects, proposals, invoices, expenses, time tracking, and professional connections in one web and Android workspace.",
  url: "https://clivora.codcrafters.org",
  appPackage: "org.codcrafters.clivora",
  appVersion: "2.20.0",
  company: {
    name: "CODCrafters",
    url: "https://codcrafters.org",
    email: "iusmanghias@gmail.com",
    privacyEmail: "iusmanghias@gmail.com",
    legalEmail: "iusmanghias@gmail.com",
  },
  pricing: {
    proMonthlyUsd: 9,
    proMonthlyLabel: "$9",
    proPlusMonthlyUsd: 19,
    proPlusMonthlyLabel: "$19",
    proListLabel: "$14",
    proPlusListLabel: "$29",
    billingNote:
      "Android subscriptions are billed through Google Play. Web billing will be introduced separately. Cancel anytime.",
    earlyAccessNote:
      "Start free, then upgrade to Pro ($9/mo) or Pro Plus ($19/mo) when you need unlimited tools and Connect. Early access — help shape Clivora.",
  },
  freeLimits: {
    clients: 3,
    projects: 5,
    invoicesPerMonth: 10,
    templates: 3,
    fileVaultMb: 100,
  },
  proLimits: {
    fileVaultGb: 5,
  },
  proPlusLimits: {
    fileVaultGb: 50,
  },
  social: {
    github: "https://github.com/usmanghias/clivora-web",
  },
  playStoreUrl: "https://play.google.com/store/apps/details?id=org.codcrafters.clivora",
  /** Custom scheme handled by Android MainActivity */
  appDeepLinkScheme: "clivora",
  appStoreUrl: "#",
  proCheckoutUrl: "/pro",
} as const;

export const legalLinks = {
  privacy: "/privacy",
  terms: "/terms",
  cookies: "/cookies",
  deleteAccount: "/delete-account",
  dataSafety: "/data-safety",
  support: "/support",
  about: "/about",
  contact: "/contact",
} as const;
