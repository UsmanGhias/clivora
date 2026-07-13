import { CheckCircle2 } from "lucide-react";
import { cn } from "@/lib/utils";

export function ProfileCompleteness({
  percent,
  isClient,
}: {
  percent: number;
  isClient?: boolean;
}) {
  const complete = percent >= 100;
  return (
    <div
      className={cn(
        "rounded-2xl border bg-surface p-4 shadow-sm",
        isClient ? "border-client-accent/20" : "border-primary/20",
      )}
    >
      <div className="flex items-center justify-between gap-3">
        <div>
          <p className="text-xs font-semibold uppercase tracking-wide text-text-muted">
            Profile completeness
          </p>
          <p className="mt-1 font-display text-2xl font-extrabold text-navy">{percent}%</p>
        </div>
        <span
          className={cn(
            "flex h-10 w-10 items-center justify-center rounded-full",
            complete ? "bg-success/15 text-success" : isClient ? "bg-client-surface text-client-accent" : "bg-primary/10 text-primary",
          )}
        >
          <CheckCircle2 className="h-5 w-5" />
        </span>
      </div>
      <p className="mt-2 text-xs text-text-secondary">
        {complete
          ? "Great job! You're all set."
          : "Add skills and a headline on Connect to reach 100%."}
      </p>
    </div>
  );
}
