import type { Metadata } from "next";
import Link from "next/link";
import { Logo } from "@/components/ui/Logo";

export const metadata: Metadata = {
  title: "Account",
};

export default function AuthLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen bg-background">
      <div className="absolute inset-0 bg-brand-gradient opacity-[0.08]" />
      <div className="relative mx-auto flex min-h-screen max-w-md flex-col justify-center px-6 py-12">
        <Link href="/" className="mb-8 flex justify-center">
          <div className="rounded-2xl bg-navy px-4 py-3">
            <Logo size="sm" />
          </div>
        </Link>
        {children}
      </div>
    </div>
  );
}
