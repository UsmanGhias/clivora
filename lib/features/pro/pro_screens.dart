import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/constants/pro_pricing.dart';
import '../../core/services/ai_assistant_service.dart';
import '../../core/services/automation_service.dart';
import '../../core/services/vault_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/form_validators.dart';
import '../../data/database/database.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';
import '../../shared/widgets/filter_chip_row.dart';
import '../../shared/widgets/step_progress_card.dart';

/// Shared Pro gate banner — CLIVORA style (distinct from generic paywalls).
class ProGateBanner extends ConsumerWidget {
  const ProGateBanner({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.workspace_premium_outlined,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ClivoraColors.navyDark,
            ClivoraColors.primaryPurple.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(description, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), height: 1.4)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: ClivoraColors.navyDark),
              onPressed: () => context.push('/upgrade'),
              child: Text('Unlock Pro — ${ProPricing.monthlyLabel}/mo'),
            ),
          ),
        ],
      ),
    );
  }
}

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  List<AiInsight>? _insights;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ownerId = ref.read(authStateProvider).valueOrNull?.id;
    if (ownerId == null) return;
    final db = ref.read(databaseProvider);
    final list = await AiAssistantService().generateInsights(db, ownerId);
    if (mounted) setState(() { _insights = list; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return ClivoraScaffold(
      title: 'CLIVORA AI',
      showBackButton: true,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ClivoraColors.primaryPurple.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ClivoraColors.primaryPurple.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: ClivoraColors.primaryPurple),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Smart insights from your local business data — private, offline, and instant.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...?_insights?.map((i) => _InsightCard(insight: i)),
                ],
              ),
            ),
    );
  }
}

class _InsightCard extends ConsumerWidget {
  const _InsightCard({required this.insight});

  final AiInsight insight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ClivoraColors.iconPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(insight.category, style: const TextStyle(fontSize: 11, color: ClivoraColors.primaryPurple, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(insight.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(insight.body, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5)),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: insight.body));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                },
                icon: const Icon(Icons.copy_outlined, size: 18),
                label: const Text('Copy'),
              ),
              if (insight.route != null)
                TextButton.icon(
                  onPressed: () => context.push(insight.route!),
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: Text(insight.actionLabel),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class MessageTemplatesScreen extends ConsumerStatefulWidget {
  const MessageTemplatesScreen({super.key});

  @override
  ConsumerState<MessageTemplatesScreen> createState() => _MessageTemplatesScreenState();
}

class _MessageTemplatesScreenState extends ConsumerState<MessageTemplatesScreen> {
  String _category = 'all';

  @override
  Widget build(BuildContext context) {
    final isPro = ref.watch(isProProvider);
    final templatesAsync = ref.watch(messageTemplatesProvider(_category == 'all' ? null : _category));

    return ClivoraScaffold(
      title: 'Smart Templates',
      showBackButton: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTemplateForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New template'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterChipRow(
            options: const ['all', 'invoice', 'project', 'follow-up', 'general'],
            selected: _category,
            onSelected: (v) => setState(() => _category = v),
          ),
          const SizedBox(height: 8),
          if (!isPro)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Free plan: up to 3 templates. Pro unlocks unlimited.', style: Theme.of(context).textTheme.bodySmall),
            ),
          Expanded(
            child: templatesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error loading templates: $e')),
              data: (templates) {
                if (templates.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.forum_outlined, size: 56, color: ClivoraColors.labelGray.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        const Text('No templates yet', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text('Create reusable messages with smart variables.', style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: () => _showTemplateForm(context),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Create your first template'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    final t = templates[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${t.type.toUpperCase()} · ${t.category}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: ClivoraColors.errorRed),
                          onPressed: () => ref.read(databaseProvider).deleteMessageTemplate(t.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showTemplateForm(BuildContext context) async {
    final isPro = ref.read(isProProvider);
    if (!isPro) {
      final count = await ref.read(databaseProvider).countMessageTemplates();
      if (count >= 3) {
        if (context.mounted) context.push('/upgrade');
        return;
      }
    }

    final nameCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    const type = 'email';
    var category = 'general';

    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: StatefulBuilder(
          builder: (context, setModal) {
            void insertVar(String v) {
              final text = bodyCtrl.text;
              final sel = bodyCtrl.selection;
              final insertAt = sel.start >= 0 ? sel.start : text.length;
              final newText = text.replaceRange(insertAt, sel.end >= 0 ? sel.end : insertAt, v);
              bodyCtrl.text = newText;
              bodyCtrl.selection = TextSelection.collapsed(offset: insertAt + v.length);
            }

            return ClivoraBottomSheetContent(
              title: 'New Template',
              onSave: () async {
                final nameErr = FormValidators.requiredField(nameCtrl.text, field: 'Template name');
                if (nameErr != null) {
                  showFormError(context, nameErr);
                  return;
                }
                final ownerId = ref.read(authStateProvider).valueOrNull?.id;
                if (ownerId == null) return;
                final db = ref.read(databaseProvider);
                await db.insertMessageTemplate(
                  MessageTemplatesCompanion.insert(
                    ownerUserId: ownerId,
                    name: nameCtrl.text.trim(),
                    type: Value(type),
                    category: Value(category),
                    subject: Value(subjectCtrl.text.trim()),
                    body: Value(bodyCtrl.text.trim()),
                  ),
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClivoraTextField(controller: nameCtrl, label: 'Template Name', hint: 'e.g. Payment Reminder'),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(labelText: 'CATEGORY'),
                    items: const [
                      DropdownMenuItem(value: 'general', child: Text('General')),
                      DropdownMenuItem(value: 'invoice', child: Text('Invoice')),
                      DropdownMenuItem(value: 'project', child: Text('Project')),
                      DropdownMenuItem(value: 'follow-up', child: Text('Follow-up')),
                    ],
                    onChanged: (v) => setModal(() => category = v ?? 'general'),
                  ),
                  const SizedBox(height: 12),
                  ClivoraTextField(controller: subjectCtrl, label: 'Subject', hint: 'Email subject line'),
                  const SizedBox(height: 12),
                  ClivoraTextField(controller: bodyCtrl, label: 'Message Body', hint: 'Write your message…', maxLines: 5),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final v in const ['{{clientName}}', '{{businessName}}', '{{invoiceNumber}}', '{{amount}}'])
                        ActionChip(label: Text(v), onPressed: () => insertVar(v)),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ContractsScreen extends ConsumerStatefulWidget {
  const ContractsScreen({super.key});

  @override
  ConsumerState<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends ConsumerState<ContractsScreen> {
  String _status = 'all';

  @override
  Widget build(BuildContext context) {
    final isPro = ref.watch(isProProvider);

    if (!isPro) {
      return ClivoraScaffold(
        title: 'Contracts',
        showBackButton: true,
        body: ListView(
          children: const [
            ProGateBanner(
              title: 'Client Contracts',
              description: 'Create, send, and track signed agreements linked to your customers. Included with CLIVORA Pro.',
              icon: Icons.description_outlined,
            ),
          ],
        ),
      );
    }

    final contractsAsync = ref.watch(contractsProvider(_status == 'all' ? null : _status));
    return ClivoraScaffold(
      title: 'Contracts',
      showBackButton: true,
      action: ClivoraIconButton(icon: Icons.add, onPressed: () => _createContract(context)),
      body: Column(
        children: [
          FilterChipRow(
            options: const ['all', 'draft', 'sent', 'signed', 'cancelled'],
            selected: _status,
            onSelected: (v) => setState(() => _status = v),
          ),
          Expanded(
            child: contractsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (list) {
                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.description_outlined, size: 56, color: ClivoraColors.labelGray),
                        const SizedBox(height: 12),
                        const Text('No contracts yet'),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: () => _createContract(context), child: const Text('Create Contract')),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final c = list[i];
                    return Card(
                      child: ListTile(
                        title: Text(c.title),
                        subtitle: Text(c.status.toUpperCase()),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _editContract(context, c),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editContract(BuildContext context, Contract contract) async {
    final contentCtrl = TextEditingController(text: contract.content);
    var status = contract.status;
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(contract.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: status,
                items: const [
                  DropdownMenuItem(value: 'draft', child: Text('Draft')),
                  DropdownMenuItem(value: 'sent', child: Text('Sent')),
                  DropdownMenuItem(value: 'signed', child: Text('Signed')),
                  DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                ],
                onChanged: (v) => status = v ?? status,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentCtrl,
                maxLines: 8,
                decoration: const InputDecoration(labelText: 'Agreement terms'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await ref.read(databaseProvider).updateContract(
                    contract.copyWith(
                      content: contentCtrl.text.trim(),
                      status: status,
                      updatedAt: DateTime.now(),
                    ),
                  );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _createContract(BuildContext context) async {
    final ownerId = ref.read(authStateProvider).valueOrNull?.id;
    if (ownerId == null) return;
    final customers = await ref.read(databaseProvider).watchCustomersForUser(ownerId).first;
    if (customers.isEmpty) {
      showFormError(context, 'Add a customer first');
      return;
    }
    final titleCtrl = TextEditingController();
    var customerId = customers.first.id;
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Contract'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Contract title')),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: customerId,
              items: customers.map((c) => DropdownMenuItem(value: c.id, child: Text(c.contactPerson))).toList(),
              onChanged: (v) => customerId = v ?? customerId,
              decoration: const InputDecoration(labelText: 'Customer'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) return;
              final ownerId = ref.read(authStateProvider).valueOrNull?.id;
              if (ownerId == null) return;
              await ref.read(databaseProvider).insertContract(
                    ContractsCompanion.insert(
                      ownerUserId: ownerId,
                      customerId: customerId,
                      title: titleCtrl.text.trim(),
                      content: Value('Agreement terms to be defined.'),
                    ),
                  );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class AutomationsScreen extends ConsumerWidget {
  const AutomationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(automationSettingsProvider);
    return ClivoraScaffold(
      title: 'Workflows',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Automations run on your device when you save customers or invoices.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          _AutomationTile(
            title: 'Overdue invoice follow-up',
            subtitle: 'Creates a high-priority task when an invoice is marked overdue',
            enabled: settings.overdueFollowUp,
            onChanged: ref.read(automationSettingsProvider.notifier).setOverdueFollowUp,
          ),
          _AutomationTile(
            title: 'New customer welcome',
            subtitle: 'Adds a welcome note and onboarding task for new clients',
            enabled: settings.customerWelcome,
            onChanged: ref.read(automationSettingsProvider.notifier).setCustomerWelcome,
          ),
          _AutomationTile(
            title: 'Weekly revenue summary',
            subtitle: 'Creates a weekly revenue note every 7 days when enabled',
            enabled: settings.weeklySummary,
            onChanged: ref.read(automationSettingsProvider.notifier).setWeeklySummary,
          ),
        ],
      ),
    );
  }
}

class _AutomationTile extends StatelessWidget {
  const _AutomationTile({
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Switch(value: enabled, onChanged: onChanged),
        ],
      ),
    );
  }
}

class StorageScreen extends ConsumerWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filesAsync = ref.watch(vaultFilesProvider);
    return ClivoraScaffold(
      title: 'File Vault',
      showBackButton: true,
      action: ClivoraIconButton(
        icon: Icons.add,
        onPressed: () async {
          final path = await VaultService.pickAndSave();
          if (path != null) ref.invalidate(vaultFilesProvider);
        },
      ),
      body: filesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (files) {
          final total = VaultService.totalBytes(files);
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${VaultService.formatSize(total)} stored on device', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('${files.length} file${files.length == 1 ? '' : 's'} in your vault', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (files.isEmpty)
                const Center(
                  child: Column(
                    children: [
                      Icon(Icons.folder_open_outlined, size: 64, color: ClivoraColors.labelGray),
                      SizedBox(height: 12),
                      Text('No files yet', style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 8),
                      Text('Tap + to add images and project assets.'),
                    ],
                  ),
                )
              else
                ...files.map((f) {
                  final file = f as File;
                  return ListTile(
                    leading: const Icon(Icons.insert_drive_file_outlined),
                    title: Text(file.path.split(Platform.pathSeparator).last),
                    subtitle: Text(VaultService.formatSize(file.lengthSync())),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        await VaultService.deleteFile(file.path);
                        ref.invalidate(vaultFilesProvider);
                      },
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

/// Lightweight bottom sheet content helper for templates.
class ClivoraBottomSheetContent extends StatelessWidget {
  const ClivoraBottomSheetContent({
    super.key,
    required this.title,
    required this.onSave,
    required this.child,
  });

  final String title;
  final VoidCallback onSave;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 16),
          child,
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: onSave, child: const Text('Save'))),
            ],
          ),
        ],
      ),
    );
  }
}
