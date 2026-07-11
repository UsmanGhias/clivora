import Link from "next/link";
import { redirect } from "next/navigation";
import { getProfile, isClientAccount, planLabel } from "@/lib/profile";
import { site } from "@/lib/site";
import { SmartAppCta } from "@/components/app/SmartAppCta";
import { AskAi } from "@/components/app/AskAi";

/** Freelancer hub — mirrors Flutter /more with app-preferred tools called out. */
export default async function HubPage() {
  const profile = await getProfile();
  if (isClientAccount(profile)) redirect("/app/account");
  const plan = planLabel(profile);

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-extrabold">Hub</h1>
        <p className="text-sm text-text-secondary">
          Web shortcuts plus tools that open best in the CLIVORA app.
        </p>
      </div>

      <div className="rounded-2xl bg-navy p-5 text-white">
        <p className="text-sm text-white/70">{profile?.email}</p>
        <p className="mt-1 text-xl font-extrabold">{profile?.name || "Freelancer"}</p>
        <p className="mt-2 text-sm">Plan: {plan}</p>
        <p className="mt-3 text-xs text-white/65">
          Today: check overdue invoices, answer Connect inbox, and keep your Connect profile complete
          for stronger ranking.
        </p>
      </div>

      <div className="grid gap-3 sm:grid-cols-3">
        <HubLink href="/app/invoices" title="What's overdue?" body="Invoices needing follow-up" />
        <HubLink href="/connect" title="Needs action" body="Connect inbox & proposals" />
        <HubLink href="/connect/manage" title="Trust profile" body="Ratings · completeness · listing" />
      </div>

      <div>
        <h2 className="mb-3 text-sm font-bold uppercase tracking-wide text-text-secondary">
          Available on web
        </h2>
        <div className="grid gap-3 sm:grid-cols-2">
          <HubLink href="/app/clients" title="Clients" body="Cloud CRM" />
          <HubLink href="/app/projects" title="Work" body="Projects" />
          <HubLink href="/app/invoices" title="Billing" body="Invoices" />
          <HubLink href="/app/messages" title="Messages" body="Cloud inbox" />
          <HubLink href="/app/timesheets" title="Timesheets" body="Log & approve time" />
          <HubLink href="/app/meetings" title="Meetings" body="Jitsi video rooms" />
          <HubLink href="/app/support" title="Support" body="Submit a ticket" />
          <HubLink href="/connect" title="CLIVORA Connect" body="Marketplace" />
          <HubLink
            href="/pro"
            title="Upgrade"
            body={`Pro ${site.pricing.proMonthlyLabel}/mo · Plus ${site.pricing.proPlusMonthlyLabel}/mo`}
          />
        </div>
      </div>

      <div>
        <h2 className="mb-3 text-sm font-bold uppercase tracking-wide text-text-secondary">
          Best in the mobile app
        </h2>
        <div className="grid gap-3 sm:grid-cols-2">
          <AppPreferred title="AI assistant" body="Drafts, summaries, coaching" />
          <AppPreferred title="Calendar & time" body="Scheduling and timers" />
          <AppPreferred title="Reports & analytics" body="Revenue charts" />
          <AppPreferred title="Contracts & vault" body="PDFs and secure files" />
          <AppPreferred title="Automations" body="Workflows & reminders" />
          <AppPreferred title="Team & biometrics" body="Seats and lock screen" />
        </div>
      </div>

      <AskAi />

      <SmartAppCta
        title="Open the full freelancer toolkit"
        body="Expenses, notes, quotes, products, recurring invoices, backup, and offline CRM sync on Android."
        deepPath="open/more"
      />
    </div>
  );
}

function HubLink({ href, title, body }: { href: string; title: string; body: string }) {
  return (
    <Link
      href={href}
      className="rounded-2xl border border-border bg-surface p-4 transition hover:border-primary/40"
    >
      <p className="font-bold">{title}</p>
      <p className="text-sm text-text-secondary">{body}</p>
    </Link>
  );
}

function AppPreferred({ title, body }: { title: string; body: string }) {
  return (
    <div className="rounded-2xl border border-dashed border-primary/30 bg-primary/5 p-4">
      <p className="font-bold text-navy">{title}</p>
      <p className="text-sm text-text-secondary">{body}</p>
      <p className="mt-1 text-[11px] font-semibold uppercase tracking-wide text-primary-dark">
        App preferred
      </p>
    </div>
  );
}
