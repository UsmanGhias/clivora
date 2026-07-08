import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "CLIVORA — Your Business Operating System",
  description: "CRM for freelancers — clients, projects, invoices & revenue in one app.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
