import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/plan_limits.dart';
import '../../core/services/invoice_share_helper.dart';
import '../../core/services/sync_outbox_service.dart';
import '../../core/utils/navigation_helper.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/database/database.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';
import '../../shared/widgets/clivora_bottom_sheet.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/filter_chip_row.dart';
import '../../shared/widgets/stat_summary_card.dart';

class InvoicesScreen extends ConsumerStatefulWidget {
  const InvoicesScreen({super.key, this.initialFilter});

  final String? initialFilter;

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  late String _status;

  @override
  void initState() {
    super.initState();
    _status = widget.initialFilter ?? 'all';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(syncOutboxServiceProvider).reconcileInvoiceShares();
      if (mounted) await showInvoiceConflictDialog(context, ref);
    });
  }

  @override
  void didUpdateWidget(covariant InvoicesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFilter != null && widget.initialFilter != _status) {
      _status = widget.initialFilter!;
    }
  }

  Future<void> _onAddInvoice() async {
    await tryOpenWithPlanCheck(
      context,
      ref: ref,
      canAdd: () => ref.read(planLimitServiceProvider).canAddInvoice(),
      path: '/invoices/new',
      resource: 'invoices this month',
      max: PlanLimits.freeMaxInvoicesPerMonth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(invoicesProvider(_status == 'all' ? null : _status));
    final statsAsync = ref.watch(invoiceStatsProvider);
    final monthlyCountAsync = ref.watch(monthlyInvoiceCountProvider);

    return ClivoraScaffold(
      title: 'Invoices',
      showMessagesButton: true,
      action: ClivoraIconButton(icon: Icons.add, onPressed: _onAddInvoice),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          statsAsync.when(
            loading: () => const SizedBox(height: 80),
            error: (_, __) => const SizedBox.shrink(),
            data: (stats) => StatSummaryCard(
              items: [
                StatItem(label: 'Total', value: '${stats.total}'),
                StatItem(label: 'Outstanding', value: formatCurrency(stats.outstanding), valueColor: ClivoraColors.warningOrange),
                StatItem(label: 'Paid', value: formatCurrency(stats.paid), valueColor: ClivoraColors.successGreen),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilterChipRow(
            options: const ['all', 'draft', 'sent', 'paid', 'overdue', 'outstanding'],
            selected: _status,
            onSelected: (v) => setState(() => _status = v),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => context.push('/recurring-invoices'),
              icon: const Icon(Icons.autorenew, size: 18),
              label: const Text('Recurring'),
            ),
          ),
          monthlyCountAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (count) => PlanLimitBanner(
              current: count,
              max: PlanLimits.freeMaxInvoicesPerMonth,
              resource: 'invoices this month',
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: invoicesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (invoices) {
                final total = statsAsync.valueOrNull?.total ?? invoices.length;
                final isFiltered = _status != 'all';
                if (invoices.isEmpty) {
                  if (isFiltered && total > 0) {
                    return EmptyState(
                      icon: Icons.receipt_long_outlined,
                      message: 'No $_status invoices',
                    );
                  }
                  return EmptyState(
                    icon: Icons.receipt_long_outlined,
                    message: 'No invoices yet',
                    actionLabel: 'Create invoice',
                    onAction: _onAddInvoice,
                  );
                }
                return ListView.separated(
                  itemCount: invoices.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final inv = invoices[index];
                    return Dismissible(
                      key: ValueKey(inv.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete invoice?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                  TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                                ],
                              ),
                            ) ??
                            false;
                      },
                      onDismissed: (_) {
                        ref.read(databaseProvider).deleteInvoice(inv.id);
                      },
                      child: ListTile(
                        onTap: () => openFormRoute(context, '/invoices/${inv.id}/edit'),
                        tileColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Theme.of(context).dividerColor),
                        ),
                        leading: Icon(Icons.receipt_long, color: _statusColor(inv.status)),
                        title: Text(inv.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(_invoiceSubtitle(inv)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(formatCurrency(inv.total, symbol: currencySymbol(inv.currency))),
                                if (inv.amountPaid > 0 && inv.status != 'paid')
                                  Text(
                                    'Paid ${formatCurrency(inv.amountPaid, symbol: currencySymbol(inv.currency))}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: ClivoraColors.successGreen,
                                        ),
                                  ),
                              ],
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, size: 20),
                              onSelected: (action) {
                                if (action == 'share') {
                                  shareInvoicePdf(ref, context, inv.id);
                                } else if (action == 'edit') {
                                  openFormRoute(context, '/invoices/${inv.id}/edit');
                                }
                              },
                              itemBuilder: (ctx) => const [
                                PopupMenuItem(value: 'share', child: Text('Share PDF')),
                                PopupMenuItem(value: 'edit', child: Text('Edit')),
                              ],
                            ),
                          ],
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

  Color _statusColor(String status) {
    switch (status) {
      case 'paid':
        return ClivoraColors.successGreen;
      case 'overdue':
        return ClivoraColors.errorRed;
      case 'sent':
        return ClivoraColors.warningOrange;
      default:
        return ClivoraColors.textSecondary;
    }
  }

  String _statusLabel(String status) {
    return status[0].toUpperCase() + status.substring(1);
  }

  String _invoiceSubtitle(Invoice inv) {
    final status = _statusLabel(inv.status);
    if (inv.status == 'paid' || inv.status == 'draft') return status;
    final due = inv.dueDate ?? inv.issueDate;
    final days = DateTime.now().difference(due).inDays;
    if (days <= 0) return '$status · Current';
    if (days <= 30) return '$status · ${days}d (1–30)';
    if (days <= 60) return '$status · ${days}d (31–60)';
    return '$status · ${days}d (60+)';
  }
}
