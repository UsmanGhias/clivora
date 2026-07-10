"use client";

import Link from "next/link";

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
      <div className="rounded-2xl border border-border bg-white p-5 shadow-sm">
        <p className="font-bold text-navy">Browse free · post with Pro Plus</p>
        <p className="mt-1 text-sm text-text-secondary">
          Anyone can explore listings. Sign in and upgrade to Pro Plus to publish a listing, post a need, or send requests.
        </p>
        <div className="mt-4 flex flex-wrap gap-2">
          <Link
            href="/login"
            className="inline-flex rounded-full bg-navy px-5 py-2.5 text-sm font-semibold text-white"
          >
            Sign in
          </Link>
          <Link
            href="/signup"
            className="inline-flex rounded-full border-2 border-navy bg-white px-5 py-2.5 text-sm font-semibold text-navy"
          >
            Sign up
          </Link>
        </div>
      </div>
    );
  }

  if (!isProPlus) {
    return (
      <div className="rounded-2xl border border-primary/30 bg-primary/5 p-5">
        <p className="font-bold text-navy">Unlock posting with Pro Plus</p>
        <p className="mt-1 text-sm text-text-secondary">
          You can browse Connect on {isClient ? "the client" : "the freelancer"} plan. Publishing listings,
          needs, and requests requires Pro Plus.
        </p>
        <Link
          href="/pro"
          className="mt-3 inline-flex rounded-full bg-primary px-4 py-2 text-sm font-semibold text-white"
        >
          Upgrade to Pro Plus
        </Link>
      </div>
    );
  }

  return (
    <div className="rounded-2xl border border-border bg-white p-5 shadow-sm">
      <p className="font-bold text-navy">You have Connect access</p>
      <p className="mt-1 text-sm text-text-secondary">
        Manage your {isClient ? "need posts" : "freelancer listing"} and send requests.
      </p>
      <Link
        href="/connect/manage"
        className="mt-3 inline-flex rounded-full bg-navy px-4 py-2 text-sm font-semibold text-white"
      >
        Manage listing
      </Link>
    </div>
  );
}
