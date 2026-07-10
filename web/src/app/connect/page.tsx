import type { Metadata } from "next";
import Link from "next/link";
import { listPublicConnectNeeds, listPublicConnectProfiles, skillsList } from "@/lib/connect";
import { getProfile, isClientAccount, isProPlus, planLabel } from "@/lib/profile";
import { site } from "@/lib/site";
import { ConnectActions } from "@/components/connect/ConnectActions";

export const metadata: Metadata = {
  title: "CLIVORA Connect",
  description:
    "Private marketplace where freelancers list services and clients post needs — powered by the same Supabase backend as the CLIVORA app.",
};

export default async function ConnectPage() {
  const [profiles, needs, profile] = await Promise.all([
    listPublicConnectProfiles(),
    listPublicConnectNeeds(),
    getProfile(),
  ]);
  const signedIn = !!profile;
  const plus = isProPlus(profile);
  const client = isClientAccount(profile);

  return (
    <div className="min-h-screen bg-background">
      <header className="border-b border-border bg-navy text-white">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-4 py-4">
          <Link href="/" className="font-extrabold tracking-wide">
            CLIVORA <span className="text-primary">Connect</span>
          </Link>
          <div className="flex items-center gap-3 text-sm">
            {signedIn ? (
              <>
                <span className="text-white/70">{planLabel(profile)}</span>
                <Link href="/app" className="rounded-full bg-white/10 px-3 py-1.5 font-semibold">
                  Open app
                </Link>
              </>
            ) : (
              <>
                <Link href="/login" className="text-white/80 hover:text-white">
                  Sign in
                </Link>
                <Link href="/signup" className="rounded-full bg-primary px-3 py-1.5 font-semibold">
                  Join free
                </Link>
              </>
            )}
          </div>
        </div>
      </header>

      <main className="mx-auto max-w-6xl space-y-10 px-4 py-10">
        <section className="rounded-3xl bg-brand-gradient p-8 text-white shadow-xl">
          <p className="text-xs font-bold uppercase tracking-[0.2em] text-white/70">Marketplace</p>
          <h1 className="mt-2 text-3xl font-extrabold sm:text-4xl">What is CLIVORA Connect?</h1>
          <p className="mt-3 max-w-2xl text-white/85 leading-relaxed">
            A private marketplace where freelancers list services and clients post needs. Browse listings,
            send requests, and message after both sides accept — without sharing contact details too early.
            Full Connect posting & requests are included with <strong>Pro Plus</strong> ({site.pricing.proPlusMonthlyLabel}/mo).
          </p>
          <div className="mt-6 flex flex-wrap gap-3">
            {!signedIn && (
              <Link href="/signup" className="rounded-full bg-white px-5 py-2.5 text-sm font-bold text-navy">
                Create account
              </Link>
            )}
            {!plus && (
              <Link href="/pro" className="rounded-full bg-primary px-5 py-2.5 text-sm font-bold text-white">
                Upgrade to Pro Plus
              </Link>
            )}
            {signedIn && plus && (
              <Link href="/connect/manage" className="rounded-full bg-white px-5 py-2.5 text-sm font-bold text-navy">
                Manage my listing
              </Link>
            )}
          </div>
        </section>

        <ConnectActions
          signedIn={signedIn}
          isProPlus={plus}
          isClient={client}
        />

        <section>
          <div className="mb-4 flex items-end justify-between gap-4">
            <div>
              <h2 className="text-xl font-extrabold">Freelancer listings</h2>
              <p className="text-sm text-text-secondary">Approved & listed profiles from Connect</p>
            </div>
          </div>
          {profiles.length === 0 ? (
            <EmptyBox text="No public listings yet — be the first to publish from Manage listing." />
          ) : (
            <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
              {profiles.map((p) => (
                <article
                  key={p.id}
                  className="rounded-2xl border border-border bg-surface p-5 shadow-sm"
                >
                  <div className="flex items-start justify-between gap-2">
                    <h3 className="font-bold text-text-primary">
                      {p.display_title || "Freelancer"}
                    </h3>
                    {p.is_verified && (
                      <span className="rounded-full bg-primary/10 px-2 py-0.5 text-[10px] font-bold uppercase text-primary-dark">
                        Verified
                      </span>
                    )}
                  </div>
                  <p className="mt-2 text-sm text-text-secondary line-clamp-3">
                    {p.headline || "Available on CLIVORA Connect"}
                  </p>
                  {p.rate_band && (
                    <p className="mt-2 text-xs font-semibold text-navy">{p.rate_band}</p>
                  )}
                  <div className="mt-3 flex flex-wrap gap-1.5">
                    {skillsList(p.skills)
                      .slice(0, 5)
                      .map((s) => (
                        <span
                          key={s}
                          className="rounded-full bg-background px-2 py-0.5 text-[11px] text-text-secondary"
                        >
                          {s}
                        </span>
                      ))}
                  </div>
                </article>
              ))}
            </div>
          )}
        </section>

        <section>
          <div className="mb-4">
            <h2 className="text-xl font-extrabold">Client needs</h2>
            <p className="text-sm text-text-secondary">Open briefs looking for freelancers</p>
          </div>
          {needs.length === 0 ? (
            <EmptyBox text="No open needs yet — clients can post from Manage listing." />
          ) : (
            <div className="grid gap-4 sm:grid-cols-2">
              {needs.map((n) => (
                <article
                  key={n.id}
                  className="rounded-2xl border border-border bg-surface p-5 shadow-sm"
                >
                  <h3 className="font-bold">{n.title || "Need"}</h3>
                  <p className="mt-2 text-sm text-text-secondary line-clamp-4">
                    {n.summary || "Details in Connect"}
                  </p>
                  {n.budget_band && (
                    <p className="mt-2 text-xs font-semibold text-navy">Budget: {n.budget_band}</p>
                  )}
                  <div className="mt-3 flex flex-wrap gap-1.5">
                    {skillsList(n.skills)
                      .slice(0, 6)
                      .map((s) => (
                        <span
                          key={s}
                          className="rounded-full bg-background px-2 py-0.5 text-[11px] text-text-secondary"
                        >
                          {s}
                        </span>
                      ))}
                  </div>
                </article>
              ))}
            </div>
          )}
        </section>
      </main>
    </div>
  );
}

function EmptyBox({ text }: { text: string }) {
  return (
    <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center text-sm text-text-secondary">
      {text}
    </div>
  );
}
