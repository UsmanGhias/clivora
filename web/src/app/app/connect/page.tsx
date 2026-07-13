import {
  listMyConnectRequests,
  listPublicConnectNeeds,
  listPublicConnectProfiles,
} from "@/lib/connect";
import { getProfile, isClientAccount, isProPlus, isRestricted } from "@/lib/profile";
import { ConnectBoard } from "@/components/connect/ConnectBoard";
import { ConnectCreditsWidget } from "@/components/connect/ConnectCreditsWidget";
import { redirect } from "next/navigation";

export const metadata = { title: "Marketplace / Connect" };

export default async function AppConnectPage() {
  const profile = await getProfile();
  if (!profile) redirect("/login");
  const client = isClientAccount(profile);
  const [profiles, needs, requests] = await Promise.all([
    listPublicConnectProfiles(),
    listPublicConnectNeeds(),
    listMyConnectRequests(),
  ]);

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
        <div>
          <h1 className="font-display text-2xl font-extrabold text-navy sm:text-3xl">
            {client ? "Marketplace / Connect" : "Find jobs"}
          </h1>
          <p className="mt-1 text-sm text-text-secondary">
            {client
              ? "Find and connect with top freelance talent ✨"
              : "Browse open jobs and submit proposals with Connect credits."}
          </p>
        </div>
      </div>

      <div className="grid gap-6 xl:grid-cols-[1fr_280px]">
        <ConnectBoard
          profiles={profiles}
          needs={needs}
          requests={requests}
          signedIn
          isProPlus={isProPlus(profile)}
          isClient={client}
          isRestricted={isRestricted(profile)}
          myUserId={profile.id}
          portalMode
          accent={client ? "slate" : "teal"}
          defaultTab={client ? "talent" : "jobs"}
        />
        <div className="hidden xl:block">
          <div className="sticky top-24 space-y-4">
            <ConnectCreditsWidget signedIn isClient={client} />
          </div>
        </div>
      </div>
    </div>
  );
}
