import { NextResponse } from "next/server";

export const runtime = "nodejs";
export const revalidate = 60; // Cache for 60 seconds

const SUPABASE_URL =
  process.env.SUPABASE_URL ??
  process.env.NEXT_PUBLIC_SUPABASE_URL ??
  "https://jtzjwgovqczlccyeujhq.supabase.co";

const SUPABASE_KEY =
  process.env.SUPABASE_SERVICE_ROLE_KEY ??
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ??
  "";

export async function GET() {
  let count = 1152;
  try {
    if (SUPABASE_KEY) {
      const res = await fetch(`${SUPABASE_URL}/rest/v1/connect_jobs?select=id`, {
        headers: {
          apikey: SUPABASE_KEY,
          Authorization: `Bearer ${SUPABASE_KEY}`,
          Range: "0-0",
          Prefer: "count=exact",
        },
        next: { revalidate: 60 },
      });
      const cr = res.headers.get("content-range");
      if (cr) {
        const match = cr.match(/\/(\d+)$/);
        if (match && Number(match[1]) > 0) {
          count = Number(match[1]);
        }
      }
    }
  } catch (e) {
    console.error("Failed to fetch live job count:", e);
  }

  const formattedJobs = `${count.toLocaleString()}+`;

  return NextResponse.json({
    ok: true,
    totalJobs: count,
    formattedJobs,
    platformFee: "$0",
    verifiedTalent: "500+",
    activeContracts: "350+",
  });
}
