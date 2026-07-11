"use client";

import Link from "next/link";
import { Crown, Sparkles, UserPlus } from "lucide-react";
import { site } from "@/lib/site";

export function ConnectActions({
  signedIn,
  isProPlus,
  isClient,
}: {
  signedIn: boolean;
  isProPlus: boolean;
  isClient: boolean;
}) {
  if (!signedIn) {
    return (
      <div className="rounded-2xl border border-amber-200 bg-gradient-to-br from-amber-50 to-white p-5 shadow-sm">
        <div className="flex items-start gap-3">
          <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-amber-100 text-amber-800">
            <Crown className="h-5 w-5" />
          </span>
          <div className="min-w-0 flex-1">
            <p className="font-bold text-navy">Browse free. Buy Pro Plus for unlimited access.</p>
            <p className="mt-1 text-sm text-text-secondary">
              Explore talent and jobs with $0 platform fees on your deals. Sign up, then unlock
              unlimited contact, proposals, and posting with Pro Plus ({site.pricing.proPlusMonthlyLabel}/mo).
            </p>
            <div className="mt-4 flex flex-wrap gap-2">
              <Link
                href={`/signup?next=${encodeURIComponent("/pro?plan=pro_plus")}`}
                className="inline-flex items-center gap-1.5 rounded-xl bg-amber-500 px-5 py-2.5 text-sm font-bold text-navy"
              >
                <UserPlus className="h-4 w-4" />
                Buy Pro Plus · {site.pricing.proPlusMonthlyLabel}/mo
              </Link>
              <Link
                href="/login?next=/connect"
                className="inline-flex rounded-xl border-2 border-navy bg-white px-5 py-2.5 text-sm font-semibold text-navy"
              >
                Sign in
              </Link>
            </div>
          </div>
        </div>
      </div>
    );
  }

  if (!isProPlus) {
    return (
      <div className="rounded-2xl border border-primary/30 bg-primary/5 p-5">
        <div className="flex items-start gap-3">
          <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-primary/15 text-primary-dark">
            <Sparkles className="h-5 w-5" />
          </span>
          <div>
            <p className="font-bold text-navy">Unlock unlimited Connect with Pro Plus</p>
            <p className="mt-1 text-sm text-text-secondary">
              You can browse as a {isClient ? "client" : "freelancer"}. Contact, proposals, and
              posting need Pro Plus. Keep 100% of negotiated rates ($0 platform fee).
            </p>
            <Link
              href="/pro?plan=pro_plus"
              className="mt-3 inline-flex rounded-xl bg-primary px-4 py-2 text-sm font-semibold text-white"
            >
              Upgrade to Pro Plus · {site.pricing.proPlusMonthlyLabel}/mo
            </Link>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="rounded-2xl border border-border bg-white p-5 shadow-sm">
      <p className="font-bold text-navy">You have unlimited Connect access</p>
      <p className="mt-1 text-sm text-text-secondary">
        Manage your {isClient ? "job posts" : "freelancer listing"}, send proposals, and message
        matches with $0 platform fees.
      </p>
      <Link
        href="/connect/manage"
        className="mt-3 inline-flex rounded-xl bg-navy px-4 py-2 text-sm font-semibold text-white"
      >
        Manage listing
      </Link>
    </div>
  );
}
