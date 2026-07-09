"use client";

import { FormEvent, useMemo, useState, type CSSProperties } from "react";
import { useSearchParams } from "next/navigation";
import { createBrowserSupabaseClient } from "@/lib/supabase";
import { CLIVORA_NAVY, CLIVORA_PURPLE, PRO_PRICE_PKR } from "@/lib/admin";

const PLUS_PRICE_PKR = 3500;

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

  const amount = plan === "pro_plus" ? PLUS_PRICE_PKR : PRO_PRICE_PKR;
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
          <h1 style={{ margin: "0 0 8px" }}>Payment request received</h1>
          <p style={{ color: "#64748b", lineHeight: 1.6 }}>
            Thanks {fullName || "there"}. We received your <strong>{plan === "pro_plus" ? "Pro Plus" : "Pro"}</strong>{" "}
            request for <strong>Rs {amount.toLocaleString()}</strong>. After we verify your transfer, Pro access is
            activated on your CLIVORA account ({email}).
          </p>
          <a href="https://clivora.codcrafters.org" style={primaryBtn}>
            Back to CLIVORA
          </a>
        </div>
      </main>
    );
  }

  return (
    <main style={pageWrap}>
      <div style={{ ...card, maxWidth: 720 }}>
        <div style={logo}>C</div>
        <h1 style={{ margin: "0 0 6px" }}>CLIVORA Pro checkout</h1>
        <p style={{ color: "#64748b", marginTop: 0, lineHeight: 1.55 }}>
          Pay from Pakistan or anywhere in the world. Submit your payment details below — an admin activates your plan
          from the dashboard.
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
            price={`Rs ${PLUS_PRICE_PKR.toLocaleString()}/mo`}
            badge="Best value"
            onClick={() => setPlan("pro_plus")}
          />
        </div>

        <div style={infoBox}>
          <strong>How to pay</strong>
          <ol style={{ margin: "8px 0 0", paddingLeft: 18, color: "#334155", lineHeight: 1.55 }}>
            <li>Send Rs {amount.toLocaleString()} via JazzCash, EasyPaisa, bank transfer, or international wire.</li>
            <li>Use your CLIVORA email as the payment note/reference.</li>
            <li>Paste the transaction ID below and submit.</li>
            <li>We activate Pro / Pro Plus after verification (usually same day).</li>
          </ol>
          <p style={{ margin: "10px 0 0", fontSize: "0.9rem", color: "#475569" }}>
            Payment destination: <strong>CODCrafters / CLIVORA</strong> · Contact{" "}
            <a href="mailto:support@codcrafters.org">support@codcrafters.org</a> for bank details or WhatsApp transfer
            instructions.
          </p>
        </div>

        <form onSubmit={onSubmit} style={{ marginTop: 20 }}>
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
          <textarea value={notes} onChange={(e) => setNotes(e.target.value)} rows={3} style={{ ...input, resize: "vertical" }} />
          <button type="submit" disabled={busy} style={{ ...primaryBtn, width: "100%", border: "none", cursor: "pointer" }}>
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
      }}
    >
      <div style={{ display: "flex", justifyContent: "space-between", gap: 8 }}>
        <strong>{title}</strong>
        {badge && (
          <span style={{ fontSize: 11, fontWeight: 700, color: "#b45309", background: "#fef3c7", padding: "2px 8px", borderRadius: 999 }}>
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
};

const card: CSSProperties = {
  width: "100%",
  maxWidth: 520,
  background: "#fff",
  borderRadius: 22,
  padding: 28,
  boxShadow: "0 24px 60px rgba(0,0,0,0.28)",
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

const label: CSSProperties = {
  display: "block",
  fontSize: "0.85rem",
  fontWeight: 600,
  marginBottom: 6,
};

const input: CSSProperties = {
  width: "100%",
  padding: "10px 12px",
  border: "1px solid #e2e8f0",
  borderRadius: 10,
  fontSize: "0.95rem",
  marginBottom: 14,
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
};
