import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_service.dart';
import '../cloud/supabase_auth_helper.dart';
import 'admin_sync_service.dart';
import 'audit_log_service.dart';
import 'secure_storage_service.dart';

final accountDeletionServiceProvider = Provider<AccountDeletionService>((ref) {
  return AccountDeletionService(ref);
});

/// GDPR-style local wipe + sign out. Cloud profile deletion uses optional RPC.
class AccountDeletionService {
  AccountDeletionService(this.ref);

  final Ref ref;

  Future<void> deleteAccount({required String confirmEmail}) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) throw StateError('Not signed in');
    if (user.email.trim().toLowerCase() != confirmEmail.trim().toLowerCase()) {
      throw ArgumentError('Email does not match your account');
    }

    await ref.read(auditLogServiceProvider).log(
          action: 'account_deletion',
          entityType: 'user',
          detail: 'User requested account deletion',
        );

    await ref.read(secureStorageServiceProvider).clearAll();

    try {
      await SupabaseAuthHelper.client.rpc('request_account_deletion');
    } catch (e) {
      debugPrint('Cloud deletion RPC optional: $e');
    }

    await ref.read(authStateProvider.notifier).signOut();
    ref.read(adminSyncServiceProvider).syncPendingEvents();
  }
}
