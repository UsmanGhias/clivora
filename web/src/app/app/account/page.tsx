import Link from "next/link";
import { getProfile, isClientAccount, planLabel } from "@/lib/profile";
import { site } from "@/lib/site";
import { SmartAppCta } from "@/components/app/SmartAppCta";

/** Client account + hub shortcuts (contracts, files, etc. → app). */
export default async function AccountPage() {
  const profile = await getProfile();
  const client = isClientAccount(profile);

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-extrabold">Account</h1>
      <div
        className={`rounded-2xl border p-5 ${
          client ? "border-client-accent/20 bg-client-surface" : "border-border bg-surface"
        }`}
      >
        <p className="text-sm text-text-secondary">Name</p>
        <p className="font-semibold">{profile?.name || "—"}</p>
        <p className="mt-3 text-sm text-text-secondary">Email</p>
        <p className="font-semibold">{profile?.email || "—"}</p>
        <p className="mt-3 text-sm text-text-secondary">Role</p>
        <p className="font-semibold">{client ? "Client" : "Freelancer"}</p>
        <p className="mt-3 text-sm text-text-secondary">Plan</p>
        <p className="font-semibold">{planLabel(profile)}</p>
      </div>

      {client && (
        <div className="grid gap-3 sm:grid-cols-2">
          <HubHint title="Contracts" body="View & sign in the app" />
          <HubHint title="Quotes" body="Shared quotes in the app" />
          <HubHint title="Payments" body="Confirm payments in the app" />
          <HubHint title="Files & milestones" body="Vault & progress in the app" />
          <Link
            href="/app/activity"
            className="rounded-2xl border border-border bg-surface p-4 hover:border-client-accent/40"
          >
            <p className="font-bold">Updates</p>
            <p className="text-sm text-text-secondary">Activity feed on web</p>
          </Link>
          <Link
            href="/app/projects"
            className="rounded-2xl border border-border bg-surface p-4 hover:border-client-accent/40"
          >
            <p className="font-bold">Shared projects</p>
            <p className="text-sm text-text-secondary">Work linked to you</p>
          </Link>
        </div>
      )}

      <Link
        href="/pro"
        className={`inline-flex rounded-full px-4 py-2 text-sm font-semibold text-white ${
          client ? "bg-client-accent" : "bg-primary"
        }`}
      >
        Upgrade · Pro {site.pricing.proMonthlyLabel} / Plus {site.pricing.proPlusMonthlyLabel}
      </Link>

      <div className="rounded-2xl border border-border bg-surface p-5">
        <h2 className="font-bold text-navy">Two-factor authentication (MFA)</h2>
        <p className="mt-2 text-sm text-text-secondary leading-relaxed">
          CLIVORA uses Supabase Auth which supports TOTP-based MFA. To enable authenticator-app
          2FA, go to your{" "}
          <a
            href="https://supabase.com/docs/guides/auth/auth-mfa"
            target="_blank"
            rel="noopener noreferrer"
            className="font-semibold text-primary underline underline-offset-2"
          >
            Supabase security settings
          </a>{" "}
          or ask your admin to enable MFA enforcement. Once enrolled you will be prompted for a
          6-digit code on every sign-in.
        </p>
        <p className="mt-2 text-xs text-text-muted">
          App-level biometric lock is available separately in the CLIVORA Android app under
          Settings → Security.
        </p>
      </div>

      <SmartAppCta
        tone={client ? "client" : "freelancer"}
        title={client ? "Open the full client portal" : "Manage profile in the app"}
        body={
          client
            ? "Link freelancers, contracts, credits, recurring invoices, and biometric lock are on Android."
            : "Profile photo, security, and backup settings are in the mobile app. Referrals are also on web."
        }
        deepPath={client ? "open/client-account" : "open/profile"}
      />

      <Link
        href="/app/referrals"
        className="inline-flex rounded-full border border-navy/20 px-4 py-2 text-sm font-semibold text-navy"
      >
        Refer & Earn on web
      </Link>
    </div>
  );
}

function HubHint({ title, body }: { title: string; body: string }) {
  return (
    <div className="rounded-2xl border border-dashed border-client-accent/30 bg-white p-4">
      <p className="font-bold text-navy">{title}</p>
      <p className="text-sm text-text-secondary">{body}</p>
      <p className="mt-1 text-[11px] font-semibold uppercase tracking-wide text-client-accent">
        App preferred
      </p>
    </div>
  );
}
