import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { getProfile, isClientAccount, planLabel } from "@/lib/profile";
import { site } from "@/lib/site";
import { DownloadAppCard } from "@/components/app/DownloadAppCard";

export default async function AppHomePage() {
  const profile = await getProfile();
  const client = isClientAccount(profile);
  const plan = planLabel(profile);
  const supabase = await createClient();
  const uid = profile?.id ?? "";

  let invoiceCount = 0;
  let projectCount = 0;
  let notifCount = 0;
  try {
    const [inv, proj, notif] = await Promise.all([
      supabase
        .from("invoice_shares")
        .select("share_id", { count: "exact", head: true })
        .eq(client ? "client_uid" : "freelancer_uid", uid),
      supabase
        .from("project_shares")
        .select("share_id", { count: "exact", head: true })
        .eq(client ? "client_uid" : "freelancer_uid", uid),
      supabase
        .from("notifications")
        .select("id", { count: "exact", head: true })
        .eq("user_uid", uid)
        .eq("is_read", false),
    ]);
    invoiceCount = inv.count ?? 0;
    projectCount = proj.count ?? 0;
    notifCount = notif.count ?? 0;
  } catch {
    /* ignore */
  }

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
        <div className="mt-4 grid grid-cols-3 gap-2">
          <Stat label="Projects" value={projectCount} />
          <Stat label="Invoices" value={invoiceCount} />
          <Stat label="Unread" value={notifCount} />
        </div>
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
            <HomeCard title="Invoices" body="Shared invoices from freelancers." href="/app/invoices" />
            <HomeCard title="Messages" body="Cloud message history." href="/app/messages" />
            <HomeCard title="Tasks" body="Assigned client tasks." href="/app/tasks" />
            <HomeCard title="Account" body="Profile & plan." href="/app/account" />
            <HomeCard title="Connect" body="Post needs & find freelancers." href="/connect" />
            <HomeCard title="Notifications" body="Cloud alerts." href="/app/notifications" />
          </>
        ) : (
          <>
            <HomeCard title="Clients" body="Cloud-linked client shares." href="/app/clients" />
            <HomeCard title="Work" body="Shared projects." href="/app/projects" />
            <HomeCard title="Billing" body="Invoice shares & payments." href="/app/invoices" />
            <HomeCard title="Hub" body="Shortcuts & upgrade." href="/app/hub" />
            <HomeCard title="Connect" body="Marketplace (Pro Plus to post)." href="/connect" />
            <HomeCard title="Notifications" body="Cloud alerts." href="/app/notifications" />
          </>
        )}
      </section>

      <DownloadAppCard
        title="Need offline CRM, PDF branding, AI, vault, or workflows?"
        body="Those tools run best in the CLIVORA Android app. Web stays connected to the same Supabase data for shares, Connect, invoices, and messages."
      />
    </div>
  );
}

function Stat({ label, value }: { label: string; value: number }) {
  return (
    <div className="rounded-xl bg-white/10 px-3 py-2 text-center">
      <p className="text-lg font-extrabold">{value}</p>
      <p className="text-[10px] uppercase tracking-wide text-white/70">{label}</p>
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
