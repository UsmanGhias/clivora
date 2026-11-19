import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/user_roles.dart';
import '../../core/services/marketplace/connect_marketplace_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../shared/widgets/clivora_scaffold.dart';
import '../../shared/widgets/empty_state.dart';

class ConnectProposalsScreen extends ConsumerStatefulWidget {
  const ConnectProposalsScreen({super.key});

  @override
  ConsumerState<ConnectProposalsScreen> createState() =>
      _ConnectProposalsScreenState();
}

class _ConnectProposalsScreenState
    extends ConsumerState<ConnectProposalsScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _proposals = [];

  @override
  void initState() {
    super.initState();
    _loadProposals();
  }

  Future<void> _loadProposals() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final user = ref.read(authStateProvider).valueOrNull;
      final isClient = isClientUser(user);
      final svc = ref.read(connectMarketplaceServiceProvider);
      final list = isClient
          ? await svc.fetchReceivedProposals()
          : await svc.fetchMyProposals();
      if (!mounted) return;
      setState(() {
        _proposals = list;
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

  Future<void> _handleAccept(Map<String, dynamic> row) async {
    final id = row['id'] as String;
    final amount = double.tryParse(row['amount']?.toString() ?? '1') ?? 1;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Accept Proposal & Create Escrow'),
        content: Text(
          'Accepting this bid will create a protected escrow milestone for \$${amount.toStringAsFixed(0)} at 0% platform fee.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: ClivoraColors.primary),
            child: const Text('Accept Bid'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final svc = ref.read(connectMarketplaceServiceProvider);
      await svc.acceptProposal(
        proposalId: id,
        clientUserId: row['to_user_id']?.toString() ?? '',
        freelancerUserId: row['from_user_id']?.toString() ?? '',
        amount: amount,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proposal accepted. Kickoff milestone created.')),
      );
      _loadProposals();
      // Navigate to milestones screen
      context.push('/connect/milestones');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: ClivoraColors.errorRed),
      );
    }
  }

  Future<void> _handleAction(String id, bool shortlist) async {
    try {
      final svc = ref.read(connectMarketplaceServiceProvider);
      if (shortlist) {
        await svc.shortlistProposal(id);
      } else {
        await svc.declineProposal(id);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(shortlist ? 'Candidate shortlisted' : 'Proposal declined')),
      );
      _loadProposals();
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
    final isClient = isClientUser(user);

    return ClivoraScaffold(
      title: isClient ? 'Received Proposals' : 'My Proposals',
      showBackButton: true,
      action: IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: _loading ? null : _loadProposals,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: ClivoraColors.errorRed)))
              : _proposals.isEmpty
                  ? EmptyState(
                      icon: Icons.description_outlined,
                      message: isClient
                          ? 'No proposals received for your listings yet.'
                          : 'You have not submitted any proposals yet.',
                    )
                  : RefreshIndicator(
                      onRefresh: _loadProposals,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _proposals.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final row = _proposals[i];
                          final status = row['status'] as String? ?? 'pending';
                          final amount = double.tryParse(row['amount']?.toString() ?? '0') ?? 0;
                          final currency = row['currency'] as String? ?? 'USD';
                          final timeline = row['timeline_days']?.toString();
                          final message = row['message'] as String? ?? '';

                          Color badgeBg = Colors.blueGrey.shade50;
                          Color badgeText = Colors.blueGrey.shade800;
                          if (status == 'accepted') {
                            badgeBg = Colors.green.shade50;
                            badgeText = Colors.green.shade800;
                          } else if (status == 'shortlisted') {
                            badgeBg = Colors.blue.shade50;
                            badgeText = Colors.blue.shade800;
                          } else if (status == 'declined') {
                            badgeBg = Colors.red.shade50;
                            badgeText = Colors.red.shade800;
                          }

                          return Container(
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatCurrency(amount, symbol: currencySymbol(currency)),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: ClivoraColors.primaryDark,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: badgeBg,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        status.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: badgeText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (timeline != null && timeline.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Estimated Timeline: $timeline days',
                                    style: TextStyle(fontSize: 12, color: ClivoraColors.textSecondary),
                                  ),
                                ],
                                if (message.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    message,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13, height: 1.4),
                                  ),
                                ],
                                if (isClient && (status == 'pending' || status == 'shortlisted')) ...[
                                  const SizedBox(height: 14),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () => _handleAction(row['id'] as String, false),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: ClivoraColors.textSecondary,
                                          side: BorderSide(color: Colors.blueGrey.shade300),
                                        ),
                                        child: const Text('Decline'),
                                      ),
                                      const SizedBox(width: 8),
                                      if (status != 'shortlisted') ...[
                                        OutlinedButton(
                                          onPressed: () => _handleAction(row['id'] as String, true),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: ClivoraColors.primary,
                                            side: const BorderSide(color: ClivoraColors.primary),
                                          ),
                                          child: const Text('Shortlist'),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      FilledButton(
                                        onPressed: () => _handleAccept(row),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: ClivoraColors.primary,
                                        ),
                                        child: const Text('Accept & Escrow'),
                                      ),
                                    ],
                                  ),
                                ],
                                if (status == 'accepted') ...[
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () => context.push('/connect/milestones'),
                                      icon: const Icon(Icons.arrow_forward, size: 14),
                                      label: const Text('View Escrow Milestone'),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
