"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import {
  Home,
  Users,
  FileText,
  Network,
  LogOut,
  Sparkles,
  MessageSquare,
  UserCircle,
  LayoutDashboard,
  FolderKanban,
  Bell,
  CheckSquare,
} from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { cn } from "@/lib/utils";
import type { Profile } from "@/lib/profile";

type NavItem = { href: string; label: string; icon: React.ComponentType<{ className?: string }> };

export function AppShell({
  profile,
  isClient,
  children,
}: {
  profile: Profile;
  isClient: boolean;
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const router = useRouter();

  const freelancerNav: NavItem[] = [
    { href: "/app", label: "Home", icon: Home },
    { href: "/app/clients", label: "Clients", icon: Users },
    { href: "/app/projects", label: "Work", icon: FolderKanban },
    { href: "/app/invoices", label: "Billing", icon: FileText },
    { href: "/connect", label: "Connect", icon: Network },
    { href: "/app/hub", label: "Hub", icon: LayoutDashboard },
  ];

  const clientNav: NavItem[] = [
    { href: "/app", label: "Home", icon: Home },
    { href: "/app/messages", label: "Messages", icon: MessageSquare },
    { href: "/app/tasks", label: "Tasks", icon: CheckSquare },
    { href: "/app/invoices", label: "Invoices", icon: FileText },
    { href: "/connect", label: "Connect", icon: Network },
    { href: "/app/account", label: "Account", icon: UserCircle },
  ];

  const nav = isClient ? clientNav : freelancerNav;
  const mobileNav = isClient
    ? clientNav.filter((n) => !["/app/tasks"].includes(n.href)).slice(0, 5)
    : [
        freelancerNav[0],
        freelancerNav[1],
        freelancerNav[2],
        freelancerNav[3],
        freelancerNav[5],
      ];

  async function signOut() {
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push("/login");
    router.refresh();
  }

  return (
    <div className="min-h-screen bg-background text-text-primary">
      <header className="border-b border-border bg-navy text-white">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-4 py-3">
          <Link href="/app" className="flex items-center gap-2 font-extrabold tracking-wide">
            <span className="rounded-lg bg-primary/20 px-2 py-1 text-primary-light">CLIVORA</span>
            <span className="hidden text-sm font-medium text-white/70 sm:inline">Web</span>
          </Link>
          <div className="flex items-center gap-2 text-sm sm:gap-3">
            <Link
              href="/app/notifications"
              className="rounded-full p-2 text-white/80 hover:bg-white/10"
              aria-label="Notifications"
            >
              <Bell className="h-4 w-4" />
            </Link>
            <span className="hidden max-w-[140px] truncate text-white/70 sm:inline">
              {profile.name || profile.email}
            </span>
            <span className="rounded-full bg-white/10 px-2.5 py-1 text-xs font-semibold">
              {isClient ? "Client" : "Freelancer"}
            </span>
            <Link
              href="/pro"
              className="inline-flex items-center gap-1 rounded-full bg-primary px-3 py-1.5 text-xs font-semibold text-white"
            >
              <Sparkles className="h-3.5 w-3.5" /> Upgrade
            </Link>
            <button
              type="button"
              onClick={signOut}
              className="rounded-full p-2 text-white/80 hover:bg-white/10"
              aria-label="Sign out"
            >
              <LogOut className="h-4 w-4" />
            </button>
          </div>
        </div>
      </header>

      <div className="mx-auto flex max-w-6xl gap-6 px-4 py-6">
        <aside className="hidden w-52 shrink-0 lg:block">
          <nav className="sticky top-6 space-y-1">
            {nav.map((item) => {
              const active =
                item.href === "/app"
                  ? pathname === "/app"
                  : pathname === item.href || pathname.startsWith(`${item.href}/`);
              const Icon = item.icon;
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={cn(
                    "flex items-center gap-2 rounded-xl px-3 py-2.5 text-sm font-medium transition",
                    active
                      ? "bg-navy text-white"
                      : "text-text-secondary hover:bg-white hover:text-text-primary"
                  )}
                >
                  <Icon className="h-4 w-4" />
                  {item.label}
                </Link>
              );
            })}
          </nav>
        </aside>

        <main className="min-w-0 flex-1 pb-24">{children}</main>
      </div>

      <nav className="fixed inset-x-0 bottom-0 z-40 border-t border-border bg-navy lg:hidden">
        <div className="mx-auto flex max-w-lg justify-around px-1 py-2">
          {mobileNav.map((item) => {
            const active =
              item.href === "/app"
                ? pathname === "/app"
                : pathname === item.href || pathname.startsWith(`${item.href}/`);
            const Icon = item.icon;
            return (
              <Link
                key={item.href}
                href={item.href}
                className={cn(
                  "flex flex-col items-center gap-0.5 rounded-lg px-1.5 py-1 text-[10px] font-semibold",
                  active ? "text-primary" : "text-white/60"
                )}
              >
                <Icon className="h-5 w-5" />
                {item.label}
              </Link>
            );
          })}
        </div>
      </nav>
    </div>
  );
}
