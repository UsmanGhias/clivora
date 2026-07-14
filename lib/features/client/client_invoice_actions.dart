import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/auth/auth_service.dart';
import '../../core/cloud/cloud_invoice_repository.dart';
import '../../core/constants/invoice_statuses.dart';
import '../../core/services/client_invoice_helper.dart';
import '../../core/services/dispute_service.dart';
import '../../core/services/sync_outbox_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/database/database.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';

/// Fullscreen invoice detail + payment confirmation for clients.
Future<void> showClientInvoiceActions(
  BuildContext context,
  WidgetRef ref, {
  Invoice? localInvoice,
  CloudInvoiceShare? cloudShare,
}) async {
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => ClientInvoiceDetailScreen(
        localInvoice: localInvoice,
        cloudShare: cloudShare,
      ),
    ),
  );
}

class ClientInvoiceDetailScreen extends ConsumerStatefulWidget {
  const ClientInvoiceDetailScreen({
    super.key,
    this.localInvoice,
    this.cloudShare,
  });

  final Invoice? localInvoice;
  final CloudInvoiceShare? cloudShare;

  @override
  ConsumerState<ClientInvoiceDetailScreen> createState() =>
      _ClientInvoiceDetailScreenState();
}

class _ClientInvoiceDetailScreenState
    extends ConsumerState<ClientInvoiceDetailScreen> {
  CloudInvoiceShare? _share;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _share = widget.cloudShare;
  }

  @override
  Widget build(BuildContext context) {
    final invoice = widget.localInvoice;
    final share = _share;
    final status = share?.status ?? invoice?.status ?? 'draft';
    final canPay = share?.canClientPay ?? (status == 'sent' || status == 'overdue');

    return ClivoraScaffold(
      title: share?.invoiceNumber ?? invoice?.invoiceNumber ?? 'Invoice',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(label: Text(status.replaceAll('_', ' ').toUpperCase())),
          ),
          const SizedBox(height: 12),
          Text(
            formatCurrency(
              share?.total ?? invoice?.total ?? 0,
              symbol: currencySymbol(share?.currency ?? invoice?.currency ?? 'USD'),
            ),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          if (share?.paymentMethod.isNotEmpty == true) ...[
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.payment_outlined),
              title: const Text('Payment method'),
              subtitle: Text(share!.paymentMethod),
            ),
          ],
          if (share?.paymentNote.isNotEmpty == true)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.note_outlined),
              title: const Text('Payment note'),
              subtitle: Text(share!.paymentNote),
            ),
          if (share?.clientPaidAt != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle_outline, color: ClivoraColors.successGreen),
              title: const Text('Paid on'),
              subtitle: Text(DateFormat.yMMMd().add_jm().format(share!.clientPaidAt!.toLocal())),
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              if (invoice != null) {
                await previewClientInvoice(ref, context, invoice);
              } else if (share != null) {
                await previewClientInvoiceFromShare(ref, context, share);
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invoice PDF not available')),
                );
              }
            },
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('View branded PDF'),
          ),
          if (status != InvoiceStatuses.disputed &&
              status != InvoiceStatuses.paid &&
              status != InvoiceStatuses.canceled &&
              status != InvoiceStatuses.draft) ...[
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                final reasonCtrl = TextEditingController();
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (dCtx) => AlertDialog(
                    title: const Text('Raise dispute'),
                    content: TextField(
                      controller: reasonCtrl,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'What is wrong with this invoice?',
                        hintText: 'Amount, deliverable, or billing issue…',
                      ),
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(dCtx, false), child: const Text('Cancel')),
                      FilledButton(onPressed: () => Navigator.pop(dCtx, true), child: const Text('Submit')),
                    ],
                  ),
                );
                if (ok != true) return;
                final client = ref.read(authStateProvider).valueOrNull;
                String? err;
                if (share != null && client != null) {
                  err = await ref.read(disputeServiceProvider).raiseDisputeOnCloudShare(
                        share: share,
                        reason: reasonCtrl.text,
                        raisedByEmail: client.email,
                      );
                } else if (invoice != null && client != null) {
                  err = await ref.read(disputeServiceProvider).raiseDispute(
                        invoice: invoice,
                        reason: reasonCtrl.text,
                        raisedByEmail: client.email,
                      );
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(err ?? 'Dispute submitted. Your freelancer was notified.')),
                  );
                }
                ref.invalidate(clientCloudInvoicesProvider);
                ref.invalidate(clientInvoicesProvider);
              },
              icon: const Icon(Icons.gavel_outlined),
              label: const Text('Raise dispute'),
            ),
          ],
          if (canPay) ...[
            const SizedBox(height: 28),
            Text('Confirm payment', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _PaymentForm(
              saving: _saving,
              onSubmit: (method, note) async {
                final client = ref.read(authStateProvider).valueOrNull;
                if (client == null || share == null) return;
                setState(() => _saving = true);
                try {
                  await ref.read(cloudInvoiceRepositoryProvider).confirmPaymentByClient(
                        share: share,
                        client: client,
                        paymentMethod: method,
                        paymentNote: note,
                      );
                  // Immediately pull paid status into local freelancer views.
                  await ref.read(syncOutboxServiceProvider).reconcileInvoiceShares();
                  ref.invalidate(clientCloudInvoicesProvider);
                  ref.invalidate(clientInvoicesProvider);
                  if (mounted) {
                    setState(() {
                      _share = CloudInvoiceShare(
                        shareId: share.shareId,
                        freelancerUid: share.freelancerUid,
                        clientUid: share.clientUid,
                        clientEmail: share.clientEmail,
                        invoiceNumber: share.invoiceNumber,
                        currency: share.currency,
                        total: share.total,
                        status: 'paid',
                        paymentMethod: method,
                        paymentNote: note,
                        paymentReference: note,
                        clientPaidAt: DateTime.now().toUtc(),
                        freelancerConfirmed: share.freelancerConfirmed,
                        expiresAt: share.expiresAt,
                        updatedAt: DateTime.now().toUtc(),
                        localInvoiceId: share.localInvoiceId,
                        localProjectId: share.localProjectId,
                        dueDate: share.dueDate,
                        publicToken: share.publicToken,
                      );
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment submitted. Your freelancer has been notified')),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _saving = false);
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _PaymentForm extends StatefulWidget {
  const _PaymentForm({required this.onSubmit, this.saving = false});

  final Future<void> Function(String method, String note) onSubmit;
  final bool saving;

  @override
  State<_PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<_PaymentForm> {
  var _method = 'Bank transfer';
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          value: _method,
          decoration: const InputDecoration(labelText: 'Payment method'),
          items: const [
            DropdownMenuItem(value: 'JazzCash', child: Text('JazzCash')),
            DropdownMenuItem(value: 'EasyPaisa', child: Text('EasyPaisa')),
            DropdownMenuItem(value: 'Bank transfer', child: Text('Bank transfer')),
            DropdownMenuItem(value: 'PayPal', child: Text('PayPal')),
            DropdownMenuItem(value: 'Stripe', child: Text('Stripe / Card')),
            DropdownMenuItem(value: 'Cash', child: Text('Cash')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
          onChanged: (v) => setState(() => _method = v ?? _method),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _noteCtrl,
          decoration: const InputDecoration(
            labelText: 'Reference / receipt note',
            hintText: 'Transaction ID, screenshot note, etc. (optional)',
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: widget.saving
              ? null
              : () async {
                  await widget.onSubmit(_method, _noteCtrl.text.trim());
                },
          style: FilledButton.styleFrom(backgroundColor: ClivoraColors.clientAccent),
          child: widget.saving
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Mark as paid'),
        ),
      ],
    );
  }
}
