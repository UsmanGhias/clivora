import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Primary authentication for CLIVORA — Supabase Auth (email + Google).
class SupabaseAuthHelper {
  static SupabaseClient get client => Supabase.instance.client;

  static String? get currentUid => client.auth.currentUser?.id;

  static String? get currentEmail => client.auth.currentUser?.email;

  static Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    return client.auth.signUp(
      email: email.trim().toLowerCase(),
      password: password,
      data: {if (name != null && name.isNotEmpty) 'name': name},
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

  static Future<void> upsertProfile({
    required String email,
    required String name,
    required String accountType,
    required String role,
  }) async {
    final uid = currentUid;
    if (uid == null) return;
    try {
      await client.from('profiles').upsert({
        'id': uid,
        'email': email.trim().toLowerCase(),
        'name': name,
        'account_type': accountType,
        'role': role,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Supabase profile upsert: $e');
    }
  }

  static Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (_) {}
  }
}
