import { cn } from "@/lib/utils";

const DISCLAIMER =
  "CLIVORA does not currently process client-to-freelancer payments. Invoice totals and payment status are records you keep on the platform; settle funds directly with your counterpart for now.";

export function PaymentDisclaimer({ className }: { className?: string }) {
  return (
    <aside
      role="note"
      className={cn(
        "rounded-xl border border-amber-200/90 bg-amber-50 px-4 py-3 text-sm leading-relaxed text-amber-950",
        className,
      )}
    >
      {DISCLAIMER}
    </aside>
  );
}
