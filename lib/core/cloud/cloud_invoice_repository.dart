import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../data/database/database.dart';
import '../constants/invoice_statuses.dart';
import '../services/cloud_write_guard.dart';
import 'cloud_notification_repository.dart';
import 'cloud_message_repository.dart';
import 'supabase_auth_helper.dart';
import 'supabase_sync_service.dart';

final cloudInvoiceRepositoryProvider = Provider<CloudInvoiceRepository>((ref) {
  return CloudInvoiceRepository(ref);
});

class CloudInvoiceShare {
  CloudInvoiceShare({
    required this.shareId,
    required this.freelancerUid,
    required this.clientEmail,
    required this.invoiceNumber,
    required this.status,
    required this.total,
    required this.currency,
    this.clientUid,
    this.localInvoiceId = 0,
    this.localProjectId,
    this.dueDate,
    this.paymentMethod = '',
    this.paymentNote = '',
    this.clientPaidAt,
    this.updatedAt,
    this.expiresAt,
  });

  final String shareId;
  final String freelancerUid;
  final String clientEmail;
  final String? clientUid;
  final int localInvoiceId;
  final int? localProjectId;
  final String invoiceNumber;
  final String status;
  final double total;
  final String currency;
  final DateTime? dueDate;
  final String paymentMethod;
  final String paymentNote;
  final DateTime? clientPaidAt;
  final DateTime? updatedAt;
  final DateTime? expiresAt;

  bool get canClientPay => InvoiceStatuses.canClientPay(status);

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!.toLocal());

  factory CloudInvoiceShare.fromRow(Map<String, dynamic> row) {
    return CloudInvoiceShare(
      shareId: row['share_id'] as String,
      freelancerUid: row['freelancer_uid'] as String? ?? '',
      clientEmail: row['client_email'] as String? ?? '',
      clientUid: row['client_uid'] as String?,
      localInvoiceId: (row['local_invoice_id'] as num?)?.toInt() ?? 0,
      localProjectId: (row['local_project_id'] as num?)?.toInt(),
      invoiceNumber: row['invoice_number'] as String? ?? '',
      status: row['status'] as String? ?? 'draft',
      total: (row['total'] as num?)?.toDouble() ?? 0,
      currency: row['currency'] as String? ?? 'USD',
      dueDate: row['due_date'] != null ? DateTime.tryParse(row['due_date'] as String) : null,
      paymentMethod: row['payment_method'] as String? ?? '',
      paymentNote: row['payment_note'] as String? ?? '',
      clientPaidAt: row['client_paid_at'] != null ? DateTime.tryParse(row['client_paid_at'] as String) : null,
      updatedAt: row['updated_at'] != null ? DateTime.tryParse(row['updated_at'] as String) : null,
      expiresAt: row['expires_at'] != null ? DateTime.tryParse(row['expires_at'] as String) : null,
    );
  }
}

class CloudInvoiceRepository {
  CloudInvoiceRepository(this.ref);

  final Ref ref;

  SupabaseClient get _db => SupabaseAuthHelper.client;

  String shareIdFor({required String freelancerUid, required int localInvoiceId}) =>
      '${freelancerUid}_$localInvoiceId';

  Future<void> syncInvoiceToClient({
    required User freelancer,
    required Invoice invoice,
    required String clientEmail,
    String? clientUid,
  }) async {
    final uid = SupabaseAuthHelper.currentUid;
    if (uid == null || uid.isEmpty) return;
    if (invoice.status == 'draft') return;

    final shareId = shareIdFor(freelancerUid: uid, localInvoiceId: invoice.id);
    await ref.read(cloudWriteGuardProvider).runOrEnqueue(
          kind: 'invoice_sync',
          payload: {
            'invoiceId': invoice.id,
            'clientEmail': clientEmail,
            if (clientUid != null) 'clientUid': clientUid,
          },
          action: () => _upsertShare(
                freelancer: freelancer,
                invoice: invoice,
                clientEmail: clientEmail,
                clientUid: clientUid,
                shareId: shareId,
                uid: uid,
              ),
        );
  }

  Future<void> _upsertShare({
    required User freelancer,
    required Invoice invoice,
    required String clientEmail,
    String? clientUid,
    required String shareId,
    required String uid,
  }) async {
    try {
      final expiresAt = DateTime.now().toUtc().add(const Duration(days: 90));
      await _db.from('invoice_shares').upsert({
        'share_id': shareId,
        'freelancer_uid': uid,
        'freelancer_email': freelancer.email.trim().toLowerCase(),
        'client_email': clientEmail.trim().toLowerCase(),
        if (clientUid != null) 'client_uid': clientUid,
        'local_invoice_id': invoice.id,
        if (invoice.projectId != null) 'local_project_id': invoice.projectId,
        'invoice_number': invoice.invoiceNumber,
        'status': invoice.status,
        'total': invoice.total,
        'currency': invoice.currency,
        if (invoice.dueDate != null) 'due_date': invoice.dueDate!.toUtc().toIso8601String(),
        'expires_at': expiresAt.toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });

      if (invoice.status == 'sent') {
        await ref.read(cloudNotificationRepositoryProvider).send(
              toEmail: clientEmail,
              title: 'Invoice ${invoice.invoiceNumber}',
              body: 'You have a new invoice for ${invoice.currency} ${invoice.total.toStringAsFixed(2)}. Open Invoices to review and confirm payment.',
              kind: 'invoice',
            );
      }
    } catch (e) {
      debugPrint('Invoice share sync failed: $e');
      rethrow;
    }
  }

  Stream<List<CloudInvoiceShare>> watchForClient({required String email, String? uid}) {
    if (uid != null && uid.isNotEmpty) {
      return _db
          .from('invoice_shares')
          .stream(primaryKey: ['share_id'])
          .eq('client_uid', uid)
          .map((rows) => _visibleToClient(rows.map(CloudInvoiceShare.fromRow).toList()));
    }
    return _db
        .from('invoice_shares')
        .stream(primaryKey: ['share_id'])
        .eq('client_email', email.trim().toLowerCase())
        .map((rows) => _visibleToClient(rows.map(CloudInvoiceShare.fromRow).toList()));
  }

  List<CloudInvoiceShare> _visibleToClient(List<CloudInvoiceShare> list) {
    final now = DateTime.now();
    return list
        .where((i) => i.status != 'draft')
        .where((i) => i.expiresAt == null || i.expiresAt!.isAfter(now))
        .toList()
      ..sort((a, b) => (b.updatedAt ?? DateTime(2000)).compareTo(a.updatedAt ?? DateTime(2000)));
  }

  Future<void> updateShareStatus({
    required String shareId,
    required String status,
  }) async {
    await _db.from('invoice_shares').update({
      'status': status,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('share_id', shareId);
  }

  Future<void> confirmPaymentByClient({
    required CloudInvoiceShare share,
    required User client,
    required String paymentMethod,
    required String paymentNote,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await _db.from('invoice_shares').update({
      'status': 'paid',
      'payment_method': paymentMethod,
      'payment_note': paymentNote,
      'client_paid_at': now,
      'updated_at': now,
    }).eq('share_id', share.shareId);

    final freelancerEmail = await _emailForUid(share.freelancerUid);
    if (freelancerEmail != null) {
      await ref.read(cloudNotificationRepositoryProvider).send(
            toEmail: freelancerEmail,
            title: 'Payment received: ${share.invoiceNumber}',
            body: '${client.name} marked invoice as paid via $paymentMethod.',
            kind: 'invoice',
          );
      await ref.read(cloudMessageRepositoryProvider).sendHybrid(
            fromUser: client,
            toEmail: freelancerEmail,
            subject: '[Payment] ${share.invoiceNumber}',
            body: 'Payment confirmed via $paymentMethod.\nAmount: ${share.currency} ${share.total.toStringAsFixed(2)}'
                '${paymentNote.isNotEmpty ? '\nNote: $paymentNote' : ''}',
          );
    }
  }

  Future<String?> _emailForUid(String uid) async {
    final row = await _db.from('profiles').select('email').eq('id', uid).maybeSingle();
    return row?['email'] as String?;
  }
}
