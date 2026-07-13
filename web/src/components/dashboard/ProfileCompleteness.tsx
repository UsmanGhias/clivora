import { Award } from "lucide-react";
import { cn } from "@/lib/utils";

export function ProfileCompleteness({
  percent,
  isClient,
  successScore,
}: {
  percent: number;
  isClient?: boolean;
  successScore?: number;
}) {
  const complete = percent >= 100;
  const r = 36;
  const c = 2 * Math.PI * r;
  const offset = c - (Math.min(100, percent) / 100) * c;
  const stroke = isClient ? "#475569" : "#0D9488";

  return (
    <div className="space-y-3">
      <div
        className={cn(
          "relative overflow-hidden rounded-2xl border bg-surface p-4 shadow-sm",
          isClient ? "border-client-accent/20" : "border-primary/20",
        )}
      >
        <div className="flex items-center gap-4">
          <div className="relative h-20 w-20 shrink-0">
            <svg className="h-20 w-20 -rotate-90" viewBox="0 0 88 88">
              <circle cx="44" cy="44" r={r} fill="none" stroke="#E2E8F0" strokeWidth="8" />
              <circle
                cx="44"
                cy="44"
                r={r}
                fill="none"
                stroke={stroke}
                strokeWidth="8"
                strokeLinecap="round"
                strokeDasharray={c}
                strokeDashoffset={offset}
              />
            </svg>
            <span className="absolute inset-0 flex items-center justify-center font-display text-sm font-extrabold text-navy">
              {percent}%
            </span>
          </div>
          <div className="min-w-0 flex-1">
            <p className="text-xs font-semibold uppercase tracking-wide text-text-muted">
              Profile completeness
            </p>
            <p className="mt-1 font-display text-lg font-bold text-navy">
              {complete ? "You're all set" : "Keep going"}
            </p>
            <p className="mt-1 text-xs text-text-secondary">
              {complete
                ? "Great job! Your profile is complete."
                : "Add skills and a headline on Connect to reach 100%."}
            </p>
          </div>
          <span
            className={cn(
              "hidden h-12 w-12 shrink-0 items-center justify-center rounded-2xl text-white shadow-lg sm:flex",
              isClient ? "bg-client-accent" : "bg-primary",
            )}
          >
            <Award className="h-6 w-6" />
          </span>
        </div>
      </div>
      {successScore != null && (
        <div className="rounded-2xl border border-border bg-surface p-4 shadow-sm">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-xs font-semibold uppercase tracking-wide text-text-muted">
                Success score
              </p>
              <p className="mt-1 font-display text-2xl font-extrabold text-navy">{successScore}%</p>
            </div>
            <span
              className={cn(
                "rounded-lg px-2.5 py-1 text-[10px] font-bold uppercase",
                isClient
                  ? "bg-client-surface text-client-accent"
                  : "bg-primary/10 text-primary-dark",
              )}
            >
              Top rated
            </span>
          </div>
        </div>
      )}
    </div>
  );
}
