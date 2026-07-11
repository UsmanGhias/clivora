"use client";

import Link from "next/link";
import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";
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
}: {
  fromEmail: string;
  defaultTo?: string;
  parentId?: string;
  parentSubject?: string;
  onSent?: () => void;
  compact?: boolean;
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
      className={`space-y-2 rounded-2xl border border-border bg-surface p-4 ${compact ? "p-3" : "p-4"}`}
    >
      {!compact && <p className="text-sm font-semibold text-navy">Send message</p>}
      {!parentId && (
        <input
          required
          type="email"
          placeholder="To email"
          value={toEmail}
          onChange={(e) => setToEmail(e.target.value)}
          className="w-full rounded-xl border border-border px-3 py-2 text-sm"
        />
      )}
      {!parentId && (
        <input
          placeholder="Subject"
          value={subject}
          onChange={(e) => setSubject(e.target.value)}
          className="w-full rounded-xl border border-border px-3 py-2 text-sm"
        />
      )}
      <textarea
        required
        rows={compact ? 2 : 3}
        placeholder={parentId ? "Reply…" : "Message"}
        value={body}
        onChange={(e) => setBody(e.target.value)}
        className="w-full rounded-xl border border-border px-3 py-2 text-sm"
      />
      {error && <p className="text-sm text-error">{error}</p>}
      {ok && (
        <p className="text-sm text-green-700">
          {parentId ? "Reply sent." : "Sent. Live chat & push work best in the app."}
        </p>
      )}
      <button
        type="submit"
        disabled={busy}
        className="rounded-full bg-navy px-4 py-2 text-sm font-semibold text-white disabled:opacity-50"
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
}: {
  rows: MessageRow[];
  fromEmail: string;
  myUid: string;
}) {
  const [replyTo, setReplyTo] = useState<string | null>(null);

  const topLevel = rows.filter((r) => !r.parent_message_id);
  const repliesFor = (parentId: string) =>
    rows.filter((r) => r.parent_message_id === parentId);

  if (rows.length === 0) {
    return (
      <div className="space-y-4">
        <ComposeForm fromEmail={fromEmail} />
        <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center">
          <p className="font-semibold">No messages yet</p>
          <p className="mt-2 text-sm text-text-secondary">
            Start a conversation from a shared project or Connect request.
          </p>
          <Link href="/connect" className="mt-4 inline-block text-sm font-semibold text-primary">
            Open Connect →
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <ComposeForm fromEmail={fromEmail} />
      <ul className="space-y-3">
        {topLevel.map((r) => {
          const replies = repliesFor(r.id);
          const isReplying = replyTo === r.id;
          const isIncoming = r.from_uid !== myUid;
          return (
            <li key={r.id} className="rounded-2xl border border-border bg-surface">
              <div className="px-4 py-3">
                <div className="flex flex-wrap items-start justify-between gap-2">
                  <div>
                    {r.subject && (
                      <p className="text-xs font-semibold text-text-secondary">{r.subject}</p>
                    )}
                    <p className="text-sm text-text-primary">{r.body || "(empty)"}</p>
                    <p className="mt-1 text-xs text-text-muted">
                      {r.from_email || "CLIVORA"}
                      {r.created_at ? ` · ${formatTime(r.created_at)}` : ""}
                      {r.read_at ? ` · Read ${formatTime(r.read_at)}` : ""}
                    </p>
                  </div>
                  <div className="flex items-center gap-2">
                    {isIncoming && !r.read_at && (
                      <MarkReadButton messageId={r.id} readAt={r.read_at} />
                    )}
                    <button
                      type="button"
                      onClick={() => setReplyTo(isReplying ? null : r.id)}
                      className="rounded px-2 py-0.5 text-[10px] font-semibold text-navy hover:underline"
                    >
                      {isReplying ? "Cancel" : "Reply"}
                    </button>
                  </div>
                </div>
              </div>

              {replies.length > 0 && (
                <ul className="ml-6 border-l-2 border-border">
                  {replies.map((rep) => {
                    const repIncoming = rep.from_uid !== myUid;
                    return (
                      <li key={rep.id} className="px-4 py-2">
                        <p className="text-sm text-text-primary">{rep.body || "(empty)"}</p>
                        <div className="mt-1 flex items-center gap-2">
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
                <div className="border-t border-border p-3">
                  <ComposeForm
                    fromEmail={fromEmail}
                    parentId={r.id}
                    parentSubject={r.subject ?? undefined}
                    compact
                    onSent={() => setReplyTo(null)}
                  />
                </div>
              )}
            </li>
          );
        })}
      </ul>
    </div>
  );
}
