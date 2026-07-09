import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_service.dart';
import '../cloud/supabase_auth_helper.dart';

final referralServiceProvider = Provider<ReferralService>((ref) {
  return ReferralService(ref);
});

class ReferralStats {
  const ReferralStats({
    required this.code,
    required this.count,
    required this.bonusDays,
  });

  final String code;
  final int count;
  final int bonusDays;
}

final referralStatsProvider = FutureProvider<ReferralStats>((ref) async {
  final service = ref.watch(referralServiceProvider);
  final code = await service.myCode() ?? '';
  final count = await service.referralCount();
  final bonusDays = await service.bonusDaysEarned();
  return ReferralStats(code: code, count: count, bonusDays: bonusDays);
});

/// Referral program — share code, earn bonus Pro days when friends subscribe.
class ReferralService {
  ReferralService(this.ref);

  final Ref ref;

  static const bonusDaysPerReferral = 7;
  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=org.codcrafters.clivora';
  static const playStoreReferralBase = '$playStoreUrl&referrer=';

  String _prefsKey(int userId) => 'clivora_referral_code_v2_$userId';

  bool _isLegacyPredictable(String code) {
    final upper = code.trim().toUpperCase();
    return RegExp(r'^CLIVORA0*\d+$').hasMatch(upper);
  }

  String _generateUniqueCode(int userId) {
    final random = Random.secure();
    final nonce = List<int>.generate(12, (_) => random.nextInt(256));
    final digest = sha256.convert(utf8.encode('clivora_ref_$userId:${nonce.join(',')}'));
    final token = digest.toString().substring(0, 10).toUpperCase();
    return 'CLV$token';
  }

  Future<String?> myCode() async {
    final userId = ref.read(authStateProvider).valueOrNull?.id;
    if (userId == null) return null;

    final prefs = await SharedPreferences.getInstance();
    var code = prefs.getString(_prefsKey(userId));
    if (code == null || code.isEmpty || _isLegacyPredictable(code)) {
      code = _generateUniqueCode(userId);
      await prefs.setString(_prefsKey(userId), code);
      await syncCodeToCloud(code);
    }
    return code;
  }

  Future<void> syncCodeToCloud([String? explicitCode]) async {
    final uid = SupabaseAuthHelper.currentUid;
    final userId = ref.read(authStateProvider).valueOrNull?.id;
    if (uid == null || userId == null) return;
    final code = explicitCode ?? await myCode();
    if (code == null) return;
    try {
      await SupabaseAuthHelper.client.from('referral_codes').upsert({
        'user_id': uid,
        'code': code,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Referral code sync failed: $e');
    }
  }

  Future<String> shareMessage() async {
    final code = await myCode() ?? 'CLIVORA';
    return 'Join me on CLIVORA for clients, projects, invoices and chat. '
        'Use my code $code when you subscribe to Pro. '
        'Download: $playStoreReferralBase$code';
  }

  Future<String?> applyReferralCode(String rawCode) async {
    final code = rawCode.trim().toUpperCase();
    if (code.isEmpty) return 'Enter a referral code';
    final my = await myCode();
    if (my != null && my.toUpperCase() == code) {
      return 'You cannot use your own referral code';
    }
    final userId = ref.read(authStateProvider).valueOrNull?.id;
    if (userId == null) return 'Sign in to apply a referral code';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('clivora_my_referral_used', code);
    await prefs.setInt('clivora_referral_applied_at_$userId', DateTime.now().millisecondsSinceEpoch);
    return null;
  }

  Future<String?> appliedReferralCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('clivora_my_referral_used');
  }

  Future<int> referralCount() async {
    final uid = SupabaseAuthHelper.currentUid;
    if (uid != null) {
      try {
        final row = await SupabaseAuthHelper.client
            .from('referral_codes')
            .select('referral_count')
            .eq('user_id', uid)
            .maybeSingle();
        if (row != null) return (row['referral_count'] as num?)?.toInt() ?? 0;
      } catch (_) {}
    }
    final userId = ref.read(authStateProvider).valueOrNull?.id;
    if (userId == null) return 0;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('clivora_referral_count_$userId') ?? 0;
  }

  Future<void> creditReferrerOnVerifiedPurchase(String code) async {
    final referredUid = SupabaseAuthHelper.currentUid;
    if (referredUid == null) return;

    try {
      final referrerRow = await SupabaseAuthHelper.client
          .from('referral_codes')
          .select('user_id')
          .eq('code', code.trim().toUpperCase())
          .maybeSingle();

      final referrerUid = referrerRow?['user_id'] as String?;
      if (referrerUid == null || referrerUid == referredUid) return;

      await SupabaseAuthHelper.client.rpc('credit_referral_on_purchase', params: {
        'p_referrer_uid': referrerUid,
        'p_referred_uid': referredUid,
        'p_code': code.trim().toUpperCase(),
        'p_bonus_days': bonusDaysPerReferral,
      });
    } catch (e) {
      debugPrint('Cloud referral credit failed: $e');
    }
  }

  Future<void> recordSuccessfulReferralLocal(int referrerUserId) async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt('clivora_referral_count_$referrerUserId') ?? 0) + 1;
    await prefs.setInt('clivora_referral_count_$referrerUserId', count);
    await prefs.setInt(
      'clivora_referral_bonus_days_$referrerUserId',
      count * bonusDaysPerReferral,
    );
  }

  Future<int> bonusDaysEarned() async {
    final uid = SupabaseAuthHelper.currentUid;
    if (uid != null) {
      try {
        final row = await SupabaseAuthHelper.client
            .from('referral_codes')
            .select('bonus_days_earned')
            .eq('user_id', uid)
            .maybeSingle();
        if (row != null) return (row['bonus_days_earned'] as num?)?.toInt() ?? 0;
      } catch (_) {}
    }
    final userId = ref.read(authStateProvider).valueOrNull?.id;
    if (userId == null) return 0;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('clivora_referral_bonus_days_$userId') ?? 0;
  }
}
