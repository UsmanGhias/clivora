import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_service.dart';
import '../../../core/providers/gemini_assistant_provider.dart';
import '../../../core/theme/clivora_colors.dart';
import '../../../data/models/invoice_line_item.dart';
import '../../../data/providers/app_providers.dart';
import '../../invoices/invoice_form_screen.dart';

/// Opens the Gemini AI Assistant Bottom Sheet
Future<void> showGeminiAssistantSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const GeminiAssistantSheet(),
  );
}

class GeminiAssistantSheet extends ConsumerStatefulWidget {
  const GeminiAssistantSheet({super.key});

  @override
  ConsumerState<GeminiAssistantSheet> createState() => _GeminiAssistantSheetState();
}

class _GeminiAssistantSheetState extends ConsumerState<GeminiAssistantSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Proposal tab controllers
  final _clientNameController = TextEditingController();
  final _projectTitleController = TextEditingController();
  final _budgetController = TextEditingController();
  final _timelineController = TextEditingController(text: '2 weeks');
  final _scopeController = TextEditingController();
  final _currency = 'USD';

  // Invoice tab controllers
  final _invoiceScopeController = TextEditingController();
  final _invoiceBudgetController = TextEditingController();

  // Job Scope tab controllers
  final _jobScopeIdeaController = TextEditingController();
  final _jobScopeBudgetController = TextEditingController(text: r'$500-1,500');
  final _jobScopeCategoryController = TextEditingController(text: 'Full-Stack Development');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _clientNameController.dispose();
    _projectTitleController.dispose();
    _budgetController.dispose();
    _timelineController.dispose();
    _scopeController.dispose();
    _invoiceScopeController.dispose();
    _invoiceBudgetController.dispose();
    _jobScopeIdeaController.dispose();
    _jobScopeBudgetController.dispose();
    _jobScopeCategoryController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(geminiAssistantProvider);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      margin: const EdgeInsets.only(top: 48),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Handle bar
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: ClivoraColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ClivoraColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: ClivoraColors.primaryDark,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CLIVORA AI Assistant',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        Text(
                          'Powered by Google Gemini',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: ClivoraColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness == Brightness.light
                          ? ClivoraColors.chipBackground
                          : ClivoraColors.darkBorder,
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            TabBar(
              controller: _tabController,
              labelColor: ClivoraColors.primary,
              unselectedLabelColor: ClivoraColors.textSecondary,
              indicatorColor: ClivoraColors.primary,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              tabs: const [
                Tab(icon: Icon(Icons.work_outline, size: 18), text: 'Scope'),
                Tab(icon: Icon(Icons.description_outlined, size: 18), text: 'Proposals'),
                Tab(icon: Icon(Icons.receipt_long_outlined, size: 18), text: 'Invoices'),
                Tab(icon: Icon(Icons.insights_outlined, size: 18), text: 'Health'),
              ],
            ),

            if (state.isLoading)
              LinearProgressIndicator(
                backgroundColor: ClivoraColors.primaryLight,
                color: ClivoraColors.primary,
                minHeight: 3,
              ),

            if (state.error != null)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: ClivoraColors.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, size: 18, color: ClivoraColors.errorRed),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.error!,
                        style: const TextStyle(color: ClivoraColors.errorRed, fontSize: 12),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => ref.read(geminiAssistantProvider.notifier).clearError(),
                    ),
                  ],
                ),
              ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildJobScopeTab(state),
                  _buildProposalTab(state),
                  _buildInvoiceTab(state),
                  _buildHealthTab(state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Tab 1: Proposals
  // --------------------------------------------------------------------------
  Widget _buildProposalTab(GeminiAssistantState state) {
    final authUser = ref.watch(authStateProvider).valueOrNull;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _clientNameController,
            decoration: const InputDecoration(
              labelText: 'Client or Company Name',
              hintText: 'e.g. Acme Corp',
              prefixIcon: Icon(Icons.business_outlined, size: 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _projectTitleController,
            decoration: const InputDecoration(
              labelText: 'Project Title',
              hintText: 'e.g. Flutter Mobile App Delivery',
              prefixIcon: Icon(Icons.work_outline_rounded, size: 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _budgetController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Budget (USD)',
                    hintText: 'e.g. 2500',
                    prefixIcon: Icon(Icons.attach_money_rounded, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _timelineController,
                  decoration: const InputDecoration(
                    labelText: 'Timeline',
                    hintText: 'e.g. 3 weeks',
                    prefixIcon: Icon(Icons.timer_outlined, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _scopeController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Project Scope & Requirements',
              hintText: 'Describe key deliverables, tech stack, and goals...',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: state.isLoading
                ? null
                : () async {
                    if (_projectTitleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a project title')),
                      );
                      return;
                    }
                    final budget = double.tryParse(_budgetController.text.trim()) ?? 1000.0;
                    await ref.read(geminiAssistantProvider.notifier).draftProposal(
                          ownerUserId: authUser?.id ?? 1,
                          clientName: _clientNameController.text.trim().isEmpty
                              ? 'Valued Client'
                              : _clientNameController.text.trim(),
                          projectTitle: _projectTitleController.text.trim(),
                          budget: budget,
                          currency: _currency,
                          timeline: _timelineController.text.trim().isEmpty
                              ? '2-3 weeks'
                              : _timelineController.text.trim(),
                          scopeDetails: _scopeController.text.trim().isEmpty
                              ? 'Full delivery as agreed'
                              : _scopeController.text.trim(),
                          freelancerName: authUser?.name,
                        );
                  },
            icon: const Icon(Icons.auto_awesome_rounded, size: 18),
            label: Text(state.isLoading ? 'Drafting Proposal...' : 'Generate Proposal'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          if (state.proposal != null) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Generated Proposal',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                TextButton.icon(
                  onPressed: () => _copyToClipboard(state.proposal!, 'Proposal'),
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Copy'),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ClivoraColors.borderLight),
              ),
              child: SelectableText(
                state.proposal!,
                style: const TextStyle(fontSize: 13, height: 1.5),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 16, color: ClivoraColors.successGreen),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Automatically cached to your local Notes for offline access.',
                    style: TextStyle(fontSize: 12, color: ClivoraColors.textSecondary),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Tab 2: Invoices
  // --------------------------------------------------------------------------
  Widget _buildInvoiceTab(GeminiAssistantState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _invoiceScopeController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Work Scope & Deliverables',
              hintText: 'e.g. Design 5 mobile screens, implement API integration, and setup authentication.',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _invoiceBudgetController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Target Total Amount (USD)',
              hintText: 'e.g. 1500',
              prefixIcon: Icon(Icons.attach_money_rounded, size: 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: state.isLoading
                ? null
                : () async {
                    final budget = double.tryParse(_invoiceBudgetController.text.trim()) ?? 1000.0;
                    final scope = _invoiceScopeController.text.trim().isEmpty
                        ? 'Software consulting and feature delivery'
                        : _invoiceScopeController.text.trim();

                    await ref.read(geminiAssistantProvider.notifier).buildInvoiceItems(
                          projectScope: scope,
                          targetBudget: budget,
                          currency: _currency,
                        );
                  },
            icon: const Icon(Icons.calculate_outlined, size: 18),
            label: Text(state.isLoading ? 'Calculating Items...' : 'Generate Line Items'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          if (state.invoiceItems.isNotEmpty) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Suggested Line Items',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                Text(
                  '${state.invoiceItems.length} items',
                  style: TextStyle(fontSize: 12, color: ClivoraColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...state.invoiceItems.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ClivoraColors.borderLight),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.description,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${item.quantity.toStringAsFixed(0)} x \$$_currency ${item.rate.toStringAsFixed(2)} · ${item.category}',
                            style: TextStyle(fontSize: 11, color: ClivoraColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${item.amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                final convertedItems = state.invoiceItems
                    .map(
                      (e) => InvoiceLineItem(
                        description: e.description,
                        quantity: e.quantity,
                        unitPrice: e.rate,
                      ),
                    )
                    .toList();

                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InvoiceFormScreen(
                      initialLineItems: convertedItems,
                      initialDescription: _invoiceScopeController.text.trim().isNotEmpty
                          ? _invoiceScopeController.text.trim()
                          : 'Milestone Delivery',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.receipt_long_rounded, size: 18),
              label: const Text('Open in New Invoice'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Tab 3: Health
  // --------------------------------------------------------------------------
  Widget _buildHealthTab(GeminiAssistantState state) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ClivoraColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.query_stats_rounded, size: 20, color: ClivoraColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Business Snapshot',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                statsAsync.when(
                  loading: () => const Text('Loading dashboard stats...'),
                  error: (e, _) => Text('Offline metrics: \$0.00 monthly'),
                  data: (stats) => Column(
                    children: [
                      _metricRow('Total Revenue', '\$${stats.revenue.toStringAsFixed(2)}'),
                      _metricRow('Outstanding Balance', '\$${stats.outstanding.toStringAsFixed(2)}'),
                      _metricRow('Active Projects', '${stats.activeProjects}'),
                      _metricRow('Total Clients', '${stats.customers}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: state.isLoading
                ? null
                : () async {
                    final stats = statsAsync.valueOrNull;
                    await ref.read(geminiAssistantProvider.notifier).generateBriefing(
                          monthlyRevenue: stats?.revenue ?? 0.0,
                          overdueCount: (stats != null && stats.outstanding > 0) ? 1 : 0,
                          overdueTotal: stats?.outstanding ?? 0.0,
                          activeProjects: stats?.activeProjects ?? 0,
                          completedProjects: stats?.customers ?? 0,
                          currency: _currency,
                        );
                  },
            icon: const Icon(Icons.psychology_outlined, size: 18),
            label: Text(state.isLoading ? 'Analyzing Metrics...' : 'Generate Executive Advisory'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          if (state.briefing != null) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Executive Advisory Briefing',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                TextButton.icon(
                  onPressed: () => _copyToClipboard(state.briefing!, 'Advisory briefing'),
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Copy'),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ClivoraColors.borderLight),
              ),
              child: SelectableText(
                state.briefing!,
                style: const TextStyle(fontSize: 13, height: 1.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Tab: Client Job Scope & Milestones
  // --------------------------------------------------------------------------
  Widget _buildJobScopeTab(GeminiAssistantState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ClivoraColors.primaryLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ClivoraColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, color: ClivoraColors.primaryDark, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Zero platform fee for clients. Gemini transforms your raw requirements into complete deliverables, milestone phases, and budget bands.',
                    style: TextStyle(
                      fontSize: 12,
                      color: ClivoraColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _jobScopeIdeaController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Project Idea / Client Requirements',
              hintText: 'e.g. Build a Flutter and Supabase mobile app for real-time delivery tracking with push notifications...',
              alignLabelWithHint: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ActionChip(
                  label: const Text('SaaS MVP', style: TextStyle(fontSize: 11)),
                  onPressed: () {
                    _jobScopeIdeaController.text =
                        'Build a B2B SaaS MVP with Next.js App Router, Supabase Auth, PostgreSQL schema, and Stripe recurring subscriptions.';
                  },
                ),
                const SizedBox(width: 8),
                ActionChip(
                  label: const Text('Flutter App', style: TextStyle(fontSize: 11)),
                  onPressed: () {
                    _jobScopeIdeaController.text =
                        'Cross-platform Flutter mobile application with Riverpod, offline-first SQLite/Drift sync, push notifications, and biometric auth.';
                  },
                ),
                const SizedBox(width: 8),
                ActionChip(
                  label: const Text('ZATCA E-Invoicing', style: TextStyle(fontSize: 11)),
                  onPressed: () {
                    _jobScopeIdeaController.text =
                        'Implement KSA ZATCA Phase 2 E-Invoicing compliance with XML generation, UBL 2.1 formatting, and cryptographic stamp.';
                  },
                ),
                const SizedBox(width: 8),
                ActionChip(
                  label: const Text('Shopify Store', style: TextStyle(fontSize: 11)),
                  onPressed: () {
                    _jobScopeIdeaController.text =
                        'Custom Shopify Liquid theme setup, headless storefront optimization, product catalog migration, and custom checkout apps.';
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _jobScopeCategoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'e.g. Mobile Development',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _jobScopeBudgetController.text.isNotEmpty ? _jobScopeBudgetController.text : r'$500-1,500',
                  decoration: const InputDecoration(
                    labelText: 'Budget Band',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Under \$500', child: Text('Under \$500')),
                    DropdownMenuItem(value: '\$500-1,500', child: Text('\$500-1,500')),
                    DropdownMenuItem(value: '\$1,500-5,000', child: Text('\$1,500-5,000')),
                    DropdownMenuItem(value: '\$5,000+', child: Text('\$5,000+')),
                    DropdownMenuItem(value: 'negotiable', child: Text('Negotiable')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      _jobScopeBudgetController.text = val;
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: state.isLoading
                ? null
                : () async {
                    if (_jobScopeIdeaController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please describe your project idea or requirements'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    await ref.read(geminiAssistantProvider.notifier).draftJobScope(
                          rawIdea: _jobScopeIdeaController.text.trim(),
                          category: _jobScopeCategoryController.text.trim(),
                          targetBudget: _jobScopeBudgetController.text.trim(),
                        );
                  },
            icon: const Icon(Icons.auto_awesome_rounded, size: 18),
            label: Text(state.isLoading ? 'Structuring Scope & Milestones...' : 'Draft Job Scope & Milestones'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          if (state.jobScope != null) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Structured Job Posting',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                TextButton.icon(
                  onPressed: () {
                    final scope = state.jobScope!;
                    final fullText =
                        '${scope.title}\nBudget: ${scope.budgetBand} (0% platform fee)\nSkills: ${scope.skills}\n\n${scope.summary}';
                    _copyToClipboard(fullText, 'Job scope & milestones');
                  },
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Copy All'),
                ),
              ],
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: ClivoraColors.borderLight),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.jobScope!.title,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: ClivoraColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            state.jobScope!.budgetBand,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: ClivoraColors.primaryDark,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '0% Platform Fee',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state.jobScope!.skills.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: state.jobScope!.skills
                            .split(',')
                            .map((s) => s.trim())
                            .where((s) => s.isNotEmpty)
                            .map(
                              (s) => Chip(
                                label: Text(s, style: const TextStyle(fontSize: 11)),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    const Divider(height: 24),
                    SelectableText(
                      state.jobScope!.summary,
                      style: const TextStyle(fontSize: 13, height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('/connect/need');
                      },
                      icon: const Icon(Icons.post_add_rounded, size: 18),
                      label: const Text('Open Post a Job Form'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _metricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: ClivoraColors.textSecondary, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}
