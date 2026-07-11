import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cloud/cloud_crm_repository.dart';
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
  static const _conflictKey = 'clivora_invoice_conflicts_v1';

  Future<List<Map<String, dynamic>>> pendingConflicts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_conflictKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveConflicts(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_conflictKey, jsonEncode(items));
  }

  Future<void> addInvoiceConflict({
    required int localInvoiceId,
    required String localStatus,
    required String cloudStatus,
    required String shareId,
  }) async {
    await addEntityConflict(
      entityType: 'invoice',
      localId: localInvoiceId,
      localStatus: localStatus,
      cloudStatus: cloudStatus,
      shareId: shareId,
    );
  }

  /// Generic LWW/conflict record for any CRM entity (invoices, projects, customers, …).
  Future<void> addEntityConflict({
    required String entityType,
    required int localId,
    required String localStatus,
    required String cloudStatus,
    String? shareId,
  }) async {
    final list = await pendingConflicts();
    list.removeWhere(
      (e) => e['entityType'] == entityType && e['localId'] == localId ||
          (entityType == 'invoice' && e['localInvoiceId'] == localId),
    );
    list.add({
      'entityType': entityType,
      'localId': localId,
      'localInvoiceId': entityType == 'invoice' ? localId : null,
      'localStatus': localStatus,
      'cloudStatus': cloudStatus,
      'shareId': shareId,
      'at': DateTime.now().toIso8601String(),
    });
    await _saveConflicts(list);
    ref.read(syncFailureMessageProvider.notifier).state =
        '${entityType[0].toUpperCase()}${entityType.substring(1)} sync conflict — resolve when online.';
  }

  Future<List<Map<String, dynamic>>> pendingByEntity(String entityType) async {
    final all = await pendingConflicts();
    return all
        .where((e) => (e['entityType'] ?? 'invoice') == entityType)
        .toList();
  }

  Future<void> clearConflict(int localInvoiceId) async {
    final list = await pendingConflicts();
    list.removeWhere(
      (e) =>
          e['localInvoiceId'] == localInvoiceId ||
          (e['entityType'] == 'invoice' && e['localId'] == localInvoiceId),
    );
    await _saveConflicts(list);
  }

  Future<void> clearEntityConflict({
    required String entityType,
    required int localId,
  }) async {
    final list = await pendingConflicts();
    list.removeWhere(
      (e) =>
          e['entityType'] == entityType && e['localId'] == localId ||
          (entityType == 'invoice' && e['localInvoiceId'] == localId),
    );
    await _saveConflicts(list);
  }

  Future<void> resolveConflictKeepLocal({
    required int localInvoiceId,
    required String shareId,
    required String clientEmail,
    String? clientUid,
  }) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    final invoice = await ref.read(databaseProvider).getInvoiceForUser(user.id, localInvoiceId);
    if (invoice == null) return;
    await ref.read(cloudInvoiceRepositoryProvider).syncInvoiceToClient(
          freelancer: user,
          invoice: invoice,
          clientEmail: clientEmail,
          clientUid: clientUid,
        );
    await clearConflict(localInvoiceId);
  }

  Future<void> resolveConflictTakeCloud({
    required int localInvoiceId,
    required String cloudStatus,
  }) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    final invoice = await ref.read(databaseProvider).getInvoiceForUser(user.id, localInvoiceId);
    if (invoice == null) return;
    await ref.read(databaseProvider).updateInvoice(
          invoice.copyWith(status: cloudStatus, updatedAt: DateTime.now()),
        );
    await clearConflict(localInvoiceId);
    ref.invalidate(invoicesProvider(null));
  }

  /// Resolve non-invoice CRM conflicts (projects / customers).
  Future<void> resolveEntityConflict({
    required String entityType,
    required int localId,
    required bool takeCloud,
    String cloudStatus = '',
  }) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    if (takeCloud && cloudStatus.isNotEmpty) {
      try {
        if (entityType == 'project') {
          final project =
              await ref.read(databaseProvider).getProjectForUser(user.id, localId);
          if (project != null) {
            await ref.read(databaseProvider).updateProject(
                  project.copyWith(status: cloudStatus, updatedAt: DateTime.now()),
                );
            // Family provider — callers refresh on next watch; clear conflict is enough.
            
          }
        } else if (entityType == 'customer') {
          // Customers rarely have status conflicts — clear only.
        }
      } catch (_) {}
    }
    await clearEntityConflict(entityType: entityType, localId: localId);
  }

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
            // Always auto-apply when cloud is paid.
            if (cloudStatus == 'paid') {
              await db.updateInvoice(invoice.copyWith(status: cloudStatus, updatedAt: cloudUpdated.toLocal()));
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
              await clearConflict(invoice.id);
              ref.invalidate(invoicesProvider(null));
            } else if (invoice.status == 'paid') {
              // Local paid wins over non-paid cloud — push local.
              await ref.read(cloudInvoiceRepositoryProvider).syncInvoiceToClient(
                    freelancer: user,
                    invoice: invoice,
                    clientEmail: row['client_email'] as String? ?? '',
                    clientUid: row['client_uid'] as String?,
                  );
            } else {
              // Other conflicts (e.g. local overdue vs cloud sent) — defer to UI.
              await addInvoiceConflict(
                localInvoiceId: invoice.id,
                localStatus: invoice.status,
                cloudStatus: cloudStatus,
                shareId: row['share_id'] as String? ?? '',
              );
            }
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
      case 'crm_customer':
        final user = ref.read(authStateProvider).valueOrNull;
        final localId = (item.payload['localId'] as num?)?.toInt();
        if (user == null || localId == null) return false;
        await ref.read(cloudCrmRepositoryProvider).pushCustomer(
              ownerUserId: user.id,
              localId: localId,
            );
        return true;
      case 'crm_project':
        final user = ref.read(authStateProvider).valueOrNull;
        final localId = (item.payload['localId'] as num?)?.toInt();
        if (user == null || localId == null) return false;
        await ref.read(cloudCrmRepositoryProvider).pushProject(
              ownerUserId: user.id,
              localId: localId,
            );
        return true;
      case 'crm_invoice':
        final user = ref.read(authStateProvider).valueOrNull;
        final localId = (item.payload['localId'] as num?)?.toInt();
        if (user == null || localId == null) return false;
        await ref.read(cloudCrmRepositoryProvider).pushInvoice(
              ownerUserId: user.id,
              localId: localId,
            );
        return true;
      case 'crm_sync_all':
        await ref.read(cloudCrmRepositoryProvider).syncAllForSignedInUser();
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

/// Shows Keep local / Take cloud dialogs for pending sync conflicts
/// (invoices, projects, customers).
Future<void> showInvoiceConflictDialog(BuildContext context, WidgetRef ref) async {
  await showEntityConflictDialog(context, ref);
}

Future<void> showEntityConflictDialog(BuildContext context, WidgetRef ref) async {
  final outbox = ref.read(syncOutboxServiceProvider);
  final conflicts = await outbox.pendingConflicts();
  if (conflicts.isEmpty || !context.mounted) return;

  for (final c in List<Map<String, dynamic>>.from(conflicts)) {
    if (!context.mounted) return;
    final entityType = (c['entityType'] as String?) ?? 'invoice';
    final localId = (c['localId'] as num?)?.toInt() ??
        (c['localInvoiceId'] as num?)?.toInt();
    if (localId == null) continue;
    final localStatus = c['localStatus'] as String? ?? '';
    final cloudStatus = c['cloudStatus'] as String? ?? '';
    final shareId = c['shareId'] as String? ?? '';
    final label = entityType == 'project'
        ? 'Project'
        : entityType == 'customer'
            ? 'Client'
            : 'Invoice';

    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$label sync conflict'),
        content: Text(
          '$label #$localId differs: local is "$localStatus", cloud is "$cloudStatus".',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'local'),
            child: const Text('Keep local'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, 'cloud'),
            child: const Text('Take cloud'),
          ),
        ],
      ),
    );

    if (entityType == 'invoice') {
      if (choice == 'local') {
        String clientEmail = '';
        String? clientUid;
        try {
          final row = await SupabaseAuthHelper.client
              .from('invoice_shares')
              .select('client_email, client_uid')
              .eq('share_id', shareId)
              .maybeSingle();
          clientEmail = row?['client_email'] as String? ?? '';
          clientUid = row?['client_uid'] as String?;
        } catch (_) {}
        await outbox.resolveConflictKeepLocal(
          localInvoiceId: localId,
          shareId: shareId,
          clientEmail: clientEmail,
          clientUid: clientUid,
        );
      } else if (choice == 'cloud') {
        await outbox.resolveConflictTakeCloud(
          localInvoiceId: localId,
          cloudStatus: cloudStatus,
        );
      }
    } else {
      // Projects / customers: drop the conflict after user chooses a side.
      // Cloud-first for "Take cloud"; keep local by discarding the conflict entry.
      await outbox.resolveEntityConflict(
        entityType: entityType,
        localId: localId,
        takeCloud: choice == 'cloud',
        cloudStatus: cloudStatus,
      );
    }
  }

  final remaining = await outbox.pendingConflicts();
  if (remaining.isEmpty) {
    ref.read(syncFailureMessageProvider.notifier).state = null;
  }
}
