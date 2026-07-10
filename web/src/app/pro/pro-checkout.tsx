"use client";

import { FormEvent, useMemo, useState } from "react";
import { useSearchParams } from "next/navigation";
import Link from "next/link";
import { createBrowserSupabaseClient } from "@/lib/supabase-browser";
import {
  OFFICIAL_EMAIL,
  PRO_PLUS_PRICE_USD,
  PRO_PRICE_USD,
} from "@/lib/admin-auth";
import { SubPageChrome } from "@/components/app/SubPageChrome";
import { Logo } from "@/components/ui/Logo";
import { SmartAppCta } from "@/components/app/SmartAppCta";

type Plan = "pro" | "pro_plus";

export default function ProCheckout() {
  const params = useSearchParams();
  const initialPlan = (params.get("plan") === "pro" ? "pro" : "pro_plus") as Plan;
  const [plan, setPlan] = useState<Plan>(initialPlan);
  const [fullName, setFullName] = useState(params.get("name") ?? "");
  const [email, setEmail] = useState(params.get("email") ?? "");
  const [accountType, setAccountType] = useState(
    params.get("type") === "client" ? "client" : "freelancer",
  );
  const [country, setCountry] = useState("PK");
  const [paymentMethod, setPaymentMethod] = useState("jazzcash");
  const [paymentReference, setPaymentReference] = useState("");
  const [notes, setNotes] = useState("");
  const [busy, setBusy] = useState(false);
  const [done, setDone] = useState(false);
  const [error, setError] = useState("");

  const amount = plan === "pro_plus" ? PRO_PLUS_PRICE_USD : PRO_PRICE_USD;
  const supabase = useMemo(() => createBrowserSupabaseClient(), []);
  const isClient = accountType === "client";

  async function onSubmit(e: FormEvent) {
    e.preventDefault();
    setBusy(true);
    setError("");
    try {
      const { error: insertError } = await supabase.from("pro_payment_requests").insert({
        email: email.trim().toLowerCase(),
        full_name: fullName.trim(),
        account_type: accountType,
        plan,
        amount_usd: amount,
        currency: "USD",
        country,
        payment_method: paymentMethod,
        payment_reference: paymentReference.trim(),
        notes: notes.trim(),
        status: "pending",
      });
      if (insertError) throw insertError;
      setDone(true);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not submit payment request");
    } finally {
      setBusy(false);
    }
  }

  return (
    <SubPageChrome
      isClient={isClient}
      backHref="/app"
      backLabel="Back to app"
      crumbs={[
        { label: "App", href: "/app" },
        { label: "Upgrade" },
      ]}
      title="CLIVORA Pro"
    >
      <div className="mx-auto max-w-xl space-y-6">
        {done ? (
          <div className="rounded-2xl border border-border bg-surface p-6 shadow-sm">
            <Logo size="sm" variant="onLight" />
            <h2 className="mt-4 text-2xl font-extrabold text-navy">Request received</h2>
            <p className="mt-2 text-sm text-text-secondary">
              Thanks {fullName || "there"}. We received your{" "}
              <strong>{plan === "pro_plus" ? "Pro Plus" : "Pro"}</strong> request for{" "}
              <strong>${amount}</strong>.
            </p>
            <p className="mt-3 text-sm text-text-secondary">
              <strong>Android app users:</strong> subscribe inside the CLIVORA app via Google Play
              Billing. This web form is for website visitors and admin-assisted grants.
            </p>
            <div className="mt-4 flex flex-wrap gap-2">
              <Link
                href="/app"
                className="rounded-full bg-primary px-4 py-2 text-sm font-semibold text-white"
              >
                Back to app
              </Link>
              <Link
                href="/"
                className="rounded-full border border-navy/20 px-4 py-2 text-sm font-semibold text-navy"
              >
                Marketing home
              </Link>
            </div>
          </div>
        ) : (
          <form
            onSubmit={onSubmit}
            className="space-y-4 rounded-2xl border border-border bg-surface p-6 shadow-sm"
          >
            <Logo size="sm" variant="onLight" />
            <p className="text-sm text-text-secondary">
              Website checkout for Pro / Pro Plus.{" "}
              <strong className="text-navy">App users must upgrade via Google Play</strong> inside
              CLIVORA.
            </p>

            <div className="grid grid-cols-2 gap-3">
              <PlanOption
                active={plan === "pro"}
                title="Pro"
                price={`$${PRO_PRICE_USD}/mo`}
                onClick={() => setPlan("pro")}
              />
              <PlanOption
                active={plan === "pro_plus"}
                title="Pro Plus"
                price={`$${PRO_PLUS_PRICE_USD}/mo`}
                badge="Connect"
                onClick={() => setPlan("pro_plus")}
              />
            </div>

            <label className="block text-sm font-semibold text-navy">
              Full name
              <input
                required
                value={fullName}
                onChange={(e) => setFullName(e.target.value)}
                className="mt-1 w-full rounded-xl border border-border px-3 py-2.5"
              />
            </label>
            <label className="block text-sm font-semibold text-navy">
              Email
              <input
                required
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="mt-1 w-full rounded-xl border border-border px-3 py-2.5"
              />
            </label>
            <label className="block text-sm font-semibold text-navy">
              Account type
              <select
                value={accountType}
                onChange={(e) => setAccountType(e.target.value)}
                className="mt-1 w-full rounded-xl border border-border px-3 py-2.5"
              >
                <option value="freelancer">Freelancer</option>
                <option value="client">Client</option>
              </select>
            </label>
            <label className="block text-sm font-semibold text-navy">
              Country
              <select
                value={country}
                onChange={(e) => setCountry(e.target.value)}
                className="mt-1 w-full rounded-xl border border-border px-3 py-2.5"
              >
                <option value="PK">Pakistan</option>
                <option value="US">United States</option>
                <option value="OTHER">Other</option>
              </select>
            </label>
            <label className="block text-sm font-semibold text-navy">
              Payment method
              <select
                value={paymentMethod}
                onChange={(e) => setPaymentMethod(e.target.value)}
                className="mt-1 w-full rounded-xl border border-border px-3 py-2.5"
              >
                <option value="jazzcash">JazzCash</option>
                <option value="easypaisa">Easypaisa</option>
                <option value="bank">Bank transfer</option>
                <option value="other">Other</option>
              </select>
            </label>
            <label className="block text-sm font-semibold text-navy">
              Payment reference
              <input
                required
                value={paymentReference}
                onChange={(e) => setPaymentReference(e.target.value)}
                className="mt-1 w-full rounded-xl border border-border px-3 py-2.5"
                placeholder="Txn ID / receipt #"
              />
            </label>
            <label className="block text-sm font-semibold text-navy">
              Notes
              <textarea
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                className="mt-1 w-full rounded-xl border border-border px-3 py-2.5"
                rows={2}
              />
            </label>

            <div className="rounded-xl bg-client-surface p-3 text-xs text-text-secondary">
              Amount due: <strong className="text-navy">${amount} USD</strong>. After payment, email{" "}
              {OFFICIAL_EMAIL} if approval takes longer than expected.
            </div>

            {error && <p className="rounded-lg bg-error/10 px-3 py-2 text-sm text-error">{error}</p>}

            <button
              type="submit"
              disabled={busy}
              className="w-full rounded-full bg-primary py-3 text-sm font-bold text-white disabled:opacity-60"
            >
              {busy ? "Submitting…" : `Submit ${plan === "pro_plus" ? "Pro Plus" : "Pro"} request`}
            </button>
          </form>
        )}

        <SmartAppCta
          tone={isClient ? "client" : "freelancer"}
          title="Already on Android?"
          body="Subscribe with Google Play Billing inside the CLIVORA app — same Pro / Pro Plus unlock as web grants."
          deepPath="open/upgrade"
        />
      </div>
    </SubPageChrome>
  );
}

function PlanOption({
  active,
  title,
  price,
  badge,
  onClick,
}: {
  active: boolean;
  title: string;
  price: string;
  badge?: string;
  onClick: () => void;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={`rounded-2xl border-2 p-4 text-left transition ${
        active ? "border-primary bg-primary/5" : "border-border bg-white"
      }`}
    >
      <div className="flex items-center justify-between gap-2">
        <strong className="text-navy">{title}</strong>
        {badge && (
          <span className="rounded-full bg-amber-100 px-2 py-0.5 text-[10px] font-bold text-amber-900">
            {badge}
          </span>
        )}
      </div>
      <p className="mt-1 font-extrabold text-primary">{price}</p>
    </button>
  );
}
