import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cloud/cloud_notification_repository.dart';
import '../cloud/supabase_auth_helper.dart';
import 'audit_log_service.dart';
import 'local_notification_service.dart';

final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  return PushNotificationService(ref);
});

/// Local push-style alerts when cloud notifications arrive (FCM-ready scaffold).
class PushNotificationService {
  PushNotificationService(this.ref);

  final Ref ref;
  String? _subscriptionId;

  Future<void> initialize() async {
    await _startListening();
  }

  Future<void> _startListening() async {
    final uid = SupabaseAuthHelper.currentUid;
    if (uid == null || uid.isEmpty) return;

    _subscriptionId = uid;
    ref.read(cloudNotificationRepositoryProvider).watchForUser(uid).listen(
      (notifications) async {
        if (notifications.isEmpty) return;
        final latest = notifications.first;
        if (latest.isRead) return;
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
    await _startListening();
  }

  Future<void> notify({
    required String title,
    required String body,
    String kind = 'info',
  }) async {
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

  void dispose() {
    _subscriptionId = null;
  }
}
