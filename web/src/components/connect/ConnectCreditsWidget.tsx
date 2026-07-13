"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Coins, Info } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { formatConnectCredits, type ConnectCreditSummary } from "@/lib/connect-credits";
import { cn } from "@/lib/utils";

export function ConnectCreditsWidget({
  signedIn,
  isClient,
}: {
  signedIn: boolean;
  isClient: boolean;
}) {
  const [summary, setSummary] = useState<ConnectCreditSummary | null>(null);

  useEffect(() => {
    if (!signedIn) return;
    let cancelled = false;
    (async () => {
      try {
        const supabase = createClient();
        const { data } = await supabase.rpc("connect_credit_summary");
        if (!cancelled && Array.isArray(data) && data[0]) {
          setSummary(data[0] as ConnectCreditSummary);
        }
      } catch {
        /* ignore */
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [signedIn]);

  const renewLabel = summary?.period_end
    ? new Date(summary.period_end).toLocaleDateString(undefined, {
        month: "short",
        day: "numeric",
        year: "numeric",
      })
    : null;

  return (
    <div className="rounded-2xl border border-border bg-surface p-5 shadow-sm">
      <div className="flex items-center gap-2">
        <Coins className={cn("h-5 w-5", isClient ? "text-client-accent" : "text-primary")} />
        <h3 className="font-display font-bold text-navy">Connect credits</h3>
        <Info className="ml-auto h-4 w-4 text-text-muted" />
      </div>
      <p
        className={cn(
          "mt-3 font-display text-2xl font-extrabold",
          summary?.legacy_unlimited ? "text-success" : isClient ? "text-client-accent" : "text-primary",
        )}
      >
        {signedIn
          ? summary?.legacy_unlimited
            ? "Unlimited"
            : formatConnectCredits(summary)
          : "Sign in"}
      </p>
      {renewLabel && (
        <p className="mt-1 text-xs text-text-secondary">Renews on {renewLabel}</p>
      )}
      <Link
        href="/pro?plan=pro_plus"
        className={cn(
          "mt-4 inline-flex w-full items-center justify-center rounded-xl px-4 py-2.5 text-sm font-semibold text-white",
          isClient ? "bg-client-accent hover:bg-client-header" : "bg-primary hover:bg-primary-dark",
        )}
      >
        Manage plan
      </Link>
    </div>
  );
}
