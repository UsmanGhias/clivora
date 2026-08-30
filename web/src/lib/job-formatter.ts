import { cleanText } from "@/lib/clean-text";

export type StructuredJobSection = {
  title: string;
  paragraphs: string[];
  bullets: string[];
};

/**
 * Strips all HTML markup, normalizes whitespace, formats bullet points,
 * and strips em/en dashes for clean typography.
 */
export function formatJobDescription(raw?: string | null): string {
  if (!raw) return "";
  return cleanText(raw);
}

/**
 * Extracts a concise 1-2 sentence executive summary for cards and mobile feeds.
 */
export function getJobExecutiveSummary(raw?: string | null, maxLength = 180): string {
  const cleaned = formatJobDescription(raw);
  if (!cleaned) return "Explore this verified remote role on CLIVORA with $0 platform fees.";

  // Find the first non-empty paragraph that isn't a heading
  const lines = cleaned
    .split("\n")
    .map((l) => l.trim())
    .filter((l) => l.length > 0 && !l.startsWith("•"));

  let chosen = lines[0] || cleaned;
  if (chosen.length < 30 && lines.length > 1) {
    chosen = `${lines[0]} - ${lines[1]}`;
  }

  if (chosen.length <= maxLength) return chosen;

  // Trim to nearest word boundary
  const sub = chosen.slice(0, maxLength);
  const lastSpace = sub.lastIndexOf(" ");
  return `${sub.slice(0, lastSpace > 100 ? lastSpace : maxLength).trim()}...`;
}

const SECTION_PATTERNS: Array<{ regex: RegExp; title: string }> = [
  {
    regex: /^(about\s+(the\s+)?(role|job|position|company|us|team)|who\s+we\s+are|overview)/i,
    title: "About the Role & Company",
  },
  {
    regex: /^(what\s+you('ll|\swill)\s+do|responsibilities|key\s+responsibilities|your\s+role|duties|what\s+you\s+will\s+work\s+on)/i,
    title: "Key Responsibilities",
  },
  {
    regex: /^(what\s+we('re|\sare)\s+looking\s+for|requirements|qualifications|skills\s+(&|and)\s+experience|what\s+you\s+need|must\s+have|ideal\s+candidate)/i,
    title: "Requirements & Qualifications",
  },
  {
    regex: /^(nice\s+to\s+have|bonus\s+points|preferred\s+qualifications|good\s+to\s+have)/i,
    title: "Nice to Have",
  },
  {
    regex: /^(what\s+we\s+offer|benefits|perks|compensation|why\s+join\s+us|what's\s+in\s+it\s+for\s+you)/i,
    title: "Benefits & Perks",
  },
];

/**
 * Splits raw job text into structured, styled semantic sections for rich UI display.
 */
export function parseJobIntoSections(raw?: string | null): StructuredJobSection[] {
  const fullText = formatJobDescription(raw);
  if (!fullText) return [];

  const rawBlocks = fullText.split(/\n\n+/).map((b) => b.trim()).filter(Boolean);
  const sections: StructuredJobSection[] = [];
  let currentSection: StructuredJobSection = {
    title: "Role Overview",
    paragraphs: [],
    bullets: [],
  };

  for (const block of rawBlocks) {
    const lines = block.split("\n").map((l) => l.trim()).filter(Boolean);
    const firstLine = lines[0] || "";

    // Check if the block starts with a recognized section header
    let matchedTitle: string | null = null;
    for (const pattern of SECTION_PATTERNS) {
      if (pattern.regex.test(firstLine.replace(/[:#*_-]/g, "").trim())) {
        matchedTitle = pattern.title;
        break;
      }
    }

    if (matchedTitle) {
      // Push previous section if it has content
      if (currentSection.paragraphs.length > 0 || currentSection.bullets.length > 0) {
        sections.push(currentSection);
      }
      currentSection = {
        title: matchedTitle,
        paragraphs: [],
        bullets: [],
      };
      // Process remaining lines in this block (skipping the header line)
      const remaining = lines.slice(1);
      for (const line of remaining) {
        if (line.startsWith("•") || line.startsWith("-") || line.startsWith("*")) {
          currentSection.bullets.push(line.replace(/^[•\-*]\s*/, "").trim());
        } else {
          currentSection.paragraphs.push(line);
        }
      }
    } else {
      // Regular content block
      for (const line of lines) {
        if (line.startsWith("•") || line.startsWith("-") || line.startsWith("*")) {
          currentSection.bullets.push(line.replace(/^[•\-*]\s*/, "").trim());
        } else {
          currentSection.paragraphs.push(line);
        }
      }
    }
  }

  if (currentSection.paragraphs.length > 0 || currentSection.bullets.length > 0) {
    sections.push(currentSection);
  }

  // If no sections were built, fallback to a single block
  if (sections.length === 0) {
    sections.push({
      title: "Role Overview",
      paragraphs: [fullText],
      bullets: [],
    });
  }

  return sections;
}
