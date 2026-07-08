import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../constants/admin_config.dart';
import '../../data/database/database.dart';
import '../../data/providers/app_providers.dart';
import 'cloud_write_guard.dart';
import 'connectivity_service.dart';
import 'sync_outbox_service.dart';

final adminSyncServiceProvider = Provider<AdminSyncService>((ref) {
  return AdminSyncService(ref);
});

/// Pushes analytics events from the app to the clivora-web admin API.
class AdminSyncService {
  AdminSyncService(this.ref);

  final Ref ref;

  Future<void> syncPendingEvents() async {
    final online = await ref.read(connectivityServiceProvider).isOnlineNow();
    if (!online) {
      await ref.read(syncOutboxServiceProvider).enqueue(
            SyncOutboxItem(kind: 'admin_sync', payload: {}),
          );
      return;
    }
    await flushPendingEvents();
  }

  Future<void> flushPendingEvents() async {
    final db = ref.read(databaseProvider);
    final pending = await db.getUnsyncedAnalytics();
    if (pending.isEmpty) return;

    for (final event in pending) {
      final ok = await _postEvent(event);
      if (ok) {
        await db.markAnalyticsSynced(event.id);
      }
    }
  }

  Future<bool> _postEvent(AppAnalytic event) async {
    if (kAdminSyncKey.isEmpty) {
      if (kDebugMode) debugPrint('Admin sync skipped: ADMIN_SYNC_KEY not configured');
      return false;
    }
    try {
      final uri = Uri.parse('$kAdminApiBaseUrl/api/admin/sync');
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'X-Admin-Sync-Key': kAdminSyncKey,
            },
            body: jsonEncode({
              'eventType': event.eventType,
              'userEmail': event.userEmail,
              'userName': event.userName,
              'plan': event.plan,
              'amount': event.amount,
              'payload': event.payload,
              'createdAt': event.createdAt.toIso8601String(),
              'source': 'clivora_app',
            }),
          )
          .timeout(const Duration(seconds: 12));

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Admin sync failed: $e');
      }
      return false;
    }
  }
}
