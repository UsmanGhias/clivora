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
    <div
      className={
        isClient
          ? "grid gap-4 xl:grid-cols-[280px_minmax(0,1fr)_240px]"
          : "grid gap-4 lg:grid-cols-[minmax(0,0.9fr)_minmax(0,1.5fr)]"
      }
    >
      <aside className="space-y-4">
        {!isClient && <ComposeForm fromEmail={fromEmail} isClient={isClient} />}
        <div className="rounded-2xl border border-border bg-surface p-3 shadow-sm">
          <div className="mb-3 px-1">
            <p className="text-xs font-bold uppercase tracking-wide text-text-muted">Inbox</p>
          </div>
          <div className="relative mb-3">
            <input
              placeholder="Search messages..."
              className="w-full rounded-xl border border-border bg-background py-2 pl-3 pr-3 text-sm"
              readOnly
            />
          </div>
          <div className="flex flex-wrap items-center gap-2 text-xs">
            <button
              type="button"
              onClick={() => setFilter("all")}
              className={`rounded-lg px-2.5 py-1 font-semibold ${
                filter === "all"
                  ? isClient
                    ? "bg-client-accent text-white"
                    : "bg-navy text-white"
                  : "bg-background text-text-secondary"
              }`}
            >
              All {topLevel.length}
            </button>
            <button
              type="button"
              onClick={() => setFilter("unread")}
              className={`rounded-lg px-2.5 py-1 font-semibold ${
                filter === "unread"
                  ? isClient
                    ? "bg-client-accent text-white"
                    : "bg-navy text-white"
                  : "bg-background text-text-secondary"
              }`}
            >
              Unread {unreadCount}
            </button>
            {isClient && (
              <button
                type="button"
                className="rounded-lg bg-background px-2.5 py-1 font-semibold text-text-secondary"
              >
                Archived
              </button>
            )}
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
                      className={`w-full rounded-xl border px-3 py-2.5 text-left transition ${
                        active
                          ? isClient
                            ? "border-client-accent bg-client-surface"
                            : "border-navy bg-navy text-white"
                          : "border-border bg-background hover:border-navy/30"
                      }`}
                    >
                      <span className="flex items-center gap-2">
                        <span
                          className={`flex h-9 w-9 shrink-0 items-center justify-center rounded-full text-xs font-bold ${
                            active && !isClient
                              ? "bg-white/20 text-white"
                              : "bg-navy text-white"
                          }`}
                        >
                          {(r.from_email || "C").charAt(0).toUpperCase()}
                        </span>
                        <span className="min-w-0 flex-1">
                          <span className="flex items-center justify-between gap-2">
                            <span
                              className={`truncate text-sm font-bold ${
                                active && !isClient ? "text-white" : "text-navy"
                              }`}
                            >
                              {(r.from_email || "CLIVORA").split("@")[0]}
                            </span>
                            {isIncoming && !r.read_at && (
                              <span className="flex h-5 min-w-5 items-center justify-center rounded-full bg-sky-500 px-1 text-[10px] font-bold text-white">
                                1
                              </span>
                            )}
                          </span>
                          <span
                            className={`mt-0.5 block truncate text-xs ${
                              active && !isClient ? "text-white/70" : "text-text-muted"
                            }`}
                          >
                            {r.subject || "Conversation"}
                          </span>
                          <span
                            className={`mt-0.5 block truncate text-[11px] ${
                              active && !isClient ? "text-white/50" : "text-text-muted"
                            }`}
                          >
                            {(r.body || "").slice(0, 48)}
                            {r.created_at ? ` · ${formatTime(r.created_at)}` : ""}
                          </span>
                        </span>
                      </span>
                    </button>
                  </li>
                );
              })}
            </ul>
          )}
          {isClient && (
            <button
              type="button"
              className="mt-3 w-full rounded-xl border border-border py-2 text-xs font-semibold text-text-secondary"
            >
              View archived
            </button>
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
              <div className="flex h-full flex-col">
                <div className="border-b border-border px-4 py-3">
                  <div className="flex flex-wrap items-start justify-between gap-2">
                    <div className="min-w-0">
                      <h2 className="font-bold text-navy">
                        {(selectedThread.from_email || "CLIVORA").split("@")[0]}
                      </h2>
                      <p className="text-xs text-text-muted">
                        {selectedThread.subject || "Conversation"}
                        {selectedThread.created_at ? ` · ${formatTime(selectedThread.created_at)}` : ""}
                      </p>
                    </div>
                    <div className="flex items-center gap-2">
                      {isClient && (
                        <Link
                          href="/app/projects"
                          className="rounded-lg border border-border px-2.5 py-1 text-[11px] font-semibold text-navy"
                        >
                          View project
                        </Link>
                      )}
                      {isIncoming && !selectedThread.read_at && (
                        <MarkReadButton
                          messageId={selectedThread.id}
                          readAt={selectedThread.read_at}
                        />
                      )}
                      <button
                        type="button"
                        onClick={() => setReplyTo(isReplying ? null : selectedThread.id)}
                        className={`rounded-lg px-2.5 py-1 text-[11px] font-semibold ${
                          isClient ? "bg-client-surface text-client-accent" : "bg-navy/5 text-navy"
                        }`}
                      >
                        {isReplying ? "Cancel" : "Reply"}
                      </button>
                    </div>
                  </div>
                  {isClient && (
                    <div className="mt-3 rounded-xl border border-border bg-client-surface/50 px-3 py-2 text-xs">
                      <span className="font-semibold text-navy">
                        {selectedThread.subject || "Shared project"}
                      </span>
                      <span className="mx-2 text-text-muted">·</span>
                      <span className="text-text-secondary">Fixed Price</span>
                      <span className="mx-2 inline-flex items-center gap-1 font-semibold text-sky-700">
                        <span className="h-1.5 w-1.5 rounded-full bg-sky-500" />
                        In Progress
                      </span>
                    </div>
                  )}
                </div>
                <div className="flex-1 space-y-3 px-4 py-4">
                  <div
                    className={`max-w-[85%] rounded-2xl px-4 py-3 ${
                      isIncoming
                        ? "bg-slate-100 text-navy"
                        : isClient
                          ? "ml-auto bg-navy text-white"
                          : "ml-auto bg-primary text-white"
                    }`}
                  >
                    <p className="text-sm">{selectedThread.body || "(empty)"}</p>
                    <p
                      className={`mt-1 text-[10px] ${
                        isIncoming ? "text-text-muted" : "text-white/60"
                      }`}
                    >
                      {formatTime(selectedThread.created_at)}
                    </p>
                  </div>
                  {replies.map((rep) => {
                    const repIncoming = rep.from_uid !== myUid;
                    return (
                      <div
                        key={rep.id}
                        className={`max-w-[85%] rounded-2xl px-4 py-3 ${
                          repIncoming
                            ? "bg-slate-100 text-navy"
                            : isClient
                              ? "ml-auto bg-navy text-white"
                              : "ml-auto bg-primary text-white"
                        }`}
                      >
                        <p className="text-sm">{rep.body || "(empty)"}</p>
                        <div className="mt-1 flex flex-wrap items-center gap-2">
                          <p
                            className={`text-[10px] ${
                              repIncoming ? "text-text-muted" : "text-white/60"
                            }`}
                          >
                            {formatTime(rep.created_at)}
                          </p>
                          {repIncoming && !rep.read_at && (
                            <MarkReadButton messageId={rep.id} readAt={rep.read_at} />
                          )}
                        </div>
                      </div>
                    );
                  })}
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
                {isClient && !isReplying && (
                  <div className="border-t border-border p-3">
                    <ComposeForm
                      fromEmail={fromEmail}
                      parentId={selectedThread.id}
                      parentSubject={selectedThread.subject ?? undefined}
                      compact
                      isClient={isClient}
                      defaultTo={
                        selectedThread.from_uid === myUid
                          ? undefined
                          : selectedThread.from_email || undefined
                      }
                    />
                  </div>
                )}
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

      {isClient && (
        <aside className="hidden space-y-4 xl:block">
          <div className="rounded-2xl border border-border bg-surface p-4 shadow-sm">
            <p className="text-sm font-bold text-navy">New message</p>
            <ComposeForm fromEmail={fromEmail} isClient compact />
          </div>
          <div className="rounded-2xl border border-border bg-surface p-4 shadow-sm">
            <p className="mb-3 text-sm font-bold text-navy">Quick actions</p>
            <ul className="space-y-2 text-sm">
              <li>
                <Link href="/app/connect" className="font-semibold text-client-accent">
                  Invite freelancers →
                </Link>
              </li>
              <li>
                <Link href="/app/projects" className="font-semibold text-client-accent">
                  Share project →
                </Link>
              </li>
              <li>
                <Link href="/app/hub" className="font-semibold text-client-accent">
                  Create team chat →
                </Link>
              </li>
              <li>
                <Link href="/app/settings" className="font-semibold text-client-accent">
                  Message settings →
                </Link>
              </li>
            </ul>
          </div>
          <div className="rounded-2xl border border-border bg-surface p-4 shadow-sm">
            <p className="mb-3 text-sm font-bold text-navy">Recent contacts</p>
            <ul className="space-y-3">
              {topLevel.slice(0, 3).map((r) => (
                <li key={r.id} className="flex items-center gap-2">
                  <span className="flex h-8 w-8 items-center justify-center rounded-full bg-navy text-xs font-bold text-white">
                    {(r.from_email || "?").charAt(0).toUpperCase()}
                  </span>
                  <div className="min-w-0">
                    <p className="truncate text-sm font-semibold text-navy">
                      {(r.from_email || "Contact").split("@")[0]}
                    </p>
                    <p className="truncate text-[11px] text-text-muted">
                      {r.subject || "Freelancer"}
                    </p>
                  </div>
                </li>
              ))}
            </ul>
            <Link
              href="/app/clients"
              className="mt-3 inline-block text-xs font-semibold text-client-accent"
            >
              View all contacts →
            </Link>
          </div>
        </aside>
      )}
    </div>
  );
}
