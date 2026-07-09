"use client";

import { FormEvent, useMemo, useState, type CSSProperties } from "react";
import { useSearchParams } from "next/navigation";
import Link from "next/link";
import { createBrowserSupabaseClient } from "@/lib/supabase-browser";
import {
  CLIVORA_NAVY,
  CLIVORA_PURPLE,
  OFFICIAL_EMAIL,
  PRO_PLUS_PRICE_PKR,
  PRO_PRICE_PKR,
} from "@/lib/admin-auth";

type Plan = "pro" | "pro_plus";

export default function ProCheckout() {
  const params = useSearchParams();
  const initialPlan = (params.get("plan") === "pro" ? "pro" : "pro_plus") as Plan;
  const [plan, setPlan] = useState<Plan>(initialPlan);
  const [fullName, setFullName] = useState(params.get("name") ?? "");
  const [email, setEmail] = useState(params.get("email") ?? "");
  const [accountType, setAccountType] = useState(params.get("type") === "client" ? "client" : "freelancer");
  const [country, setCountry] = useState("PK");
  const [paymentMethod, setPaymentMethod] = useState("jazzcash");
  const [paymentReference, setPaymentReference] = useState("");
  const [notes, setNotes] = useState("");
  const [busy, setBusy] = useState(false);
  const [done, setDone] = useState(false);
  const [error, setError] = useState("");

  const amount = plan === "pro_plus" ? PRO_PLUS_PRICE_PKR : PRO_PRICE_PKR;
  const supabase = useMemo(() => createBrowserSupabaseClient(), []);

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
        amount_pkr: amount,
        currency: "PKR",
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

  if (done) {
    return (
      <main style={pageWrap}>
        <div style={card}>
          <div style={logo}>C</div>
          <h1 style={heading}>Request received</h1>
          <p style={bodyText}>
            Thanks {fullName || "there"}. We received your{" "}
            <strong style={{ color: "#0f172a" }}>{plan === "pro_plus" ? "Pro Plus" : "Pro"}</strong> request for{" "}
            <strong style={{ color: "#0f172a" }}>Rs {amount.toLocaleString()}</strong>.
          </p>
          <p style={bodyText}>
            <strong style={{ color: "#0f172a" }}>Android app users:</strong> subscribe inside the CLIVORA app via
            Google Play Billing (Play policy). This web form is for website visitors and admin-assisted grants only —
            it is not linked from the Play-distributed app.
          </p>
          <Link href="/" style={primaryBtn}>
            Back to CLIVORA
          </Link>
        </div>
      </main>
    );
  }

  return (
    <main style={pageWrap}>
      <div style={{ ...card, maxWidth: 720 }}>
        <div style={logo}>C</div>
        <h1 style={heading}>CLIVORA Pro (web)</h1>
        <p style={{ ...bodyText, marginTop: 0 }}>
          This page is for website visitors and admin-assisted grants.{" "}
          <strong style={{ color: "#0f172a" }}>Android app users must subscribe inside the CLIVORA app via Google Play Billing</strong>{" "}
          (Google Play payments policy). The Play app does not open this checkout.
        </p>

        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12, marginBottom: 20 }}>
          <PlanOption
            active={plan === "pro"}
            title="Pro"
            price={`Rs ${PRO_PRICE_PKR.toLocaleString()}/mo`}
            onClick={() => setPlan("pro")}
          />
          <PlanOption
            active={plan === "pro_plus"}
            title="Pro Plus"
            price={`Rs ${PRO_PLUS_PRICE_PKR.toLocaleString()}/mo`}
            badge="Best value"
            onClick={() => setPlan("pro_plus")}
          />
        </div>

        <div style={infoBox}>
          <strong style={{ color: "#0f172a", display: "block", marginBottom: 4 }}>How to pay</strong>
          <ol style={{ margin: "8px 0 0", paddingLeft: 18, color: "#334155", lineHeight: 1.55 }}>
            <li>Send Rs {amount.toLocaleString()} via JazzCash, EasyPaisa, bank transfer, or international wire.</li>
            <li>Use your CLIVORA email as the payment note or reference.</li>
            <li>Paste the transaction ID below and submit.</li>
            <li>We activate Pro or Pro Plus after verification (usually same day).</li>
          </ol>
          <p style={{ margin: "10px 0 0", fontSize: "0.9rem", color: "#475569" }}>
            Payment destination: <strong style={{ color: "#0f172a" }}>CODCrafters / CLIVORA</strong>. Contact{" "}
            <a href={`mailto:${OFFICIAL_EMAIL}`} style={{ color: CLIVORA_PURPLE, fontWeight: 600 }}>
              {OFFICIAL_EMAIL}
            </a>{" "}
            for bank details or WhatsApp transfer instructions.
          </p>
        </div>

        <form onSubmit={onSubmit} style={{ marginTop: 20, color: "#0f172a" }}>
          {error && <p style={{ color: "#dc2626", fontSize: "0.9rem" }}>{error}</p>}
          <label style={label}>Full name</label>
          <input required value={fullName} onChange={(e) => setFullName(e.target.value)} style={input} />
          <label style={label}>CLIVORA account email</label>
          <input required type="email" value={email} onChange={(e) => setEmail(e.target.value)} style={input} />
          <label style={label}>Account type</label>
          <select value={accountType} onChange={(e) => setAccountType(e.target.value)} style={input}>
            <option value="freelancer">Freelancer</option>
            <option value="client">Client</option>
          </select>
          <label style={label}>Country</label>
          <select value={country} onChange={(e) => setCountry(e.target.value)} style={input}>
            <option value="PK">Pakistan</option>
            <option value="AE">United Arab Emirates</option>
            <option value="SA">Saudi Arabia</option>
            <option value="US">United States</option>
            <option value="GB">United Kingdom</option>
            <option value="OTHER">Other / Worldwide</option>
          </select>
          <label style={label}>Payment method</label>
          <select value={paymentMethod} onChange={(e) => setPaymentMethod(e.target.value)} style={input}>
            <option value="jazzcash">JazzCash</option>
            <option value="easypaisa">EasyPaisa</option>
            <option value="bank_transfer">Bank transfer (PK)</option>
            <option value="international_wire">International wire / Wise</option>
            <option value="card_manual">Card (manual confirmation)</option>
          </select>
          <label style={label}>Transaction / reference ID</label>
          <input
            required
            value={paymentReference}
            onChange={(e) => setPaymentReference(e.target.value)}
            placeholder="e.g. JC123456 or bank TRN"
            style={input}
          />
          <label style={label}>Notes (optional)</label>
          <textarea
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            rows={3}
            style={{ ...input, resize: "vertical" }}
          />
          <button
            type="submit"
            disabled={busy}
            style={{ ...primaryBtn, width: "100%", border: "none", cursor: busy ? "wait" : "pointer" }}
          >
            {busy ? "Submitting…" : `Submit payment for Rs ${amount.toLocaleString()}`}
          </button>
        </form>
      </div>
    </main>
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
      style={{
        textAlign: "left",
        borderRadius: 14,
        border: active ? `2px solid ${CLIVORA_PURPLE}` : "1px solid #e2e8f0",
        background: active ? "#f5f3ff" : "#fff",
        padding: 14,
        cursor: "pointer",
        color: "#0f172a",
      }}
    >
      <div style={{ display: "flex", justifyContent: "space-between", gap: 8, alignItems: "center" }}>
        <strong style={{ color: "#0f172a" }}>{title}</strong>
        {badge && (
          <span
            style={{
              fontSize: 11,
              fontWeight: 700,
              color: "#92400e",
              background: "#fef3c7",
              padding: "2px 8px",
              borderRadius: 999,
            }}
          >
            {badge}
          </span>
        )}
      </div>
      <div style={{ marginTop: 6, color: CLIVORA_PURPLE, fontWeight: 800 }}>{price}</div>
    </button>
  );
}

const pageWrap: CSSProperties = {
  minHeight: "100vh",
  background: `linear-gradient(160deg, ${CLIVORA_NAVY} 0%, #134e4a 45%, #0f766e 100%)`,
  padding: 24,
  display: "flex",
  alignItems: "center",
  justifyContent: "center",
  color: "#0f172a",
};

const card: CSSProperties = {
  width: "100%",
  maxWidth: 520,
  background: "#fff",
  borderRadius: 22,
  padding: 28,
  boxShadow: "0 24px 60px rgba(0,0,0,0.28)",
  color: "#0f172a",
};

const logo: CSSProperties = {
  width: 48,
  height: 48,
  borderRadius: 14,
  background: CLIVORA_PURPLE,
  color: "#fff",
  display: "flex",
  alignItems: "center",
  justifyContent: "center",
  fontWeight: 800,
  fontSize: "1.4rem",
  marginBottom: 14,
};

const heading: CSSProperties = {
  margin: "0 0 8px",
  color: "#0f172a",
  fontSize: "1.75rem",
  fontWeight: 800,
};

const bodyText: CSSProperties = {
  color: "#475569",
  lineHeight: 1.6,
};

const label: CSSProperties = {
  display: "block",
  fontSize: "0.85rem",
  fontWeight: 600,
  marginBottom: 6,
  color: "#0f172a",
};

const input: CSSProperties = {
  width: "100%",
  padding: "10px 12px",
  border: "1px solid #cbd5e1",
  borderRadius: 10,
  fontSize: "0.95rem",
  marginBottom: 14,
  background: "#fff",
  color: "#0f172a",
  WebkitTextFillColor: "#0f172a",
};

const primaryBtn: CSSProperties = {
  display: "inline-block",
  textAlign: "center",
  background: CLIVORA_PURPLE,
  color: "#fff",
  borderRadius: 12,
  padding: "12px 18px",
  fontWeight: 700,
  textDecoration: "none",
  marginTop: 8,
};

const infoBox: CSSProperties = {
  background: "#f8fafc",
  border: "1px solid #e2e8f0",
  borderRadius: 14,
  padding: 14,
  color: "#0f172a",
};
