export const site = {
  name: "CLIVORA",
  tagline: "Private Connect + Freelancer CRM",
  shortDescription:
    "Private Connect hiring, CRM, invoices, and timesheets on web and Android - $0 platform fee on your deals.",
  description:
    "CLIVORA is a freelancer OS from CODCrafters (Lahore). Hire and get hired on Connect with private contact until mutual accept, then run clients, projects, invoices, and timesheets on web and Android with one account. Platform fee on negotiated deals stays $0.",
  url: "https://clivora.codcrafters.org",
  appPackage: "org.codcrafters.clivora",
  appVersion: "3.8.1",
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
    billingNote: "Billed monthly via Google Play. Cancel anytime.",
    earlyAccessNote:
      "Start free, then upgrade to Pro ($9/mo) or Pro Plus ($19/mo) when you need unlimited tools and Connect.",
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
