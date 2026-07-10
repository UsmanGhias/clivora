"use client";

import { FormEvent, useEffect, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

type ProfileRow = {
  id?: string;
  display_title: string;
  headline: string;
  skills: string;
  rate_band: string;
  is_listed: boolean;
};

type NeedRow = {
  id: string;
  title: string;
  summary: string;
  skills: string;
  budget_band: string;
  is_open: boolean;
};

export default function ConnectManagePage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);
  const [accountType, setAccountType] = useState("freelancer");
  const [plan, setPlan] = useState("free");
  const [listing, setListing] = useState<ProfileRow>({
    display_title: "",
    headline: "",
    skills: "",
    rate_band: "",
    is_listed: true,
  });
  const [need, setNeed] = useState({ title: "", summary: "", skills: "", budget_band: "" });
  const [needs, setNeeds] = useState<NeedRow[]>([]);

  useEffect(() => {
    (async () => {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        router.replace("/login?next=/connect/manage");
        return;
      }
      const { data: profile } = await supabase
        .from("profiles")
        .select("account_type, subscription_plan, name")
        .eq("id", user.id)
        .maybeSingle();
      const p = (profile?.subscription_plan ?? "free").toLowerCase();
      const plus = p === "pro_plus" || p === "plus" || p === "proplus";
      if (!plus) {
        router.replace("/pro");
        return;
      }
      setAccountType((profile?.account_type ?? "freelancer").toLowerCase());
      setPlan(profile?.subscription_plan ?? "free");

      const { data: cp } = await supabase
        .from("connect_profiles")
        .select("id, display_title, headline, skills, rate_band, is_listed")
        .eq("user_id", user.id)
        .maybeSingle();
      if (cp) {
        setListing({
          id: cp.id,
          display_title: cp.display_title ?? "",
          headline: cp.headline ?? "",
          skills: Array.isArray(cp.skills) ? cp.skills.join(", ") : String(cp.skills ?? ""),
          rate_band: cp.rate_band ?? "",
          is_listed: !!cp.is_listed,
        });
      } else if (profile?.name) {
        setListing((s) => ({ ...s, display_title: profile.name as string }));
      }

      const { data: needRows } = await supabase
        .from("connect_need_posts")
        .select("id, title, summary, skills, budget_band, is_open")
        .eq("client_user_id", user.id)
        .order("created_at", { ascending: false });
      setNeeds(
        (needRows ?? []).map((n) => ({
          id: n.id,
          title: n.title ?? "",
          summary: n.summary ?? "",
          skills: Array.isArray(n.skills) ? n.skills.join(", ") : String(n.skills ?? ""),
          budget_band: n.budget_band ?? "",
          is_open: !!n.is_open,
        }))
      );
      setLoading(false);
    })();
  }, [router]);

  async function saveListing(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    setError(null);
    setMessage(null);
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) return;
    const skills = listing.skills
      .split(",")
      .map((s) => s.trim())
      .filter(Boolean);
    const payload = {
      user_id: user.id,
      display_title: listing.display_title.trim(),
      headline: listing.headline.trim(),
      skills,
      rate_band: listing.rate_band.trim(),
      is_listed: listing.is_listed,
      account_type: accountType,
      moderation_status: "pending",
      updated_at: new Date().toISOString(),
    };
    const { error: err } = listing.id
      ? await supabase.from("connect_profiles").update(payload).eq("id", listing.id)
      : await supabase.from("connect_profiles").insert(payload);
    setSaving(false);
    if (err) {
      setError(err.message);
      return;
    }
    setMessage("Listing saved. It may appear after moderation.");
  }

  async function createNeed(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    setError(null);
    setMessage(null);
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) return;
    const skills = need.skills
      .split(",")
      .map((s) => s.trim())
      .filter(Boolean);
    const { error: err } = await supabase.from("connect_need_posts").insert({
      client_user_id: user.id,
      title: need.title.trim(),
      summary: need.summary.trim(),
      skills,
      budget_band: need.budget_band.trim(),
      is_open: true,
      moderation_status: "pending",
    });
    setSaving(false);
    if (err) {
      setError(err.message);
      return;
    }
    setMessage("Need posted.");
    setNeed({ title: "", summary: "", skills: "", budget_band: "" });
    router.refresh();
  }

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background text-sm text-text-secondary">
        Loading Connect…
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      <header className="border-b border-border bg-navy px-4 py-4 text-white">
        <div className="mx-auto flex max-w-3xl items-center justify-between">
          <Link href="/connect" className="font-extrabold">
            ← Connect
          </Link>
          <span className="text-xs text-white/70">Plan: {plan}</span>
        </div>
      </header>
      <main className="mx-auto max-w-3xl space-y-8 px-4 py-8">
        <div>
          <h1 className="text-2xl font-extrabold">Manage Connect</h1>
          <p className="text-sm text-text-secondary">
            Publish to the same marketplace moderated in CodCrafters Admin.
          </p>
        </div>

        {accountType !== "client" && (
          <form onSubmit={saveListing} className="space-y-3 rounded-2xl border border-border bg-surface p-5">
            <h2 className="font-bold">Freelancer listing</h2>
            <input
              required
              placeholder="Display title"
              value={listing.display_title}
              onChange={(e) => setListing({ ...listing, display_title: e.target.value })}
              className="w-full rounded-xl border border-border px-3 py-2"
            />
            <textarea
              required
              placeholder="Headline"
              value={listing.headline}
              onChange={(e) => setListing({ ...listing, headline: e.target.value })}
              className="w-full rounded-xl border border-border px-3 py-2"
              rows={3}
            />
            <input
              placeholder="Skills (comma separated)"
              value={listing.skills}
              onChange={(e) => setListing({ ...listing, skills: e.target.value })}
              className="w-full rounded-xl border border-border px-3 py-2"
            />
            <input
              placeholder="Rate band (e.g. $40–60/hr)"
              value={listing.rate_band}
              onChange={(e) => setListing({ ...listing, rate_band: e.target.value })}
              className="w-full rounded-xl border border-border px-3 py-2"
            />
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={listing.is_listed}
                onChange={(e) => setListing({ ...listing, is_listed: e.target.checked })}
              />
              Listed publicly
            </label>
            <button
              type="submit"
              disabled={saving}
              className="rounded-full bg-primary px-4 py-2 text-sm font-semibold text-white disabled:opacity-60"
            >
              {saving ? "Saving…" : "Save listing"}
            </button>
          </form>
        )}

        <form onSubmit={createNeed} className="space-y-3 rounded-2xl border border-border bg-surface p-5">
          <h2 className="font-bold">Post a need</h2>
          <input
            required
            placeholder="Title"
            value={need.title}
            onChange={(e) => setNeed({ ...need, title: e.target.value })}
            className="w-full rounded-xl border border-border px-3 py-2"
          />
          <textarea
            required
            placeholder="Summary"
            value={need.summary}
            onChange={(e) => setNeed({ ...need, summary: e.target.value })}
            className="w-full rounded-xl border border-border px-3 py-2"
            rows={3}
          />
          <input
            placeholder="Skills"
            value={need.skills}
            onChange={(e) => setNeed({ ...need, skills: e.target.value })}
            className="w-full rounded-xl border border-border px-3 py-2"
          />
          <input
            placeholder="Budget band"
            value={need.budget_band}
            onChange={(e) => setNeed({ ...need, budget_band: e.target.value })}
            className="w-full rounded-xl border border-border px-3 py-2"
          />
          <button
            type="submit"
            disabled={saving}
            className="rounded-full bg-navy px-4 py-2 text-sm font-semibold text-white disabled:opacity-60"
          >
            {saving ? "Posting…" : "Post need"}
          </button>
        </form>

        {needs.length > 0 && (
          <div className="space-y-2">
            <h2 className="font-bold">Your needs</h2>
            {needs.map((n) => (
              <div key={n.id} className="rounded-xl border border-border bg-surface px-4 py-3">
                <p className="font-semibold">{n.title}</p>
                <p className="text-sm text-text-secondary">{n.summary}</p>
              </div>
            ))}
          </div>
        )}

        {error && <p className="rounded-lg bg-error/10 px-3 py-2 text-sm text-error">{error}</p>}
        {message && (
          <p className="rounded-lg bg-primary/10 px-3 py-2 text-sm text-primary-dark">{message}</p>
        )}
      </main>
    </div>
  );
}
