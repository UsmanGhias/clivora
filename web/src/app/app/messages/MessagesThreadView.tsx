"use client";

import Link from "next/link";
import { FormEvent, useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { MessageSquare, Network, Send } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import type { MessageRow } from "./page";

function formatTime(iso?: string | null) {
  if (!iso) return "";
  try {
    return new Date(iso).toLocaleString(undefined, {
      dateStyle: "short",
      timeStyle: "short",
    });
  } catch {
    return iso;
  }
}

function ComposeForm({
  fromEmail,
  defaultTo,
  parentId,
  parentSubject,
  onSent,
  compact,
  isClient,
}: {
  fromEmail: string;
  defaultTo?: string;
  parentId?: string;
  parentSubject?: string;
  onSent?: () => void;
  compact?: boolean;
  isClient?: boolean;
}) {
  const router = useRouter();
  const [toEmail, setToEmail] = useState(defaultTo ?? "");
  const [subject, setSubject] = useState(parentSubject ? `Re: ${parentSubject}` : "");
  const [body, setBody] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [ok, setOk] = useState(false);

  async function onSend(e: FormEvent) {
    e.preventDefault();
    setBusy(true);
    setError(null);
    setOk(false);
    try {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) throw new Error("Sign in required");
      const to = toEmail.trim().toLowerCase();
      let toUid: string | null = null;
      if (to) {
        const { data: prof } = await supabase
          .from("profiles")
          .select("id")
          .eq("email", to)
          .maybeSingle();
        toUid = prof?.id ?? null;
      }
      const { error: err } = await supabase.from("client_messages").insert({
        from_uid: user.id,
        from_email: fromEmail || user.email || "",
        to_email: to || null,
        to_uid: toUid,
        subject: subject.trim() || (parentId ? "Reply" : "Message"),
        body: body.trim(),
        is_read: false,
        parent_message_id: parentId ?? null,
      });
      if (err) throw err;
      setBody("");
      if (!parentId) {
        setSubject("");
        setToEmail(defaultTo ?? "");
      }
      setOk(true);
      onSent?.();
      router.refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Send failed");
    } finally {
      setBusy(false);
    }
  }

  return (
    <form
      onSubmit={onSend}
      className={`space-y-2 rounded-2xl border border-border bg-surface ${compact ? "p-3" : "p-4"}`}
    >
      {!compact && (
        <div className="flex items-center gap-2">
          <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-navy/10 text-navy">
            <Send className="h-4 w-4" />
          </span>
          <div>
            <p className="text-sm font-semibold text-navy">
              {isClient ? "Message your freelancer" : "Message a client"}
            </p>
            <p className="text-[11px] text-text-muted">
              Use the email from an accepted Connect match, or your CRM contact.
            </p>
          </div>
        </div>
      )}
      {!parentId && (
        <label className="block text-xs font-semibold text-text-secondary">
          {isClient ? "Freelancer email" : "Client email"}
          <input
            required
            type="email"
            placeholder={isClient ? "freelancer@example.com" : "client@example.com"}
            value={toEmail}
            onChange={(e) => setToEmail(e.target.value)}
            className="mt-1 w-full rounded-xl border border-border px-3 py-2 text-sm"
          />
        </label>
      )}
      {!parentId && (
        <label className="block text-xs font-semibold text-text-secondary">
          Subject
          <input
            placeholder="Project update, invoice question, or next step"
            value={subject}
            onChange={(e) => setSubject(e.target.value)}
            className="mt-1 w-full rounded-xl border border-border px-3 py-2 text-sm"
          />
        </label>
      )}
      <label className="block text-xs font-semibold text-text-secondary">
        {parentId ? "Reply" : "Message"}
        <textarea
          required
          rows={compact ? 2 : 3}
          placeholder={parentId ? "Write a reply" : "Write your message"}
          value={body}
          onChange={(e) => setBody(e.target.value)}
          className="mt-1 w-full rounded-xl border border-border px-3 py-2 text-sm"
        />
      </label>
      {error && <p className="text-sm text-error">{error}</p>}
      {ok && (
        <p className="text-sm text-green-700">
          {parentId ? "Reply sent." : "Message sent."}
        </p>
      )}
      <button
        type="submit"
        disabled={busy}
        className="rounded-xl bg-navy px-4 py-2 text-sm font-semibold text-white disabled:opacity-50"
      >
        {busy ? "Sending…" : parentId ? "Reply" : "Send"}
      </button>
    </form>
  );
}

function MarkReadButton({ messageId, readAt }: { messageId: string; readAt?: string | null }) {
  const router = useRouter();
  const [busy, setBusy] = useState(false);
  const [done, setDone] = useState(!!readAt);

  async function markRead() {
    if (done || busy) return;
    setBusy(true);
    try {
      const supabase = createClient();
      await supabase
        .from("client_messages")
        .update({ read_at: new Date().toISOString() })
        .eq("id", messageId);
      setDone(true);
      router.refresh();
    } finally {
      setBusy(false);
    }
  }

  if (done) {
    return <span className="text-[10px] text-text-muted">Read</span>;
  }
  return (
    <button
      type="button"
      onClick={markRead}
      disabled={busy}
      className="rounded px-2 py-0.5 text-[10px] font-semibold text-primary hover:underline disabled:opacity-50"
    >
      {busy ? "…" : "Mark read"}
    </button>
  );
}

export function MessagesThreadView({
  rows,
  fromEmail,
  myUid,
  isClient = false,
}: {
  rows: MessageRow[];
  fromEmail: string;
  myUid: string;
  isClient?: boolean;
}) {
  const [replyTo, setReplyTo] = useState<string | null>(null);
  const [filter, setFilter] = useState<"all" | "unread">("all");
  const [selectedId, setSelectedId] = useState<string | null>(null);

  const topLevel = useMemo(() => {
    const roots = rows.filter((r) => !r.parent_message_id);
    const sorted = [...roots].sort((a, b) =>
      String(b.created_at || "").localeCompare(String(a.created_at || "")),
    );
    if (filter === "unread") {
      return sorted.filter((r) => r.from_uid !== myUid && !r.read_at);
    }
    return sorted;
  }, [rows, filter, myUid]);

  const repliesFor = (parentId: string) =>
    rows.filter((r) => r.parent_message_id === parentId);

  const unreadCount = rows.filter(
    (r) => !r.parent_message_id && r.from_uid !== myUid && !r.read_at,
  ).length;
  const selectedThread = topLevel.find((r) => r.id === selectedId) ?? topLevel[0] ?? null;

  useEffect(() => {
    if (selectedId && !topLevel.some((r) => r.id === selectedId)) {
      setSelectedId(null);
      setReplyTo(null);
    }
  }, [selectedId, topLevel]);

  if (rows.length === 0) {
    return (
      <div className="space-y-4">
        <ComposeForm fromEmail={fromEmail} isClient={isClient} />
        <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center">
          <MessageSquare className="mx-auto h-8 w-8 text-text-muted" />
          <p className="mt-3 font-semibold text-navy">No messages yet</p>
          <p className="mt-2 text-sm text-text-secondary">
            {isClient
              ? "Message freelancers after you accept a Connect request, or start from a shared project."
              : "Message clients from your CRM email, or continue after a Connect match."}
          </p>
          <Link
            href="/connect"
            className={`mt-4 inline-flex items-center gap-2 rounded-xl px-4 py-2.5 text-sm font-bold text-white ${
              isClient ? "bg-client-accent" : "bg-primary"
            }`}
          >
            <Network className="h-4 w-4" />
            Open Connect
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="grid gap-4 lg:grid-cols-[minmax(0,0.9fr)_minmax(0,1.5fr)]">
      <aside className="space-y-4">
        <ComposeForm fromEmail={fromEmail} isClient={isClient} />
        <div className="rounded-2xl border border-border bg-surface p-3 shadow-sm">
          <div className="flex flex-wrap items-center gap-2 text-xs">
            <button
              type="button"
              onClick={() => setFilter("all")}
              className={`rounded-lg px-2.5 py-1 font-semibold ${
                filter === "all" ? "bg-navy text-white" : "bg-background text-text-secondary"
              }`}
            >
              All threads
            </button>
            <button
              type="button"
              onClick={() => setFilter("unread")}
              className={`rounded-lg px-2.5 py-1 font-semibold ${
                filter === "unread" ? "bg-navy text-white" : "bg-background text-text-secondary"
              }`}
            >
              Unread ({unreadCount})
            </button>
          </div>
          {topLevel.length === 0 ? (
            <p className="mt-3 rounded-xl border border-dashed border-border px-4 py-6 text-center text-sm text-text-secondary">
              No unread messages.
            </p>
          ) : (
            <ul className="mt-3 space-y-2">
              {topLevel.map((r) => {
                const isIncoming = r.from_uid !== myUid;
                const active = selectedThread?.id === r.id;
                return (
                  <li key={r.id}>
                    <button
                      type="button"
                      onClick={() => {
                        setSelectedId(r.id);
                        setReplyTo(null);
                      }}
                      className={`w-full rounded-xl border px-3 py-2 text-left transition ${
                        active
                          ? "border-navy bg-navy text-white"
                          : "border-border bg-background hover:border-navy/30"
                      }`}
                    >
                      <span className="flex items-center justify-between gap-2">
                        <span className="truncate text-sm font-bold">
                          {r.subject || (isIncoming ? "Incoming message" : "Sent message")}
                        </span>
                        {isIncoming && !r.read_at && (
                          <span
                            className={`rounded px-1.5 py-0.5 text-[10px] font-bold uppercase ${
                              active ? "bg-white/15 text-white" : "bg-primary/15 text-primary-dark"
                            }`}
                          >
                            New
                          </span>
                        )}
                      </span>
                      <span
                        className={`mt-1 block truncate text-xs ${
                          active ? "text-white/70" : "text-text-muted"
                        }`}
                      >
                        {r.from_email || "CLIVORA"}
                        {r.created_at ? ` · ${formatTime(r.created_at)}` : ""}
                      </span>
                    </button>
                  </li>
                );
              })}
            </ul>
          )}
        </div>
      </aside>

      <section className="rounded-2xl border border-border bg-surface shadow-sm">
        {selectedThread ? (
          (() => {
            const replies = repliesFor(selectedThread.id);
            const isReplying = replyTo === selectedThread.id;
            const isIncoming = selectedThread.from_uid !== myUid;
            return (
              <div>
                <div className="border-b border-border px-4 py-3">
                  <div className="flex flex-wrap items-start justify-between gap-2">
                    <div className="min-w-0">
                      <div className="flex flex-wrap items-center gap-2">
                        {isIncoming && !selectedThread.read_at && (
                          <span className="rounded bg-primary/15 px-1.5 py-0.5 text-[10px] font-bold uppercase text-primary-dark">
                            New
                          </span>
                        )}
                        <span className="rounded bg-background px-1.5 py-0.5 text-[10px] font-bold uppercase text-text-muted">
                          {isIncoming ? "Incoming" : "Sent"}
                        </span>
                      </div>
                      <h2 className="mt-1 font-bold text-navy">
                        {selectedThread.subject || "Message thread"}
                      </h2>
                      <p className="text-xs text-text-muted">
                        {selectedThread.from_email || "CLIVORA"}
                        {selectedThread.created_at ? ` · ${formatTime(selectedThread.created_at)}` : ""}
                        {selectedThread.read_at ? ` · Read ${formatTime(selectedThread.read_at)}` : ""}
                      </p>
                    </div>
                    <div className="flex items-center gap-2">
                      {isIncoming && !selectedThread.read_at && (
                        <MarkReadButton
                          messageId={selectedThread.id}
                          readAt={selectedThread.read_at}
                        />
                      )}
                      <button
                        type="button"
                        onClick={() => setReplyTo(isReplying ? null : selectedThread.id)}
                        className="rounded-lg bg-navy/5 px-2.5 py-1 text-[11px] font-semibold text-navy"
                      >
                        {isReplying ? "Cancel" : "Reply"}
                      </button>
                    </div>
                  </div>
                </div>
                <div className="space-y-3 px-4 py-4">
                  <div className="rounded-xl bg-background px-4 py-3">
                    <p className="text-sm text-text-primary">{selectedThread.body || "(empty)"}</p>
                  </div>
                  {replies.length > 0 && (
                    <ul className="space-y-2 border-l-2 border-border pl-3">
                      {replies.map((rep) => {
                        const repIncoming = rep.from_uid !== myUid;
                        return (
                          <li key={rep.id} className="rounded-xl bg-background px-4 py-3">
                            <p className="text-sm text-text-primary">{rep.body || "(empty)"}</p>
                            <div className="mt-1 flex flex-wrap items-center gap-2">
                              <p className="text-xs text-text-muted">
                                {rep.from_email || "CLIVORA"}
                                {rep.created_at ? ` · ${formatTime(rep.created_at)}` : ""}
                              </p>
                              {repIncoming && !rep.read_at && (
                                <MarkReadButton messageId={rep.id} readAt={rep.read_at} />
                              )}
                            </div>
                          </li>
                        );
                      })}
                    </ul>
                  )}
                  {isReplying && (
                    <ComposeForm
                      fromEmail={fromEmail}
                      parentId={selectedThread.id}
                      parentSubject={selectedThread.subject ?? undefined}
                      compact
                      isClient={isClient}
                      onSent={() => setReplyTo(null)}
                    />
                  )}
                </div>
              </div>
            );
          })()
        ) : (
          <div className="p-8 text-center">
            <MessageSquare className="mx-auto h-8 w-8 text-text-muted" />
            <p className="mt-3 font-semibold text-navy">No thread selected</p>
            <p className="mt-2 text-sm text-text-secondary">
              Choose a thread or switch back to all messages.
            </p>
          </div>
        )}
      </section>
    </div>
  );
}
