import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/cloud/cloud_project_repository.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/duration_formatter.dart';
import '../../core/utils/navigation_helper.dart';
import '../../data/providers/app_providers.dart';
import 'client_portal_screen.dart' show ClientTrackingKey, clientProjectSecondsProvider;

/// Opens project detail sheet with live tracked seconds.
Future<void> openClientProjectDetail(
  BuildContext context,
  WidgetRef ref,
  ClientSharedProjectView view,
  int? clientUserId,
) async {
  var seconds = 0;
  if (clientUserId != null && view.localProject != null && !view.isCloudOnly) {
    seconds = await ref.read(
      clientProjectSecondsProvider(
        ClientTrackingKey(clientUserId: clientUserId, projectId: view.localProject!.id),
      ).future,
    );
  }
  if (context.mounted) {
    await showClientProjectDetail(context, project: view, trackedSeconds: seconds);
  }
}

/// Full project detail for clients — tap any shared project card.
Future<void> showClientProjectDetail(
  BuildContext context, {
  required ClientSharedProjectView project,
  required int trackedSeconds,
}) async {
  final status = project.status.replaceAll('_', ' ');
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      minChildSize: 0.45,
      builder: (_, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ClivoraColors.clientAccentLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.folder_open_rounded, color: ClivoraColors.clientAccent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                    Text(status.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ClivoraColors.clientAccent)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (project.budget > 0)
            _DetailRow(
              icon: Icons.payments_outlined,
              label: 'Budget',
              value: '${formatCurrency(project.budget, symbol: currencySymbol(project.currency))} (${project.currency})',
            ),
          _DetailRow(
            icon: Icons.timer_outlined,
            label: 'Time tracked',
            value: project.isCloudOnly ? 'Synced from freelancer' : formatTrackedDuration(trackedSeconds),
          ),
          if (project.deadline != null)
            _DetailRow(
              icon: Icons.event_outlined,
              label: 'Deadline',
              value: DateFormat.yMMMd().format(project.deadline!.toLocal()),
            ),
          if (project.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Scope', style: Theme.of(ctx).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(project.description),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    openFormRoute(context, '/client-activity');
                  },
                  icon: const Icon(Icons.timeline_outlined),
                  label: const Text('Updates'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    openFormRoute(context, '/client-messages');
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Message'),
                  style: FilledButton.styleFrom(backgroundColor: ClivoraColors.clientAccent),
                ),
              ),
            ],
          ),
          if (project.status == 'completed') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ClivoraColors.successGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: ClivoraColors.successGreen),
                  SizedBox(width: 10),
                  Expanded(child: Text('This project is marked completed by your freelancer.')),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: ClivoraColors.clientAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
