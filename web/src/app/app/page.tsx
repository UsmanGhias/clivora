import Link from "next/link";
import { getProfile, isClientAccount, planLabel } from "@/lib/profile";
import { site } from "@/lib/site";

export default async function AppHomePage() {
  const profile = await getProfile();
  const client = isClientAccount(profile);
  const plan = planLabel(profile);

  return (
    <div className="space-y-6">
      <section className="rounded-2xl bg-brand-gradient p-6 text-white shadow-lg">
        <p className="text-sm text-white/70">Welcome back</p>
        <h1 className="mt-1 text-2xl font-extrabold">
          {profile?.name || (client ? "Client" : "Freelancer")}
        </h1>
        <p className="mt-2 text-sm text-white/80">
          Plan: <span className="font-semibold">{plan}</span> · Same Supabase account as the mobile app
        </p>
        <div className="mt-4 flex flex-wrap gap-2">
          <Link
            href="/connect"
            className="rounded-full bg-white/15 px-4 py-2 text-sm font-semibold hover:bg-white/25"
          >
            Explore Connect
          </Link>
          <Link
            href="/pro"
            className="rounded-full bg-primary px-4 py-2 text-sm font-semibold text-white"
          >
            Upgrade · Pro {site.pricing.proMonthlyLabel} / Plus {site.pricing.proPlusMonthlyLabel}
          </Link>
        </div>
      </section>

      <section className="grid gap-4 sm:grid-cols-2">
        {client ? (
          <>
            <HomeCard
              title="Invoices"
              body="View shared invoices from your freelancers."
              href="/app/invoices"
            />
            <HomeCard
              title="Messages"
              body="Chat continues in the mobile app for now — open Messages for tips."
              href="/app/messages"
            />
            <HomeCard
              title="Account"
              body="Profile details and plan status."
              href="/app/account"
            />
            <HomeCard
              title="Connect marketplace"
              body="Post needs and discover freelancers."
              href="/connect"
            />
          </>
        ) : (
          <>
            <HomeCard
              title="Clients"
              body="Cloud-linked clients when synced from the app."
              href="/app/clients"
            />
            <HomeCard
              title="Invoices"
              body="Cloud invoice shares awaiting payment or confirmation."
              href="/app/invoices"
            />
            <HomeCard
              title="Hub"
              body="Shortcuts for upgrade, Connect, and backup guidance."
              href="/app/hub"
            />
            <HomeCard
              title="Connect marketplace"
              body="List services and match with clients (Pro Plus)."
              href="/connect"
            />
          </>
        )}
      </section>
    </div>
  );
}

function HomeCard({
  title,
  body,
  href,
}: {
  title: string;
  body: string;
  href: string;
}) {
  return (
    <Link
      href={href}
      className="rounded-2xl border border-border bg-surface p-5 shadow-sm transition hover:border-primary/40"
    >
      <h2 className="font-bold text-text-primary">{title}</h2>
      <p className="mt-1 text-sm text-text-secondary">{body}</p>
    </Link>
  );
}
