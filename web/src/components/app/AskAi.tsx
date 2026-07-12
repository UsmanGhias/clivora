"use client";

import { FormEvent, useState } from "react";
import { Smartphone, Sparkles } from "lucide-react";
import { site } from "@/lib/site";

export function AskAi() {
  const [query, setQuery] = useState("");
  const [answer, setAnswer] = useState<string | null>(null);
  const [mode, setMode] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function onAsk(e: FormEvent) {
    e.preventDefault();
    if (!query.trim()) return;
    setBusy(true);
    setAnswer(null);
    setMode(null);
    setError(null);
    try {
      const res = await fetch("/api/ai/ask", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ query: query.trim() }),
      });
      const json = await res.json();
      if (!res.ok) {
        setError(json.error ?? "Request failed");
      } else {
        setAnswer(json.answer ?? "No response.");
        setMode(json.mode ?? json.source ?? null);
      }
    } catch {
      setError("Network error");
    } finally {
      setBusy(false);
    }
  }

  const showAppCta = mode === "app_required" || mode === "provider_error";

  return (
    <div className="space-y-3 rounded-2xl border border-primary/20 bg-primary/5 p-4">
      <div className="flex items-center gap-2">
        <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-primary/15 text-primary">
          <Sparkles className="h-4 w-4" />
        </span>
        <div>
          <p className="text-sm font-bold text-navy">Ask AI</p>
          <p className="text-[11px] font-semibold uppercase tracking-wide text-amber-800">
            Pro feature
          </p>
        </div>
      </div>
      <p className="text-xs text-text-secondary">
        Ask about clients, projects, and invoices. If cloud AI is offline, use the Android app for
        local insights.
      </p>
      <form onSubmit={onAsk} className="flex gap-2">
        <input
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="What did I bill last month?"
          className="flex-1 rounded-xl border border-border px-3 py-2 text-sm outline-none ring-primary focus:ring-2"
        />
        <button
          type="submit"
          disabled={busy || !query.trim()}
          className="rounded-xl bg-primary px-4 py-2 text-sm font-semibold text-white disabled:opacity-50"
        >
          {busy ? "…" : "Ask"}
        </button>
      </form>
      {error && (
        <p className="rounded-xl bg-error/10 px-3 py-2 text-sm text-error">{error}</p>
      )}
      {answer && (
        <div className="rounded-xl border border-primary/20 bg-white px-4 py-3 text-sm leading-relaxed text-text-primary">
          {answer}
        </div>
      )}
      {showAppCta && (
        <a
          href={site.playStoreUrl}
          target="_blank"
          rel="noreferrer"
          className="inline-flex items-center gap-2 rounded-xl bg-navy px-4 py-2.5 text-sm font-bold text-white"
        >
          <Smartphone className="h-4 w-4" />
          Download Android app for AI
        </a>
      )}
    </div>
  );
}
