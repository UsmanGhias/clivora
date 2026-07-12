import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/marketplace/connect_marketplace_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../data/providers/app_providers.dart';

/// Action-first Connect / work summary strip for freelancer home (teal branding).
class FreelancerPriorityStrip extends ConsumerStatefulWidget {
  const FreelancerPriorityStrip({super.key});

  @override
  ConsumerState<FreelancerPriorityStrip> createState() => _FreelancerPriorityStripState();
}

class _FreelancerPriorityStripState extends ConsumerState<FreelancerPriorityStrip> {
  Map<String, dynamic> _home = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    if (!ref.read(isProPlusProvider)) {
      if (mounted) setState(() => _loaded = true);
      return;
    }
    try {
      final data = await ref.read(connectMarketplaceServiceProvider).homeSummary(client: false);
      if (!mounted) return;
      setState(() {
        _home = data;
        _loaded = true;
      });
    } catch (_) {
      if (mounted) setState(() => _loaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox(height: 8);
    final pending = (_home['pending_proposals'] as num?)?.toInt() ?? 0;
    final accepted = (_home['accepted_proposals'] as num?)?.toInt() ?? 0;
    final milestones = (_home['active_milestones'] as num?)?.toInt() ?? 0;
    final unread = (_home['unread_messages'] as num?)?.toInt() ?? 0;
    if (pending + accepted + milestones + unread == 0 && !ref.watch(isProPlusProvider)) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          _chip(context, 'Proposals', pending, () => context.push('/connect')),
          const SizedBox(width: 8),
          _chip(context, 'Accepted', accepted, () => context.push('/connect')),
          const SizedBox(width: 8),
          _chip(context, 'Milestones', milestones, () => context.push('/connect')),
          const SizedBox(width: 8),
          _chip(context, 'Unread', unread, () => context.push('/freelancer-messages')),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, int value, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: ClivoraColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ClivoraColors.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Text('$value', style: const TextStyle(fontWeight: FontWeight.w800, color: ClivoraColors.primary)),
              Text(label, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}

/// Action-first summary for client home (slate branding).
class ClientPriorityStrip extends ConsumerStatefulWidget {
  const ClientPriorityStrip({super.key});

  @override
  ConsumerState<ClientPriorityStrip> createState() => _ClientPriorityStripState();
}

class _ClientPriorityStripState extends ConsumerState<ClientPriorityStrip> {
  Map<String, dynamic> _home = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    try {
      final data = await ref.read(connectMarketplaceServiceProvider).homeSummary(client: true);
      if (!mounted) return;
      setState(() {
        _home = data;
        _loaded = true;
      });
    } catch (_) {
      if (mounted) setState(() => _loaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.shrink();
    final jobs = (_home['open_jobs'] as num?)?.toInt() ?? 0;
    final pending = (_home['pending_proposals'] as num?)?.toInt() ?? 0;
    final milestones = (_home['milestones_needing_action'] as num?)?.toInt() ?? 0;
    final unread = (_home['unread_messages'] as num?)?.toInt() ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _chip(context, 'Open jobs', jobs, () => context.push('/connect')),
              const SizedBox(width: 8),
              _chip(context, 'Proposals', pending, () => context.push('/connect')),
              const SizedBox(width: 8),
              _chip(context, 'Approvals', milestones, () => context.push('/connect')),
              const SizedBox(width: 8),
              _chip(context, 'Unread', unread, () => context.push('/client-messages')),
            ],
          ),
          if (ref.watch(isProPlusProvider)) ...[
            const SizedBox(height: 10),
            FilledButton.tonal(
              onPressed: () => context.push('/connect/need'),
              style: FilledButton.styleFrom(
                foregroundColor: ClivoraColors.clientAccent,
                minimumSize: const Size.fromHeight(44),
              ),
              child: const Text('Post a job on Connect'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, int value, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: ClivoraColors.clientSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ClivoraColors.clientAccent.withValues(alpha: 0.25)),
          ),
          child: Column(
            children: [
              Text('$value', style: const TextStyle(fontWeight: FontWeight.w800, color: ClivoraColors.clientAccent)),
              Text(label, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
