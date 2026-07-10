"use client";

import { FormEvent, useState } from "react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function LoginForm() {
  const router = useRouter();
  const search = useSearchParams();
  const next = search.get("next") || "/app";
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function onSubmit(e: FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError(null);
    const supabase = createClient();
    const { error: err } = await supabase.auth.signInWithPassword({
      email: email.trim().toLowerCase(),
      password,
    });
    setLoading(false);
    if (err) {
      setError(err.message);
      return;
    }
    router.push(next);
    router.refresh();
  }

  return (
    <div className="rounded-2xl border border-border bg-surface p-6 shadow-sm">
      <h1 className="text-2xl font-extrabold text-text-primary">Sign in</h1>
      <p className="mt-1 text-sm text-text-secondary">
        Same account as the CLIVORA mobile app.
      </p>
      <form onSubmit={onSubmit} className="mt-6 space-y-4">
        <label className="block text-sm font-medium text-text-primary">
          Email
          <input
            type="email"
            required
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="mt-1 w-full rounded-xl border border-border bg-white px-3 py-2.5 outline-none ring-primary focus:ring-2"
          />
        </label>
        <label className="block text-sm font-medium text-text-primary">
          Password
          <input
            type="password"
            required
            minLength={6}
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="mt-1 w-full rounded-xl border border-border bg-white px-3 py-2.5 outline-none ring-primary focus:ring-2"
          />
        </label>
        {error && (
          <p className="rounded-lg bg-error/10 px-3 py-2 text-sm text-error">{error}</p>
        )}
        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-full bg-primary py-3 text-sm font-semibold text-white shadow-lg shadow-primary/25 disabled:opacity-60"
        >
          {loading ? "Signing in…" : "Sign in"}
        </button>
      </form>
      <div className="mt-4 flex items-center justify-between text-sm">
        <Link href="/auth/reset-password" className="text-primary hover:underline">
          Forgot password?
        </Link>
        <Link href="/signup" className="font-medium text-text-primary hover:underline">
          Create account
        </Link>
      </div>
    </div>
  );
}
