import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/clivora_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';

/// Read-only invoices shared with the client via linked projects.
class ClientInvoicesScreen extends ConsumerWidget {
  const ClientInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(clientInvoicesProvider);

    return ClivoraScaffold(
      title: 'Invoices',
      body: invoicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (invoices) {
          if (invoices.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 56, color: ClivoraColors.clientMuted),
                    const SizedBox(height: 16),
                    Text('No invoices shared', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Invoices linked to your shared projects will appear here.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: invoices.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final inv = invoices[index];
              final statusColor = inv.status == 'paid'
                  ? ClivoraColors.successGreen
                  : inv.status == 'overdue'
                      ? ClivoraColors.errorRed
                      : ClivoraColors.clientAccent;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.receipt_outlined, color: statusColor),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(inv.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.w700)),
                          Text(
                            inv.status.replaceAll('_', ' ').toUpperCase(),
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor),
                          ),
                        ],
                      ),
                    ),
                    Text(formatCurrency(inv.total, symbol: currencySymbol(inv.currency)), style: const TextStyle(fontWeight: FontWeight.w800)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
