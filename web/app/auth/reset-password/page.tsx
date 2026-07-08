"use client";

import { useEffect, useState, type CSSProperties, type FormEvent } from "react";
import Link from "next/link";
import { createBrowserSupabaseClient } from "@/lib/supabase";
import { CLIVORA_NAVY, CLIVORA_PURPLE } from "@/lib/admin";

export default function ResetPasswordPage() {
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");
  const [ready, setReady] = useState(false);
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [done, setDone] = useState(false);

  const supabase = createBrowserSupabaseClient();

  useEffect(() => {
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((event) => {
      if (event === "PASSWORD_RECOVERY" || event === "SIGNED_IN") {
        setReady(true);
      }
    });

    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session) setReady(true);
    });

    return () => subscription.unsubscribe();
  }, [supabase.auth]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError("");
    setMessage("");

    if (password.length < 8) {
      setError("Password must be at least 8 characters.");
      return;
    }
    if (password !== confirm) {
      setError("Passwords do not match.");
      return;
    }

    setLoading(true);
    const { error: updateError } = await supabase.auth.updateUser({ password });
    setLoading(false);

    if (updateError) {
      setError(updateError.message);
      return;
    }

    setDone(true);
    setMessage("Password updated. You can return to the CLIVORA app and sign in.");
    await supabase.auth.signOut();
  }

  return (
    <main
      style={{
        minHeight: "100vh",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        padding: 24,
        background: `linear-gradient(135deg, ${CLIVORA_NAVY} 0%, #312e81 100%)`,
      }}
    >
      <div
        style={{
          background: "#fff",
          borderRadius: 20,
          padding: 32,
          width: "100%",
          maxWidth: 420,
          boxShadow: "0 20px 50px rgba(0,0,0,0.25)",
        }}
      >
        <div
          style={{
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
            marginBottom: 16,
          }}
        >
          C
        </div>
        <h1 style={{ margin: "0 0 8px", fontSize: "1.4rem" }}>Reset your password</h1>
        <p style={{ color: "#64748b", margin: "0 0 24px", fontSize: "0.9rem", lineHeight: 1.5 }}>
          Set a new password for your CLIVORA account. This page handles Supabase reset links from the mobile app.
        </p>

        {!ready && !done && (
          <p style={{ color: "#64748b", fontSize: "0.9rem" }}>
            Open the reset link from your email to continue. If you already have a valid link, wait a moment…
          </p>
        )}

        {error && <p style={{ color: "#dc2626", fontSize: "0.85rem", marginBottom: 12 }}>{error}</p>}
        {message && <p style={{ color: "#16a34a", fontSize: "0.85rem", marginBottom: 12 }}>{message}</p>}

        {ready && !done && (
          <form onSubmit={handleSubmit}>
            <label style={{ display: "block", fontSize: "0.85rem", fontWeight: 600, marginBottom: 6 }}>
              New password
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              minLength={8}
              required
              autoComplete="new-password"
              style={inputStyle}
            />
            <label style={{ display: "block", fontSize: "0.85rem", fontWeight: 600, marginBottom: 6 }}>
              Confirm password
            </label>
            <input
              type="password"
              value={confirm}
              onChange={(e) => setConfirm(e.target.value)}
              minLength={8}
              required
              autoComplete="new-password"
              style={inputStyle}
            />
            <button
              type="submit"
              disabled={loading}
              style={{
                width: "100%",
                background: CLIVORA_PURPLE,
                color: "#fff",
                border: "none",
                borderRadius: 10,
                padding: "12px 16px",
                fontWeight: 600,
                cursor: loading ? "wait" : "pointer",
              }}
            >
              {loading ? "Updating…" : "Update password"}
            </button>
          </form>
        )}

        <p style={{ marginTop: 20, fontSize: "0.85rem" }}>
          <Link href="/">Back to CLIVORA</Link>
        </p>
      </div>
    </main>
  );
}

const inputStyle: CSSProperties = {
  width: "100%",
  padding: "10px 12px",
  border: "1px solid #e2e8f0",
  borderRadius: 10,
  fontSize: "0.95rem",
  marginBottom: 16,
};
