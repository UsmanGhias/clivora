import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/admin_config.dart';

/// Primary authentication for CLIVORA — Supabase Auth (email + Google).
class SupabaseAuthHelper {
  static SupabaseClient get client => Supabase.instance.client;

  static String? get currentUid => client.auth.currentUser?.id;

  static String? get currentEmail => client.auth.currentUser?.email;

  static Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? name,
    String? accountType,
  }) async {
    return client.auth.signUp(
      email: email.trim().toLowerCase(),
      password: password,
      data: {
        if (name != null && name.isNotEmpty) 'name': name,
        if (accountType != null && accountType.isNotEmpty) 'account_type': accountType,
      },
    );
  }

  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return client.auth.signInWithPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  static Future<AuthResponse> signInWithGoogle({
    required String idToken,
    String? accessToken,
  }) async {
    return client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  static Future<void> refreshSessionIfNeeded() async {
    final session = client.auth.currentSession;
    if (session == null) return;
    if (session.isExpired) {
      try {
        await client.auth.refreshSession();
      } catch (e) {
        debugPrint('Supabase session refresh: $e');
      }
    }
  }

  static Future<Map<String, dynamic>?> fetchOwnProfile() async {
    final uid = currentUid;
    if (uid == null) return null;
    try {
      return await client
          .from('profiles')
          .select('id, email, name, account_type, account_type_locked, role')
          .eq('id', uid)
          .maybeSingle();
    } catch (e) {
      debugPrint('fetchOwnProfile: $e');
      return null;
    }
  }

  /// Locks freelancer/client role in cloud after first successful auth.
  static Future<void> finalizeAccountType({
    required String accountType,
    String name = '',
  }) async {
    try {
      await client.rpc('finalize_account_type', params: {
        'p_account_type': accountType,
        'p_name': name,
      });
    } catch (e) {
      debugPrint('finalize_account_type RPC: $e — falling back to upsert');
      await upsertProfile(
        email: currentEmail ?? '',
        name: name,
        accountType: accountType,
        role: accountType == 'admin' ? 'admin' : 'user',
        forceLock: true,
      );
    }
  }

  static Future<void> upsertProfile({
    required String email,
    required String name,
    required String accountType,
    required String role,
    bool forceLock = false,
  }) async {
    final uid = currentUid;
    if (uid == null) return;
    try {
      final existing = await fetchOwnProfile();
      final locked = existing?['account_type_locked'] as bool? ?? false;
      final lockedType = existing?['account_type'] as String?;

      if (locked && lockedType != null && lockedType.isNotEmpty && lockedType != accountType && !forceLock) {
        debugPrint('Profile upsert: type locked as $lockedType');
        return;
      }

      await client.from('profiles').upsert({
        'id': uid,
        'email': email.trim().toLowerCase(),
        'name': name,
        'account_type': accountType,
        'role': role,
        'account_type_locked': forceLock || locked,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Supabase profile upsert: $e');
    }
  }

  static Future<String?> resetPasswordForEmail(String email) async {
    try {
      await client.auth.resetPasswordForEmail(
        email.trim().toLowerCase(),
        redirectTo: kPasswordResetRedirectUrl,
      );
      return null;
    } catch (e) {
      return 'Could not send reset email: $e';
    }
  }

  static Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (_) {}
  }
}
