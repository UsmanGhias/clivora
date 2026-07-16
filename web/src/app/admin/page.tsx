"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Logo } from "@/components/ui/Logo";
import { createBrowserSupabaseClient } from "@/lib/supabase-browser";

/** Admin login gate — authenticated admins are sent to the new panel overview. */
export default function AdminLoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);
  const [checking, setChecking] = useState(true);

  useEffect(() => {
    const supabase = createBrowserSupabaseClient();
    void supabase.auth.getSession().then(({ data }) => {
      if (data.session) {
        router.replace("/admin/overview");
      } else {
        setChecking(false);
      }
    });
  }, [router]);

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    setBusy(true);
    setError("");
    try {
      const supabase = createBrowserSupabaseClient();
      const { error: authError } = await supabase.auth.signInWithPassword({
        email: email.trim().toLowerCase(),
        password,
      });
      if (authError) throw authError;
      router.replace("/admin/overview");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Sign-in failed");
    } finally {
      setBusy(false);
    }
  }

  if (checking) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-slate-950 text-slate-300">
        Loading admin…
      </div>
    );
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-slate-950 via-slate-900 to-teal-950 p-6">
      <form
        onSubmit={onSubmit}
        className="w-full max-w-md rounded-3xl border border-white/10 bg-white p-8 shadow-2xl"
      >
        <div className="mb-6 flex flex-col items-center text-center">
          <Logo size="lg" showText={false} variant="onLight" />
          <h1 className="mt-4 text-2xl font-black text-slate-900">CLIVORA Admin</h1>
          <p className="mt-1 text-sm text-slate-500">Sign in with your admin account + MFA</p>
        </div>
        {error && (
          <div className="mb-4 rounded-xl border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700">
            {error}
          </div>
        )}
        <label className="mb-3 block text-xs font-bold uppercase tracking-wide text-slate-500">
          Email
          <input
            type="email"
            required
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="mt-1 w-full rounded-xl border border-slate-200 px-3 py-2.5 text-sm font-medium text-slate-900 outline-none focus:border-teal-500"
            placeholder="usmanghias1@gmail.com"
          />
        </label>
        <label className="mb-5 block text-xs font-bold uppercase tracking-wide text-slate-500">
          Password
          <input
            type="password"
            required
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="mt-1 w-full rounded-xl border border-slate-200 px-3 py-2.5 text-sm font-medium text-slate-900 outline-none focus:border-teal-500"
          />
        </label>
        <button
          type="submit"
          disabled={busy}
          className="w-full rounded-xl bg-teal-600 py-3 text-sm font-bold text-white hover:bg-teal-700 disabled:opacity-60"
        >
          {busy ? "Signing in…" : "Continue to Admin Panel"}
        </button>
        <p className="mt-4 text-center text-xs text-slate-400">
          Admins: usmanghias1@gmail.com · iusmanghias@gmail.com
        </p>
      </form>
    </div>
  );
}
