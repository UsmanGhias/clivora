import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clivora/core/constants/billing_products.dart';
import 'package:clivora/core/services/billing_service.dart';
import 'package:clivora/core/services/play_billing_verify_service.dart';
import 'package:clivora/core/services/subscription_manager.dart';

class FakeInAppPurchase implements InAppPurchase {
  final List<PurchaseDetails> completedPurchases = [];

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    completedPurchases.add(purchase);
  }

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => const Stream.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakePlayBillingVerifyService implements PlayBillingVerifyService {
  FakePlayBillingVerifyService(this._result);

  final PlayVerifyResult? _result;

  @override
  Future<PlayVerifyResult?> verifyPurchase(PurchaseDetails purchase) async {
    return _result;
  }
}

PurchaseDetails createTestPurchase({
  String productId = BillingProducts.freelancerProMonthly,
  bool pendingComplete = true,
}) {
  return PurchaseDetails(
    purchaseID: 'test-purchase-1',
    productID: productId,
    verificationData: PurchaseVerificationData(
      localVerificationData: 'local-test-token',
      serverVerificationData: 'server-test-token',
      source: 'google_play',
    ),
    transactionDate: DateTime.now().millisecondsSinceEpoch.toString(),
    status: PurchaseStatus.purchased,
  )..pendingCompletePurchase = pendingComplete;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SubscriptionManager.clearLocalSubscription();
  });

  tearDown(() async {
    await SubscriptionManager.clearLocalSubscription();
  });

  group('BillingService.handlePurchaseUpdates', () {
    test('verify returns null: does not complete purchase and does not activate Pro', () async {
      final fakeIap = FakeInAppPurchase();
      final testBillingProvider = Provider<BillingService>((ref) {
        return BillingService(ref, fakeIap, () => null);
      });

      final container = ProviderContainer(
        overrides: [
          playBillingVerifyServiceProvider.overrideWithValue(
            FakePlayBillingVerifyService(null),
          ),
        ],
      );
      addTearDown(container.dispose);

      final billingService = container.read(testBillingProvider);
      final purchase = createTestPurchase();

      await billingService.handlePurchaseUpdates([purchase]);

      // Complete purchase must NOT be called on transient verify failure
      expect(fakeIap.completedPurchases, isEmpty);
      // Pro must NOT be activated
      expect(await SubscriptionManager.isProActive(), isFalse);
    });

    test('verify returns inactive: completes purchase but does not activate Pro', () async {
      final fakeIap = FakeInAppPurchase();
      final testBillingProvider = Provider<BillingService>((ref) {
        return BillingService(ref, fakeIap, () => null);
      });

      final container = ProviderContainer(
        overrides: [
          playBillingVerifyServiceProvider.overrideWithValue(
            FakePlayBillingVerifyService(
              const PlayVerifyResult(active: false, verified: false),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final billingService = container.read(testBillingProvider);
      final purchase = createTestPurchase();

      await billingService.handlePurchaseUpdates([purchase]);

      // Complete purchase IS called to acknowledge and clear rejected purchase from queue
      expect(fakeIap.completedPurchases, hasLength(1));
      expect(fakeIap.completedPurchases.first.purchaseID, 'test-purchase-1');
      // Pro must NOT be activated
      expect(await SubscriptionManager.isProActive(), isFalse);
    });

    test('verify returns active: activates Pro and completes purchase', () async {
      final fakeIap = FakeInAppPurchase();
      final testBillingProvider = Provider<BillingService>((ref) {
        return BillingService(ref, fakeIap, () => null);
      });

      final container = ProviderContainer(
        overrides: [
          playBillingVerifyServiceProvider.overrideWithValue(
            FakePlayBillingVerifyService(
              PlayVerifyResult(
                active: true,
                verified: true,
                expiresAt: DateTime.now().add(const Duration(days: 30)),
                productId: BillingProducts.freelancerProMonthly,
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final billingService = container.read(testBillingProvider);
      final purchase = createTestPurchase();

      await billingService.handlePurchaseUpdates([purchase]);

      // Pro IS activated
      expect(await SubscriptionManager.isProActive(), isTrue);
      expect(await SubscriptionManager.activeProductId(), BillingProducts.freelancerProMonthly);
      // Complete purchase IS called
      expect(fakeIap.completedPurchases, hasLength(1));
      expect(fakeIap.completedPurchases.first.purchaseID, 'test-purchase-1');
    });
  });
}
