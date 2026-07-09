import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/clivora_colors.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';

/// Client tools hub — parity with freelancer Hub for collaboration surfaces.
class ClientHubScreen extends ConsumerWidget {
  const ClientHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlus = ref.watch(isProPlusProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClivoraScaffold(
      title: 'Client Hub',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
            builder: (context, t, child) => Opacity(
              opacity: t,
              child: Transform.translate(offset: Offset(0, 10 * (1 - t)), child: child),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ClivoraColors.navyDark,
                    const Color(0xFF0F766E).withValues(alpha: 0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your workspace',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Quotes, payments, contracts, and Connect — everything your freelancer shares with you.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Money', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          _HubGrid(
            isDark: isDark,
            tiles: [
              _HubTile(Icons.request_quote_outlined, 'Quotes', () => context.push('/client-quotes')),
              _HubTile(Icons.payments_outlined, 'Payments', () => context.push('/client-payments')),
              _HubTile(Icons.account_balance_wallet_outlined, 'Credits', () => context.push('/client-credits')),
              _HubTile(Icons.autorenew, 'Recurring', () => context.push('/client-recurring')),
              _HubTile(Icons.receipt_long_outlined, 'Invoices', () => context.go('/client-invoices')),
            ],
          ),
          const SizedBox(height: 20),
          Text('Work together', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          _HubGrid(
            isDark: isDark,
            tiles: [
              _HubTile(Icons.description_outlined, 'Contracts', () => context.push('/client-contracts')),
              _HubTile(Icons.add_task_outlined, 'Tasks', () => context.push('/client-tasks')),
              _HubTile(Icons.folder_open_outlined, 'Files', () => context.push('/client-files')),
              _HubTile(Icons.timeline_outlined, 'Updates', () => context.push('/client-activity')),
              _HubTile(Icons.person_add_alt_1_outlined, 'Link freelancer', () => context.push('/client-link-freelancer')),
              if (isPlus)
                _HubTile(Icons.hub_outlined, 'Connect', () => context.go('/connect'))
              else
                _HubTile(Icons.workspace_premium_outlined, 'Upgrade', () => context.push('/upgrade')),
            ],
          ),
        ],
      ),
    );
  }
}

class _HubTile {
  const _HubTile(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _HubGrid extends StatelessWidget {
  const _HubGrid({required this.tiles, required this.isDark});
  final List<_HubTile> tiles;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: [
        for (final t in tiles)
          Material(
            color: isDark ? ClivoraColors.navyDark.withValues(alpha: 0.55) : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: t.onTap,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? ClivoraColors.darkBorder : ClivoraColors.borderLight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(t.icon, color: ClivoraColors.clientAccent),
                    const SizedBox(height: 10),
                    Text(t.label, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
