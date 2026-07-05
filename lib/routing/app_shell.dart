import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/auth_service.dart';
import '../core/auth/user_roles.dart';
import '../core/theme/clivora_colors.dart';
import '../core/utils/exit_dialog.dart';
import '../data/providers/app_providers.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _freelancerTabs = [
    _NavItem('/dashboard', Icons.space_dashboard_outlined, Icons.space_dashboard, 'Home'),
    _NavItem('/customers', Icons.groups_outlined, Icons.groups, 'Clients'),
    _NavItem('/projects', Icons.view_kanban_outlined, Icons.view_kanban, 'Work'),
    _NavItem('/invoices', Icons.payments_outlined, Icons.payments, 'Billing'),
    _NavItem('/more', Icons.hub_outlined, Icons.hub, 'Hub'),
  ];

  static const _clientTabs = [
    _NavItem('/client-portal', Icons.home_outlined, Icons.home_rounded, 'Home'),
    _NavItem('/client-messages', Icons.mail_outline, Icons.mail_rounded, 'Messages'),
    _NavItem('/client-invoices', Icons.receipt_long_outlined, Icons.receipt_long, 'Invoices'),
    _NavItem('/client-activity', Icons.notifications_outlined, Icons.notifications_rounded, 'Updates'),
    _NavItem('/client-account', Icons.person_outline, Icons.person, 'Account'),
  ];

  int _indexFromLocation(String location, List<_NavItem> tabs) {
    for (var i = 0; i < tabs.length; i++) {
      if (location.startsWith(tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final isClient = isClientUser(user);
    final tabs = isClient ? _clientTabs : _freelancerTabs;
    final accent = isClient ? ClivoraColors.clientAccent : ClivoraColors.primary;
    final navBackground = isClient
        ? const Color(0xFF334155)
        : (Theme.of(context).brightness == Brightness.light
            ? ClivoraColors.navyDark
            : ClivoraColors.darkSurface);
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(location, tabs);
    final unreadAsync = ref.watch(unreadMessagesProvider);
    final unreadCount = unreadAsync.valueOrNull ?? 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await showExitDialog(context);
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isClient)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                color: ClivoraColors.clientSurface,
                child: Text(
                  unreadCount > 0
                      ? '$unreadCount new message${unreadCount == 1 ? '' : 's'} from your freelancer'
                      : 'Client portal — projects, invoices & messages',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: ClivoraColors.clientAccent, fontWeight: FontWeight.w600),
                ),
              ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              decoration: BoxDecoration(
                color: navBackground,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: navBackground.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (var i = 0; i < tabs.length; i++)
                        _BottomNavItem(
                          item: tabs[i],
                          selected: currentIndex == i,
                          accent: accent,
                          onTap: () => context.go(tabs[i].path),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.path, this.icon, this.activeIcon, this.label);

  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.item,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? accent : Colors.white54;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: selected ? 12 : 8, vertical: 6),
        decoration: selected
            ? BoxDecoration(
                color: accent.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? item.activeIcon : item.icon, color: color, size: 22),
            if (selected) ...[
              const SizedBox(height: 2),
              Text(
                item.label,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
