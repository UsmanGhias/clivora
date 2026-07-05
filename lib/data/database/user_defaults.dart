import 'package:drift/drift.dart';

import 'database.dart';

/// Companions with all NOT NULL columns set — prevents Drift null-read crashes.
extension UserDefaultsHelpers on AppDatabase {
  /// Insert companion with every NOT NULL user column explicitly set.
  UsersCompanion newUserCompanion({
    required String email,
    required String name,
    String passwordHash = '',
    String role = 'user',
    String accountType = 'freelancer',
    String? googleId,
    bool emailVerified = false,
  }) {
    return UsersCompanion.insert(
      email: email.trim().toLowerCase(),
      passwordHash: Value(passwordHash),
      name: name,
      role: Value(role),
      accountType: Value(accountType),
      googleId: Value(googleId),
      emailVerified: Value(emailVerified),
      createdAt: Value(DateTime.now()),
    );
  }

  BusinessProfilesCompanion defaultBusinessProfileCompanion(
    int userId, {
    String ownerName = '',
    String email = '',
  }) {
    return BusinessProfilesCompanion(
      userId: Value(userId),
      ownerName: Value(ownerName),
      businessEmail: Value(email),
      businessName: const Value(''),
      businessPhone: const Value(''),
      businessAddress: const Value(''),
      businessCity: const Value(''),
      businessPostalCode: const Value(''),
      businessCountry: const Value(''),
      memberSince: Value(DateTime.now()),
    );
  }

  InvoiceBrandingsCompanion defaultInvoiceBrandingCompanion(int userId) {
    return InvoiceBrandingsCompanion(
      userId: Value(userId),
      accentColor: const Value('#6C63FF'),
      templateStyle: const Value('classic'),
      showLogo: const Value(true),
    );
  }

  AppSettingsTableCompanion defaultAppSettingsCompanion(int userId) {
    return AppSettingsTableCompanion(
      userId: Value(userId),
      themeMode: const Value('light'),
      currency: const Value('USD'),
      timezone: const Value('UTC'),
      subscriptionPlan: const Value('free'),
    );
  }

  /// Fix NULL columns in [users] — Drift crashes on read when these are null.
  Future<void> repairAllUsersNulls() async {
    final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    try {
      await customStatement('''
        UPDATE users SET
          password_hash = COALESCE(password_hash, ''),
          role = COALESCE(role, 'user'),
          account_type = COALESCE(NULLIF(account_type, ''), 'freelancer'),
          email_verified = COALESCE(email_verified, 0),
          created_at = COALESCE(created_at, $nowSec)
      ''');
    } catch (_) {}
  }

  /// Fix NULL columns in per-user settings tables (all rows).
  Future<void> repairAllProfileNulls() async {
    final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    try {
      await customStatement('''
        UPDATE business_profiles SET
          member_since = COALESCE(member_since, $nowSec),
          business_name = COALESCE(business_name, ''),
          business_email = COALESCE(business_email, ''),
          business_phone = COALESCE(business_phone, ''),
          owner_name = COALESCE(owner_name, ''),
          business_address = COALESCE(business_address, ''),
          business_city = COALESCE(business_city, ''),
          business_postal_code = COALESCE(business_postal_code, ''),
          business_country = COALESCE(business_country, '')
        WHERE member_since IS NULL
           OR business_name IS NULL
           OR business_email IS NULL
           OR business_phone IS NULL
           OR owner_name IS NULL
           OR business_address IS NULL
           OR business_city IS NULL
           OR business_postal_code IS NULL
           OR business_country IS NULL
      ''');
    } catch (_) {}
    try {
      await customStatement('''
        UPDATE invoice_brandings SET
          accent_color = COALESCE(accent_color, '#6C63FF'),
          template_style = COALESCE(template_style, 'classic'),
          show_logo = COALESCE(show_logo, 1)
        WHERE accent_color IS NULL
           OR template_style IS NULL
           OR show_logo IS NULL
      ''');
    } catch (_) {}
    try {
      await customStatement('''
        UPDATE app_settings_table SET
          theme_mode = COALESCE(theme_mode, 'light'),
          currency = COALESCE(currency, 'USD'),
          timezone = COALESCE(timezone, 'UTC'),
          subscription_plan = COALESCE(subscription_plan, 'free')
        WHERE theme_mode IS NULL
           OR currency IS NULL
           OR timezone IS NULL
           OR subscription_plan IS NULL
      ''');
    } catch (_) {}
  }

  /// Run all NULL repairs — call before any Drift read on legacy databases.
  Future<void> repairAllDatabaseNulls() async {
    await repairAllUsersNulls();
    await repairAllProfileNulls();
  }

  /// Repair NULL columns before Drift reads (prevents null-check crashes on old DB rows).
  Future<void> repairUserDefaultsNulls(int userId) async {
    final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    try {
      await customStatement('''
        UPDATE users SET
          password_hash = COALESCE(password_hash, ''),
          role = COALESCE(role, 'user'),
          account_type = COALESCE(NULLIF(account_type, ''), 'freelancer'),
          email_verified = COALESCE(email_verified, 0),
          created_at = COALESCE(created_at, $nowSec)
        WHERE id = $userId
      ''');
    } catch (_) {}
    try {
      await customStatement('''
        UPDATE business_profiles SET
          member_since = COALESCE(member_since, $nowSec),
          business_name = COALESCE(business_name, ''),
          business_email = COALESCE(business_email, ''),
          business_phone = COALESCE(business_phone, ''),
          owner_name = COALESCE(owner_name, ''),
          business_address = COALESCE(business_address, ''),
          business_city = COALESCE(business_city, ''),
          business_postal_code = COALESCE(business_postal_code, ''),
          business_country = COALESCE(business_country, '')
        WHERE user_id = $userId
      ''');
    } catch (_) {}
    try {
      await customStatement('''
        UPDATE invoice_brandings SET
          accent_color = COALESCE(accent_color, '#6C63FF'),
          template_style = COALESCE(template_style, 'classic'),
          show_logo = COALESCE(show_logo, 1)
        WHERE user_id = $userId
      ''');
    } catch (_) {}
    try {
      await customStatement('''
        UPDATE app_settings_table SET
          theme_mode = COALESCE(theme_mode, 'light'),
          currency = COALESCE(currency, 'USD'),
          timezone = COALESCE(timezone, 'UTC'),
          subscription_plan = COALESCE(subscription_plan, 'free')
        WHERE user_id = $userId
      ''');
    } catch (_) {}
  }

  /// Safe per-user defaults — never throws; used during sign-up.
  Future<void> safeSeedUserDefaults(int userId, {String name = '', String email = ''}) async {
    await repairUserDefaultsNulls(userId);
    try {
      await into(businessProfiles).insertOnConflictUpdate(
        defaultBusinessProfileCompanion(userId, ownerName: name, email: email),
      );
    } catch (_) {}
    try {
      await into(invoiceBrandings).insertOnConflictUpdate(
        defaultInvoiceBrandingCompanion(userId),
      );
    } catch (_) {}
    try {
      await into(appSettingsTable).insertOnConflictUpdate(
        defaultAppSettingsCompanion(userId),
      );
    } catch (_) {}
    await repairUserDefaultsNulls(userId);
  }

  /// Insert user then ensure row is readable by Drift.
  Future<int> insertUserSafe(UsersCompanion entry) async {
    final userId = await into(users).insert(entry);
    await repairUserDefaultsNulls(userId);
    return userId;
  }
}
