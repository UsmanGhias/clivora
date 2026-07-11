"use client";

import { FormEvent, useState } from "react";
import { Sparkles } from "lucide-react";

export function AskAi() {
  const [query, setQuery] = useState("");
  const [answer, setAnswer] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function onAsk(e: FormEvent) {
    e.preventDefault();
    if (!query.trim()) return;
    setBusy(true);
    setAnswer(null);
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
      }
    } catch {
      setError("Network error");
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="rounded-2xl border border-primary/20 bg-primary/5 p-4 space-y-3">
      <div className="flex items-center gap-2">
        <Sparkles className="h-4 w-4 text-primary" />
        <p className="text-sm font-bold text-navy">Ask AI</p>
        <span className="rounded-full bg-amber-100 px-2 py-0.5 text-[10px] font-bold text-amber-900">
          Pro
        </span>
      </div>
      <p className="text-xs text-text-secondary">
        Ask questions about your clients, projects, and invoices using natural language.
      </p>
      <form onSubmit={onAsk} className="flex gap-2">
        <input
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="What did I bill last month?"
          className="flex-1 rounded-xl border border-border px-3 py-2 text-sm outline-none focus:ring-2 ring-primary"
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
        <div className="rounded-xl bg-white border border-primary/20 px-4 py-3 text-sm text-text-primary leading-relaxed">
          {answer}
        </div>
      )}
    </div>
  );
}
