import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/clivora_colors.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';
import '../../shared/widgets/tool_grid_tile.dart';

/// Client tools hub — parity with freelancer Hub for collaboration surfaces.
class ClientHubScreen extends ConsumerWidget {
  const ClientHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlus = ref.watch(isProPlusProvider);

    return ClivoraScaffold(
      title: 'Client Hub',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 32),
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
            builder: (context, t, child) => Opacity(
              opacity: t,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - t)),
                child: child,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
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
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Money',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 12),
          _ClientHubGrid(
            children: [
              ToolGridTile(
                icon: Icons.request_quote_outlined,
                label: 'Quotes',
                iconBackground: ClivoraColors.iconTeal,
                iconColor: ClivoraColors.clientAccent,
                onTap: () => context.push('/client-quotes'),
              ),
              ToolGridTile(
                icon: Icons.payments_outlined,
                label: 'Payments',
                iconBackground: ClivoraColors.iconGreen,
                iconColor: ClivoraColors.successGreen,
                onTap: () => context.push('/client-payments'),
              ),
              ToolGridTile(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Credits',
                iconBackground: ClivoraColors.iconYellow,
                iconColor: ClivoraColors.accent,
                onTap: () => context.push('/client-credits'),
              ),
              ToolGridTile(
                icon: Icons.autorenew,
                label: 'Recurring',
                iconBackground: ClivoraColors.iconPurple,
                iconColor: ClivoraColors.primaryPurple,
                onTap: () => context.push('/client-recurring'),
              ),
              ToolGridTile(
                icon: Icons.receipt_long_outlined,
                label: 'Invoices',
                iconBackground: ClivoraColors.iconTeal,
                iconColor: ClivoraColors.clientAccent,
                onTap: () => context.go('/client-invoices'),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Work together',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 12),
          _ClientHubGrid(
            children: [
              ToolGridTile(
                icon: Icons.description_outlined,
                label: 'Contracts',
                iconBackground: ClivoraColors.iconPurple,
                iconColor: ClivoraColors.primaryPurple,
                onTap: () => context.push('/client-contracts'),
              ),
              ToolGridTile(
                icon: Icons.add_task_outlined,
                label: 'Tasks',
                iconBackground: ClivoraColors.iconOrange,
                iconColor: ClivoraColors.warningOrange,
                onTap: () => context.push('/client-tasks'),
              ),
              ToolGridTile(
                icon: Icons.folder_open_outlined,
                label: 'Files',
                iconBackground: ClivoraColors.iconBlue,
                iconColor: Colors.blue,
                onTap: () => context.push('/client-files'),
              ),
              ToolGridTile(
                icon: Icons.timeline_outlined,
                label: 'Updates',
                iconBackground: ClivoraColors.iconTeal,
                iconColor: ClivoraColors.clientAccent,
                onTap: () => context.push('/client-activity'),
              ),
              ToolGridTile(
                icon: Icons.person_add_alt_1_outlined,
                label: 'Link freelancer',
                iconBackground: ClivoraColors.iconGreen,
                iconColor: ClivoraColors.successGreen,
                onTap: () => context.push('/client-link-freelancer'),
              ),
              if (isPlus)
                ToolGridTile(
                  icon: Icons.hub_outlined,
                  label: 'Connect',
                  iconBackground: ClivoraColors.iconTeal,
                  iconColor: ClivoraColors.primary,
                  onTap: () => context.go('/connect'),
                )
              else
                ToolGridTile(
                  icon: Icons.workspace_premium_outlined,
                  label: 'Upgrade',
                  iconBackground: ClivoraColors.iconYellow,
                  iconColor: ClivoraColors.accent,
                  onTap: () => context.push('/upgrade'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClientHubGrid extends StatelessWidget {
  const _ClientHubGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 4.6,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: children,
    );
  }
}
