import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/clivora_colors.dart';
import '../../data/providers/app_providers.dart';

/// Dashboard card surfacing overdue invoices and pending tasks.
class TodayOverdueCard extends ConsumerWidget {
  const TodayOverdueCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final tasksAsync = ref.watch(tasksProvider(const TaskFilter(status: 'pending')));

    return statsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (stats) {
        final outstanding = stats.outstanding;
        final pendingTasks = tasksAsync.valueOrNull?.length ?? 0;
        if (outstanding <= 0 && pendingTasks == 0) return const SizedBox.shrink();

        return Card(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push('/invoices?filter=outstanding'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.today_outlined, color: ClivoraColors.warningOrange, size: 20),
                      const SizedBox(width: 8),
                      Text('Today', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (outstanding > 0)
                    Text('Outstanding invoices need attention', style: Theme.of(context).textTheme.bodySmall),
                  if (pendingTasks > 0)
                    Text('$pendingTasks pending task${pendingTasks == 1 ? '' : 's'}', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
