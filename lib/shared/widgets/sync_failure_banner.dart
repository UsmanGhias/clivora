import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/sync_outbox_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/crm_refresh.dart';

/// Shows pending sync failures with retry affordance.
class SyncFailureBanner extends ConsumerWidget {
  const SyncFailureBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(syncFailureMessageProvider);
    if (message == null || message.isEmpty) return const SizedBox.shrink();

    return Material(
      color: ClivoraColors.warningOrange.withValues(alpha: 0.15),
      child: InkWell(
        onTap: () async {
          final outbox = ref.read(syncOutboxServiceProvider);
          await outbox.processQueue();
          invalidateOnReconnect(ref);
          final pending = await outbox.pendingCount();
          if (pending > 0) {
            ref.read(syncFailureMessageProvider.notifier).state =
                'Sync pending ($pending). Tap to retry.';
          } else {
            ref.read(syncFailureMessageProvider.notifier).state = null;
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.sync_problem_outlined, size: 16, color: ClivoraColors.warningOrange),
              const SizedBox(width: 8),
              Expanded(child: Text(message, style: Theme.of(context).textTheme.bodySmall)),
              const Icon(Icons.refresh, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
