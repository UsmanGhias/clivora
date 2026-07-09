import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "CLIVORA Admin",
  robots: { index: false, follow: false },
};

export default function AdminLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen bg-white text-slate-900 antialiased [&_input]:text-slate-900 [&_input]:placeholder:text-slate-400">
      {children}
    </div>
  );
}
