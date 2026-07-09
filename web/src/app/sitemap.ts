import type { MetadataRoute } from "next";
import { site, legalLinks } from "@/lib/site";

export default function sitemap(): MetadataRoute.Sitemap {
  const pages = [
    "",
    legalLinks.privacy,
    legalLinks.terms,
    legalLinks.cookies,
    legalLinks.about,
    legalLinks.contact,
    legalLinks.support,
    legalLinks.deleteAccount,
    legalLinks.dataSafety,
  ];

  return pages.map((path) => ({
    url: `${site.url}${path}`,
    lastModified: new Date(),
    changeFrequency: path === "" ? "weekly" : "monthly",
    priority: path === "" ? 1 : 0.7,
  }));
}
