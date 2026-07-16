"use client";

import Link from "next/link";

/** Billing is manual / Play until a gateway is approved (master plan §4). */
export function ManageBillingButton() {
  return (
    <div className="space-y-2">
      <Link
        href="/pro"
        className="inline-flex rounded-full border border-navy/20 px-4 py-2 text-sm font-semibold text-navy"
      >
        Manage plan (manual / Play)
      </Link>
      <p className="text-xs text-text-secondary">
        Card billing via Stripe is coming soon. Renew with JazzCash or Google Play Billing.
      </p>
    </div>
  );
}
