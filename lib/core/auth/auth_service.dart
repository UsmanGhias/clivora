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

import '../../core/auth/account_type_guard.dart';
import '../../core/auth/auth_session.dart';
import '../../core/auth/supabase_auth_errors.dart';
import '../../core/auth/user_roles.dart';
import '../../core/cloud/supabase_auth_helper.dart';
import '../../core/cloud/supabase_sync_service.dart';
import '../../core/constants/admin_config.dart';
import '../../core/constants/plan_limits.dart';
import '../../core/services/analytics_service.dart';
import '../../core/services/admin_management_service.dart';
import '../../core/services/automation_service.dart';
import '../../core/services/project_time_service.dart';
import '../../core/services/push_notification_service.dart';
import '../../core/services/referral_service.dart';
import '../../core/services/cloud_crm_backup_service.dart';
import '../../core/services/sync_outbox_service.dart';
import '../../data/database/database.dart';
import '../../data/database/user_defaults.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/providers/app_providers.dart';

const _sessionUserIdKey = 'clivora_user_id';

const kGoogleWebClientId =
    '976757530869-ap3ea6t2noq56o46tfokgdp6haj6ioqj.apps.googleusercontent.com';

/// Salted SHA-256 password hash. Format: `v2:<saltHex>:<hashHex>`.
/// Legacy unsalted hex hashes are still accepted and upgraded on next successful login.
String hashPassword(String password, {String? saltHex}) {
  final salt = saltHex ??
      sha256
          .convert(utf8.encode('${DateTime.now().microsecondsSinceEpoch}:${password.hashCode}'))
          .toString()
          .substring(0, 32);
  final digest = sha256.convert(utf8.encode('$salt::$password')).toString();
  return 'v2:$salt:$digest';
}

bool verifyPassword(String password, String stored) {
  if (stored.isEmpty) return false;
  if (stored.startsWith('v2:')) {
    final parts = stored.split(':');
    if (parts.length != 3) return false;
    final salt = parts[1];
    final expected = parts[2];
    final actual = sha256.convert(utf8.encode('$salt::$password')).toString();
    return actual == expected;
  }
  // Legacy unsalted SHA-256
  return sha256.convert(utf8.encode(password)).toString() == stored;
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
      await _db.repairAllDatabaseNulls();
      await SupabaseAuthHelper.refreshSessionIfNeeded();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt(_sessionUserIdKey);
      final cloudEmail = SupabaseAuthHelper.currentEmail?.trim().toLowerCase();

      User? user;
      if (cloudEmail != null) {
        user = await _db.safeGetUserByEmail(cloudEmail);
      }
      user ??= userId != null ? await _db.safeGetUser(userId) : null;

      if (user == null) {
        await prefs.remove(_sessionUserIdKey);
        state = const AsyncValue.data(null);
        setAuthSession(null);
        return;
      }

      final cloudUid = SupabaseAuthHelper.currentUid;
      if (cloudUid != null && user.googleId != cloudUid) {
        await _db.updateUser(user.copyWith(googleId: Value(cloudUid)));
        user = await _db.safeGetUser(user.id);
      }
      if (cloudUid != null && user != null) {
        user = await _applyCloudProfileToLocal(user, await SupabaseAuthHelper.fetchOwnProfile());
      }

      state = AsyncValue.data(user);
      setAuthSession(user);
      if (user != null && cloudUid != null) {
        await ref.read(supabaseSyncServiceProvider).onUserSignedIn(user);
        try {
          await ref.read(pushNotificationServiceProvider).onUserSignedIn();
        } catch (e) {
          debugPrint('Push on restore: $e');
        }
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
      await _db.repairAllDatabaseNulls();
      final previewType = accountType == kAccountClient ? kAccountClient : kAccountFreelancer;
      final guestEmail = 'guest_${DateTime.now().millisecondsSinceEpoch}@clivora.local';
      final userId = await _db.insertUserSafe(
        _db.newUserCompanion(
          email: guestEmail,
          name: 'Guest',
          passwordHash: '',
          accountType: previewType,
        ),
      );
      await _db.safeSeedUserDefaults(userId, name: 'Guest');
      final user = await _db.safeGetUser(userId);
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
    final type = AccountTypeGuard.normalizedAccountType(
      isAdmin ? kAccountAdmin : accountType,
      email: trimmedEmail,
    );

    final localExisting = await _db.safeGetUserByEmail(trimmedEmail);
    final guardErr = AccountTypeGuard.validateSignUp(
      email: trimmedEmail,
      requestedType: type,
      existingLocal: localExisting,
    );
    if (guardErr != null) return guardErr;

    if (localExisting != null) {
      return 'An account with this email already exists. Sign in instead.';
    }

    try {
      final response = await SupabaseAuthHelper.signUpWithEmail(
        email: trimmedEmail,
        password: password,
        name: name.trim(),
        accountType: type,
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
      finalizeCloudRole: true,
    );
  }

  Future<String?> signIn({
    required String email,
    required String password,
    String? loginAsType,
  }) async {
    final trimmedEmail = email.trim().toLowerCase();
    if (trimmedEmail.isEmpty || !trimmedEmail.contains('@')) return 'Valid email is required';
    if (password.isEmpty) return 'Password is required';

    await _db.repairAllDatabaseNulls();

    try {
      await SupabaseAuthHelper.signInWithEmail(email: trimmedEmail, password: password);
    } on AuthException catch (e) {
      return supabaseAuthErrorMessage(e);
    } catch (e) {
      return 'Sign in failed: $e';
    }

    final cloudUid = SupabaseAuthHelper.currentUid;
    if (cloudUid == null) return 'Sign in failed: no Supabase session.';

    final blockedProfile = await SupabaseAuthHelper.fetchOwnProfile();
    if (blockedProfile?['is_blocked'] == true) {
      await SupabaseAuthHelper.signOut();
      final reason = (blockedProfile?['block_reason'] as String?)?.trim();
      return (reason != null && reason.isNotEmpty)
          ? 'Account blocked: $reason'
          : 'This account has been blocked by CLIVORA admin.';
    }

    var user = await _db.safeGetUserByEmail(trimmedEmail);
    user ??= await _db.recoverUserByEmail(trimmedEmail);
    if (user == null) {
      final isAdmin = kAdminEmails.contains(trimmedEmail);
      final cloudProfile = await SupabaseAuthHelper.fetchOwnProfile();
      final cloudType = cloudProfile?['account_type'] as String?;
      final cloudName = _profileString(cloudProfile, 'name');
      final cloudAvatarUrl = _profileString(cloudProfile, 'avatar_url');
      final type = isAdmin
          ? kAccountAdmin
          : AccountTypeGuard.normalizedAccountType(
              loginAsType ?? cloudType ?? kAccountFreelancer,
              email: trimmedEmail,
            );
      if (loginAsType != null) {
        final expectedClient = loginAsType == kAccountClient;
        final cloudIsClient = cloudType == 'client';
        if (cloudType != null && expectedClient != cloudIsClient && !isAdmin) {
          return 'This email is registered as ${cloudIsClient ? 'Client' : 'Freelancer'}. Use the correct sign-in option.';
        }
      }
      return _createLocalAccount(
        name: cloudName ?? trimmedEmail.split('@').first,
        email: trimmedEmail,
        password: password,
        accountType: type,
        isAdmin: isAdmin,
        cloudUid: cloudUid,
        profilePhotoPath: cloudAvatarUrl,
        finalizeCloudRole: true,
      );
    }

    final roleErr = AccountTypeGuard.validateSignInRole(user: user, loginAsType: loginAsType);
    if (roleErr != null) return roleErr;

    if (user.passwordHash.isNotEmpty && !verifyPassword(password, user.passwordHash)) {
      // Supabase auth succeeded, update local hash (user may have reset password in cloud).
      await _db.updateUser(user.copyWith(passwordHash: hashPassword(password), googleId: Value(cloudUid)));
    } else if (user.passwordHash.isNotEmpty &&
        verifyPassword(password, user.passwordHash) &&
        !user.passwordHash.startsWith('v2:')) {
      // Upgrade legacy unsalted hash to salted v2.
      await _db.updateUser(user.copyWith(passwordHash: hashPassword(password)));
    } else if (user.googleId != cloudUid) {
      await _db.updateUser(user.copyWith(googleId: Value(cloudUid)));
    }

    final isAdmin = kAdminEmails.contains(trimmedEmail);
    if (isAdmin) {
      await _db.updateUser(user.copyWith(role: 'admin'));
    }

    await _syncCloudSubscriptionPlan(user.id);
    await _setSession(user.id);
    _invalidateUserData();

    if (isAdmin) {
      try {
        await ref.read(planLimitServiceProvider).setPlan(PlanLimits.proPlusPlan);
      } catch (_) {}
    }
    return null;
  }

  Future<String?> signInWithGoogle({String? accountType}) async {
    try {
      await _db.repairAllDatabaseNulls();
      final googleSignIn = GoogleSignIn(
        serverClientId: kGoogleWebClientId,
        scopes: const ['email', 'profile'],
      );

      try {
        await googleSignIn.signOut();
      } catch (_) {}

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return 'Sign in cancelled';

      final email = googleUser.email.trim().toLowerCase();
      if (email.isEmpty) return 'Google account has no email address.';

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) {
        return 'Google sign-in failed: no ID token. Add this APK signing SHA-1 in Firebase Console.';
      }

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
      final displayName = googleUser.displayName ?? email.split('@').first;
      final requestedType = AccountTypeGuard.normalizedAccountType(
        isAdmin ? kAccountAdmin : (accountType ?? kAccountFreelancer),
        email: email,
      );

      final ownProfile = await SupabaseAuthHelper.fetchOwnProfile();
      final cloudType = ownProfile?['account_type'] as String?;
      final cloudLocked = ownProfile?['account_type_locked'] as bool? ?? false;
      final cloudName = _profileString(ownProfile, 'name');
      final cloudAvatarUrl = _profileString(ownProfile, 'avatar_url');
      final initialName = cloudName ?? displayName;

      var user = await _db.safeGetUserByEmail(email);
      user ??= await _db.recoverUserByEmail(email);

      if (user == null) {
        String type = requestedType;
        if (cloudLocked && cloudType != null && cloudType.isNotEmpty && !isAdmin) {
          type = cloudType == kAccountClient ? kAccountClient : kAccountFreelancer;
          if (accountType != null) {
            final wantsClient = accountType == kAccountClient;
            final isClient = type == kAccountClient;
            if (wantsClient != isClient) {
              return 'This email is registered as ${isClient ? 'Client' : 'Freelancer'}. Use the correct sign-in option.';
            }
          }
        } else {
          await SupabaseAuthHelper.finalizeAccountType(
            accountType: type,
            name: initialName,
          );
        }

        return _createLocalAccount(
          name: initialName,
          email: email,
          password: '',
          accountType: type,
          isAdmin: isAdmin,
          cloudUid: cloudUid,
          profilePhotoPath: cloudAvatarUrl,
          trackSignup: true,
          finalizeCloudRole: true,
        );
      }

      final roleErr = AccountTypeGuard.validateSignInRole(user: user, loginAsType: accountType);
      if (roleErr != null) return roleErr;

      if (user.googleId != cloudUid) {
        await _db.updateUser(user.copyWith(
          googleId: Value(cloudUid),
        ));
        final linkedUser = await _db.safeGetUser(user.id);
        if (linkedUser == null) return 'Could not load your profile. Try again.';
        user = linkedUser;
      }
      user = await _applyCloudProfileToLocal(user, ownProfile);

      if (isAdmin) {
        await _db.updateUser(user.copyWith(role: 'admin'));
      }

      final sessionUser = await _db.safeGetUser(user.id);
      if (sessionUser == null) return 'Could not load your profile. Try again.';
      await _syncCloudSubscriptionPlan(sessionUser.id);
      await _setSession(sessionUser.id);
      _invalidateUserData();

      if (isAdmin) {
        try {
          await ref.read(planLimitServiceProvider).setPlan(PlanLimits.proPlusPlan);
        } catch (_) {}
      }
      return null;
    } catch (e, st) {
      debugPrint('Google sign-in error: $e\n$st');
      final msg = e.toString();
      if (msg.contains('ApiException: 10') || msg.contains('sign_in_failed')) {
        return 'Google sign-in failed. Register this APK SHA-1 in Firebase, then retry.';
      }
      return 'Google sign-in failed. Try again or use email sign-in.';
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
    bool finalizeCloudRole = false,
    String? profilePhotoPath,
  }) async {
    try {
      await _db.repairAllDatabaseNulls();

      var user = await _db.safeGetUserByEmail(email);
      user ??= await _db.recoverUserByEmail(email);

      late final int userId;
      if (user != null) {
        userId = user.id;
      } else {
        userId = await _db.insertUserSafe(
          _db.newUserCompanion(
            email: email,
            name: name.isNotEmpty ? name : email.split('@').first,
            passwordHash: password.isEmpty ? '' : hashPassword(password),
            role: isAdmin ? 'admin' : 'user',
            accountType: accountType,
            googleId: cloudUid ?? SupabaseAuthHelper.currentUid,
            emailVerified: false,
          ),
        );
      }

      await _db.safeSeedUserDefaults(userId, name: name, email: email);
      if (profilePhotoPath != null && profilePhotoPath.trim().isNotEmpty) {
        final linkedProfile = await _db.safeGetUser(userId);
        if (linkedProfile != null) {
          await _db.updateUser(linkedProfile.copyWith(profilePhotoPath: Value(profilePhotoPath.trim())));
          await _db.saveBusinessProfileForUser(
            userId,
            BusinessProfilesCompanion(ownerPhotoPath: Value(profilePhotoPath.trim())),
          );
        }
      }

      if (isAdmin) {
        try {
          final adminUser = await _db.safeGetUser(userId);
          if (adminUser != null) {
            await _db.updateUser(adminUser.copyWith(role: 'admin', accountType: kAccountAdmin));
          }
        } catch (e) {
          debugPrint('Admin role update: $e');
        }
      } else if (cloudUid != null) {
        try {
          final linked = await _db.safeGetUser(userId);
          if (linked != null && linked.googleId != cloudUid) {
            await _db.updateUser(linked.copyWith(googleId: Value(cloudUid)));
          }
        } catch (e) {
          debugPrint('Google id link: $e');
        }
      }

      final sessionUser = await _db.safeGetUser(userId);
      if (sessionUser == null) {
        return 'Could not load your profile. Please try again.';
      }

      await _setSession(sessionUser.id, skipCloudSync: skipCloudSync, finalizeCloudRole: finalizeCloudRole);

      try {
        _invalidateUserData();
      } catch (_) {}

      if (isAdmin) {
        try {
          await ref.read(planLimitServiceProvider).setPlan(PlanLimits.proPlusPlan);
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
      final recovered = await _db.recoverUserByEmail(email);
      if (recovered != null) {
        try {
          await _setSession(recovered.id, skipCloudSync: skipCloudSync, finalizeCloudRole: finalizeCloudRole);
          try {
            _invalidateUserData();
          } catch (_) {}
          return null;
        } catch (retryErr) {
          debugPrint('Create local account recovery failed: $retryErr');
        }
      }
      return 'Sign-in could not finish. Clear app storage or reinstall, then try again.';
    }
  }

  Future<void> signOut() async {
    try {
      await ref.read(syncOutboxServiceProvider).clearForCurrentUser();
    } catch (_) {}
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

  Future<void> _syncCloudSubscriptionPlan(int userId) async {
    try {
      final profile = await SupabaseAuthHelper.fetchOwnProfile();
      final cloudPlan = profile?['subscription_plan'] as String?;
      if (cloudPlan == PlanLimits.proPlan ||
          cloudPlan == PlanLimits.proPlusPlan ||
          cloudPlan == PlanLimits.freePlan) {
        await ref.read(planLimitServiceProvider).setPlanForUser(userId, cloudPlan!);
      }
    } catch (e) {
      debugPrint('Cloud subscription sync: $e');
    }
  }

  Future<User> _applyCloudProfileToLocal(User user, Map<String, dynamic>? cloudProfile) async {
    if (cloudProfile == null) return user;

    final cloudUpdatedAt = _profileUpdatedAt(cloudProfile);
    final cloudIsNewer = cloudUpdatedAt != null && cloudUpdatedAt.isAfter(user.createdAt.toUtc());
    final cloudName = _profileString(cloudProfile, 'name');
    final cloudAvatarUrl = _profileString(cloudProfile, 'avatar_url');
    final localAvatar = user.profilePhotoPath?.trim();

    final shouldUseCloudName = cloudName != null && (cloudIsNewer || user.name.trim().isEmpty);
    final shouldUseCloudAvatar = cloudAvatarUrl != null &&
        (cloudIsNewer || localAvatar == null || localAvatar.isEmpty || _isRemoteUrl(localAvatar));

    if (!shouldUseCloudName && !shouldUseCloudAvatar) return user;

    final localUpdate = user.copyWith(
      name: shouldUseCloudName ? cloudName : null,
      profilePhotoPath: shouldUseCloudAvatar ? Value(cloudAvatarUrl) : const Value.absent(),
    );
    await _db.updateUser(localUpdate);
    await _db.saveBusinessProfileForUser(
      user.id,
      BusinessProfilesCompanion(
        ownerName: shouldUseCloudName ? Value(cloudName) : const Value.absent(),
        ownerPhotoPath: shouldUseCloudAvatar ? Value(cloudAvatarUrl) : const Value.absent(),
      ),
    );

    final updated = await _db.safeGetUser(user.id) ?? localUpdate;
    state = AsyncValue.data(updated);
    setAuthSession(updated);
    return updated;
  }

  Future<String?> _profilePhotoCloudUrl(String? photoPath) async {
    return (await _profilePhotoCloudUpload(photoPath)).url;
  }

  Future<_AvatarUploadResult> _profilePhotoCloudUpload(String? photoPath) async {
    final path = photoPath?.trim();
    if (path == null || path.isEmpty) return const _AvatarUploadResult();
    if (_isRemoteUrl(path)) return _AvatarUploadResult(url: path);

    final uid = SupabaseAuthHelper.currentUid;
    if (uid == null || uid.isEmpty) return const _AvatarUploadResult();

    try {
      final file = File(path);
      if (!await file.exists()) {
        return const _AvatarUploadResult(error: 'Selected profile photo is no longer available on this device.');
      }
      final ext = _avatarExtension(path);
      final storagePath = '$uid/avatar.$ext';
      await SupabaseAuthHelper.client.storage.from('avatars').uploadBinary(
            storagePath,
            await file.readAsBytes(),
            fileOptions: FileOptions(contentType: _avatarContentType(ext), upsert: true),
          );
      return _AvatarUploadResult(
        url: SupabaseAuthHelper.client.storage.from('avatars').getPublicUrl(storagePath),
      );
    } catch (e) {
      debugPrint('Profile avatar upload: $e');
      return _AvatarUploadResult(error: '$e');
    }
  }

  void _invalidateUserData() {
    ref.invalidate(customersProvider);
    ref.invalidate(projectsProvider);
    ref.invalidate(invoicesProvider);
    ref.invalidate(tasksProvider);
    ref.invalidate(businessProfileProvider);
    ref.invalidate(invoiceBrandingProvider);
    ref.invalidate(appSettingsProvider);
    ref.invalidate(cloudSubscriptionPlanProvider);
    ref.invalidate(serverSubscriptionProvider);
    ref.invalidate(dashboardStatsProvider);
    ref.invalidate(clientProjectsProvider);
    ref.invalidate(clientSharedProjectsProvider);
    ref.invalidate(unifiedClientInboxProvider);
    ref.invalidate(freelancerMailboxProvider);
    ref.invalidate(unreadMessagesProvider);
    ref.invalidate(freelancerUnreadProvider);
    ref.invalidate(cloudNotificationsProvider);
    ref.invalidate(cloudUnreadCountProvider);
    ref.invalidate(freelancerClientTasksProvider);
    ref.invalidate(clientAssignedTasksProvider);
    ref.invalidate(projectTimeTrackerProvider);
    ref.invalidate(projectTrackedSecondsMapProvider);
  }

  Future<void> _setSession(int userId, {bool skipCloudSync = false, bool finalizeCloudRole = false}) async {
    await _db.repairUserDefaultsNulls(userId);
    final loadedUser = await _db.safeGetUser(userId);
    if (loadedUser == null) {
      throw StateError('Session error: user record missing (id $userId)');
    }
    var user = loadedUser;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionUserIdKey, userId);
    state = AsyncValue.data(user);
    setAuthSession(user);
    // Sync email verification from Supabase (Google / confirmed email).
    try {
      final cloud = SupabaseAuthHelper.client.auth.currentUser;
      final confirmed = cloud?.emailConfirmedAt != null ||
          (cloud?.identities ?? const []).any((i) => i.provider == 'google') ||
          isAdminUser(user) ||
          user.email.toLowerCase().endsWith('@clivora.local');
      if (confirmed && !user.emailVerified) {
        await _db.updateUser(user.copyWith(emailVerified: true));
        final refreshed = await _db.safeGetUser(user.id);
        if (refreshed == null) return;
        user = refreshed;
        state = AsyncValue.data(refreshed);
        setAuthSession(refreshed);
      }
    } catch (e) {
      debugPrint('Email verification sync: $e');
    }
    if (!skipCloudSync) {
      try {
        final cloudProfile = await SupabaseAuthHelper.fetchOwnProfile();
        user = await _applyCloudProfileToLocal(user, cloudProfile);
        final avatarUrl = await _profilePhotoCloudUrl(user.profilePhotoPath) ??
            _profileString(cloudProfile, 'avatar_url');

        if (finalizeCloudRole) {
          await SupabaseAuthHelper.finalizeAccountType(
            accountType: user.accountType,
            name: user.name,
          );
        }
        await SupabaseAuthHelper.upsertProfile(
          email: user.email,
          name: user.name,
          accountType: user.accountType,
          role: user.role,
          forceLock: finalizeCloudRole,
          avatarUrl: avatarUrl,
        );
      } catch (e) {
        debugPrint('Cloud profile sync on session: $e');
      }
      await _syncCloudSubscriptionPlan(userId);
      try {
        await ref.read(supabaseSyncServiceProvider).onUserSignedIn(user);
      } catch (e) {
        debugPrint('Cloud sync on session: $e');
      }
      try {
        await ref.read(pushNotificationServiceProvider).onUserSignedIn();
      } catch (e) {
        debugPrint('Push on session: $e');
      }
      try {
        await ref.read(referralServiceProvider).syncCodeToCloud();
      } catch (e) {
        debugPrint('Referral sync on session: $e');
      }
      try {
        final restored = await ref.read(cloudCrmBackupServiceProvider).restoreIfLocalEmpty();
        if (restored) {
          _invalidateUserData();
        } else {
          final remind = await ref.read(cloudCrmBackupServiceProvider).shouldRemindBackup();
          if (!remind) {
            // Recent backup exists, quiet auto-upload to keep cloud fresh
            try {
              await ref.read(cloudCrmBackupServiceProvider).uploadCurrentWorkspace();
            } catch (_) {}
          }
        }
      } catch (e) {
        debugPrint('Cloud CRM restore on session: $e');
      }
    }
  }

  Future<String?> updateProfilePhoto(String sourcePath) async {
    final user = state.valueOrNull;
    if (user == null) return 'Not signed in';

    late final String savedPath;
    try {
      savedPath = await _persistImage(sourcePath, 'profile_${user.id}');
    } catch (e) {
      debugPrint('Persist profile photo: $e');
      return 'Could not save profile photo on this device: $e';
    }
    await _db.updateUser(user.copyWith(profilePhotoPath: Value(savedPath)));
    await _db.saveBusinessProfileForUser(
      user.id,
      BusinessProfilesCompanion(ownerPhotoPath: Value(savedPath)),
    );

    final updated = await _db.safeGetUser(user.id);
    if (updated == null) return 'Could not reload your profile photo.';
    state = AsyncValue.data(updated);
    setAuthSession(updated);
    final avatarUpload = await _profilePhotoCloudUpload(savedPath);
    final profileError = await SupabaseAuthHelper.upsertProfile(
      email: updated.email,
      name: updated.name,
      accountType: updated.accountType,
      role: updated.role,
      avatarUrl: avatarUpload.url,
    );
    if (avatarUpload.error != null) {
      return 'Profile photo saved on this device, but cloud upload failed: ${avatarUpload.error}';
    }
    if (profileError != null) {
      return 'Profile photo saved on this device, but cloud profile sync failed: $profileError';
    }
    return null;
  }

  Future<void> setEmailVerified(bool value) async {
    final user = state.valueOrNull;
    if (user == null) return;
    if (user.emailVerified == value) return;
    await _db.updateUser(user.copyWith(emailVerified: value));
    final updated = await _db.getUser(user.id);
    state = AsyncValue.data(updated);
    setAuthSession(updated);
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
    final updated = await _db.safeGetUser(user.id);
    if (updated == null) return 'Could not reload your profile.';
    state = AsyncValue.data(updated);
    setAuthSession(updated);
    final avatarUrl = await _profilePhotoCloudUrl(updated.profilePhotoPath);
    await SupabaseAuthHelper.upsertProfile(
      email: newEmail,
      name: name.trim(),
      accountType: user.accountType,
      role: user.role,
      avatarUrl: avatarUrl,
    );
    return null;
  }

  Future<String?> resetPasswordForEmail(String email) async {
    final trimmed = email.trim().toLowerCase();
    if (trimmed.isEmpty || !trimmed.contains('@')) {
      return 'Enter a valid email address';
    }
    return SupabaseAuthHelper.resetPasswordForEmail(trimmed);
  }
}

class _AvatarUploadResult {
  const _AvatarUploadResult({this.url, this.error});

  final String? url;
  final String? error;
}

String? _profileString(Map<String, dynamic>? profile, String key) {
  final value = profile?[key];
  if (value is! String) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

DateTime? _profileUpdatedAt(Map<String, dynamic>? profile) {
  final value = profile?['updated_at'];
  if (value is DateTime) return value.toUtc();
  if (value is String) return DateTime.tryParse(value)?.toUtc();
  return null;
}

bool _isRemoteUrl(String value) {
  final uri = Uri.tryParse(value);
  return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
}

String _avatarExtension(String sourcePath) {
  final ext = p.extension(sourcePath).toLowerCase().replaceFirst('.', '');
  switch (ext) {
    case 'png':
    case 'webp':
    case 'gif':
      return ext;
    case 'jpeg':
    case 'jpg':
      return 'jpg';
    default:
      return 'jpg';
  }
}

String _avatarContentType(String ext) {
  switch (ext) {
    case 'png':
      return 'image/png';
    case 'webp':
      return 'image/webp';
    case 'gif':
      return 'image/gif';
    default:
      return 'image/jpeg';
  }
}

Future<String> _persistImage(String sourcePath, String prefix) async {
  final dir = await getApplicationDocumentsDirectory();
  final imagesDir = Directory(p.join(dir.path, 'images'));
  if (!await imagesDir.exists()) {
    await imagesDir.create(recursive: true);
  }
  final source = File(sourcePath);
  if (!await source.exists()) {
    throw StateError('Selected image is no longer available.');
  }
  final ext = p.extension(sourcePath).isNotEmpty ? p.extension(sourcePath) : '.jpg';
  final dest = p.join(imagesDir.path, '${prefix}_${DateTime.now().millisecondsSinceEpoch}$ext');
  await File(dest).writeAsBytes(await source.readAsBytes(), flush: true);
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
