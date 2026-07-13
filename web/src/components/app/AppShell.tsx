"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import {
  LayoutDashboard,
  FileText,
  FolderKanban,
  MessageSquare,
  Users,
  Settings,
  LogOut,
  Bell,
  Search,
  Sparkles,
  Network,
  Receipt,
  Clock,
  Star,
  UserCircle,
  Bookmark,
  Briefcase,
  Plus,
  Diamond,
} from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { cn } from "@/lib/utils";
import type { Profile } from "@/lib/profile-types";
import { isProPlus, planLabel } from "@/lib/plan";
import { Logo } from "@/components/ui/Logo";
import type { PortalNavCounts } from "@/lib/portal-nav";

type NavItem = {
  href: string;
  label: string;
  icon: React.ComponentType<{ className?: string }>;
  badge?: number;
  cta?: boolean;
};

function NavLink({
  item,
  active,
  isClient,
}: {
  item: NavItem;
  active: boolean;
  isClient: boolean;
}) {
  const Icon = item.icon;
  return (
    <Link
      href={item.href}
      className={cn(
        "group flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition",
        item.cta
          ? isClient
            ? "mt-2 bg-client-accent text-white hover:bg-client-header"
            : "mt-2 bg-primary text-white hover:bg-primary-dark"
          : active
            ? isClient
              ? "border-l-4 border-client-accent bg-white/10 text-white"
              : "border-l-4 border-primary bg-primary/20 text-white"
            : "text-white/70 hover:bg-white/5 hover:text-white",
      )}
    >
      <Icon className="h-4 w-4 shrink-0" />
      <span className="flex-1 truncate">{item.label}</span>
      {item.badge != null && item.badge > 0 && (
        <span
          className={cn(
            "rounded-full px-2 py-0.5 text-[10px] font-bold",
            isClient ? "bg-client-accent text-white" : "bg-primary text-white",
          )}
        >
          {item.badge}
        </span>
      )}
    </Link>
  );
}

export function AppShell({
  profile,
  isClient,
  counts,
  children,
}: {
  profile: Profile;
  isClient: boolean;
  counts?: PortalNavCounts;
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const router = useRouter();
  const plus = isProPlus(profile);
  const plan = planLabel(profile);

  const freelancerNav: NavItem[] = [
    { href: "/app", label: "Dashboard", icon: LayoutDashboard },
    { href: "/app/connect", label: "Find jobs (Connect)", icon: Network },
    { href: "/app/proposals", label: "Proposals", icon: FileText, badge: counts?.proposals },
    { href: "/app/projects", label: "Projects", icon: FolderKanban, badge: counts?.projects },
    { href: "/app/messages", label: "Messages", icon: MessageSquare, badge: counts?.messages },
    { href: "/app/invoices", label: "Earnings", icon: Receipt },
    { href: "/app/invoices", label: "Invoices", icon: FileText },
    { href: "/app/timesheets", label: "Time tracking", icon: Clock },
    { href: "/app/clients", label: "Clients", icon: Users },
    { href: "/app/hub", label: "Reviews", icon: Star },
    { href: "/app/account", label: "My profile", icon: UserCircle },
    { href: "/app/hub", label: "Bookmarks", icon: Bookmark },
    { href: "/app/hub", label: "Analytics", icon: Briefcase },
    { href: "/app/account", label: "Settings", icon: Settings },
  ];

  const clientNav: NavItem[] = [
    { href: "/app", label: "Dashboard", icon: LayoutDashboard },
    { href: "/connect/manage", label: "Post a job", icon: Plus },
    { href: "/app/connect", label: "Marketplace / Connect", icon: Network },
    { href: "/app/proposals", label: "Proposals", icon: FileText, badge: counts?.proposals },
    { href: "/app/projects", label: "Projects", icon: FolderKanban },
    { href: "/app/messages", label: "Messages", icon: MessageSquare, badge: counts?.messages },
    { href: "/app/invoices", label: "Payments", icon: Receipt },
    { href: "/app/invoices", label: "Invoices", icon: FileText },
    { href: "/app/hub", label: "My team", icon: Users },
    { href: "/app/hub", label: "Bookmarks", icon: Bookmark },
    { href: "/app/hub", label: "Reviews", icon: Star },
    { href: "/app/timesheets", label: "Time tracking", icon: Clock },
    { href: "/app/hub", label: "Reports", icon: Briefcase },
    { href: "/app/account", label: "Settings", icon: Settings },
  ];

  const nav = isClient ? clientNav : freelancerNav;

  const mobileNav = isClient
    ? [
        { href: "/app", label: "Home", icon: LayoutDashboard },
        { href: "/app/connect", label: "Connect", icon: Network },
        { href: "/app/proposals", label: "Proposals", icon: FileText },
        { href: "/app/messages", label: "Messages", icon: MessageSquare },
        { href: "/app/account", label: "Account", icon: UserCircle },
      ]
    : [
        { href: "/app", label: "Home", icon: LayoutDashboard },
        { href: "/app/proposals", label: "Proposals", icon: FileText },
        { href: "/app/projects", label: "Work", icon: FolderKanban },
        { href: "/app/connect", label: "Connect", icon: Network },
        { href: "/app/account", label: "Account", icon: UserCircle },
      ];

  async function signOut() {
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push("/login");
    router.refresh();
  }

  function isActive(href: string) {
    if (href === "/app") return pathname === "/app";
    return pathname === href || pathname.startsWith(`${href}/`);
  }

  const pageTitle =
    pathname === "/app"
      ? "Dashboard"
      : nav.find((n) => isActive(n.href))?.label ?? "App";

  return (
    <div
      className={cn(
        "flex min-h-screen bg-background text-text-primary",
        isClient && "theme-client",
      )}
    >
      <aside className="hidden w-64 shrink-0 flex-col bg-navy text-white lg:flex">
        <div className="border-b border-white/10 px-4 py-5">
          <Link href="/app" className="block">
            <Logo size="sm" variant="onDark" />
          </Link>
          <p
            className={cn(
              "mt-2 text-xs font-bold uppercase tracking-wider",
              isClient ? "text-client-muted" : "text-primary-light",
            )}
          >
            {isClient ? "Client portal" : "Freelancer portal"}
          </p>
        </div>

        <div className="border-b border-white/10 px-4 py-4">
          <p className="truncate font-semibold">{profile.name || profile.email}</p>
          {plus && (
            <span
              className={cn(
                "mt-1 inline-flex items-center gap-1 rounded-lg px-2 py-0.5 text-[10px] font-bold uppercase",
                isClient
                  ? "bg-white/15 text-white"
                  : "bg-primary/20 text-primary-light",
              )}
            >
              <Diamond className="h-3 w-3" />
              {plan}
            </span>
          )}
          {!plus && (
            <span className="mt-1 inline-block text-[10px] font-semibold uppercase tracking-wide text-white/50">
              Free plan
            </span>
          )}
        </div>

        <nav className="flex-1 space-y-0.5 overflow-y-auto px-3 py-4">
          {nav.map((item, i) => (
            <NavLink
              key={`${item.href}-${item.label}-${i}`}
              item={item}
              active={isActive(item.href) && !item.cta}
              isClient={isClient}
            />
          ))}
        </nav>

        <div className="border-t border-white/10 p-4">
          {isClient ? (
            <Link
              href="/connect/manage"
              className="mb-3 flex w-full items-center justify-center gap-2 rounded-xl bg-client-accent px-3 py-2.5 text-sm font-bold text-white hover:bg-client-header"
            >
              <Plus className="h-4 w-4" />
              Post a job
            </Link>
          ) : (
            <Link
              href="/app/connect"
              className="mb-3 flex w-full items-center justify-center gap-2 rounded-xl bg-primary px-3 py-2.5 text-sm font-bold text-white hover:bg-primary-dark"
            >
              <Briefcase className="h-4 w-4" />
              Find jobs (Connect)
            </Link>
          )}
          <div className="rounded-xl border border-white/10 bg-white/5 p-3">
            <p className="text-xs font-bold text-white/80">{plus ? `${plan} plan` : "Free plan"}</p>
            <p className="mt-1 text-[10px] text-white/50">Manage billing & credits</p>
            <Link
              href="/pro?plan=pro_plus"
              className={cn(
                "mt-2 block rounded-lg px-3 py-1.5 text-center text-xs font-semibold text-white",
                isClient ? "bg-client-accent" : "bg-primary",
              )}
            >
              Manage plan
            </Link>
          </div>
        </div>
      </aside>

      <div className="flex min-w-0 flex-1 flex-col">
        <header className="sticky top-0 z-30 border-b border-border bg-surface/95 backdrop-blur">
          <div className="flex items-center gap-3 px-4 py-3 sm:px-6">
            <div className="lg:hidden">
              <Logo size="sm" variant="onLight" showText={false} />
            </div>
            <p className="hidden font-display text-sm font-bold text-navy sm:block">{pageTitle}</p>
            <div className="relative mx-auto hidden max-w-md flex-1 sm:block">
              <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-text-muted" />
              <input
                readOnly
                placeholder={
                  isClient
                    ? "Search freelancers, projects, invoices..."
                    : "Search anything..."
                }
                className="w-full rounded-full border border-border bg-background py-2 pl-10 pr-16 text-sm text-text-secondary"
              />
              <span className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 rounded-md bg-surface px-1.5 py-0.5 text-[10px] font-bold text-text-muted">
                ⌘K
              </span>
            </div>
            <div className="ml-auto flex items-center gap-1">
              <Link
                href="/app/messages"
                className="rounded-full p-2 text-text-secondary hover:bg-background"
                aria-label="Messages"
              >
                <MessageSquare className="h-5 w-5" />
              </Link>
              <Link
                href="/app/notifications"
                className="relative rounded-full p-2 text-text-secondary hover:bg-background"
                aria-label="Notifications"
              >
                <Bell className="h-5 w-5" />
                {(counts?.notifications ?? 0) > 0 && (
                  <span className="absolute right-1 top-1 flex h-4 w-4 items-center justify-center rounded-full bg-error text-[9px] font-bold text-white">
                    {counts!.notifications}
                  </span>
                )}
              </Link>
              <Link
                href={plus ? "/pro" : "/pro?plan=pro_plus"}
                className={cn(
                  "hidden items-center gap-1 rounded-full px-3 py-1.5 text-xs font-semibold text-white sm:inline-flex",
                  isClient ? "bg-client-accent" : "bg-primary",
                )}
              >
                <Sparkles className="h-3.5 w-3.5" />
                {plus ? plan : "Upgrade"}
              </Link>
              <Link
                href="/app/account"
                className="flex h-9 w-9 items-center justify-center rounded-full bg-navy text-xs font-bold text-white"
              >
                {(profile.name || profile.email || "?").charAt(0).toUpperCase()}
              </Link>
              <button
                type="button"
                onClick={signOut}
                className="hidden rounded-full p-2 text-text-muted hover:bg-background lg:inline-flex"
                aria-label="Sign out"
              >
                <LogOut className="h-4 w-4" />
              </button>
            </div>
          </div>
        </header>

        <main className="flex-1 px-4 py-6 sm:px-6 lg:px-8">{children}</main>
      </div>

      <nav className="fixed inset-x-0 bottom-0 z-40 border-t border-white/10 bg-navy lg:hidden">
        <div className="mx-auto flex max-w-lg justify-around px-1 py-2">
          {mobileNav.map((item) => {
            const active = isActive(item.href);
            const Icon = item.icon;
            return (
              <Link
                key={item.href}
                href={item.href}
                className={cn(
                  "flex flex-col items-center gap-0.5 rounded-lg px-1.5 py-1 text-[10px] font-semibold",
                  active
                    ? isClient
                      ? "text-client-muted"
                      : "text-primary-light"
                    : "text-white/50",
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
