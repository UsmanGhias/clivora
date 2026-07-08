import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/services/backup_restore_service.dart';
import '../../core/services/last_login_service.dart';
import '../../shared/widgets/clivora_scaffold.dart';

class BackupRestoreScreen extends ConsumerStatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  ConsumerState<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends ConsumerState<BackupRestoreScreen> {
  final _passwordCtrl = TextEditingController();
  bool _usePassword = false;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metaAsync = ref.watch(lastBackupMetaProvider);

    return ClivoraScaffold(
      title: 'Backup & Restore',
      showBackButton: true,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Export your workspace as JSON. Optional password protects the file on shared storage.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            metaAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (meta) {
                if (meta.at == null) return const SizedBox.shrink();
                final sizeKb = ((meta.bytes ?? 0) / 1024).toStringAsFixed(1);
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Last backup'),
                    subtitle: Text('${DateFormat.yMMMd().add_jm().format(meta.at!.toLocal())} · $sizeKb KB'),
                  ),
                );
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Password-protect export'),
              value: _usePassword,
              onChanged: (v) => setState(() => _usePassword = v),
            ),
            if (_usePassword)
              TextField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'BACKUP PASSWORD',
                  hintText: 'Required to open this file later',
                ),
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                try {
                  await ref.read(backupRestoreServiceProvider).shareExport(
                        password: _usePassword ? _passwordCtrl.text : null,
                      );
                  ref.invalidate(lastBackupMetaProvider);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
                  }
                }
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('One-tap backup'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Restore workspace'),
                    content: const Text(
                      'Import validates schema version and account ownership. '
                      'Restore respects Free plan limits for clients and templates.',
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Restore guide'),
            ),
          ],
        ),
      ),
    );
  }
}
