import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cloud/cloud_crm_repository.dart';
import '../cloud/cloud_invoice_repository.dart';
import '../cloud/cloud_message_repository.dart';
import '../cloud/cloud_notification_repository.dart';
import '../cloud/cloud_project_repository.dart';
import '../cloud/supabase_auth_helper.dart';
import '../cloud/supabase_sync_service.dart';
import '../auth/auth_service.dart';
import '../../core/utils/crm_refresh.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/providers/app_providers.dart';
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
  static const _deadLetterKey = 'clivora_sync_dead_letter_v1';
  static const _maxRetries = 8;

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
        '${entityType[0].toUpperCase()}${entityType.substring(1)} sync conflict, resolve when online.';
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
            // Family provider, callers refresh on next watch; clear conflict is enough.
            
          }
        } else if (entityType == 'customer') {
          // Customers rarely have status conflicts, clear only.
        }
      } catch (_) {}
    }
    await clearEntityConflict(entityType: entityType, localId: localId);
  }

  String _dedupeKey(SyncOutboxItem item) {
    final p = item.payload;
    switch (item.kind) {
      case 'crm_customer':
      case 'crm_project':
      case 'crm_invoice':
        return '${item.kind}:${p['localId']}';
      case 'invoice_sync':
        return 'invoice_sync:${p['invoiceId']}';
      case 'project_share':
        return 'project_share:${p['projectId']}:${p['clientEmail']}';
      case 'message_send':
        return 'message_send:${p['idempotencyKey'] ?? p['createdAt'] ?? ''}';
      case 'notification':
        return 'notification:${p['toUid'] ?? p['toEmail']}:${p['title']}:${p['body']}';
      case 'analytics':
        return 'analytics:${p['eventType']}:${p['email']}:${p['createdAt'] ?? ''}';
      default:
        return '${item.kind}:${jsonEncode(p)}';
    }
  }

  Future<List<Map<String, dynamic>>> deadLetterItems() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_deadLetterKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> _appendDeadLetter(SyncOutboxItem item, String reason) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await deadLetterItems();
    list.add({
      ...item.toJson(),
      'deadAt': DateTime.now().toIso8601String(),
      'reason': reason,
    });
    // Keep last 50 for evidence / manual retry
    final trimmed = list.length > 50 ? list.sublist(list.length - 50) : list;
    await prefs.setString(_deadLetterKey, jsonEncode(trimmed));
  }

  Future<void> requeueDeadLetter() async {
    final dead = await deadLetterItems();
    if (dead.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_deadLetterKey);
    for (final row in dead) {
      await enqueue(
        SyncOutboxItem.fromJson(Map<String, dynamic>.from(row))
            .copyWith(retries: 0),
      );
    }
  }

  Future<void> enqueue(SyncOutboxItem item) async {
    final items = await _load();
    final key = _dedupeKey(item);
    final existingIdx = items.indexWhere((e) => _dedupeKey(e) == key);
    if (existingIdx >= 0) {
      // Replace with freshest payload; keep lower retry count
      final prev = items[existingIdx];
      items[existingIdx] = SyncOutboxItem(
        kind: item.kind,
        payload: item.payload,
        retries: prev.retries < item.retries ? prev.retries : item.retries,
        createdAt: prev.createdAt,
      );
    } else {
      items.add(item);
    }
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
    final now = DateTime.now();
    for (final item in items) {
      // Exponential backoff: 2^retries seconds (cap 5 min)
      final waitSecs = (1 << item.retries.clamp(0, 8)).clamp(1, 300);
      final dueAt = item.createdAt.add(Duration(seconds: waitSecs * (item.retries == 0 ? 0 : 1)));
      if (item.retries > 0 && now.isBefore(dueAt)) {
        remaining.add(item);
        continue;
      }
      try {
        final ok = await _execute(item);
        if (!ok) {
          final next = item.copyWith(retries: item.retries + 1);
          if (next.retries < _maxRetries) {
            remaining.add(next);
          } else {
            dropped++;
            await _appendDeadLetter(next, 'max_retries');
          }
        }
      } catch (e) {
        debugPrint('Sync outbox item failed (${item.kind}): $e');
        final next = item.copyWith(retries: item.retries + 1);
        if (next.retries < _maxRetries) {
          remaining.add(next);
        } else {
          dropped++;
          await _appendDeadLetter(next, e.toString());
        }
      }
    }
    await _save(remaining);
    final dead = await deadLetterItems();
    if (dropped > 0 || dead.isNotEmpty) {
      ref.read(syncFailureMessageProvider.notifier).state =
          '${remaining.length} pending · ${dead.length} failed sync(s). Tap to retry.';
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
              // Local paid wins over non-paid cloud, push local.
              await ref.read(cloudInvoiceRepositoryProvider).syncInvoiceToClient(
                    freelancer: user,
                    invoice: invoice,
                    clientEmail: row['client_email'] as String? ?? '',
                    clientUid: row['client_uid'] as String?,
                  );
            } else {
              // Other conflicts (e.g. local overdue vs cloud sent), defer to UI.
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
                bypassQueue: true,
              );
        } else {
          final toEmail = item.payload['toEmail'] as String? ?? '';
          if (toEmail.isEmpty) return false;
          await ref.read(cloudNotificationRepositoryProvider).send(
                toEmail: toEmail,
                title: item.payload['title'] as String? ?? '',
                body: item.payload['body'] as String? ?? '',
                kind: item.payload['kind'] as String? ?? 'info',
                bypassQueue: true,
              );
        }
        return true;
      case 'analytics':
        await ref.read(supabaseSyncServiceProvider).mirrorAnalyticsEvent(
              eventType: item.payload['eventType'] as String? ?? 'event',
              userEmail: item.payload['email'] as String? ?? '',
              userName: item.payload['name'] as String? ?? '',
              plan: item.payload['plan'] as String? ?? 'free',
              amount: (item.payload['amount'] as num?)?.toDouble() ?? 0,
              payload: item.payload['payload'] as String? ?? '{}',
              rethrowOnError: true,
            );
        return true;
      case 'admin_sync':
        // Legacy no-op — drop without retry burn
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
              bypassQueue: true,
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
              bypassQueue: true,
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
      case 'message_send':
        final fromUid = item.payload['fromUid'] as String? ?? '';
        final fromEmail = item.payload['fromEmail'] as String? ?? '';
        final toEmail = item.payload['toEmail'] as String? ?? '';
        if (fromUid.isEmpty || toEmail.isEmpty) return false;
        await ref.read(cloudMessageRepositoryProvider).sendMessage(
              fromUid: fromUid,
              fromEmail: fromEmail,
              toEmail: toEmail,
              toUid: item.payload['toUid'] as String?,
              subject: item.payload['subject'] as String? ?? '',
              body: item.payload['body'] as String? ?? '',
              projectShareId: item.payload['projectShareId'] as String?,
            );
        return true;
      default:
        // Unknown kinds go to dead letter instead of silent success
        await _appendDeadLetter(item, 'unknown_kind');
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
