import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cloud/cloud_notification_repository.dart';
import '../cloud/supabase_auth_helper.dart';
import 'audit_log_service.dart';
import 'fcm_service.dart';
import 'local_notification_service.dart';
import 'notification_prefs_service.dart';

final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  return PushNotificationService(ref);
});

/// Realtime → local alerts + FCM registration (offline fallback = local notifications).
class PushNotificationService {
  PushNotificationService(this.ref);

  final Ref ref;
  String? _listeningUid;
  final Set<String> _shownIds = {};
  DateTime? _bootstrappedAt;
  bool _skipBootstrap = true;

  Future<void> initialize() async {
    await ref.read(fcmServiceProvider).initialize();
    await _startListening();
  }

  Future<void> _startListening() async {
    final uid = SupabaseAuthHelper.currentUid;
    if (uid == null || uid.isEmpty) return;
    if (_listeningUid == uid) return;
    _listeningUid = uid;
    _skipBootstrap = true;
    _bootstrappedAt = DateTime.now().toUtc();

    final prefs = await SharedPreferences.getInstance();
    final seenKey = 'notif_seen_$uid';
    final lastSeenIso = prefs.getString(seenKey);
    final lastSeen = lastSeenIso != null ? DateTime.tryParse(lastSeenIso) : null;

    ref.read(cloudNotificationRepositoryProvider).watchForUser(uid).listen(
      (notifications) async {
        if (notifications.isEmpty) return;
        final latest = notifications.first;
        if (latest.isRead) return;
        if (_shownIds.contains(latest.id)) return;

        // Skip the first snapshot after listen attach (historical unread).
        if (_skipBootstrap) {
          _skipBootstrap = false;
          for (final n in notifications) {
            _shownIds.add(n.id);
          }
          final newest = notifications.first.createdAt.toUtc();
          await prefs.setString(seenKey, newest.toIso8601String());
          return;
        }

        // Only alert for notifications created after this session started,
        // or after the last locally-seen timestamp.
        final created = latest.createdAt.toUtc();
        final floor = lastSeen ?? _bootstrappedAt;
        if (floor != null && !created.isAfter(floor)) {
          _shownIds.add(latest.id);
          return;
        }

        _shownIds.add(latest.id);
        if (_shownIds.length > 200) {
          _shownIds.remove(_shownIds.first);
        }
        await prefs.setString(seenKey, created.toIso8601String());
        if (!await ref.read(notificationPrefsServiceProvider).allowsKind(latest.kind)) {
          return;
        }
        await _showLocalAlert(
          title: latest.title,
          body: latest.body,
          kind: latest.kind,
        );
        await ref.read(auditLogServiceProvider).logNotificationSent(
              toEmail: uid,
              title: latest.title,
            );
      },
      onError: (e) => debugPrint('Push listener error: $e'),
    );
  }

  Future<void> onUserSignedIn() async {
    await ref.read(fcmServiceProvider).onUserSignedIn();
    await _startListening();
  }

  Future<void> notify({
    required String title,
    required String body,
    String kind = 'info',
  }) async {
    if (!await ref.read(notificationPrefsServiceProvider).allowsKind(kind)) return;
    await _showLocalAlert(title: title, body: body, kind: kind);
  }

  Future<void> _showLocalAlert({
    required String title,
    required String body,
    required String kind,
  }) async {
    await ref.read(localNotificationServiceProvider).show(
          title: title,
          body: body,
          payload: kind,
        );
  }
}
