"use client";

import { FormEvent, useEffect, useMemo, useState } from "react";
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
  const [currentPlan, setCurrentPlan] = useState<string | null>(null);
  const [loadingPlan, setLoadingPlan] = useState(true);

  const amount = plan === "pro_plus" ? PRO_PLUS_PRICE_USD : PRO_PRICE_USD;
  const supabase = useMemo(() => createBrowserSupabaseClient(), []);
  const isClient = accountType === "client";

  useEffect(() => {
    (async () => {
      try {
        const {
          data: { user },
        } = await supabase.auth.getUser();
        if (!user) {
          setLoadingPlan(false);
          return;
        }
        const { data } = await supabase
          .from("profiles")
          .select("email, name, account_type, subscription_plan, is_blocked")
          .eq("id", user.id)
          .maybeSingle();
        if (data?.is_blocked) {
          window.location.href = "/blocked";
          return;
        }
        if (data?.email) setEmail(data.email);
        if (data?.name) setFullName(data.name);
        if (data?.account_type) {
          setAccountType(data.account_type === "client" ? "client" : "freelancer");
        }
        setCurrentPlan((data?.subscription_plan ?? "free").toLowerCase());
      } finally {
        setLoadingPlan(false);
      }
    })();
  }, [supabase]);

  const alreadyProPlus =
    currentPlan === "pro_plus" || currentPlan === "plus" || currentPlan === "proplus";
  const alreadyPro = currentPlan === "pro" || alreadyProPlus;
  const wantsSameOrLower = alreadyProPlus || (alreadyPro && plan === "pro");

  async function onSubmit(e: FormEvent) {
    e.preventDefault();
    if (wantsSameOrLower) {
      setError("You already have this plan (or higher). No payment needed.");
      return;
    }
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

  const showForm =
    !loadingPlan &&
    !alreadyProPlus &&
    !(alreadyPro && plan === "pro") &&
    !done;

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
        {loadingPlan && <p className="text-sm text-text-secondary">Checking your plan…</p>}

        {!loadingPlan && alreadyProPlus && (
          <div className="rounded-2xl border border-emerald-200 bg-emerald-50 p-6">
            <Logo size="sm" variant="onLight" />
            <h2 className="mt-4 text-2xl font-extrabold text-navy">You&apos;re on Pro Plus</h2>
            <p className="mt-2 text-sm text-text-secondary">
              Connect posting and Plus perks are already unlocked. No extra payment required.
            </p>
            <div className="mt-4 flex flex-wrap gap-2">
              <Link href="/connect" className="rounded-full bg-primary px-4 py-2 text-sm font-semibold text-white">
                Open Connect
              </Link>
              <Link href="/app" className="rounded-full border border-navy/20 px-4 py-2 text-sm font-semibold text-navy">
                Back to app
              </Link>
            </div>
          </div>
        )}

        {!loadingPlan && alreadyPro && plan === "pro" && !alreadyProPlus && (
          <div className="rounded-2xl border border-teal-200 bg-teal-50 p-6">
            <Logo size="sm" variant="onLight" />
            <h2 className="mt-4 text-2xl font-extrabold text-navy">You&apos;re already on Pro</h2>
            <p className="mt-2 text-sm text-text-secondary">
              No need to pay for Pro again. Choose Pro Plus only if you want Connect marketplace posting.
            </p>
            <div className="mt-4 flex flex-wrap gap-2">
              <button
                type="button"
                onClick={() => setPlan("pro_plus")}
                className="rounded-full bg-primary px-4 py-2 text-sm font-semibold text-white"
              >
                See Pro Plus · ${PRO_PLUS_PRICE_USD}/mo
              </button>
              <Link href="/app" className="rounded-full border border-navy/20 px-4 py-2 text-sm font-semibold text-navy">
                Back to app
              </Link>
            </div>
          </div>
        )}

        {done && (
          <div className="rounded-2xl border border-border bg-surface p-6 shadow-sm">
            <Logo size="sm" variant="onLight" />
            <h2 className="mt-4 text-2xl font-extrabold text-navy">Request received</h2>
            <p className="mt-2 text-sm text-text-secondary">
              Thanks {fullName || "there"}. We received your{" "}
              <strong>{plan === "pro_plus" ? "Pro Plus" : "Pro"}</strong> request for{" "}
              <strong>${amount}</strong>.
            </p>
            <Link href="/app" className="mt-4 inline-flex rounded-full bg-primary px-4 py-2 text-sm font-semibold text-white">
              Back to app
            </Link>
          </div>
        )}

        {showForm && (
          <form onSubmit={onSubmit} className="space-y-4 rounded-2xl border border-border bg-surface p-6 shadow-sm">
            <Logo size="sm" variant="onLight" />
            {alreadyPro && (
              <p className="rounded-xl bg-primary/10 px-3 py-2 text-sm text-primary-dark">
                You already have <strong>Pro</strong>. Submitting Pro Plus upgrades Connect access only.
              </p>
            )}
            <p className="text-sm text-text-secondary">
              Website checkout. <strong className="text-navy">Android users subscribe via Google Play</strong> in the app.
            </p>
            <div className="grid grid-cols-2 gap-3">
              <PlanOption
                active={plan === "pro"}
                title="Pro"
                price={`$${PRO_PRICE_USD}/mo`}
                disabled={alreadyPro}
                onClick={() => !alreadyPro && setPlan("pro")}
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
              <input required value={fullName} onChange={(e) => setFullName(e.target.value)} className="mt-1 w-full rounded-xl border border-border px-3 py-2.5" />
            </label>
            <label className="block text-sm font-semibold text-navy">
              Email
              <input required type="email" value={email} onChange={(e) => setEmail(e.target.value)} className="mt-1 w-full rounded-xl border border-border px-3 py-2.5" />
            </label>
            <label className="block text-sm font-semibold text-navy">
              Account type
              <select value={accountType} onChange={(e) => setAccountType(e.target.value)} className="mt-1 w-full rounded-xl border border-border px-3 py-2.5">
                <option value="freelancer">Freelancer</option>
                <option value="client">Client</option>
              </select>
            </label>
            <label className="block text-sm font-semibold text-navy">
              Country
              <select value={country} onChange={(e) => setCountry(e.target.value)} className="mt-1 w-full rounded-xl border border-border px-3 py-2.5">
                <option value="PK">Pakistan</option>
                <option value="US">United States</option>
                <option value="OTHER">Other</option>
              </select>
            </label>
            <label className="block text-sm font-semibold text-navy">
              Payment method
              <select value={paymentMethod} onChange={(e) => setPaymentMethod(e.target.value)} className="mt-1 w-full rounded-xl border border-border px-3 py-2.5">
                <option value="jazzcash">JazzCash</option>
                <option value="easypaisa">Easypaisa</option>
                <option value="bank">Bank transfer</option>
                <option value="other">Other</option>
              </select>
            </label>
            <label className="block text-sm font-semibold text-navy">
              Payment reference
              <input required value={paymentReference} onChange={(e) => setPaymentReference(e.target.value)} className="mt-1 w-full rounded-xl border border-border px-3 py-2.5" placeholder="Txn ID / receipt #" />
            </label>
            <label className="block text-sm font-semibold text-navy">
              Notes
              <textarea value={notes} onChange={(e) => setNotes(e.target.value)} className="mt-1 w-full rounded-xl border border-border px-3 py-2.5" rows={2} />
            </label>
            <div className="rounded-xl bg-client-surface p-3 text-xs text-text-secondary">
              Amount due: <strong className="text-navy">${amount} USD</strong>. Email {OFFICIAL_EMAIL} if approval is delayed.
            </div>
            {error && <p className="rounded-lg bg-error/10 px-3 py-2 text-sm text-error">{error}</p>}
            <button type="submit" disabled={busy || wantsSameOrLower} className="w-full rounded-full bg-primary py-3 text-sm font-bold text-white disabled:opacity-60">
              {busy ? "Submitting…" : `Submit ${plan === "pro_plus" ? "Pro Plus" : "Pro"} request`}
            </button>
          </form>
        )}

        {!alreadyProPlus && (
          <SmartAppCta
            tone={isClient ? "client" : "freelancer"}
            title="Already on Android?"
            body="Subscribe with Google Play Billing inside the CLIVORA app — same unlock as web grants."
            deepPath="open/upgrade"
          />
        )}
      </div>
    </SubPageChrome>
  );
}

function PlanOption({
  active,
  title,
  price,
  badge,
  disabled,
  onClick,
}: {
  active: boolean;
  title: string;
  price: string;
  badge?: string;
  disabled?: boolean;
  onClick: () => void;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      disabled={disabled}
      className={`rounded-2xl border-2 p-4 text-left transition ${
        active ? "border-primary bg-primary/5" : "border-border bg-white"
      } ${disabled ? "cursor-not-allowed opacity-50" : ""}`}
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
