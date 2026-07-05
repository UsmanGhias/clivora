import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../core/auth/auth_session.dart';
import '../../core/auth/supabase_auth_errors.dart';
import '../../core/auth/user_roles.dart';
import '../../core/cloud/supabase_auth_helper.dart';
import '../../core/cloud/supabase_sync_service.dart';
import '../../core/constants/admin_config.dart';
import '../../core/constants/plan_limits.dart';
import '../../core/services/analytics_service.dart';
import '../../core/services/automation_service.dart';
import '../../data/database/database.dart';
import '../../data/database/user_defaults.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/providers/app_providers.dart';

const _sessionUserIdKey = 'clivora_user_id';

const kGoogleWebClientId =
    '976757530869-ap3ea6t2noq56o46tfokgdp6haj6ioqj.apps.googleusercontent.com';

String hashPassword(String password) {
  final bytes = utf8.encode(password);
  return sha256.convert(bytes).toString();
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier(this.ref) : super(const AsyncValue.loading()) {
    setAuthSessionLoading(true);
    _restoreSession();
  }

  final Ref ref;

  AppDatabase get _db => ref.read(databaseProvider);

  Future<void> _restoreSession() async {
    try {
      await SupabaseAuthHelper.refreshSessionIfNeeded();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt(_sessionUserIdKey);
      final cloudEmail = SupabaseAuthHelper.currentEmail?.trim().toLowerCase();

      User? user;
      if (cloudEmail != null) {
        user = await _db.getUserByEmail(cloudEmail);
      }
      user ??= userId != null ? await _db.getUser(userId) : null;

      if (user == null) {
        await prefs.remove(_sessionUserIdKey);
        state = const AsyncValue.data(null);
        setAuthSession(null);
        return;
      }

      final cloudUid = SupabaseAuthHelper.currentUid;
      if (cloudUid != null && user.googleId != cloudUid) {
        await _db.updateUser(user.copyWith(googleId: Value(cloudUid)));
        user = await _db.getUser(user.id);
      }

      state = AsyncValue.data(user);
      setAuthSession(user);
      if (user != null && cloudUid != null) {
        await ref.read(supabaseSyncServiceProvider).onUserSignedIn(user);
      }
    } catch (e) {
      debugPrint('Auth restore error: $e');
      state = const AsyncValue.data(null);
      setAuthSession(null);
    }
  }

  Future<void> ensureLoaded() async {
    if (state.isLoading) await _restoreSession();
  }

  Future<String?> signInAsGuest({String accountType = kAccountFreelancer}) async {
    try {
      final previewType = accountType == kAccountClient ? kAccountClient : kAccountFreelancer;
      var user = await _db.getUserByEmail(kGuestEmail);
      if (user == null) {
        final userId = await _db.insertUser(
          _db.newUserCompanion(
            email: kGuestEmail,
            name: 'Guest',
            passwordHash: '',
            accountType: previewType,
          ),
        );
        await _db.safeSeedUserDefaults(userId, name: 'Guest');
        user = await _db.getUser(userId);
      } else {
        await _db.updateUser(user.copyWith(accountType: previewType));
        user = await _db.getUser(user.id);
      }
      if (user == null) return 'Could not start guest session.';
      await _setSession(user.id, skipCloudSync: true);
      _invalidateUserData();
      return null;
    } catch (e) {
      debugPrint('Guest sign-in error: $e');
      return 'Guest mode failed: $e';
    }
  }

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    required String accountType,
  }) async {
    final trimmedEmail = email.trim().toLowerCase();
    if (name.trim().isEmpty) return 'Name is required';
    if (trimmedEmail.isEmpty || !trimmedEmail.contains('@')) return 'Valid email is required';
    if (password.length < 6) return 'Password must be at least 6 characters';

    final isAdmin = kAdminEmails.contains(trimmedEmail);
    final type = isAdmin
        ? kAccountAdmin
        : (accountType == kAccountClient ? kAccountClient : kAccountFreelancer);

    if (await _db.getUserByEmail(trimmedEmail) != null) {
      return 'An account with this email already exists. Sign in instead.';
    }

    try {
      final response = await SupabaseAuthHelper.signUpWithEmail(
        email: trimmedEmail,
        password: password,
        name: name.trim(),
      );
      if (response.user == null) {
        return 'Sign up failed. Check Supabase Auth settings (email provider ON).';
      }
    } on AuthException catch (e) {
      return supabaseAuthErrorMessage(e);
    } catch (e) {
      return 'Sign up failed: $e';
    }

    return _createLocalAccount(
      name: name.trim(),
      email: trimmedEmail,
      password: password,
      accountType: type,
      isAdmin: isAdmin,
      cloudUid: SupabaseAuthHelper.currentUid,
      trackSignup: true,
    );
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim().toLowerCase();
    if (trimmedEmail.isEmpty || !trimmedEmail.contains('@')) return 'Valid email is required';
    if (password.isEmpty) return 'Password is required';

    try {
      await SupabaseAuthHelper.signInWithEmail(email: trimmedEmail, password: password);
    } on AuthException catch (e) {
      return supabaseAuthErrorMessage(e);
    } catch (e) {
      return 'Sign in failed: $e';
    }

    final cloudUid = SupabaseAuthHelper.currentUid;
    if (cloudUid == null) return 'Sign in failed: no Supabase session.';

    var user = await _db.getUserByEmail(trimmedEmail);
    if (user == null) {
      final isAdmin = kAdminEmails.contains(trimmedEmail);
      return _createLocalAccount(
        name: trimmedEmail.split('@').first,
        email: trimmedEmail,
        password: password,
        accountType: isAdmin ? kAccountAdmin : kAccountFreelancer,
        isAdmin: isAdmin,
        cloudUid: cloudUid,
      );
    }

    if (user.passwordHash.isNotEmpty && user.passwordHash != hashPassword(password)) {
      // Supabase auth succeeded — update local hash (user may have reset password in cloud).
      await _db.updateUser(user.copyWith(passwordHash: hashPassword(password), googleId: Value(cloudUid)));
    } else if (user.googleId != cloudUid) {
      await _db.updateUser(user.copyWith(googleId: Value(cloudUid)));
    }

    final isAdmin = kAdminEmails.contains(trimmedEmail);
    if (isAdmin) {
      await _db.updateUser(user.copyWith(role: 'admin', accountType: kAccountAdmin));
    }

    await _setSession(user.id);
    _invalidateUserData();

    if (isAdmin) {
      try {
        await ref.read(planLimitServiceProvider).setPlan(PlanLimits.proPlan);
      } catch (_) {}
    }
    return null;
  }

  Future<String?> signInWithGoogle({String? accountType}) async {
    try {
      final googleSignIn = GoogleSignIn(
        serverClientId: kGoogleWebClientId,
        scopes: const ['email', 'profile'],
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final email = googleUser.email.trim().toLowerCase();
      if (email.isEmpty) return 'Google account has no email address.';

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) return 'Google sign-in failed: no ID token.';

      try {
        await SupabaseAuthHelper.signInWithGoogle(
          idToken: googleAuth.idToken!,
          accessToken: googleAuth.accessToken,
        );
      } on AuthException catch (e) {
        return supabaseAuthErrorMessage(e);
      }

      final cloudUid = SupabaseAuthHelper.currentUid;
      if (cloudUid == null) return 'Google sign-in failed: no Supabase session.';

      final isAdmin = kAdminEmails.contains(email);
      final type = isAdmin
          ? kAccountAdmin
          : (accountType == kAccountClient ? kAccountClient : kAccountFreelancer);

      var user = await _db.getUserByEmail(email);
      if (user == null) {
        final err = await _createLocalAccount(
          name: googleUser.displayName ?? email.split('@').first,
          email: email,
          password: '',
          accountType: type,
          isAdmin: isAdmin,
          cloudUid: cloudUid,
          trackSignup: true,
        );
        return err;
      }

      if (user.googleId != cloudUid) {
        await _db.updateUser(user.copyWith(googleId: Value(cloudUid)));
      }
      await _setSession(user.id);
      _invalidateUserData();
      return null;
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      return 'Google sign-in failed: $e';
    }
  }

  Future<String?> _createLocalAccount({
    required String name,
    required String email,
    required String password,
    required String accountType,
    required bool isAdmin,
    String? cloudUid,
    bool trackSignup = false,
    bool skipCloudSync = false,
  }) async {
    try {
      final existing = await _db.getUserByEmail(email);
      if (existing != null) {
        return 'An account with this email already exists. Sign in instead.';
      }

      final userId = await _db.insertUser(
        _db.newUserCompanion(
          email: email,
          name: name,
          passwordHash: password.isEmpty ? '' : hashPassword(password),
          role: isAdmin ? 'admin' : 'user',
          accountType: accountType,
          googleId: cloudUid ?? SupabaseAuthHelper.currentUid,
          emailVerified: false,
        ),
      );

      await _db.safeSeedUserDefaults(userId, name: name, email: email);

      if (isAdmin) {
        final adminUser = await _db.getUser(userId);
        if (adminUser != null) {
          await _db.updateUser(adminUser.copyWith(role: 'admin', accountType: kAccountAdmin));
        }
      }

      await _setSession(userId, skipCloudSync: skipCloudSync);
      _invalidateUserData();

      if (isAdmin) {
        try {
          await ref.read(planLimitServiceProvider).setPlan(PlanLimits.proPlan);
        } catch (_) {}
      }

      if (trackSignup) {
        try {
          await ref.read(analyticsServiceProvider).trackSignup(email: email, name: name);
        } catch (_) {}
      }

      try {
        await _db.linkPendingClientsForUser(userId, email);
        if (accountType == kAccountClient) {
          final links = await _db.getFreelancerLinksForClient(userId);
          for (final link in links) {
            await ref.read(automationServiceProvider).onClientAccountLinked(userId, link.freelancerUserId);
          }
        }
      } catch (_) {}

      return null;
    } catch (e, st) {
      debugPrint('Create local account error: $e\n$st');
      return 'Could not create account: $e';
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn(serverClientId: kGoogleWebClientId).signOut();
      await SupabaseAuthHelper.signOut();
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionUserIdKey);
    state = const AsyncValue.data(null);
    setAuthSession(null);
    _invalidateUserData();
  }

  void _invalidateUserData() {
    ref.invalidate(customersProvider);
    ref.invalidate(projectsProvider);
    ref.invalidate(invoicesProvider);
    ref.invalidate(tasksProvider);
    ref.invalidate(businessProfileProvider);
    ref.invalidate(invoiceBrandingProvider);
    ref.invalidate(appSettingsProvider);
    ref.invalidate(dashboardStatsProvider);
    ref.invalidate(clientProjectsProvider);
    ref.invalidate(clientSharedProjectsProvider);
    ref.invalidate(unifiedClientInboxProvider);
    ref.invalidate(freelancerMailboxProvider);
    ref.invalidate(unreadMessagesProvider);
    ref.invalidate(freelancerUnreadProvider);
  }

  Future<void> _setSession(int userId, {bool skipCloudSync = false}) async {
    final user = await _db.getUser(userId);
    if (user == null) {
      throw StateError('Session error: user record missing (id $userId)');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionUserIdKey, userId);
    state = AsyncValue.data(user);
    setAuthSession(user);
    if (!skipCloudSync) {
      try {
        await SupabaseAuthHelper.upsertProfile(
          email: user.email,
          name: user.name,
          accountType: user.accountType,
          role: user.role,
        );
        await ref.read(supabaseSyncServiceProvider).onUserSignedIn(user);
      } catch (e) {
        debugPrint('Cloud sync on session: $e');
      }
    }
  }

  Future<String?> updateProfilePhoto(String sourcePath) async {
    final user = state.valueOrNull;
    if (user == null) return 'Not signed in';

    final savedPath = await _persistImage(sourcePath, 'profile_${user.id}');
    await _db.updateUser(user.copyWith(profilePhotoPath: Value(savedPath)));
    await _db.saveBusinessProfileForUser(
      user.id,
      BusinessProfilesCompanion(ownerPhotoPath: Value(savedPath)),
    );

    final updated = await _db.getUser(user.id);
    state = AsyncValue.data(updated);
    return null;
  }

  Future<String?> updateProfile({required String name, required String email}) async {
    final user = state.valueOrNull;
    if (user == null) return 'Not signed in';
    if (name.trim().isEmpty) return 'Name is required';

    final newEmail = email.trim().toLowerCase();
    await _db.updateUser(user.copyWith(name: name.trim(), email: newEmail));
    await _db.saveBusinessProfileForUser(
      user.id,
      BusinessProfilesCompanion(
        ownerName: Value(name.trim()),
        businessEmail: Value(newEmail),
      ),
    );
    final updated = await _db.getUser(user.id);
    state = AsyncValue.data(updated);
    await SupabaseAuthHelper.upsertProfile(
      email: newEmail,
      name: name.trim(),
      accountType: user.accountType,
      role: user.role,
    );
    return null;
  }
}

Future<String> _persistImage(String sourcePath, String prefix) async {
  final dir = await getApplicationDocumentsDirectory();
  final imagesDir = Directory(p.join(dir.path, 'images'));
  if (!await imagesDir.exists()) {
    await imagesDir.create(recursive: true);
  }
  final ext = p.extension(sourcePath);
  final dest = p.join(imagesDir.path, '${prefix}_${DateTime.now().millisecondsSinceEpoch}$ext');
  await File(sourcePath).copy(dest);
  return dest;
}

Future<String?> pickAndSaveImage(ImageSource source) async {
  final picker = ImagePicker();
  final file = await picker.pickImage(source: source, maxWidth: 1024, imageQuality: 85);
  if (file == null) return null;
  return _persistImage(file.path, 'upload');
}

Future<String?> pickProfilePhoto(WidgetRef ref, ImageSource source) async {
  final picker = ImagePicker();
  final file = await picker.pickImage(source: source, maxWidth: 1024, imageQuality: 85);
  if (file == null) return null;
  return ref.read(authStateProvider.notifier).updateProfilePhoto(file.path);
}
