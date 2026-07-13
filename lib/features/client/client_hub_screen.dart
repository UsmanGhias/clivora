import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/clivora_colors.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_bottom_sheet.dart';
import '../../shared/widgets/clivora_scaffold.dart';
import '../../shared/widgets/tool_grid_tile.dart';

/// Client tools hub, parity with freelancer Hub for collaboration surfaces.
class ClientHubScreen extends ConsumerWidget {
  const ClientHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlus = ref.watch(isProPlusProvider);

    return ClivoraScaffold(
      title: 'Client Hub',
      subtitle: 'All tools and resources in one place',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: ClivoraColors.clientGradient,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: ClivoraColors.clientAccent.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Command Center',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'A command center for invoices, files, contracts, and updates from your freelancer.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _HubPill(icon: Icons.receipt_long_outlined, label: 'Pay'),
                      _HubPill(icon: Icons.folder_open_outlined, label: 'Review'),
                      _HubPill(icon: Icons.mail_outline, label: 'Reply'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
            builder: (context, t, child) => Opacity(
              opacity: t,
              child: Transform.translate(offset: Offset(0, 8 * (1 - t)), child: child),
            ),
            child: const SectionHeader(title: 'Money'),
          ),
          const SizedBox(height: 4),
          _ClientHubGrid(
            children: [
              ToolGridTile(
                icon: Icons.request_quote_outlined,
                label: 'Quotes',
                description: 'Review quotes before you approve work',
                iconBackground: ClivoraColors.clientSurface,
                iconColor: ClivoraColors.clientAccent,
                onTap: () => context.push('/client-quotes'),
              ),
              ToolGridTile(
                icon: Icons.payments_outlined,
                label: 'Payments',
                description: 'See payment history and confirmations',
                iconBackground: ClivoraColors.iconGreen,
                iconColor: ClivoraColors.successGreen,
                onTap: () => context.push('/client-payments'),
              ),
              ToolGridTile(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Credits',
                description: 'Track credits applied to your account',
                iconBackground: ClivoraColors.iconYellow,
                iconColor: ClivoraColors.accent,
                onTap: () => context.push('/client-credits'),
              ),
              ToolGridTile(
                icon: Icons.autorenew,
                label: 'Recurring',
                description: 'View recurring billing schedules',
                iconBackground: ClivoraColors.clientSurface,
                iconColor: ClivoraColors.clientAccent,
                onTap: () => context.push('/client-recurring'),
              ),
              ToolGridTile(
                icon: Icons.receipt_long_outlined,
                label: 'Invoices',
                description: 'Pay invoices and download PDFs',
                iconBackground: ClivoraColors.clientSurface,
                iconColor: ClivoraColors.clientAccent,
                onTap: () => context.go('/client-invoices'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Work together'),
          const SizedBox(height: 4),
          _ClientHubGrid(
            children: [
              ToolGridTile(
                icon: Icons.description_outlined,
                label: 'Contracts',
                description: 'Review and sign shared contracts',
                iconBackground: ClivoraColors.clientSurface,
                iconColor: ClivoraColors.clientAccent,
                onTap: () => context.push('/client-contracts'),
              ),
              ToolGridTile(
                icon: Icons.add_task_outlined,
                label: 'Tasks',
                description: 'Assign tasks to your freelancer',
                iconBackground: ClivoraColors.iconOrange,
                iconColor: ClivoraColors.warningOrange,
                onTap: () => context.push('/client-tasks'),
              ),
              ToolGridTile(
                icon: Icons.folder_open_outlined,
                label: 'Files',
                description: 'Browse shared project files',
                iconBackground: ClivoraColors.iconBlue,
                iconColor: Colors.blue,
                onTap: () => context.push('/client-files'),
              ),
              ToolGridTile(
                icon: Icons.timeline_outlined,
                label: 'Updates',
                description: 'Follow project activity and notes',
                iconBackground: ClivoraColors.clientSurface,
                iconColor: ClivoraColors.clientAccent,
                onTap: () => context.push('/client-activity'),
              ),
              ToolGridTile(
                icon: Icons.flag_outlined,
                label: 'Milestones',
                description: 'Track milestone progress and approvals',
                iconBackground: ClivoraColors.iconIndigo,
                iconColor: Colors.indigo,
                onTap: () => context.push('/client-milestones'),
              ),
              ToolGridTile(
                icon: Icons.person_add_alt_1_outlined,
                label: 'Link freelancer',
                description: 'Connect with your freelancer by email',
                iconBackground: ClivoraColors.iconGreen,
                iconColor: ClivoraColors.successGreen,
                onTap: () => context.push('/client-link-freelancer'),
              ),
              if (isPlus)
                ToolGridTile(
                  icon: Icons.hub_outlined,
                  label: 'Connect',
                  description: 'Discover freelancers on CLIVORA Connect',
                  iconBackground: ClivoraColors.clientSurface,
                  iconColor: ClivoraColors.clientAccent,
                  onTap: () => context.go('/connect'),
                )
              else
                ToolGridTile(
                  icon: Icons.workspace_premium_outlined,
                  label: 'Upgrade',
                  description: 'Unlock Connect and premium client tools',
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
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: children,
    );
  }
}

class _HubPill extends StatelessWidget {
  const _HubPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
