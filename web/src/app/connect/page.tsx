import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import {
  listMyConnectRequests,
  listPublicConnectNeeds,
  listPublicConnectProfiles,
} from "@/lib/connect";
import {
  getProfile,
  isBlocked,
  isClientAccount,
  isProPlus,
  isRestricted,
  planLabel,
} from "@/lib/profile";
import { site } from "@/lib/site";
import { SubPageChrome } from "@/components/app/SubPageChrome";
import { ConnectBoard } from "@/components/connect/ConnectBoard";

export const metadata: Metadata = {
  title: "CLIVORA Connect. Private marketplace",
  description:
    "Hire freelancers and find clients on CLIVORA Connect. Private contact until mutual accept, then continue in the same CRM.",
};

export default async function ConnectPage() {
  const profile = await getProfile();
  if (profile && isBlocked(profile)) redirect("/blocked");
  const [profiles, needs, requests] = await Promise.all([
    listPublicConnectProfiles(),
    listPublicConnectNeeds(),
    listMyConnectRequests(),
  ]);
  const signedIn = !!profile;
  const plus = isProPlus(profile);
  const client = isClientAccount(profile);
  const restricted = isRestricted(profile);
  const backHref = signedIn ? "/app" : "/";
  const backLabel = signedIn ? "Back to app" : "Back to home";

  return (
    <SubPageChrome
      isClient={client}
      backHref={backHref}
      backLabel={backLabel}
      crumbs={[
        { label: signedIn ? "App" : "Home", href: backHref },
        { label: "Connect" },
      ]}
      title="Connect"
      rightSlot={
        signedIn ? (
          <span className="hidden rounded-lg bg-emerald-500/20 px-2.5 py-1 text-[11px] font-bold text-emerald-200 sm:inline">
            {planLabel(profile)}
          </span>
        ) : (
          <Link
            href="/login?next=/connect"
            className="rounded-lg bg-white/10 px-3 py-1.5 text-xs font-semibold text-white"
          >
            Sign in
          </Link>
        )
      }
    >
      <div className="space-y-6">
        <section
          className={`overflow-hidden rounded-3xl p-6 text-white sm:p-8 ${
            client ? "bg-client-gradient" : "bg-brand-gradient"
          }`}
        >
          <p className="text-[11px] font-bold uppercase tracking-[0.22em] text-white/70">
            CLIVORA Connect
          </p>
          <h1 className="mt-2 font-display text-2xl font-extrabold sm:text-4xl">
            Hire & get hired, privately
          </h1>
          <p className="mt-3 max-w-2xl text-sm leading-relaxed text-white/85 sm:text-base">
            Browse talent and jobs free. $0 platform fees on negotiated rates (no per-proposal
            tokens). Contact and post with Pro Plus. Emails unlock only after both sides accept,
            then continue in the same CLIVORA CRM.
          </p>
          <div className="mt-5 flex flex-wrap gap-2">
            {signedIn && plus ? (
              <Link
                href="/connect/manage"
                className="rounded-xl bg-white px-4 py-2.5 text-sm font-bold text-navy"
              >
                {client ? "Post a job" : "Update my profile"}
              </Link>
            ) : (
              <Link
                href={
                  signedIn
                    ? "/pro?plan=pro_plus"
                    : `/signup?next=${encodeURIComponent("/pro?plan=pro_plus")}`
                }
                className="rounded-xl bg-amber-400 px-4 py-2.5 text-sm font-bold text-navy"
              >
                {signedIn
                  ? `Buy Pro Plus · ${site.pricing.proPlusMonthlyLabel}/mo`
                  : `Buy Pro Plus · ${site.pricing.proPlusMonthlyLabel}/mo`}
              </Link>
            )}
            {!signedIn && (
              <Link
                href="/login?next=/connect"
                className="rounded-xl border border-white/30 px-4 py-2.5 text-sm font-bold text-white"
              >
                Sign in
              </Link>
            )}
          </div>
          {restricted && (
            <p className="mt-4 rounded-xl bg-black/20 px-3 py-2 text-sm text-amber-100">
              Your account is restricted, browsing works, posting/contact is paused. Contact
              support if this is unexpected.
            </p>
          )}
        </section>

        <ol className="grid gap-3 sm:grid-cols-3">
          {[
            {
              n: "01",
              t: "Discover",
              d: "Search talent or open jobs by skill, rate, and budget.",
            },
            {
              n: "02",
              t: "Request",
              d: "Send a Connect request, emails stay private until accept.",
            },
            {
              n: "03",
              t: "Work in CRM",
              d: "After match, manage the relationship in CLIVORA on web or app.",
            },
          ].map((step) => (
            <li
              key={step.n}
              className="rounded-2xl border border-border bg-surface px-4 py-4 shadow-sm"
            >
              <p className="font-display text-xs font-bold tracking-widest text-primary">{step.n}</p>
              <p className="mt-1 font-bold text-navy">{step.t}</p>
              <p className="mt-1 text-sm text-text-secondary">{step.d}</p>
            </li>
          ))}
        </ol>

        <ConnectBoard
          profiles={profiles}
          needs={needs}
          requests={requests}
          signedIn={signedIn}
          isProPlus={plus}
          isClient={client}
          isRestricted={restricted}
          myUserId={profile?.id}
        />
      </div>
    </SubPageChrome>
  );
}
