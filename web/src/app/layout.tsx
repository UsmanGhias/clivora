import type { Metadata } from "next";
import { Inter } from "next/font/google";
import { site } from "@/lib/site";
import "./globals.css";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

export const metadata: Metadata = {
  metadataBase: new URL(site.url),
  title: {
    default: `${site.name} - ${site.tagline}`,
    template: `%s - ${site.name}`,
  },
  description: site.description,
  keywords: [
    "freelancer CRM",
    "business operating system",
    "invoice app",
    "project management",
    "agency tools",
    "CLIVORA",
    "CODCrafters",
  ],
  authors: [{ name: site.company.name, url: site.company.url }],
  creator: site.company.name,
  publisher: site.company.name,
  openGraph: {
    title: `${site.name} - ${site.tagline}`,
    description:
      "Run your entire freelance business from one beautiful app. CRM, invoicing, projects, expenses & more.",
    url: site.url,
    siteName: site.name,
    type: "website",
    locale: "en_US",
  },
  twitter: {
    card: "summary_large_image",
    title: `${site.name} - ${site.tagline}`,
    description:
      "Run your entire freelance business from one beautiful app.",
  },
  robots: {
    index: true,
    follow: true,
  },
  icons: {
    icon: "/clivora_logo.png",
    apple: "/app-icon.png",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className={inter.variable}>
      <body className="min-h-screen overflow-x-hidden">{children}</body>
    </html>
  );
}
