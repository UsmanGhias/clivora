import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_service.dart';
import '../../core/services/marketplace/connect_marketplace_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../shared/widgets/clivora_scaffold.dart';
import '../../shared/widgets/empty_state.dart';

class ConnectMilestonesScreen extends ConsumerStatefulWidget {
  const ConnectMilestonesScreen({super.key});

  @override
  ConsumerState<ConnectMilestonesScreen> createState() =>
      _ConnectMilestonesScreenState();
}

class _ConnectMilestonesScreenState
    extends ConsumerState<ConnectMilestonesScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _milestones = [];
  String _filter = 'all'; // all | funded | submitted | pending_funding | released | disputed

  @override
  void initState() {
    super.initState();
    _loadMilestones();
  }

  Future<void> _loadMilestones() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final svc = ref.read(connectMarketplaceServiceProvider);
      final list = await svc.fetchMyMilestones();
      if (!mounted) return;
      setState(() {
        _milestones = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _submitDeliverable(Map<String, dynamic> row) async {
    final noteCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Deliverable'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add completion notes or links to your work. The client will have 14 days to review before escrow funds auto-release.',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe completed deliverables, repository links, or files...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: ClivoraColors.primary),
            child: const Text('Submit Work'),
          ),
        ],
      ),
    );

    if (ok != true || noteCtrl.text.trim().isEmpty) return;

    try {
      final svc = ref.read(connectMarketplaceServiceProvider);
      await svc.submitMilestoneDeliverable(
        milestoneId: row['id'] as String,
        notes: noteCtrl.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deliverable submitted. 14-day review countdown started.')),
      );
      _loadMilestones();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: ClivoraColors.errorRed),
      );
    }
  }

  Future<void> _approveRelease(Map<String, dynamic> row) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Release Escrow Funds?'),
        content: Text(
          'This will immediately transfer ${row['currency'] ?? 'USD'} ${row['amount']} to the freelancer. This action is final.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: ClivoraColors.successGreen),
            child: const Text('Approve & Release'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final svc = ref.read(connectMarketplaceServiceProvider);
      await svc.approveAndReleaseMilestone(milestoneId: row['id'] as String);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escrow funds released successfully.')),
      );
      _loadMilestones();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: ClivoraColors.errorRed),
      );
    }
  }

  Future<void> _raiseDispute(Map<String, dynamic> row) async {
    final reasonCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Raise Escrow Dispute'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Disputing pauses the 14-day auto-release timer and flags the contract for mediator arbitration.',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'State specific issues with the deliverables...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: ClivoraColors.errorRed),
            child: const Text('File Dispute'),
          ),
        ],
      ),
    );

    if (ok != true || reasonCtrl.text.trim().isEmpty) return;

    try {
      final svc = ref.read(connectMarketplaceServiceProvider);
      await svc.disputeMilestone(
        milestoneId: row['id'] as String,
        reason: reasonCtrl.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dispute opened. Auto-release paused.')),
      );
      _loadMilestones();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: ClivoraColors.errorRed),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final myUid = user?.id.toString();

    final filtered = _filter == 'all'
        ? _milestones
        : _milestones.where((m) => m['status'] == _filter).toList();

    return ClivoraScaffold(
      title: 'Milestones & Escrow',
      showBackButton: true,
      action: IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: _loading ? null : _loadMilestones,
      ),
      body: Column(
        children: [
          // Trust Guarantee Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ClivoraColors.primaryLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ClivoraColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: ClivoraColors.primaryDark, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '0% Platform Fee · 14-day auto-release security · Client escrow funded protection.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ClivoraColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _filterChip('All', 'all'),
                const SizedBox(width: 6),
                _filterChip('Funded', 'funded'),
                const SizedBox(width: 6),
                _filterChip('In Review', 'submitted'),
                const SizedBox(width: 6),
                _filterChip('Pending Deposit', 'pending_funding'),
                const SizedBox(width: 6),
                _filterChip('Released', 'released'),
                const SizedBox(width: 6),
                _filterChip('Disputed', 'disputed'),
              ],
            ),
          ),

          // Milestone List
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!, style: const TextStyle(color: ClivoraColors.errorRed)))
                    : filtered.isEmpty
                        ? const EmptyState(
                            icon: Icons.account_balance_wallet_outlined,
                            message: 'No milestones in this view.',
                          )
                        : RefreshIndicator(
                            onRefresh: _loadMilestones,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: filtered.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 12),
                              itemBuilder: (context, i) {
                                final row = filtered[i];
                                final status = row['status'] as String? ?? 'pending';
                                final isClient = row['client_user_id'] == myUid;
                                final isFreelancer = row['freelancer_user_id'] == myUid;
                                final amount = double.tryParse(row['amount']?.toString() ?? '0') ?? 0;
                                final currency = row['currency'] as String? ?? 'USD';

                                return _buildMilestoneCard(
                                  row: row,
                                  status: status,
                                  isClient: isClient,
                                  isFreelancer: isFreelancer,
                                  amount: amount,
                                  currency: currency,
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final active = _filter == value;
    return ChoiceChip(
      label: Text(label),
      selected: active,
      onSelected: (_) => setState(() => _filter = value),
      selectedColor: ClivoraColors.primary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
        color: active ? ClivoraColors.primaryDark : ClivoraColors.textSecondary,
      ),
    );
  }

  Widget _buildMilestoneCard({
    required Map<String, dynamic> row,
    required String status,
    required bool isClient,
    required bool isFreelancer,
    required double amount,
    required String currency,
  }) {
    Color badgeColor;
    Color badgeTextColor;
    String statusText;

    switch (status) {
      case 'funded':
        badgeColor = Colors.blue.shade50;
        badgeTextColor = Colors.blue.shade800;
        statusText = 'Funded in Escrow';
        break;
      case 'submitted':
        badgeColor = Colors.purple.shade50;
        badgeTextColor = Colors.purple.shade800;
        statusText = 'Submitted · In Review';
        break;
      case 'released':
        badgeColor = Colors.green.shade50;
        badgeTextColor = Colors.green.shade800;
        statusText = 'Escrow Released';
        break;
      case 'disputed':
        badgeColor = Colors.red.shade50;
        badgeTextColor = Colors.red.shade800;
        statusText = 'Disputed';
        break;
      case 'pending_funding':
      default:
        badgeColor = Colors.amber.shade50;
        badgeTextColor = Colors.amber.shade900;
        statusText = 'Awaiting Deposit';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  row['title'] as String? ?? 'Contract Milestone',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            formatCurrency(amount, symbol: currencySymbol(currency)),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: ClivoraColors.primaryDark,
            ),
          ),
          if (row['notes'] != null && (row['notes'] as String).isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              row['notes'] as String,
              style: TextStyle(fontSize: 12, color: ClivoraColors.textSecondary),
            ),
          ],
          if (status == 'submitted') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.purple.shade50.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.timer_outlined, size: 16, color: Colors.purple.shade700),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '14-Day Auto-Release Protection: Work submitted for review.',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isFreelancer && status == 'funded')
                FilledButton.icon(
                  onPressed: () => _submitDeliverable(row),
                  icon: const Icon(Icons.upload_file, size: 16),
                  label: const Text('Submit Deliverable'),
                  style: FilledButton.styleFrom(
                    backgroundColor: ClivoraColors.primary,
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              if (isClient && status == 'submitted') ...[
                OutlinedButton(
                  onPressed: () => _raiseDispute(row),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ClivoraColors.errorRed,
                    side: const BorderSide(color: ClivoraColors.errorRed),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Raise Dispute'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => _approveRelease(row),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Approve & Release'),
                  style: FilledButton.styleFrom(
                    backgroundColor: ClivoraColors.successGreen,
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
