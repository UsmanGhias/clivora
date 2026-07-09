export const site = {
  name: "CLIVORA",
  tagline: "Your Business Operating System",
  shortDescription:
    "CRM for freelancers: clients, projects, invoices and revenue in one app.",
  description:
    "CLIVORA is your all-in-one Business Operating System for freelancers, consultants, and small agencies. Manage clients, track projects, send branded PDF invoices, and monitor revenue from your phone.",
  url: "https://clivora.codcrafters.org",
  appPackage: "org.codcrafters.clivora",
  appVersion: "2.7.1",
  company: {
    name: "CODCrafters",
    url: "https://codcrafters.org",
    email: "iusmanghias@gmail.com",
    privacyEmail: "iusmanghias@gmail.com",
    legalEmail: "iusmanghias@gmail.com",
  },
  pricing: {
    proMonthlyPkr: 2000,
    proMonthlyLabel: "Rs 2,000",
    proPlusMonthlyPkr: 3500,
    proPlusMonthlyLabel: "Rs 3,500",
    billingNote: "Billed monthly. Cancel anytime.",
    earlyAccessNote:
      "Start free, then upgrade to Pro or Pro Plus from the website checkout when you need unlimited tools.",
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
  social: {
    github: "https://github.com/usmanghias/clivora-web",
  },
  playStoreUrl: "https://play.google.com/store/apps/details?id=org.codcrafters.clivora",
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
