import Link from "next/link";
import { CLIVORA_NAVY, CLIVORA_PURPLE } from "@/lib/admin";

export default function HomePage() {
  return (
    <main
      style={{
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        padding: "48px 24px",
        background: `linear-gradient(135deg, ${CLIVORA_NAVY} 0%, #1e1b4b 55%, ${CLIVORA_PURPLE} 100%)`,
        color: "#fff",
        textAlign: "center",
      }}
    >
      <div
        style={{
          width: 72,
          height: 72,
          borderRadius: 20,
          background: CLIVORA_PURPLE,
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          fontSize: "2rem",
          fontWeight: 800,
          marginBottom: 24,
          boxShadow: "0 12px 40px rgba(108,60,225,0.45)",
        }}
      >
        C
      </div>
      <h1 style={{ margin: "0 0 12px", fontSize: "2.4rem", fontWeight: 800 }}>
        CLIVORA
      </h1>
      <p style={{ margin: "0 0 32px", maxWidth: 520, color: "#cbd5e1", lineHeight: 1.6 }}>
        CRM for freelancers — clients, projects, invoices &amp; revenue in one app.
      </p>
      <div style={{ display: "flex", gap: 16, flexWrap: "wrap", justifyContent: "center" }}>
        <Link
          href="/admin"
          style={{
            background: CLIVORA_PURPLE,
            color: "#fff",
            padding: "14px 28px",
            borderRadius: 12,
            fontWeight: 700,
            textDecoration: "none",
          }}
        >
          Admin Dashboard
        </Link>
        <a
          href="https://play.google.com/store/apps/details?id=org.codcrafters.clivora"
          target="_blank"
          rel="noopener noreferrer"
          style={{
            background: "transparent",
            color: "#fff",
            padding: "14px 28px",
            borderRadius: 12,
            fontWeight: 600,
            border: "1px solid rgba(255,255,255,0.35)",
            textDecoration: "none",
          }}
        >
          Get the App
        </a>
      </div>
      <p style={{ marginTop: 48, fontSize: "0.85rem", color: "#94a3b8" }}>
        v2.6.6 · CodCrafters
      </p>
    </main>
  );
}
