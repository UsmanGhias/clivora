import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/database_provider.dart';
import '../auth/auth_service.dart';
import '../auth/user_roles.dart';
import '../cloud/cloud_notification_repository.dart';
import '../cloud/supabase_auth_helper.dart';
import '../cloud/supabase_sync_service.dart';
import '../constants/plan_limits.dart';

final cloudNotificationsProvider = StreamProvider<List<CloudNotification>>((ref) {
  final uid = SupabaseAuthHelper.currentUid;
  if (uid == null || uid.isEmpty) return const Stream.empty();
  return ref.watch(cloudNotificationRepositoryProvider).watchForUser(uid);
});

final cloudUnreadCountProvider = FutureProvider<int>((ref) async {
  final uid = SupabaseAuthHelper.currentUid;
  if (uid == null) return 0;
  ref.watch(cloudNotificationsProvider);
  return ref.read(cloudNotificationRepositoryProvider).countUnread(uid);
});

final freelancerClientTasksProvider = StreamProvider<List<CloudClientTask>>((ref) {
  final uid = SupabaseAuthHelper.currentUid;
  if (uid == null || uid.isEmpty) return const Stream.empty();
  return ref.watch(cloudClientTaskRepositoryProvider).watchForFreelancer(uid);
});

final clientAssignedTasksProvider = StreamProvider<List<CloudClientTask>>((ref) {
  final uid = SupabaseAuthHelper.currentUid;
  if (uid == null || uid.isEmpty) return const Stream.empty();
  return ref.watch(cloudClientTaskRepositoryProvider).watchForClient(uid);
});

final adminManagementServiceProvider = Provider<AdminManagementService>((ref) {
  return AdminManagementService(ref);
});

class AdminManagementService {
  AdminManagementService(this.ref);

  final Ref ref;

  Future<String?> grantAdminByEmail(String email) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (!isSuperAdmin(user)) return 'Only the super admin can add admins.';

    final normalized = email.trim().toLowerCase();
    if (normalized.isEmpty) return 'Enter an email address.';
    if (!normalized.contains('@')) return 'Invalid email.';

    final uid = await ref.read(supabaseSyncServiceProvider).uidForEmail(normalized);
    if (uid == null) {
      return 'No CLIVORA account found for $normalized. They must sign up first.';
    }

    try {
      await ref.read(supabaseClientProvider).from('profiles').update({
        'role': 'admin',
        'account_type': 'admin',
      }).eq('id', uid);
    } catch (e) {
      return 'Could not update cloud profile: $e';
    }

    final local = await ref.read(databaseProvider).getUserByEmail(normalized);
    if (local != null) {
      await ref.read(databaseProvider).updateUser(
            local.copyWith(role: 'admin', accountType: kAccountAdmin),
          );
    }

    return null;
  }
}
