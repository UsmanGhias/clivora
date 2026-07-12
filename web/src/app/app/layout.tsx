import { redirect } from "next/navigation";
import { AppShell } from "@/components/app/AppShell";
import { getProfile, isBlocked, isClientAccount } from "@/lib/profile";

export const metadata = {
  title: "App",
};

export default async function AppLayout({ children }: { children: React.ReactNode }) {
  const profile = await getProfile();
  if (!profile) redirect("/login");
  if (isBlocked(profile)) redirect("/blocked");

  return (
    <AppShell profile={profile} isClient={isClientAccount(profile)}>
      {children}
    </AppShell>
  );
}
