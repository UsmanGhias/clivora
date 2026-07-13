"use client";

import { FormEvent, useState } from "react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { site } from "@/lib/site";
import { authErrorMessage, isRateLimitError } from "@/lib/auth-errors";
import { ResendVerification } from "@/components/auth/ResendVerification";
import { GoogleAuthButton } from "@/components/auth/GoogleAuthButton";

export default function SignupForm() {
  const router = useRouter();
  const search = useSearchParams();
  const next = search.get("next") || "/app";
  const roleParam = search.get("role");
  const initialRole =
    roleParam === "client" || roleParam === "freelancer" ? roleParam : "freelancer";
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [accountType, setAccountType] = useState<"freelancer" | "client">(initialRole);
  const [error, setError] = useState<string | null>(null);
  const [info, setInfo] = useState<string | null>(null);
  const [awaitingVerify, setAwaitingVerify] = useState(false);
  const [loading, setLoading] = useState(false);

  async function onSubmit(e: FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setInfo(null);
    setAwaitingVerify(false);
    const supabase = createClient();
    const trimmedEmail = email.trim().toLowerCase();
    const { data, error: err } = await supabase.auth.signUp({
      email: trimmedEmail,
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
      setError(authErrorMessage(err.message));
      if (isRateLimitError(err.message)) {
        setAwaitingVerify(true);
      }
      return;
    }

    if (data.user) {
      await supabase.from("profiles").upsert({
        id: data.user.id,
        email: trimmedEmail,
        name: name.trim(),
        account_type: accountType,
        subscription_plan: "free",
        updated_at: new Date().toISOString(),
      });
    }

    setLoading(false);
    if (!data.session) {
      setAwaitingVerify(true);
      setInfo(
        "Account created. Check your inbox (and spam) to verify your email, then sign in. You can browse Connect meanwhile; creating work needs verification.",
      );
      return;
    }
    router.push(next.startsWith("/") ? next : "/app");
    router.refresh();
  }

  return (
    <div className="rounded-2xl border border-border bg-surface p-6 shadow-sm">
      <h1 className="text-2xl font-extrabold text-text-primary">Create account</h1>
      <p className="mt-1 text-sm text-text-secondary">
        Same Supabase account as the mobile app. Verify email before creating clients, invoices, or Connect posts.
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
            className="mt-1 w-full rounded-xl border border-border bg-white px-3 py-2.5 text-text-primary outline-none ring-primary focus:ring-2"
          />
        </label>
        <label className="block text-sm font-medium text-text-primary">
          Email
          <input
            type="email"
            required
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="mt-1 w-full rounded-xl border border-border bg-white px-3 py-2.5 text-text-primary outline-none ring-primary focus:ring-2"
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
            className="mt-1 w-full rounded-xl border border-border bg-white px-3 py-2.5 text-text-primary outline-none ring-primary focus:ring-2"
          />
        </label>
        {error && (
          <p className="rounded-lg bg-error/10 px-3 py-2 text-sm text-error">{error}</p>
        )}
        {info && (
          <p className="rounded-lg bg-primary/10 px-3 py-2 text-sm text-primary-dark">{info}</p>
        )}
        {awaitingVerify && <ResendVerification email={email} />}
        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-full bg-primary py-3 text-sm font-semibold text-white shadow-lg shadow-primary/25 disabled:opacity-60"
        >
          {loading ? "Creating…" : "Sign up"}
        </button>
      </form>
      <div className="my-4 flex items-center gap-3 text-xs text-text-muted">
        <div className="h-px flex-1 bg-border" />
        OR
        <div className="h-px flex-1 bg-border" />
      </div>
      <GoogleAuthButton mode="signup" accountType={accountType} next={next} />
      {awaitingVerify && (
        <div className="mt-4 flex flex-wrap gap-2 text-sm">
          <Link
            href={`/login?next=${encodeURIComponent(next)}`}
            className="rounded-full bg-navy px-4 py-2 font-semibold text-white"
          >
            Go to sign in
          </Link>
          <Link href="/connect" className="rounded-full border border-navy/20 px-4 py-2 font-semibold text-navy">
            Browse Connect
          </Link>
        </div>
      )}
      <p className="mt-4 text-center text-sm text-text-secondary">
        Already have an account?{" "}
        <Link
          href={`/login?next=${encodeURIComponent(next)}`}
          className="font-medium text-primary hover:underline"
        >
          Sign in
        </Link>
      </p>
    </div>
  );
}
