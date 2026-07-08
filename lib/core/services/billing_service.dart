import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../auth/auth_service.dart';
import '../auth/user_roles.dart';
import '../constants/billing_products.dart';
import '../constants/plan_limits.dart';
import '../constants/pro_pricing.dart';
import 'referral_service.dart';
import 'subscription_manager.dart';
import '../../data/providers/app_providers.dart';

final billingServiceProvider = Provider<BillingService>((ref) {
  return BillingService(ref);
});

/// Google Play Billing — separate Pro subscriptions for freelancers and clients.
class BillingService {
  BillingService(this.ref);

  final Ref ref;
  final InAppPurchase _iap = InAppPurchase.instance;

  ProductDetails? _freelancerProduct;
  ProductDetails? _clientProduct;

  Future<bool> isAvailable() => _iap.isAvailable();

  /// Billing is open to all signed-in users when Play Billing is available.
  bool get isBillingOpenToUser {
    final user = ref.read(authStateProvider).valueOrNull;
    return user != null && !isGuestUser(user);
  }

  String productIdForCurrentUser() {
    final user = ref.read(authStateProvider).valueOrNull;
    final type = isClientUser(user) ? 'client' : 'freelancer';
    return BillingProducts.forAccountType(type);
  }

  Future<List<ProductDetails>> loadProducts() async {
    if (!await isAvailable()) return [];
    final response = await _iap.queryProductDetails(BillingProducts.all);
    if (response.error != null) {
      debugPrint('Billing query error: ${response.error}');
    }
    for (final p in response.productDetails) {
      if (p.id == BillingProducts.freelancerProMonthly) _freelancerProduct = p;
      if (p.id == BillingProducts.clientProMonthly) _clientProduct = p;
    }
    return response.productDetails;
  }

  ProductDetails? productForUser() {
    final user = ref.read(authStateProvider).valueOrNull;
    if (isClientUser(user)) return _clientProduct;
    return _freelancerProduct;
  }

  String displayPriceForUser() {
    final product = productForUser();
    if (product != null) return product.price;
    return ProPricing.monthlyLabel;
  }

  Future<bool> purchaseProForCurrentUser() async {
    if (!isBillingOpenToUser) return false;
    final products = await loadProducts();
    if (products.isEmpty) return false;

    final product = productForUser();
    if (product == null) return false;

    final param = PurchaseParam(productDetails: product);
    return _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() async {
    if (!isBillingOpenToUser) return;
    await _iap.restorePurchases();
  }

  Future<void> handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      final isValidProduct = purchase.productID == BillingProducts.freelancerProMonthly ||
          purchase.productID == BillingProducts.clientProMonthly;

      if (!isValidProduct) continue;

      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        final user = ref.read(authStateProvider).valueOrNull;
        final expectedId = productIdForCurrentUser();

        if (user != null && purchase.productID != expectedId) {
          debugPrint('Purchase product ${purchase.productID} does not match account type');
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          continue;
        }

        await SubscriptionManager.activatePro(productId: purchase.productID);
        await ref.read(planLimitServiceProvider).setPlan(PlanLimits.proPlan);
        await _applyReferralBonusIfAny();

        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      } else if (purchase.status == PurchaseStatus.error) {
        await SubscriptionManager.startGracePeriod();
      }
    }
  }

  Future<void> _applyReferralBonusIfAny() async {
    final referral = ref.read(referralServiceProvider);
    final applied = await referral.appliedReferralCode();
    if (applied == null) return;
    final referrerId = referral.userIdFromCode(applied);
    if (referrerId != null) {
      await referral.recordSuccessfulReferral(referrerId);
      await SubscriptionManager.extendPro(days: ReferralService.bonusDaysPerReferral);
    }
  }
}

/// Legacy alias for older call sites.
const kProMonthlyProductId = BillingProducts.freelancerProMonthly;
