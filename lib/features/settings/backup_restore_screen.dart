import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/backup_restore_service.dart';
import '../../shared/widgets/clivora_scaffold.dart';

class BackupRestoreScreen extends ConsumerWidget {
  const BackupRestoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClivoraScaffold(
      title: 'Backup & Restore',
      showBackButton: true,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Export your workspace as JSON. Import restores clients and templates.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                try {
                  await ref.read(backupRestoreServiceProvider).shareExport();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
                  }
                }
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Export workspace'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Import from Hub settings or admin JSON import on web')),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('How to restore'),
            ),
          ],
        ),
      ),
    );
  }
}
