import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/cloud/cloud_invoice_repository.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/database/database.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';
import '../../shared/widgets/filter_chip_row.dart';
import '../../shared/widgets/stat_summary_card.dart';
import 'client_invoice_actions.dart';

/// Client invoices, cloud sync, PDF view, mark paid with payment method.
class ClientInvoicesScreen extends ConsumerStatefulWidget {
  const ClientInvoicesScreen({super.key});

  @override
  ConsumerState<ClientInvoicesScreen> createState() => _ClientInvoicesScreenState();
}

class _ClientInvoicesScreenState extends ConsumerState<ClientInvoicesScreen> {
  String _status = 'all';

  List<_InvoiceListItem> _mergeItems(
    List<CloudInvoiceShare> cloudList,
    List<Invoice> localList,
  ) {
    if (cloudList.isNotEmpty) {
      return cloudList
          .map((s) => _InvoiceListItem.fromCloud(s, localList))
          .toList();
    }
    return localList
        .where((i) => i.status != 'draft')
        .map(_InvoiceListItem.fromLocal)
        .toList();
  }

  List<_InvoiceListItem> _filter(List<_InvoiceListItem> items) {
    if (_status == 'all') return items;
    if (_status == 'outstanding') {
      return items
          .where((i) => i.status == 'sent' || i.status == 'overdue' || i.status == 'viewed')
          .toList();
    }
    return items.where((i) => i.status == _status).toList();
  }

  _ClientInvoiceStats _stats(List<_InvoiceListItem> items) {
    var outstanding = 0.0;
    var paid = 0.0;
    for (final item in items) {
      if (item.status == 'paid') {
        paid += item.total;
      } else if (item.status != 'draft' && item.status != 'cancelled') {
        outstanding += item.total;
      }
    }
    return _ClientInvoiceStats(
      total: items.length,
      outstanding: outstanding,
      paid: paid,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cloudAsync = ref.watch(clientCloudInvoicesProvider);
    final localAsync = ref.watch(clientInvoicesProvider);

    return ClivoraScaffold(
      title: 'Invoices',
      subtitle: 'Review and pay invoices from your freelancer',
      showBackButton: true,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(clientCloudInvoicesProvider);
          ref.invalidate(clientInvoicesProvider);
        },
        child: cloudAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (cloudList) {
            final localList = localAsync.valueOrNull ?? [];
            final allItems = _mergeItems(cloudList, localList);
            final stats = _stats(allItems);
            final filtered = _filter(allItems);

            if (allItems.isEmpty) {
              return ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 56,
                              color: ClivoraColors.clientMuted,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No invoices yet',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'When your freelancer sends an invoice, it will appear here with payment details and confirmations.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: () => context.push('/client-link-freelancer'),
                              icon: const Icon(Icons.person_add_alt_1_outlined),
                              label: const Text('Add your freelancer'),
                              style: FilledButton.styleFrom(
                                backgroundColor: ClivoraColors.clientAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                StatSummaryCard(
                  items: [
                    StatItem(
                      label: 'Total Invoices',
                      value: '${stats.total}',
                      icon: Icons.description_outlined,
                      iconColor: ClivoraColors.clientAccent,
                    ),
                    StatItem(
                      label: 'Outstanding',
                      value: formatCurrency(stats.outstanding),
                      valueColor: ClivoraColors.warningOrange,
                      icon: Icons.error_outline,
                      iconColor: ClivoraColors.warningOrange,
                    ),
                    StatItem(
                      label: 'Paid',
                      value: formatCurrency(stats.paid),
                      valueColor: ClivoraColors.successGreen,
                      icon: Icons.check_circle_outline,
                      iconColor: ClivoraColors.successGreen,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                FilterChipRow(
                  options: const ['all', 'outstanding', 'paid', 'overdue'],
                  selected: _status,
                  onSelected: (v) => setState(() => _status = v),
                ),
                const SizedBox(height: 14),
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Center(
                      child: Text(
                        'No invoices match this filter.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: ClivoraColors.textSecondary,
                            ),
                      ),
                    ),
                  )
                else
                  ...filtered.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _InvoiceCard(
                        invoiceNumber: item.invoiceNumber,
                        status: item.status,
                        total: item.total,
                        currency: item.currency,
                        dueDate: item.dueDate,
                        canPay: item.canPay,
                        onTap: () => item.showActions(context, ref),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ClientInvoiceStats {
  const _ClientInvoiceStats({
    required this.total,
    required this.outstanding,
    required this.paid,
  });

  final int total;
  final double outstanding;
  final double paid;
}

class _InvoiceListItem {
  const _InvoiceListItem({
    required this.invoiceNumber,
    required this.status,
    required this.total,
    required this.currency,
    required this.canPay,
    this.dueDate,
    this.localInvoice,
    this.cloudShare,
  });

  final String invoiceNumber;
  final String status;
  final double total;
  final String currency;
  final DateTime? dueDate;
  final bool canPay;
  final Invoice? localInvoice;
  final CloudInvoiceShare? cloudShare;

  factory _InvoiceListItem.fromCloud(
    CloudInvoiceShare share,
    List<Invoice> localInvoices,
  ) {
    Invoice? local;
    for (final inv in localInvoices) {
      if (inv.invoiceNumber == share.invoiceNumber) {
        local = inv;
        break;
      }
    }
    return _InvoiceListItem(
      invoiceNumber: share.invoiceNumber,
      status: share.status,
      total: share.total,
      currency: share.currency,
      dueDate: share.dueDate,
      canPay: share.canClientPay,
      localInvoice: local,
      cloudShare: share,
    );
  }

  factory _InvoiceListItem.fromLocal(Invoice invoice) {
    return _InvoiceListItem(
      invoiceNumber: invoice.invoiceNumber,
      status: invoice.status,
      total: invoice.total,
      currency: invoice.currency,
      dueDate: invoice.dueDate,
      canPay: invoice.status == 'sent' || invoice.status == 'overdue',
      localInvoice: invoice,
    );
  }

  void showActions(BuildContext context, WidgetRef ref) {
    showClientInvoiceActions(
      context,
      ref,
      localInvoice: localInvoice,
      cloudShare: cloudShare,
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({
    required this.invoiceNumber,
    required this.status,
    required this.total,
    required this.currency,
    required this.onTap,
    this.dueDate,
    this.canPay = false,
  });

  final String invoiceNumber;
  final String status;
  final double total;
  final String currency;
  final DateTime? dueDate;
  final bool canPay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = status == 'paid'
        ? ClivoraColors.successGreen
        : status == 'overdue'
            ? ClivoraColors.errorRed
            : ClivoraColors.clientAccent;

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? ClivoraColors.darkBorder : ClivoraColors.borderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: ClivoraColors.navyDark.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: ClivoraColors.clientSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.receipt_outlined, color: statusColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoiceNumber,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      status.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                        letterSpacing: 0.4,
                      ),
                    ),
                    if (dueDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Due ${DateFormat.yMMMd().format(dueDate!.toLocal())}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCurrency(total, symbol: currencySymbol(currency)),
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  Text(currency, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    canPay ? 'Tap to pay' : 'View details',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: canPay ? ClivoraColors.clientAccent : ClivoraColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: ClivoraColors.labelGray.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
