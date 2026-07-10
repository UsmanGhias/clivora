import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/cloud/cloud_invoice_repository.dart';
import '../../core/cloud/supabase_auth_helper.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../shared/widgets/clivora_scaffold.dart';
import '../../shared/widgets/empty_state.dart';

final paymentConfirmationsProvider = StreamProvider<List<CloudInvoiceShare>>((ref) {
  final uid = SupabaseAuthHelper.currentUid;
  if (uid == null || uid.isEmpty) return const Stream.empty();
  return ref.watch(cloudInvoiceRepositoryProvider).watchUnconfirmedPayments(freelancerUid: uid);
});

/// Freelancer queue of client-paid invoices awaiting confirmation.
class PaymentConfirmationsScreen extends ConsumerWidget {
  const PaymentConfirmationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(paymentConfirmationsProvider);

    return ClivoraScaffold(
      title: 'Payment queue',
      showBackButton: true,
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.payments_outlined,
              message: 'No payments waiting for confirmation.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final share = items[i];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(share.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(share.clientEmail),
                    Text(
                      formatCurrency(share.total, symbol: currencySymbol(share.currency)),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (share.paymentMethod.isNotEmpty)
                      Text('via ${share.paymentMethod}', style: Theme.of(context).textTheme.bodySmall),
                    if (share.clientPaidAt != null)
                      Text(
                        'Paid ${DateFormat.yMMMd().add_jm().format(share.clientPaidAt!.toLocal())}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        onPressed: () async {
                          await ref
                              .read(cloudInvoiceRepositoryProvider)
                              .confirmPaymentByFreelancer(share.shareId);
                          ref.invalidate(paymentConfirmationsProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Confirmed ${share.invoiceNumber}')),
                            );
                          }
                        },
                        style: FilledButton.styleFrom(backgroundColor: ClivoraColors.successGreen),
                        child: const Text('Confirm'),
                      ),
                    ),
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
