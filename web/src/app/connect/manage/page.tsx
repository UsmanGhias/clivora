"use client";

import { FormEvent, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { SubPageChrome } from "@/components/app/SubPageChrome";

type ProfileRow = {
  id?: string;
  display_title: string;
  headline: string;
  bio: string;
  skills: string;
  rate_band: string;
  availability: string;
  location_label: string;
  is_listed: boolean;
  avg_rating?: number;
  review_count?: number;
  profile_completeness?: number;
};

function computeCompleteness(l: ProfileRow): number {
  let score = 0;
  if (l.display_title.trim()) score += 20;
  if (l.headline.trim()) score += 15;
  if (l.bio.trim()) score += 20;
  if (l.skills.split(",").map((s) => s.trim()).filter(Boolean).length > 0) score += 15;
  if (l.rate_band.trim()) score += 10;
  if (l.availability.trim()) score += 10;
  if (l.location_label.trim()) score += 10;
  return score;
}

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
  const [restricted, setRestricted] = useState(false);
  const [listing, setListing] = useState<ProfileRow>({
    display_title: "",
    headline: "",
    bio: "",
    skills: "",
    rate_band: "",
    availability: "Available now",
    location_label: "",
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
        .select("account_type, subscription_plan, name, is_blocked, is_restricted")
        .eq("id", user.id)
        .maybeSingle();
      if (profile?.is_blocked) {
        router.replace("/blocked");
        return;
      }
      const p = (profile?.subscription_plan ?? "free").toLowerCase();
      const plus = p === "pro_plus" || p === "plus" || p === "proplus";
      if (!plus) {
        router.replace("/pro?plan=pro_plus");
        return;
      }
      setRestricted(profile?.is_restricted === true);
      setAccountType((profile?.account_type ?? "freelancer").toLowerCase());
      setPlan(profile?.subscription_plan ?? "free");

      const { data: cp } = await supabase
        .from("connect_profiles")
        .select(
          "id, display_title, headline, bio, skills, rate_band, availability, location_label, is_listed, avg_rating, review_count, profile_completeness",
        )
        .eq("user_id", user.id)
        .maybeSingle();
      if (cp) {
        setListing({
          id: cp.id,
          display_title: cp.display_title ?? "",
          headline: cp.headline ?? "",
          bio: cp.bio ?? "",
          skills: Array.isArray(cp.skills) ? cp.skills.join(", ") : String(cp.skills ?? ""),
          rate_band: cp.rate_band ?? "",
          availability: cp.availability ?? "Available now",
          location_label: cp.location_label ?? "",
          is_listed: !!cp.is_listed,
          avg_rating: Number(cp.avg_rating ?? 0),
          review_count: Number(cp.review_count ?? 0),
          profile_completeness: Number(cp.profile_completeness ?? 0),
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
        })),
      );
      setLoading(false);
    })();
  }, [router]);

  async function saveListing(e: FormEvent) {
    e.preventDefault();
    if (restricted) {
      setError("Your account is restricted from publishing.");
      return;
    }
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
      bio: listing.bio.trim(),
      skills,
      rate_band: listing.rate_band.trim(),
      availability: listing.availability.trim(),
      location_label: listing.location_label.trim(),
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
    setMessage("Profile saved. It may appear after moderation.");
  }

  async function createNeed(e: FormEvent) {
    e.preventDefault();
    if (restricted) {
      setError("Your account is restricted from posting jobs.");
      return;
    }
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
    setMessage("Job posted.");
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

  const isClient = accountType === "client";

  return (
    <SubPageChrome
      isClient={isClient}
      backHref="/connect"
      backLabel="Back to Connect"
      crumbs={[
        { label: "App", href: "/app" },
        { label: "Connect", href: "/connect" },
        { label: "Manage" },
      ]}
      title="Manage Connect"
      rightSlot={
        <span className="rounded-full bg-white/10 px-3 py-1.5 text-xs font-semibold text-white/80">
          {plan}
        </span>
      }
    >
      <div className="mx-auto max-w-3xl space-y-8">
        <p className="text-sm text-text-secondary">
          Keep your listing sharp, title, rate, skills, location, and availability show on the
          public marketplace.
        </p>

        {restricted && (
          <p className="rounded-xl bg-amber-50 px-4 py-3 text-sm text-amber-900">
            Restricted account: you can view Connect but cannot publish until an admin lifts the
            restriction.
          </p>
        )}

        {!isClient && (
          <form onSubmit={saveListing} className="space-y-3 rounded-2xl border border-border bg-surface p-5">
            <h2 className="font-bold text-navy">Freelancer profile</h2>
            {(() => {
              const pct = computeCompleteness(listing);
              return (
                <div className="rounded-xl bg-background px-3 py-2">
                  <div className="flex items-center justify-between text-xs font-semibold text-navy">
                    <span>Profile completeness · {pct}%</span>
                    <span className="text-text-muted">
                      {(listing.review_count ?? 0) > 0
                        ? `★ ${Number(listing.avg_rating ?? 0).toFixed(1)} (${listing.review_count})`
                        : "No reviews yet. New badge"}
                    </span>
                  </div>
                  <div className="mt-1.5 h-2 overflow-hidden rounded-full bg-border">
                    <div
                      className="h-full rounded-full bg-primary transition-all"
                      style={{ width: `${pct}%` }}
                    />
                  </div>
                  {pct < 80 && (
                    <p className="mt-1 text-[11px] text-text-secondary">
                      Fill title, headline, bio, skills, rate, availability, and location for stronger ranking.
                    </p>
                  )}
                </div>
              );
            })()}
            <input
              required
              placeholder="Display title (e.g. Full-stack developer)"
              value={listing.display_title}
              onChange={(e) => setListing({ ...listing, display_title: e.target.value })}
              className="w-full rounded-xl border border-border px-3 py-2"
            />
            <input
              required
              placeholder="Headline"
              value={listing.headline}
              onChange={(e) => setListing({ ...listing, headline: e.target.value })}
              className="w-full rounded-xl border border-border px-3 py-2"
            />
            <textarea
              placeholder="Bio, what you deliver, industries, tools"
              value={listing.bio}
              onChange={(e) => setListing({ ...listing, bio: e.target.value })}
              className="w-full rounded-xl border border-border px-3 py-2"
              rows={4}
            />
            <div className="grid gap-3 sm:grid-cols-2">
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
              <input
                placeholder="Location (e.g. Lahore · Remote)"
                value={listing.location_label}
                onChange={(e) => setListing({ ...listing, location_label: e.target.value })}
                className="w-full rounded-xl border border-border px-3 py-2"
              />
              <input
                placeholder="Availability"
                value={listing.availability}
                onChange={(e) => setListing({ ...listing, availability: e.target.value })}
                className="w-full rounded-xl border border-border px-3 py-2"
              />
            </div>
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
              disabled={saving || restricted}
              className="rounded-full bg-primary px-4 py-2 text-sm font-semibold text-white disabled:opacity-60"
            >
              {saving ? "Saving…" : "Save profile"}
            </button>
          </form>
        )}

        <form onSubmit={createNeed} className="space-y-3 rounded-2xl border border-border bg-surface p-5">
          <h2 className="font-bold text-navy">{isClient ? "Post a job" : "Post a need (optional)"}</h2>
          <input
            required
            placeholder="Job title"
            value={need.title}
            onChange={(e) => setNeed({ ...need, title: e.target.value })}
            className="w-full rounded-xl border border-border px-3 py-2"
          />
          <textarea
            required
            placeholder="What do you need delivered?"
            value={need.summary}
            onChange={(e) => setNeed({ ...need, summary: e.target.value })}
            className="w-full rounded-xl border border-border px-3 py-2"
            rows={4}
          />
          <div className="grid gap-3 sm:grid-cols-2">
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
          </div>
          <button
            type="submit"
            disabled={saving || restricted}
            className="rounded-full bg-navy px-4 py-2 text-sm font-semibold text-white disabled:opacity-60"
          >
            {saving ? "Posting…" : "Publish job"}
          </button>
        </form>

        {needs.length > 0 && (
          <div className="space-y-2">
            <h2 className="font-bold">Your jobs</h2>
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
      </div>
    </SubPageChrome>
  );
}
