import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth/auth_service.dart';
import '../auth/user_roles.dart';
import '../constants/billing_products.dart';
import '../constants/pro_pricing.dart';
import 'analytics_service.dart';
import 'play_billing_verify_service.dart';
import 'referral_service.dart';
import 'subscription_manager.dart';
import '../../data/providers/app_providers.dart';

final billingServiceProvider = Provider<BillingService>((ref) {
  return BillingService(ref);
});

/// Google Play Billing. Pro and Pro Plus monthly subscriptions (no external web checkout in-app).
class BillingService {
  BillingService(this.ref);

  final Ref ref;
  final InAppPurchase _iap = InAppPurchase.instance;

  final Map<String, ProductDetails> _products = {};

  Future<bool> isAvailable() => _iap.isAvailable();

  bool get isBillingOpenToUser {
    final user = ref.read(authStateProvider).valueOrNull;
    return user != null && !isGuestUser(user);
  }

  String _accountType() {
    final user = ref.read(authStateProvider).valueOrNull;
    return isClientUser(user) ? 'client' : 'freelancer';
  }

  String productIdForCurrentUser({required bool plus}) {
    return plus
        ? BillingProducts.plusForAccountType(_accountType())
        : BillingProducts.proForAccountType(_accountType());
  }

  Future<List<ProductDetails>> loadProducts() async {
    if (!await isAvailable()) return [];
    final response = await _iap.queryProductDetails(BillingProducts.all);
    if (response.error != null) {
      debugPrint('Billing query error: ${response.error}');
    }
    for (final p in response.productDetails) {
      _products[p.id] = p;
    }
    return response.productDetails;
  }

  ProductDetails? productForUser({required bool plus}) {
    return _products[productIdForCurrentUser(plus: plus)];
  }

  String displayPriceForUser({required bool plus}) {
    final product = productForUser(plus: plus);
    if (product != null) return product.price;
    return plus ? ProPricing.plusMonthlyLabel : ProPricing.monthlyLabel;
  }

  Future<bool> purchasePlan({required bool plus}) async {
    if (!isBillingOpenToUser) return false;
    await loadProducts();
    final product = productForUser(plus: plus);
    if (product == null) {
      debugPrint('Play product missing: ${productIdForCurrentUser(plus: plus)}');
      return false;
    }
    final param = PurchaseParam(productDetails: product);
    return _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<bool> purchaseProForCurrentUser() => purchasePlan(plus: false);

  Future<bool> purchaseProPlusForCurrentUser() => purchasePlan(plus: true);

  Future<void> restorePurchases() async {
    if (!isBillingOpenToUser) return;
    await _iap.restorePurchases();
  }

  /// Opens Google Play subscription management (cancel / change payment).
  Future<bool> openManageSubscription() async {
    final sku = await SubscriptionManager.activeProductId();
    final uri = BillingProducts.manageSubscriptionUri(sku: sku);
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (!BillingProducts.isProProduct(purchase.productID)) continue;

      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        final user = ref.read(authStateProvider).valueOrNull;
        final expectedPro = productIdForCurrentUser(plus: false);
        final expectedPlus = productIdForCurrentUser(plus: true);

        if (user != null &&
            purchase.productID != expectedPro &&
            purchase.productID != expectedPlus) {
          debugPrint('Purchase product ${purchase.productID} does not match account type');
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          continue;
        }

        final verify = await ref.read(playBillingVerifyServiceProvider).verifyPurchase(purchase);
        if (verify == null || !verify.active) {
          debugPrint('Play purchase not verified, plan not activated');
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          continue;
        }

        final period = verify.expiresAt != null
            ? verify.expiresAt!.difference(DateTime.now())
            : const Duration(days: 30);

        await SubscriptionManager.activatePro(
          productId: purchase.productID,
          period: period.isNegative ? const Duration(days: 30) : period,
        );

        final plan = BillingProducts.planForProduct(purchase.productID);
        await ref.read(planLimitServiceProvider).setPlan(plan);
        ref.invalidate(serverSubscriptionProvider);
        ref.invalidate(cloudSubscriptionPlanProvider);
        ref.invalidate(subscriptionPlanProvider);

        if (user != null) {
          await ref.read(analyticsServiceProvider).trackProActivation(
                email: user.email,
                name: user.name,
              );
        }

        await _applyReferralBonusIfAny();

        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      } else if (purchase.status == PurchaseStatus.error) {
        debugPrint('Purchase error: ${purchase.error}');
      }
    }
  }

  Future<void> _applyReferralBonusIfAny() async {
    final referral = ref.read(referralServiceProvider);
    final applied = await referral.appliedReferralCode();
    if (applied == null) return;
    await referral.creditReferrerOnVerifiedPurchase(applied);
  }
}

const kProMonthlyProductId = BillingProducts.freelancerProMonthly;
