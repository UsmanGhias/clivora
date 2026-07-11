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
  Activity,
} from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { cn } from "@/lib/utils";
import type { Profile } from "@/lib/profile-types";
import { isProPlus } from "@/lib/plan";
import { Logo } from "@/components/ui/Logo";
import { Breadcrumbs, type Crumb } from "@/components/app/Breadcrumbs";
import { SmartAppCtaButton } from "@/components/app/SmartAppCta";

type NavItem = { href: string; label: string; icon: React.ComponentType<{ className?: string }>; plusOnly?: boolean };

function crumbsForPath(pathname: string, isClient: boolean): Crumb[] {
  const base: Crumb[] = [{ label: "App", href: "/app" }];
  const map: Record<string, string> = {
    "/app": isClient ? "Home" : "Home",
    "/app/clients": "Clients",
    "/app/projects": "Work",
    "/app/invoices": isClient ? "Invoices" : "Billing",
    "/app/messages": "Messages",
    "/app/tasks": "Tasks",
    "/app/activity": "Updates",
    "/app/hub": "Hub",
    "/app/account": "Account",
    "/app/notifications": "Notifications",
    "/app/timesheets": "Timesheets",
    "/app/meetings": "Meetings",
    "/app/support": "Support",
  };
  if (pathname === "/app") return [{ label: "App" }, { label: "Home" }];
  const label = map[pathname] || pathname.split("/").pop() || "Page";
  return [...base, { label }];
}

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
  const plus = isProPlus(profile);

  const freelancerNav: NavItem[] = [
    { href: "/app", label: "Home", icon: Home },
    { href: "/app/clients", label: "Clients", icon: Users },
    { href: "/app/projects", label: "Work", icon: FolderKanban },
    { href: "/app/invoices", label: "Billing", icon: FileText },
    { href: "/connect", label: "Connect", icon: Network, plusOnly: false },
    { href: "/app/hub", label: "Hub", icon: LayoutDashboard },
  ];

  // Mirror Flutter client shell: Home, Messages, Invoices, Updates, Account (+ Connect)
  const clientNav: NavItem[] = [
    { href: "/app", label: "Home", icon: Home },
    { href: "/app/messages", label: "Messages", icon: MessageSquare },
    { href: "/app/invoices", label: "Invoices", icon: FileText },
    { href: "/app/activity", label: "Updates", icon: Activity },
    { href: "/connect", label: "Connect", icon: Network },
    { href: "/app/account", label: "Account", icon: UserCircle },
  ];

  const nav = (isClient ? clientNav : freelancerNav).map((item) =>
    item.href === "/connect" && !plus
      ? { ...item, label: "Connect" }
      : item,
  );

  // Mobile: 5 tabs — include Connect for both roles (matches Plus mobile; Free still browses)
  const mobileNav = isClient
    ? [
        clientNav[0],
        clientNav[1],
        clientNav[2],
        clientNav[4],
        clientNav[5],
      ]
    : [
        freelancerNav[0],
        freelancerNav[1],
        freelancerNav[2],
        freelancerNav[3],
        freelancerNav[4],
      ];

  async function signOut() {
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push("/login");
    router.refresh();
  }

  const headerBg = isClient ? "bg-client-header" : "bg-navy";
  const activeAside = isClient ? "bg-client-accent text-white" : "bg-navy text-white";
  const activeMobile = isClient ? "text-client-muted" : "text-primary";

  return (
    <div
      className={cn(
        "min-h-screen bg-background text-text-primary",
        isClient && "theme-client",
      )}
    >
      <header className={cn("border-b border-white/10 text-white", headerBg)}>
        <div className="mx-auto flex max-w-6xl items-center justify-between gap-3 px-4 py-3">
          <Link href="/app" className="flex items-center gap-2" aria-label="CLIVORA App">
            <Logo size="sm" variant="onDark" />
            <span className="hidden rounded-md bg-white/10 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-white/80 sm:inline">
              Web
            </span>
          </Link>
          <div className="flex items-center gap-1.5 text-sm sm:gap-2">
            <SmartAppCtaButton size="sm" />
            <Link
              href="/app/notifications"
              className="rounded-full p-2 text-white/80 hover:bg-white/10"
              aria-label="Notifications"
            >
              <Bell className="h-4 w-4" />
            </Link>
            <span className="hidden max-w-[120px] truncate text-white/70 sm:inline">
              {profile.name || profile.email}
            </span>
            <span
              className={cn(
                "rounded-full px-2.5 py-1 text-xs font-semibold",
                isClient ? "bg-white/15 text-white" : "bg-primary/30 text-primary-light",
              )}
            >
              {isClient ? "Client" : "Freelancer"}
            </span>
            <Link
              href={plus ? "/connect" : "/pro?plan=pro_plus"}
              className={cn(
                "inline-flex items-center gap-1 rounded-full px-3 py-1.5 text-xs font-semibold text-white",
                isClient ? "bg-client-accent" : "bg-primary",
              )}
            >
              <Sparkles className="h-3.5 w-3.5" /> {plus ? "Pro Plus" : "Upgrade"}
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

      <div className="mx-auto max-w-6xl px-4 pt-4">
        <Breadcrumbs items={crumbsForPath(pathname, isClient)} />
      </div>

      <div className="mx-auto flex max-w-6xl gap-6 px-4 py-4">
        <aside className="hidden w-52 shrink-0 lg:block">
          <nav className="sticky top-6 space-y-1">
            {nav.map((item) => {
              const active =
                item.href === "/app"
                  ? pathname === "/app"
                  : pathname === item.href || pathname.startsWith(`${item.href}/`);
              const Icon = item.icon;
              const connectLocked = item.href === "/connect" && !plus;
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={cn(
                    "flex items-center gap-2 rounded-xl px-3 py-2.5 text-sm font-medium transition",
                    active
                      ? activeAside
                      : "text-text-secondary hover:bg-white hover:text-text-primary",
                  )}
                >
                  <Icon className="h-4 w-4" />
                  <span className="flex-1">{item.label}</span>
                  {connectLocked && (
                    <span className="rounded bg-amber-100 px-1.5 py-0.5 text-[9px] font-bold uppercase text-amber-800">
                      Plus
                    </span>
                  )}
                </Link>
              );
            })}
          </nav>
        </aside>

        <main className="min-w-0 flex-1 pb-24">{children}</main>
      </div>

      <nav
        className={cn(
          "fixed inset-x-0 bottom-0 z-40 border-t border-white/10 lg:hidden",
          headerBg,
        )}
      >
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
                  active ? activeMobile : "text-white/60",
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
