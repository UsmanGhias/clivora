import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../auth/auth_service.dart';
import '../auth/user_roles.dart';
import '../constants/plan_limits.dart';
import '../../data/providers/app_providers.dart';

/// Google Play product ID — create matching subscription in Play Console.
const kProMonthlyProductId = 'clivora_pro_monthly';

final billingServiceProvider = Provider<BillingService>((ref) {
  return BillingService(ref);
});

class BillingService {
  BillingService(this.ref);

  final Ref ref;
  final InAppPurchase _iap = InAppPurchase.instance;

  bool get _canPurchase {
    final user = ref.read(authStateProvider).valueOrNull;
    return isAdminUser(user);
  }

  Future<bool> isAvailable() => _iap.isAvailable();

  Future<List<ProductDetails>> loadProducts() async {
    if (!await isAvailable()) return [];
    final response = await _iap.queryProductDetails({kProMonthlyProductId});
    return response.productDetails;
  }

  Future<bool> purchaseProMonthly() async {
    if (!_canPurchase) return false;
    final products = await loadProducts();
    if (products.isEmpty) return false;
    final product = products.first;
    final purchaseParam = PurchaseParam(productDetails: product);
    return _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    if (!_canPurchase) return;
    await _iap.restorePurchases();
  }

  Future<void> handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    if (!_canPurchase) return;
    for (final purchase in purchases) {
      if (purchase.productID == kProMonthlyProductId &&
          (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored)) {
        await ref.read(planLimitServiceProvider).setPlan(PlanLimits.proPlan);
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      }
    }
  }

  /// Pro is admin-only during beta billing rollout.
  bool get isBillingOpenToUser {
    final user = ref.read(authStateProvider).valueOrNull;
    return isAdminUser(user);
  }
}
