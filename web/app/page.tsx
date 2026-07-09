import Link from "next/link";
import type { CSSProperties } from "react";
import { CLIVORA_NAVY, CLIVORA_PURPLE, PRO_PRICE_PKR } from "@/lib/admin";

export default function HomePage() {
  return (
    <main
      style={{
        minHeight: "100vh",
        background: `linear-gradient(160deg, ${CLIVORA_NAVY} 0%, #134e4a 50%, #0f766e 100%)`,
        color: "#fff",
      }}
    >
      <header
        style={{
          maxWidth: 1100,
          margin: "0 auto",
          padding: "20px 24px",
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
        }}
      >
        <div style={{ display: "flex", alignItems: "center", gap: 10, fontWeight: 800, letterSpacing: 2 }}>
          <span
            style={{
              width: 36,
              height: 36,
              borderRadius: 10,
              background: CLIVORA_PURPLE,
              display: "inline-flex",
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            C
          </span>
          CLIVORA
        </div>
        <div style={{ display: "flex", gap: 12 }}>
          <Link href="/pro" style={navBtn}>
            Pricing
          </Link>
          <Link href="/admin" style={{ ...navBtn, background: "rgba(255,255,255,0.12)" }}>
            Admin
          </Link>
        </div>
      </header>

      <section style={{ maxWidth: 900, margin: "0 auto", padding: "56px 24px 40px", textAlign: "center" }}>
        <p style={{ color: "#99f6e4", fontWeight: 700, letterSpacing: 1, marginBottom: 12 }}>FREELANCERS + CLIENTS</p>
        <h1 style={{ margin: "0 0 16px", fontSize: "clamp(2.2rem, 5vw, 3.4rem)", fontWeight: 800, lineHeight: 1.15 }}>
          Work with integrity.
          <br />
          Run your business in one app.
        </h1>
        <p style={{ margin: "0 auto 28px", maxWidth: 620, color: "#cbd5e1", lineHeight: 1.65, fontSize: "1.05rem" }}>
          CLIVORA brings clients and freelancers together — projects, milestones, invoices, contracts, messages, and Pro
          tools without marketplace fees.
        </p>
        <div style={{ display: "flex", gap: 14, flexWrap: "wrap", justifyContent: "center" }}>
          <Link href="/pro" style={ctaPrimary}>
            Get Pro Plus — Rs 3,500/mo
          </Link>
          <a
            href="https://play.google.com/store/apps/details?id=org.codcrafters.clivora"
            target="_blank"
            rel="noopener noreferrer"
            style={ctaSecondary}
          >
            Get the App
          </a>
        </div>
      </section>

      <section
        style={{
          maxWidth: 1100,
          margin: "0 auto",
          padding: "0 24px 64px",
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(240px, 1fr))",
          gap: 16,
        }}
      >
        {[
          ["Milestones", "Break work into payment checkpoints clients can trust."],
          ["Invoices & PDF", "Branded invoices, disputes, and client PDF downloads."],
          ["Pro Plus", `Priority support, 25 GB vault, and advanced tools from Rs ${PRO_PRICE_PKR.toLocaleString()}.`],
        ].map(([title, body]) => (
          <div
            key={title}
            style={{
              background: "rgba(255,255,255,0.08)",
              border: "1px solid rgba(255,255,255,0.14)",
              borderRadius: 18,
              padding: 22,
            }}
          >
            <h3 style={{ margin: "0 0 8px", fontSize: "1.15rem" }}>{title}</h3>
            <p style={{ margin: 0, color: "#cbd5e1", lineHeight: 1.55 }}>{body}</p>
          </div>
        ))}
      </section>

      <footer style={{ textAlign: "center", color: "#94a3b8", fontSize: "0.85rem", padding: "0 24px 40px" }}>
        v2.7.1 · CodCrafters · <Link href="/pro" style={{ color: "#99f6e4" }}>Subscribe</Link>
      </footer>
    </main>
  );
}

const navBtn: CSSProperties = {
  color: "#fff",
  textDecoration: "none",
  fontWeight: 600,
  padding: "8px 14px",
  borderRadius: 10,
};

const ctaPrimary: CSSProperties = {
  background: CLIVORA_PURPLE,
  color: "#fff",
  padding: "14px 26px",
  borderRadius: 12,
  fontWeight: 700,
  textDecoration: "none",
};

const ctaSecondary: CSSProperties = {
  background: "transparent",
  color: "#fff",
  padding: "14px 26px",
  borderRadius: 12,
  fontWeight: 600,
  border: "1px solid rgba(255,255,255,0.35)",
  textDecoration: "none",
};
