import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_service.dart';
import '../constants/plan_limits.dart';

final referralServiceProvider = Provider<ReferralService>((ref) {
  return ReferralService(ref);
});

/// Referral program — share code, earn bonus Pro days when friends subscribe.
class ReferralService {
  ReferralService(this.ref);

  final Ref ref;

  static const bonusDaysPerReferral = 7;
  static const playStoreReferralBase = 'https://play.google.com/store/apps/details?id=org.codcrafters.clivora&referrer=';

  String codeForUser(int userId) {
    final hash = userId.toRadixString(36).toUpperCase();
    return 'CLIVORA${hash.padLeft(6, '0').substring(0, 6)}';
  }

  Future<String?> myCode() async {
    final userId = ref.read(authStateProvider).valueOrNull?.id;
    if (userId == null) return null;
    return codeForUser(userId);
  }

  Future<String> shareMessage() async {
    final code = await myCode() ?? 'CLIVORA';
    return 'Join me on CLIVORA — the business OS for freelancers & clients. '
        'Use my code $code when you sign up. '
        'Download: $playStoreReferralBase$code';
  }

  Future<void> applyReferralCode(String rawCode) async {
    final code = rawCode.trim().toUpperCase();
    if (code.isEmpty) return;
    final userId = ref.read(authStateProvider).valueOrNull?.id;
    if (userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('clivora_my_referral_used', code);
    await prefs.setInt('clivora_referral_applied_at_$userId', DateTime.now().millisecondsSinceEpoch);
  }

  Future<String?> appliedReferralCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('clivora_my_referral_used');
  }

  Future<int> referralCount() async {
    final userId = ref.read(authStateProvider).valueOrNull?.id;
    if (userId == null) return 0;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('clivora_referral_count_$userId') ?? 0;
  }

  /// Call when a referred user completes their first Pro purchase.
  Future<void> recordSuccessfulReferral(int referrerUserId) async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt('clivora_referral_count_$referrerUserId') ?? 0) + 1;
    await prefs.setInt('clivora_referral_count_$referrerUserId', count);
    await prefs.setInt(
      'clivora_referral_bonus_days_$referrerUserId',
      count * bonusDaysPerReferral,
    );
  }

  Future<int> bonusDaysEarned() async {
    final userId = ref.read(authStateProvider).valueOrNull?.id;
    if (userId == null) return 0;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('clivora_referral_bonus_days_$userId') ?? 0;
  }

  /// Resolve referrer user id from code (local heuristic; cloud sync can extend later).
  int? userIdFromCode(String code) {
    final normalized = code.trim().toUpperCase().replaceFirst('CLIVORA', '');
    if (normalized.isEmpty) return null;
    try {
      return int.parse(normalized, radix: 36);
    } catch (_) {
      return null;
    }
  }
}
