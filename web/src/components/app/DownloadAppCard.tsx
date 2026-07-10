import Link from "next/link";
import { site } from "@/lib/site";

/** Shown when a feature is richer in the mobile app. */
export function DownloadAppCard({
  title = "Full power in the CLIVORA app",
  body = "This area is available on web for viewing. Create, edit, offline CRM, PDF branding, AI, vault, and push notifications work best in the Android app.",
}: {
  title?: string;
  body?: string;
}) {
  return (
    <div className="rounded-2xl border border-dashed border-primary/40 bg-primary/5 p-5">
      <p className="font-bold text-navy">{title}</p>
      <p className="mt-1 text-sm text-text-secondary">{body}</p>
      <div className="mt-3 flex flex-wrap gap-2">
        <a
          href={site.playStoreUrl}
          target="_blank"
          rel="noreferrer"
          className="rounded-full bg-navy px-4 py-2 text-sm font-semibold text-white"
        >
          Download Android app
        </a>
        <Link href="/app" className="rounded-full border border-navy/20 px-4 py-2 text-sm font-semibold text-navy">
          Back to web home
        </Link>
      </div>
    </div>
  );
}
