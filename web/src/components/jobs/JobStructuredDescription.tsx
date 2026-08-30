import React from "react";
import { parseJobIntoSections, type StructuredJobSection } from "@/lib/job-formatter";
import {
  Briefcase,
  CheckCircle2,
  Gift,
  HelpCircle,
  Sparkles,
  Target,
  UserCheck,
} from "lucide-react";

function getSectionIcon(title: string) {
  const lower = title.toLowerCase();
  if (lower.includes("responsibilit") || lower.includes("do")) {
    return <Target className="h-5 w-5 text-teal-600" />;
  }
  if (lower.includes("requirement") || lower.includes("qualification") || lower.includes("looking for")) {
    return <UserCheck className="h-5 w-5 text-teal-600" />;
  }
  if (lower.includes("benefit") || lower.includes("perk") || lower.includes("offer")) {
    return <Gift className="h-5 w-5 text-emerald-600" />;
  }
  if (lower.includes("nice") || lower.includes("bonus")) {
    return <Sparkles className="h-5 w-5 text-amber-500" />;
  }
  if (lower.includes("about") || lower.includes("overview")) {
    return <Briefcase className="h-5 w-5 text-teal-700" />;
  }
  return <CheckCircle2 className="h-5 w-5 text-teal-600" />;
}

export function JobStructuredDescription({ rawDescription }: { rawDescription?: string | null }) {
  const sections: StructuredJobSection[] = parseJobIntoSections(rawDescription);

  if (sections.length === 0) {
    return (
      <div className="rounded-2xl border border-slate-200/80 bg-slate-50/50 p-6 text-center text-sm text-slate-500">
        No detailed overview provided for this role.
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {sections.map((section, idx) => (
        <div
          key={idx}
          className="rounded-2xl border border-slate-200/90 bg-white p-6 shadow-xs transition-all hover:border-slate-300"
        >
          <div className="flex items-center gap-2.5 border-b border-slate-100 pb-3.5">
            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-teal-50">
              {getSectionIcon(section.title)}
            </div>
            <h3 className="text-base font-bold text-slate-900">{section.title}</h3>
          </div>

          <div className="mt-4 space-y-3">
            {section.paragraphs.map((p, pIdx) => (
              <p key={pIdx} className="text-sm leading-relaxed text-slate-700">
                {p}
              </p>
            ))}

            {section.bullets.length > 0 && (
              <ul className="mt-3 space-y-2.5 pl-1">
                {section.bullets.map((b, bIdx) => (
                  <li key={bIdx} className="flex items-start gap-2.5 text-sm leading-relaxed text-slate-700">
                    <span className="mt-1.5 h-1.5 w-1.5 shrink-0 rounded-full bg-teal-600" />
                    <span>{b}</span>
                  </li>
                ))}
              </ul>
            )}
          </div>
        </div>
      ))}
    </div>
  );
}
