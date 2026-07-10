import { site, legalLinks } from "@/lib/site";
import Link from "next/link";
import { Github, Mail } from "lucide-react";

const footerLinks = {
  Product: [
    { label: "Features", href: "/#features" },
    { label: "Connect", href: "/connect" },
    { label: "Pricing", href: "/#pricing" },
    { label: "FAQ", href: "/#faq" },
    { label: "Sign in", href: "/login" },
  ],
  Company: [
    { label: "About CODCrafters", href: legalLinks.about },
    { label: "Contact", href: legalLinks.contact },
    { label: "Support", href: legalLinks.support },
  ],
  Legal: [
    { label: "Privacy Policy", href: legalLinks.privacy },
    { label: "Terms of Service", href: legalLinks.terms },
    { label: "Cookie Policy", href: legalLinks.cookies },
    { label: "Data Safety", href: legalLinks.dataSafety },
    { label: "Delete Account", href: legalLinks.deleteAccount },
  ],
};

export function Footer() {
  return (
    <footer className="relative border-t border-white/5 bg-dark-bg pt-16 pb-8">
      <div className="mx-auto max-w-7xl px-6 lg:px-8">
        <div className="grid gap-12 lg:grid-cols-5">
          <div className="lg:col-span-2">
            <Link href="/" className="inline-block">
              <span className="text-xl font-bold tracking-wider text-white">
                CLIVORA
              </span>
            </Link>
            <p className="mt-1 text-xs font-medium uppercase tracking-widest text-primary">
              by {site.company.name}
            </p>
            <p className="mt-4 max-w-sm text-sm text-white/50 leading-relaxed">
              {site.tagline}. The all-in-one platform for freelancers and
              agencies to manage clients, projects, invoices, and more.
            </p>
            <div className="mt-6 flex gap-4">
              <a
                href={site.social.github}
                target="_blank"
                rel="noopener noreferrer"
                aria-label="GitHub"
                className="flex h-10 w-10 items-center justify-center rounded-xl glass text-white/50 transition-colors hover:bg-white/10 hover:text-white"
              >
                <Github className="h-5 w-5" />
              </a>
              <a
                href={`mailto:${site.company.email}`}
                aria-label="Email"
                className="flex h-10 w-10 items-center justify-center rounded-xl glass text-white/50 transition-colors hover:bg-white/10 hover:text-white"
              >
                <Mail className="h-5 w-5" />
              </a>
            </div>
          </div>

          {Object.entries(footerLinks).map(([category, links]) => (
            <div key={category}>
              <h4 className="text-sm font-semibold uppercase tracking-wider text-white/80">
                {category}
              </h4>
              <ul className="mt-4 space-y-3">
                {links.map((link) => (
                  <li key={link.label}>
                    <Link
                      href={link.href}
                      className="text-sm text-white/50 transition-colors hover:text-white"
                    >
                      {link.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        <div className="mt-12 flex flex-col items-center justify-between gap-4 border-t border-white/5 pt-8 sm:flex-row">
          <p className="text-sm text-white/40">
            &copy; {new Date().getFullYear()} {site.company.name}. {site.name}{" "}
            is a product of {site.company.name}.
          </p>
          <p className="text-sm text-white/40">
            <a
              href={site.company.url}
              className="hover:text-white transition-colors"
            >
              {site.company.url.replace("https://", "")}
            </a>
          </p>
        </div>
      </div>
    </footer>
  );
}
