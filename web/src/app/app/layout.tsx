import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { AppShell } from "@/components/app/AppShell";
import { getProfile, isClientAccount } from "@/lib/profile";

export const metadata: Metadata = {
  title: "App",
};

export default async function AppLayout({ children }: { children: React.ReactNode }) {
  const profile = await getProfile();
  if (!profile) redirect("/login");

  return (
    <AppShell profile={profile} isClient={isClientAccount(profile)}>
      {children}
    </AppShell>
  );
}
