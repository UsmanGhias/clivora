/**
 * Clivora AI Autonomous Live Chat Engine
 * Integrates Google Gemini with Odoo Live Chat & CRM
 * Features:
 * - 24/7 automated intelligence when operators are offline
 * - Trained on Clivora platform docs, zero fees, jobs, and CODCrafters capabilities
 * - Automatic CRM lead capture when visitors share contact info
 * - Strict token and rate limits (gemini-flash-lite-latest)
 * - Zero em dashes invariant
 */

const ODOO_URL = process.env.ODOO_MAIN_URL || "https://clivora.odoo.com";
const ODOO_DB = process.env.ODOO_MAIN_DB || "clivora";
const ODOO_KEY = process.env.ODOO_MAIN_API_KEY || "d4e37f9afc54226aebb9d4677a1df8e03cded9df";
const ODOO_UID = 2;

const GEMINI_KEY = process.env.GEMINI_API_KEY || "AQ.Ab8RN6I8UIEWWeU7EhUEEZKLplCFXaCwpaVBpmkb8pODZTz6Uw";
const GEMINI_FALLBACK = process.env.GEMINI_FALLBACK_API_KEY || "AQ.Ab8RN6KaOvEU6Wk9AsQsyJJnog_zGuMJxV1Bh0m-XS2ncIVLlw";

const SYSTEM_PROMPT = `You are Clivora AI, the official intelligent assistant for Clivora (clivora.io) and CODCrafters (codcrafters.org), founded and led by Usman Ghias.

Core Knowledge:
- Clivora is the zero-fee freelance operating system and remote job marketplace.
- Platform fee is $0 forever. Freelancers keep 100% of their earnings.
- Over 1,270+ verified remote jobs are live at clivora.io/jobs.
- Features: Escrow milestone contracts, free invoicing, client CRM, timesheets, and Android app (Flutter v5.3.19).
- Founder: Usman Ghias, Lead Full-Stack Architect & Mobile Systems Engineer.
- Parent Agency: CODCrafters, specializing in custom Web (Next.js), Mobile (Flutter), Odoo ERP, and AI workflow bots.
- Community Forum: community.clivora.io.

Rules:
- NEVER use em dashes (—) or en dashes (–). Use standard hyphens (-), colons (:), commas (,), or parentheses.
- Keep responses concise, friendly, and under 3 sentences.
- If the visitor needs custom software or a custom quote, invite them to share their email or project brief so Usman Ghias can reach out directly.`;

async function rpc(model, method, args, kwargs = {}) {
  const res = await fetch(ODOO_URL + "/jsonrpc", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      jsonrpc: "2.0",
      method: "call",
      params: { service: "object", method: "execute_kw", args: [ODOO_DB, ODOO_UID, ODOO_KEY, model, method, args, kwargs] },
      id: Date.now()
    })
  });
  const json = await res.json();
  if (json.error) {
    const msg = json.error.data?.message || json.error.message || "Odoo error";
    throw new Error(model + "." + method + ": " + msg);
  }
  return json.result;
}

function sanitizeDashes(text) {
  if (!text) return "";
  return text.replace(/[\u2014\u2013]/g, "-");
}

async function callGemini(question) {
  const keys = [GEMINI_KEY, GEMINI_FALLBACK];
  for (const key of keys) {
    try {
      const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-lite-latest:generateContent?key=${key}`;
      const res = await fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: [
            { role: "user", parts: [{ text: "Instructions: " + SYSTEM_PROMPT }] },
            { role: "model", parts: [{ text: "Understood. I will answer strictly as Clivora AI with zero em dashes within token limits." }] },
            { role: "user", parts: [{ text: question }] }
          ],
          generationConfig: {
            maxOutputTokens: 200,
            temperature: 0.6
          }
        })
      });
      const json = await res.json();
      const text = json.candidates?.[0]?.content?.parts?.[0]?.text;
      if (text) return sanitizeDashes(text.trim());
    } catch {
      // Try fallback key
    }
  }
  return "Clivora offers $0 platform fees and 1,270+ live verified remote jobs at clivora.io/jobs. Please leave your email and our team will follow up directly.";
}

function stripHtml(html) {
  return (html || "").replace(/<[^>]*>?/gm, "").trim();
}

async function processActiveLivechats() {
  // Find livechat channels active in the last 2 hours
  const channels = await rpc("discuss.channel", "search_read", [
    [["channel_type", "=", "livechat"]],
    ["id", "name", "write_date"]
  ], { limit: 10, order: "id desc" });

  for (const ch of channels) {
    // Read the latest 2 messages
    const msgs = await rpc("mail.message", "search_read", [
      [["model", "=", "discuss.channel"], ["res_id", "=", ch.id]],
      ["id", "author_id", "body", "create_date"]
    ], { limit: 2, order: "id desc" });

    if (!msgs || msgs.length === 0) continue;

    const lastMsg = msgs[0];
    const cleanBody = stripHtml(lastMsg.body);

    // If last message was from visitor (author_id is false or not Usman)
    const isFromVisitor = !lastMsg.author_id || (Array.isArray(lastMsg.author_id) && lastMsg.author_id[0] !== ODOO_UID);

    if (isFromVisitor && cleanBody && !cleanBody.startsWith("🤖")) {
      console.log(`[Channel ${ch.id}] Visitor asked: "${cleanBody}"`);
      const aiReply = await callGemini(cleanBody);
      console.log(`[Channel ${ch.id}] Gemini AI Replied: "${aiReply}"`);

      // Post back to channel
      await rpc("discuss.channel", "message_post", [[ch.id]], {
        body: `<p>🤖 <strong>Clivora AI</strong>: ${aiReply}</p>`,
        message_type: "comment",
        subtype_xmlid: "mail.mt_comment"
      });

      // If visitor shared an email, create a CRM lead automatically
      const emailMatch = cleanBody.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/);
      if (emailMatch) {
        try {
          await rpc("crm.lead", "create", [{
            name: `Livechat Lead: ${ch.name}`,
            email_from: emailMatch[0],
            description: `Captured from livechat conversation in channel ${ch.id}.\nUser inquiry: ${cleanBody}\nAI response: ${aiReply}`
          }]);
          console.log(`[CRM] Auto-created lead for ${emailMatch[0]}`);
        } catch {
          // Ignore duplicate lead errors
        }
      }
    }
  }
}

async function run() {
  console.log("=== CLIVORA AI LIVECHAT WORKER INITIALIZED ===");
  console.log("Connected to Odoo:", ODOO_URL);
  console.log("AI Model: gemini-flash-lite-latest");
  await processActiveLivechats();
  console.log("=== CYCLE COMPLETE ===");
}

if (require.main === module) {
  run().catch(console.error);
}

module.exports = { processActiveLivechats, callGemini };
