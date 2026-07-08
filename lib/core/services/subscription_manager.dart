import 'package:shared_preferences/shared_preferences.dart';

import '../constants/billing_products.dart';
import '../constants/plan_limits.dart';

/// Subscription state with grace periods, product tracking, and referral extensions.
class SubscriptionManager {
  static const _kProExpires = 'sub_pro_expires_ms';
  static const _kGraceUntil = 'sub_grace_until_ms';
  static const _kVerifiedPurchase = 'sub_verified_purchase';
  static const _kProductId = 'sub_product_id';
  static const graceDays = 3;

  static Future<void> activatePro({
    Duration period = const Duration(days: 30),
    String? productId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existingMs = prefs.getInt(_kProExpires);
    var base = DateTime.now();
    if (existingMs != null) {
      final existing = DateTime.fromMillisecondsSinceEpoch(existingMs);
      if (existing.isAfter(base)) base = existing;
    }
    final expires = base.add(period);
    await prefs.setInt(_kProExpires, expires.millisecondsSinceEpoch);
    await prefs.setBool(_kVerifiedPurchase, true);
    if (productId != null) await prefs.setString(_kProductId, productId);
    await prefs.remove(_kGraceUntil);
  }

  static Future<void> extendPro({required int days}) async {
    final prefs = await SharedPreferences.getInstance();
    final existingMs = prefs.getInt(_kProExpires);
    final base = existingMs != null
        ? DateTime.fromMillisecondsSinceEpoch(existingMs)
        : DateTime.now();
    final start = base.isAfter(DateTime.now()) ? base : DateTime.now();
    await prefs.setInt(_kProExpires, start.add(Duration(days: days)).millisecondsSinceEpoch);
    await prefs.setBool(_kVerifiedPurchase, true);
  }

  static Future<void> startGracePeriod() async {
    final prefs = await SharedPreferences.getInstance();
    final grace = DateTime.now().add(const Duration(days: graceDays));
    await prefs.setInt(_kGraceUntil, grace.millisecondsSinceEpoch);
  }

  static Future<bool> isProActive() async {
    final prefs = await SharedPreferences.getInstance();
    final expiresMs = prefs.getInt(_kProExpires);
    if (expiresMs == null) return false;
    final expires = DateTime.fromMillisecondsSinceEpoch(expiresMs);
    if (DateTime.now().isBefore(expires)) return true;

    final graceMs = prefs.getInt(_kGraceUntil);
    if (graceMs != null) {
      return DateTime.now().isBefore(DateTime.fromMillisecondsSinceEpoch(graceMs));
    }
    return false;
  }

  static Future<DateTime?> proExpiresAt() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_kProExpires);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  static Future<String?> activeProductId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kProductId);
  }

  static Future<bool> hasVerifiedPayment() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kVerifiedPurchase) ?? false;
  }

  static Future<String> effectivePlan() async {
    return (await isProActive()) ? PlanLimits.proPlan : PlanLimits.freePlan;
  }

  static bool isFreelancerProduct(String? id) =>
      id == BillingProducts.freelancerProMonthly || id == null;
  static bool isClientProduct(String? id) => id == BillingProducts.clientProMonthly;
}
