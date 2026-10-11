import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/marketplace/connect_marketplace_service.dart';
import '../../core/providers/gemini_assistant_provider.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';

class ConnectNeedScreen extends ConsumerStatefulWidget {
  const ConnectNeedScreen({super.key});

  @override
  ConsumerState<ConnectNeedScreen> createState() => _ConnectNeedScreenState();
}

class _ConnectNeedScreenState extends ConsumerState<ConnectNeedScreen> {
  final _title = TextEditingController();
  final _summary = TextEditingController();
  final _skills = TextEditingController();
  final _aiPrompt = TextEditingController();
  String _budget = '\$500-1,500';
  bool _busy = false;
  bool _aiLoading = false;

  @override
  void dispose() {
    _title.dispose();
    _summary.dispose();
    _skills.dispose();
    _aiPrompt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasAccess = ref.watch(isProPlusProvider);
    return ClivoraScaffold(
      title: 'Post a job',
      showBackButton: true,
      body: !hasAccess
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 44,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Connect requires Pro Plus',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.push('/upgrade'),
                    child: const Text('Upgrade to Pro Plus'),
                  ),
                ],
              ),
            )
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Stay anonymous until you accept a freelancer. Describe the work, not your company email.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 16),
          // Gemini AI Scope Assistant Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 20, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'AI Job Scope Assistant',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '0% Platform Fee',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter 1 sentence and Gemini will draft full deliverables, milestones, and required skills.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _aiPrompt,
                        decoration: InputDecoration(
                          hintText: 'e.g. Mobile laundry app with Stripe...',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onSubmitted: (_) => _generateScope(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: _aiLoading ? null : () => _generateScope(),
                      icon: _aiLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.bolt, size: 18),
                      label: Text(_aiLoading ? 'Drafting…' : 'Generate'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ActionChip(
                        label: const Text('Flutter Mobile App'),
                        onPressed: _aiLoading ? null : () => _generateScope('Flutter Mobile App for iOS and Android with Supabase backend'),
                      ),
                      const SizedBox(width: 6),
                      ActionChip(
                        label: const Text('Next.js SaaS MVP'),
                        onPressed: _aiLoading ? null : () => _generateScope('Next.js full-stack SaaS web app with Stripe billing'),
                      ),
                      const SizedBox(width: 6),
                      ActionChip(
                        label: const Text('AI Agent Integration'),
                        onPressed: _aiLoading ? null : () => _generateScope('Python AI backend integrating Gemini LLM API and vector search'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Job title')),
          const SizedBox(height: 12),
          TextField(controller: _summary, maxLines: 4, decoration: const InputDecoration(labelText: 'Summary')),
          const SizedBox(height: 12),
          TextField(controller: _skills, decoration: const InputDecoration(labelText: 'Skills needed (comma separated)')),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey(_budget),
            initialValue: _budget,
            decoration: const InputDecoration(labelText: 'Budget band'),
            items: const [
              DropdownMenuItem(value: 'Under \$500', child: Text('Under \$500')),
              DropdownMenuItem(value: '\$500-1,500', child: Text('\$500-1,500')),
              DropdownMenuItem(value: '\$1,500-5,000', child: Text('\$1,500-5,000')),
              DropdownMenuItem(value: '\$5,000+', child: Text('\$5,000+')),
              DropdownMenuItem(value: 'negotiable', child: Text('Negotiable')),
            ],
            onChanged: (v) => setState(() => _budget = v ?? _budget),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(_busy ? 'Posting…' : 'Publish job'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateScope([String? overrideText]) async {
    final query = (overrideText ?? _aiPrompt.text).trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a short project idea to draft scope.')),
      );
      return;
    }
    setState(() => _aiLoading = true);
    try {
      final scope = await ref.read(geminiAssistantProvider.notifier).draftJobScope(
            rawIdea: query,
            targetBudget: _budget,
          );
      if (scope != null && mounted) {
        setState(() {
          _title.text = scope.title;
          _summary.text = scope.summary;
          _skills.text = scope.skills;
          const validBudgets = ['Under \$500', '\$500-1,500', '\$1,500-5,000', '\$5,000+', 'negotiable'];
          if (validBudgets.contains(scope.budgetBand)) {
            _budget = scope.budgetBand;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job scope drafted with Gemini AI!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _aiLoading = false);
    }
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      final skills = _skills.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      await ref.read(connectMarketplaceServiceProvider).createNeedPost(
            title: _title.text,
            summary: _summary.text,
            skills: skills,
            budgetBand: _budget,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job posted')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
