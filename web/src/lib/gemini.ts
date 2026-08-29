import "server-only";

import { createClient } from "@/lib/supabase/server";

const GEMINI_ENV_KEY = process.env.GEMINI_API_KEY?.trim();

/**
 * Remove em dashes and en dashes to enforce user preference across all outputs
 */
export function sanitizeDashes(text: string): string {
  if (!text) return "";
  return text.replace(/[\u2014\u2013]/g, "-");
}

/**
 * Resolves the active Gemini API key from environment variables or database secrets
 */
export async function getGeminiApiKey(): Promise<string | null> {
  if (GEMINI_ENV_KEY) return GEMINI_ENV_KEY;
  try {
    const supabase = await createClient();
    const { data } = await supabase.rpc("admin_get_integration_secret", {
      p_key: "GEMINI_API_KEY",
    });
    if (typeof data === "string" && data.trim()) {
      return data.trim();
    }
  } catch {
    // Fall back to null if database lookup is unavailable
  }
  return null;
}

export type GeminiGenerateOptions = {
  prompt: string;
  systemInstruction?: string;
  maxOutputTokens?: number;
  temperature?: number;
  model?: string;
};

/**
 * Lightweight caller for Google Gemini API with token limits for free tier safety
 */
export async function callGemini(options: GeminiGenerateOptions): Promise<string | null> {
  const apiKey = await getGeminiApiKey();
  if (!apiKey) return null;

  const model = options.model || "gemini-flash-lite-latest";
  const maxTokens = Math.min(options.maxOutputTokens || 400, 800);
  const temperature = options.temperature ?? 0.7;

  const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`;

  const contents: Array<{ role?: string; parts: Array<{ text: string }> }> = [];

  if (options.systemInstruction) {
    contents.push({
      role: "user",
      parts: [{ text: `Instructions: ${options.systemInstruction}` }],
    });
    contents.push({
      role: "model",
      parts: [{ text: "Understood. I will follow these instructions strictly with zero em dashes." }],
    });
  }

  contents.push({
    role: "user",
    parts: [{ text: options.prompt }],
  });

  const payload = {
    contents,
    generationConfig: {
      maxOutputTokens: maxTokens,
      temperature,
    },
  };

  try {
    const res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });

    if (!res.ok) {
      console.warn(`[callGemini] HTTP ${res.status} from model ${model}`);
      // If primary flash-lite failed, try flash-latest once
      if (model === "gemini-flash-lite-latest") {
        return callGemini({ ...options, model: "gemini-flash-latest" });
      }
      return null;
    }

    const data = (await res.json()) as {
      candidates?: Array<{
        content?: {
          parts?: Array<{ text?: string }>;
        };
      }>;
    };

    const rawText = data.candidates?.[0]?.content?.parts?.[0]?.text?.trim() || null;
    return rawText ? sanitizeDashes(rawText) : null;
  } catch (err) {
    console.error("[callGemini] Network error:", err);
    return null;
  }
}
