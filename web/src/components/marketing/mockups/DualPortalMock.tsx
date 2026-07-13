import { ClientDashMock } from "./ClientDashMock";
import { FreelancerDashMock } from "./FreelancerDashMock";

/** Side-by-side freelancer + client portals (ALL-IN-ONE section center). */
export function DualPortalMock({ focus = "both" }: { focus?: "freelancer" | "client" | "both" }) {
  return (
    <div className="grid gap-3 lg:grid-cols-2">
      <div
        className={`transition duration-300 ${
          focus === "client" ? "opacity-55 saturate-[0.85] lg:scale-[0.98]" : ""
        }`}
      >
        <FreelancerDashMock compact />
      </div>
      <div
        className={`transition duration-300 ${
          focus === "freelancer" ? "opacity-55 saturate-[0.85] lg:scale-[0.98]" : ""
        }`}
      >
        <ClientDashMock compact />
      </div>
    </div>
  );
}
