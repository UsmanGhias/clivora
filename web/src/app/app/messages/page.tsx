import Link from "next/link";
import { site } from "@/lib/site";

export default function MessagesPage() {
  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-extrabold">Messages</h1>
      <div className="rounded-2xl border border-border bg-surface p-6">
        <p className="font-semibold">Realtime chat is optimized in the mobile app</p>
        <p className="mt-2 text-sm text-text-secondary">
          Your conversations sync via Supabase. Open the CLIVORA app for the full messaging experience,
          or use Connect requests on web to start new matches.
        </p>
        <div className="mt-4 flex flex-wrap gap-3">
          <Link href="/connect" className="rounded-full bg-navy px-4 py-2 text-sm font-semibold text-white">
            Open Connect
          </Link>
          <a
            href={site.playStoreUrl}
            target="_blank"
            rel="noreferrer"
            className="rounded-full border border-border px-4 py-2 text-sm font-semibold"
          >
            Get the app
          </a>
        </div>
      </div>
    </div>
  );
}
