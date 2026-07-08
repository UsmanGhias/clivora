import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../cloud/supabase_auth_helper.dart';

final playBillingVerifyServiceProvider = Provider<PlayBillingVerifyService>((ref) {
  return PlayBillingVerifyService();
});

class PlayVerifyResult {
  const PlayVerifyResult({
    required this.active,
    this.expiresAt,
    this.productId,
    this.verified = false,
  });

  final bool active;
  final DateTime? expiresAt;
  final String? productId;
  final bool verified;
}

/// Verifies Google Play purchases via Supabase Edge Function before granting Pro locally.
class PlayBillingVerifyService {
  static const packageName = 'org.codcrafters.clivora';

  Future<PlayVerifyResult?> verifyPurchase(PurchaseDetails purchase) async {
    final token = purchase.verificationData.serverVerificationData;
    if (token.isEmpty) {
      debugPrint('Play verify: empty purchase token');
      return null;
    }

    try {
      final response = await SupabaseAuthHelper.client.functions.invoke(
        'verify-play-purchase',
        body: {
          'productId': purchase.productID,
          'purchaseToken': token,
          'packageName': packageName,
        },
      );

      if (response.status != 200) {
        debugPrint('Play verify failed: ${response.status} ${response.data}');
        return null;
      }

      final data = response.data as Map<String, dynamic>? ?? {};
      final expiresRaw = data['expiresAt'] as String?;
      return PlayVerifyResult(
        active: data['active'] == true,
        expiresAt: expiresRaw != null ? DateTime.tryParse(expiresRaw) : null,
        productId: data['productId'] as String? ?? purchase.productID,
        verified: data['verified'] != false,
      );
    } catch (e) {
      debugPrint('Play verify error: $e');
      return null;
    }
  }
}
