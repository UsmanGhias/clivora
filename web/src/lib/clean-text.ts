/**
 * Ultra-robust HTML and MS Word rich-text cleaner for job descriptions,
 * markdown summaries, and portal content.
 *
 * Strips XML tags, Office conditional comments, raw data attributes,
 * JSON metadata artifacts, and normalizes bullet lists cleanly.
 */
export function cleanText(str?: string | null): string {
  if (!str) return "";

  let text = str;

  // 1. Remove XML/HTML comments & Office conditionals (mso)
  text = text.replace(/<!--[\s\S]*?-->/g, "");
  text = text.replace(/<!\[[\s\S]*?\]>/g, "");

  // 2. Remove script and style blocks
  text = text.replace(/<style[^>]*>[\s\S]*?<\/style>/gi, "");
  text = text.replace(/<script[^>]*>[\s\S]*?<\/script>/gi, "");

  // 3. Remove raw Office/Word list metadata blobs e.g. data-list-defn-props="{...}"
  text = text.replace(/data-[a-z0-9_-]+="\{[^}]*\}"/gi, "");
  text = text.replace(/data-[a-z0-9_-]+='\{[^']*\}'/gi, "");
  text = text.replace(/data-[a-z0-9_-]+="[^"]*"/gi, "");
  text = text.replace(/data-[a-z0-9_-]+='[^']*'/gi, "");
  text = text.replace(/\{"\d+":\s*\d+[^}]*\}/g, "");
  text = text.replace(/\{"33555[^}]*\}/g, "");

  // 4. Convert all <li> elements with any attributes to uniform bullet points
  text = text.replace(/<li(\s+[^>]*)?>/gi, "\n• ");
  text = text.replace(/<\/li>/gi, "\n");
  text = text.replace(/<br\s*[\/]?>/gi, "\n");
  text = text.replace(/<\/(p|div|h[1-6]|tr|table|ul|ol|section|article)>/gi, "\n\n");

  // 5. Strip any remaining standard or malformed HTML tags
  text = text.replace(/<[^>]+>/g, " ");

  // 6. Decode all HTML entities
  text = text
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/&#x27;/g, "'")
    .replace(/&#39;/g, "'")
    .replace(/&apos;/g, "'")
    .replace(/&#x2F;/gi, "/")
    .replace(/&#47;/g, "/")
    .replace(/&nbsp;/g, " ")
    .replace(/&bull;/g, "•")
    .replace(/&middot;/g, "·")
    .replace(/&#(\d+);/g, (_, code) => String.fromCharCode(parseInt(code, 10)))
    .replace(/&#x([a-f0-9]+);/gi, (_, code) => String.fromCharCode(parseInt(code, 16)));

  // 7. Re-run bullet and tag cleanup on any entities that decoded into markup
  text = text.replace(/<li(\s+[^>]*)?>/gi, "\n• ");
  text = text.replace(/<[^>]+>/g, " ");

  // 8. Clean leftover broken markup strings
  text = text.replace(/<li\b[^>]*$/gim, "\n• ");
  text = text.replace(/<\/?[a-z0-9_-]+(\s+[^>]*)?>/gi, " ");

  // 9. Standardize dashes and typography (no em dashes)
  text = text.replace(/[\u2014\u2013]/g, "-");
  text = text.replace(/[ \t]+/g, " ");
  text = text.replace(/\n[ \t]+/g, "\n");
  text = text.replace(/\n\s*\n\s*\n+/g, "\n\n");

  return text.trim();
}
