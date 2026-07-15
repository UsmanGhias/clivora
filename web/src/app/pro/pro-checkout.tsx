"use client";

import { FormEvent, useEffect, useMemo, useState } from "react";
import { useSearchParams } from "next/navigation";
import Link from "next/link";
import { createBrowserSupabaseClient } from "@/lib/supabase-browser";
import { site } from "@/lib/site";
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
  const [promoCode, setPromoCode] = useState(params.get("promo") ?? params.get("ref") ?? "");
  const [promoNote, setPromoNote] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [done, setDone] = useState(false);
  const [error, setError] = useState("");
  const [stripeBusy, setStripeBusy] = useState(false);
  const [currentPlan, setCurrentPlan] = useState<string | null>(null);
  const [loadingPlan, setLoadingPlan] = useState(true);

  const amount = plan === "pro_plus" ? site.pricing.proPlusMonthlyUsd : site.pricing.proMonthlyUsd;
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

  async function validatePromo(codeRaw: string): Promise<{
    code: string;
    discountType: string;
    discountValue: number;
    note: string;
  } | null> {
    const code = codeRaw.trim().toUpperCase();
    if (!code) return null;
    const { data } = await supabase
      .from("promo_codes")
      .select("code, discount_type, discount_value, applies_to, max_uses, used_count, expires_at, is_active")
      .eq("code", code)
      .maybeSingle();
    if (!data || !data.is_active) throw new Error("Promo code is invalid or inactive");
    if (data.expires_at && new Date(data.expires_at) < new Date()) {
      throw new Error("Promo code expired");
    }
    if (data.max_uses != null && Number(data.used_count ?? 0) >= Number(data.max_uses)) {
      throw new Error("Promo code usage limit reached");
    }
    if (data.applies_to !== "any" && data.applies_to !== plan) {
      throw new Error(`Promo applies to ${data.applies_to} only`);
    }
    const note =
      data.discount_type === "percent"
        ? `${data.discount_value}% off ${plan === "pro_plus" ? "Pro Plus" : "Pro"}`
        : `$${data.discount_value} off`;
    return {
      code: data.code,
      discountType: data.discount_type,
      discountValue: Number(data.discount_value),
      note,
    };
  }

  async function onSubmit(e: FormEvent) {
    e.preventDefault();
    if (wantsSameOrLower) {
      setError("You already have this plan (or higher). No payment needed.");
      return;
    }
    setBusy(true);
    setError("");
    setPromoNote(null);
    try {
      let promoMeta: Awaited<ReturnType<typeof validatePromo>> = null;
      if (promoCode.trim()) {
        promoMeta = await validatePromo(promoCode);
        if (promoMeta) setPromoNote(promoMeta.note);
      }
      const noteParts = [notes.trim()];
      if (promoMeta) noteParts.push(`Promo: ${promoMeta.code} (${promoMeta.note})`);
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
        notes: noteParts.filter(Boolean).join("\n"),
        promo_code: promoMeta?.code ?? null,
        status: "pending",
      });
      if (insertError) throw insertError;
      if (promoMeta) {
        try {
          const { data: promoRow } = await supabase
            .from("promo_codes")
            .select("used_count")
            .eq("code", promoMeta.code)
            .maybeSingle();
          await supabase
            .from("promo_codes")
            .update({ used_count: Number(promoRow?.used_count ?? 0) + 1 })
            .eq("code", promoMeta.code);
        } catch {
          /* admin can reconcile usage from payment notes */
        }
      }
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
                See Pro Plus · ${site.pricing.proPlusMonthlyUsd}/mo
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
                price={`$${site.pricing.proMonthlyUsd}/mo`}
                disabled={alreadyPro}
                onClick={() => !alreadyPro && setPlan("pro")}
              />
              <PlanOption
                active={plan === "pro_plus"}
                title="Pro Plus"
                price={`$${site.pricing.proPlusMonthlyUsd}/mo`}
                badge="Connect"
                onClick={() => setPlan("pro_plus")}
              />
            </div>
            <label className="block text-sm font-semibold text-navy">
              Promo / referral code (optional)
              <input
                value={promoCode}
                onChange={(e) => setPromoCode(e.target.value.toUpperCase())}
                className="mt-1 w-full rounded-xl border border-border px-3 py-2.5 font-mono uppercase"
                placeholder="CLIVORA15 or CLV…"
              />
            </label>
            {promoNote && (
              <p className="text-xs font-semibold text-primary-dark">{promoNote}</p>
            )}
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
              Amount due: <strong className="text-navy">${amount} USD</strong>. Email {site.company.email} if approval is delayed.
            </div>
            {error && <p className="rounded-lg bg-error/10 px-3 py-2 text-sm text-error">{error}</p>}
            <button type="submit" disabled={busy || wantsSameOrLower} className="w-full rounded-full bg-primary py-3 text-sm font-bold text-white disabled:opacity-60">
              {busy ? "Submitting…" : `Submit ${plan === "pro_plus" ? "Pro Plus" : "Pro"} request`}
            </button>

            <div className="relative flex items-center gap-3">
              <div className="flex-1 border-t border-border" />
              <span className="text-xs text-text-muted">or</span>
              <div className="flex-1 border-t border-border" />
            </div>
            <button
              type="button"
              disabled={stripeBusy || wantsSameOrLower}
              onClick={async () => {
                setStripeBusy(true);
                setError("");
                try {
                  const res = await fetch("/api/stripe/checkout", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({
                      plan,
                      email: email.trim().toLowerCase(),
                      promoCode: promoCode.trim() || undefined,
                    }),
                  });
                  const json = await res.json();
                  if (!res.ok) throw new Error(json.error || "Stripe checkout unavailable");
                  if (json.url) window.location.href = json.url;
                } catch (err) {
                  setError(err instanceof Error ? err.message : "Stripe checkout failed");
                } finally {
                  setStripeBusy(false);
                }
              }}
              className="w-full rounded-full border border-border bg-white py-3 text-sm font-bold text-navy shadow-sm hover:bg-slate-50 disabled:opacity-60"
            >
              {stripeBusy ? "Redirecting…" : "Pay with Stripe"}
            </button>
          </form>
        )}

        {!alreadyProPlus && (
          <SmartAppCta
            tone={isClient ? "client" : "freelancer"}
            title="Already on Android?"
            body="Subscribe with Google Play Billing inside the CLIVORA app, same unlock as web grants."
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
