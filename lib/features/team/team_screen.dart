import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/form_validators.dart';
import '../../data/database/database.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';
import '../../shared/widgets/empty_state.dart';

class TeamScreen extends ConsumerStatefulWidget {
  const TeamScreen({super.key});

  @override
  ConsumerState<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends ConsumerState<TeamScreen> {
  Future<void> _addMember() async {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    var role = 'member';

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModal) => AlertDialog(
          title: const Text('Add team member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 12),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: role,
                decoration: const InputDecoration(labelText: 'Role'),
                items: const [
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'member', child: Text('Member')),
                  DropdownMenuItem(value: 'viewer', child: Text('Viewer')),
                ],
                onChanged: (v) => setModal(() => role = v ?? 'member'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final nameErr = FormValidators.requiredField(nameCtrl.text, field: 'Name');
                final emailErr = FormValidators.email(emailCtrl.text, required: true);
                if (nameErr != null || emailErr != null) return;
                Navigator.pop(ctx, true);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );

    if (saved != true || !mounted) return;
    final ownerId = ref.read(authStateProvider).valueOrNull?.id;
    if (ownerId == null) return;
    await ref.read(databaseProvider).insertTeamMember(
          TeamMembersCompanion.insert(
            ownerUserId: ownerId,
            name: nameCtrl.text.trim(),
            email: emailCtrl.text.trim().toLowerCase(),
            role: Value(role),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final teamAsync = ref.watch(teamMembersProvider);

    return ClivoraScaffold(
      title: 'Team',
      showBackButton: true,
      action: IconButton(onPressed: _addMember, icon: const Icon(Icons.person_add_outlined)),
      body: teamAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (members) {
          if (members.isEmpty) {
            return EmptyState(
              icon: Icons.groups_outlined,
              message: 'No team members yet',
              actionLabel: 'Add team member',
              onAction: _addMember,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: members.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final m = members[index];
              return ListTile(
                tileColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Theme.of(context).dividerColor),
                ),
                leading: CircleAvatar(
                  backgroundColor: ClivoraColors.primary.withValues(alpha: 0.12),
                  child: Text(m.name.isNotEmpty ? m.name[0].toUpperCase() : '?'),
                ),
                title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${m.email} · ${m.role}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: ClivoraColors.errorRed),
                  onPressed: () => ref.read(databaseProvider).deleteTeamMember(m.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
