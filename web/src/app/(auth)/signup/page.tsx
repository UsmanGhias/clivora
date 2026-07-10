"use client";

import { FormEvent, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { site } from "@/lib/site";

export default function SignupPage() {
  const router = useRouter();
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [accountType, setAccountType] = useState<"freelancer" | "client">("freelancer");
  const [error, setError] = useState<string | null>(null);
  const [info, setInfo] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function onSubmit(e: FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setInfo(null);
    const supabase = createClient();
    const { data, error: err } = await supabase.auth.signUp({
      email: email.trim().toLowerCase(),
      password,
      options: {
        data: {
          name: name.trim(),
          account_type: accountType,
        },
        emailRedirectTo: `${site.url}/auth/callback`,
      },
    });
    if (err) {
      setLoading(false);
      setError(err.message);
      return;
    }

    // Upsert profile when session exists (confirm-email may be off).
    if (data.user) {
      await supabase.from("profiles").upsert({
        id: data.user.id,
        email: email.trim().toLowerCase(),
        name: name.trim(),
        account_type: accountType,
        subscription_plan: "free",
        updated_at: new Date().toISOString(),
      });
    }

    setLoading(false);
    if (!data.session) {
      setInfo("Check your inbox to verify your email, then sign in.");
      return;
    }
    router.push("/app");
    router.refresh();
  }

  return (
    <div className="rounded-2xl border border-border bg-surface p-6 shadow-sm">
      <h1 className="text-2xl font-extrabold text-text-primary">Create account</h1>
      <p className="mt-1 text-sm text-text-secondary">
        Works with the same Supabase backend as the mobile app.
      </p>
      <form onSubmit={onSubmit} className="mt-6 space-y-4">
        <div className="grid grid-cols-2 gap-2 rounded-xl bg-background p-1">
          {(["freelancer", "client"] as const).map((t) => (
            <button
              key={t}
              type="button"
              onClick={() => setAccountType(t)}
              className={`rounded-lg py-2 text-sm font-semibold capitalize ${
                accountType === t ? "bg-navy text-white" : "text-text-secondary"
              }`}
            >
              {t}
            </button>
          ))}
        </div>
        <label className="block text-sm font-medium text-text-primary">
          Full name
          <input
            required
            value={name}
            onChange={(e) => setName(e.target.value)}
            className="mt-1 w-full rounded-xl border border-border bg-white px-3 py-2.5 outline-none ring-primary focus:ring-2"
          />
        </label>
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
        {info && (
          <p className="rounded-lg bg-primary/10 px-3 py-2 text-sm text-primary-dark">{info}</p>
        )}
        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-full bg-primary py-3 text-sm font-semibold text-white shadow-lg shadow-primary/25 disabled:opacity-60"
        >
          {loading ? "Creating…" : "Sign up"}
        </button>
      </form>
      <p className="mt-4 text-center text-sm text-text-secondary">
        Already have an account?{" "}
        <Link href="/login" className="font-medium text-primary hover:underline">
          Sign in
        </Link>
      </p>
    </div>
  );
}
