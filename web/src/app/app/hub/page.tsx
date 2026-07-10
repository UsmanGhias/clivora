import Link from "next/link";
import { getProfile, planLabel } from "@/lib/profile";
import { site } from "@/lib/site";

export default async function HubPage() {
  const profile = await getProfile();
  const plan = planLabel(profile);

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-extrabold">Hub</h1>
        <p className="text-sm text-text-secondary">Shortcuts for your web workspace.</p>
      </div>

      <div className="rounded-2xl bg-navy p-5 text-white">
        <p className="text-sm text-white/70">{profile?.email}</p>
        <p className="mt-1 text-xl font-extrabold">{profile?.name || "Freelancer"}</p>
        <p className="mt-2 text-sm">Plan: {plan}</p>
      </div>

      <div className="grid gap-3 sm:grid-cols-2">
        <HubLink href="/connect" title="CLIVORA Connect" body="Marketplace for freelancers & clients" />
        <HubLink href="/pro" title="Upgrade" body={`Pro ${site.pricing.proMonthlyLabel}/mo · Plus ${site.pricing.proPlusMonthlyLabel}/mo`} />
        <HubLink href="/app/invoices" title="Payment & invoices" body="Cloud invoice shares" />
        <HubLink href="/support" title="Support" body="Help & FAQ" />
        <HubLink href={site.playStoreUrl} title="Mobile app" body="Full CRM on Android" external />
      </div>
    </div>
  );
}

function HubLink({
  href,
  title,
  body,
  external,
}: {
  href: string;
  title: string;
  body: string;
  external?: boolean;
}) {
  const className =
    "rounded-2xl border border-border bg-surface p-4 transition hover:border-primary/40";
  if (external) {
    return (
      <a href={href} target="_blank" rel="noreferrer" className={className}>
        <p className="font-bold">{title}</p>
        <p className="text-sm text-text-secondary">{body}</p>
      </a>
    );
  }
  return (
    <Link href={href} className={className}>
      <p className="font-bold">{title}</p>
      <p className="text-sm text-text-secondary">{body}</p>
    </Link>
  );
}
