import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cloud/cloud_invoice_repository.dart';
import '../cloud/cloud_notification_repository.dart';
import '../cloud/cloud_project_repository.dart';
import '../cloud/supabase_auth_helper.dart';
import '../auth/auth_service.dart';
import '../../core/utils/crm_refresh.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/providers/app_providers.dart';
import 'admin_sync_service.dart';
import 'analytics_service.dart';
import 'audit_log_service.dart';
import 'connectivity_service.dart';
import 'tracking_service.dart';

final syncOutboxServiceProvider = Provider<SyncOutboxService>((ref) {
  return SyncOutboxService(ref);
});

/// Offline-first queue for cloud operations with retry and last-updated reconciliation.
class SyncOutboxService {
  SyncOutboxService(this.ref);

  final Ref ref;
  static const _storageKey = 'clivora_sync_outbox_v1';
  static const _maxRetries = 8;

  Future<void> enqueue(SyncOutboxItem item) async {
    final items = await _load();
    items.add(item);
    await _save(items);
    if (SupabaseAuthHelper.currentUid != null &&
        await ref.read(connectivityServiceProvider).isOnlineNow()) {
      await processQueue();
    }
  }

  Future<void> processQueue() async {
    if (SupabaseAuthHelper.currentUid == null) return;
    final items = await _load();
    if (items.isEmpty) return;

    final remaining = <SyncOutboxItem>[];
    var dropped = 0;
    for (final item in items) {
      try {
        final ok = await _execute(item);
        if (!ok) {
          final next = item.copyWith(retries: item.retries + 1);
          if (next.retries < _maxRetries) {
            remaining.add(next);
          } else {
            dropped++;
          }
        }
      } catch (e) {
        debugPrint('Sync outbox item failed: $e');
        final next = item.copyWith(retries: item.retries + 1);
        if (next.retries < _maxRetries) {
          remaining.add(next);
        } else {
          dropped++;
        }
      }
    }
    await _save(remaining);
    if (dropped > 0) {
      ref.read(syncFailureMessageProvider.notifier).state =
          '$dropped change(s) could not sync. Tap to retry when online.';
    } else if (remaining.isEmpty) {
      ref.read(syncFailureMessageProvider.notifier).state = null;
    } else {
      ref.read(syncFailureMessageProvider.notifier).state =
          '${remaining.length} change(s) pending sync…';
    }
  }

  Future<void> reconcileInvoiceShares() async {
    final uid = SupabaseAuthHelper.currentUid;
    final user = ref.read(authStateProvider).valueOrNull;
    if (uid == null || user == null) return;

    try {
      final rows = await SupabaseAuthHelper.client
          .from('invoice_shares')
          .select()
          .eq('freelancer_uid', uid);
      final db = ref.read(databaseProvider);
      for (final row in rows as List) {
        final localId = (row['local_invoice_id'] as num?)?.toInt();
        if (localId == null || localId <= 0) continue;
        final cloudStatus = row['status'] as String? ?? 'draft';
        final cloudUpdated = DateTime.tryParse(row['updated_at'] as String? ?? '');
        final invoice = await db.getInvoiceForUser(user.id, localId);
        if (invoice == null) continue;

        if (cloudUpdated != null && cloudUpdated.isAfter(invoice.updatedAt)) {
          if (invoice.status != cloudStatus) {
            await db.updateInvoice(invoice.copyWith(status: cloudStatus, updatedAt: cloudUpdated.toLocal()));
            if (cloudStatus == 'paid') {
              final method = row['payment_method'] as String? ?? '';
              final clientEmail = row['client_email'] as String? ?? '';
              await ref.read(trackingServiceProvider).logStatusChange(
                    entityType: 'invoice',
                    entityId: invoice.id,
                    status: 'paid',
                    note: method.isNotEmpty ? 'Client paid via $method' : 'Client confirmed payment',
                  );
              await ref.read(auditLogServiceProvider).logPaymentConfirmed(
                    invoiceNumber: invoice.invoiceNumber,
                    clientName: clientEmail,
                  );
            }
            ref.invalidate(invoicesProvider(null));
          }
        } else if (invoice.updatedAt.isAfter(cloudUpdated ?? DateTime(2000))) {
          await ref.read(cloudInvoiceRepositoryProvider).syncInvoiceToClient(
                freelancer: user,
                invoice: invoice,
                clientEmail: row['client_email'] as String? ?? '',
                clientUid: row['client_uid'] as String?,
              );
        }
      }
    } catch (e) {
      debugPrint('Invoice reconciliation failed: $e');
    }
  }

  Future<bool> _execute(SyncOutboxItem item) async {
    switch (item.kind) {
      case 'notification':
        final toUid = item.payload['toUid'] as String?;
        if (toUid != null && toUid.isNotEmpty) {
          await ref.read(cloudNotificationRepositoryProvider).sendToUid(
                toUid: toUid,
                title: item.payload['title'] as String? ?? '',
                body: item.payload['body'] as String? ?? '',
                kind: item.payload['kind'] as String? ?? 'info',
              );
        } else {
          await ref.read(cloudNotificationRepositoryProvider).send(
                toEmail: item.payload['toEmail'] as String? ?? '',
                title: item.payload['title'] as String? ?? '',
                body: item.payload['body'] as String? ?? '',
                kind: item.payload['kind'] as String? ?? 'info',
              );
        }
        return true;
      case 'analytics':
        await ref.read(analyticsServiceProvider).track(
              eventType: item.payload['eventType'] as String? ?? 'event',
              email: item.payload['email'] as String?,
              name: item.payload['name'] as String?,
              plan: item.payload['plan'] as String? ?? 'free',
              amount: (item.payload['amount'] as num?)?.toDouble() ?? 0,
              payload: item.payload['payload'] as String? ?? '{}',
            );
        return true;
      case 'admin_sync':
        await ref.read(adminSyncServiceProvider).flushPendingEvents();
        return true;
      case 'invoice_sync':
        final user = ref.read(authStateProvider).valueOrNull;
        if (user == null) return false;
        final invoiceId = (item.payload['invoiceId'] as num?)?.toInt();
        if (invoiceId == null) return false;
        final invoice = await ref.read(databaseProvider).getInvoiceForUser(user.id, invoiceId);
        if (invoice == null) return false;
        await ref.read(cloudInvoiceRepositoryProvider).syncInvoiceToClient(
              freelancer: user,
              invoice: invoice,
              clientEmail: item.payload['clientEmail'] as String? ?? '',
              clientUid: item.payload['clientUid'] as String?,
            );
        return true;
      case 'project_share':
        final user = ref.read(authStateProvider).valueOrNull;
        if (user == null) return false;
        final projectId = (item.payload['projectId'] as num?)?.toInt();
        if (projectId == null) return false;
        final project = await ref.read(databaseProvider).getProjectForUser(user.id, projectId);
        if (project == null) return false;
        await ref.read(cloudProjectRepositoryProvider).shareHybrid(
              freelancer: user,
              clientEmail: item.payload['clientEmail'] as String? ?? '',
              localProjectId: projectId,
              project: project,
            );
        return true;
      default:
        return true;
    }
  }

  Future<List<SyncOutboxItem>> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => SyncOutboxItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _save(List<SyncOutboxItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  Future<int> pendingCount() async => (await _load()).length;
}

class SyncOutboxItem {
  SyncOutboxItem({
    required this.kind,
    required this.payload,
    this.retries = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String kind;
  final Map<String, dynamic> payload;
  final int retries;
  final DateTime createdAt;

  SyncOutboxItem copyWith({int? retries}) => SyncOutboxItem(
        kind: kind,
        payload: payload,
        retries: retries ?? this.retries,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'kind': kind,
        'payload': payload,
        'retries': retries,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SyncOutboxItem.fromJson(Map<String, dynamic> json) => SyncOutboxItem(
        kind: json['kind'] as String? ?? '',
        payload: Map<String, dynamic>.from(json['payload'] as Map? ?? {}),
        retries: (json['retries'] as num?)?.toInt() ?? 0,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}
