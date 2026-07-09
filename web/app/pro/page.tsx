import { Suspense } from "react";
import ProCheckout from "./pro-checkout";

export const metadata = {
  title: "CLIVORA Pro Plus — Subscribe",
  description: "Upgrade to CLIVORA Pro or Pro Plus. Pay from Pakistan or worldwide.",
};

export default function ProPage() {
  return (
    <Suspense fallback={<div style={{ padding: 40, textAlign: "center" }}>Loading checkout…</div>}>
      <ProCheckout />
    </Suspense>
  );
}
