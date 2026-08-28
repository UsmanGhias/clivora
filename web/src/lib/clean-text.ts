export function cleanText(str?: string | null): string {
  if (!str) return "";
  return str
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/&#x27;/g, "'")
    .replace(/&#39;/g, "'")
    .replace(/&#x2F;/gi, "/")
    .replace(/&#47;/g, "/")
    .replace(/&nbsp;/g, " ")
    .replace(/&#(\d+);/g, (_, code) => String.fromCharCode(parseInt(code, 10)))
    .replace(/&#x([a-f0-9]+);/gi, (_, code) => String.fromCharCode(parseInt(code, 16)))
    .trim();
}
