import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { AdminMfaGate } from "@/components/admin/AdminMfaGate";
import { requireAdmin } from "@/lib/admin-auth";

export const dynamic = "force-dynamic";

export const metadata: Metadata = {
  title: "CLIVORA Admin",
  robots: { index: false, follow: false },
};

export default async function AdminLayout({ children }: { children: React.ReactNode }) {
  try {
    await requireAdmin();
  } catch {
    redirect("/login?next=/admin");
  }

  return (
    <div className="min-h-screen bg-white text-slate-900 antialiased [&_input]:text-slate-900 [&_input]:placeholder:text-slate-400">
      <AdminMfaGate>{children}</AdminMfaGate>
    </div>
  );
}
