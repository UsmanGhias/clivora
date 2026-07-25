abstract final class ProPricing {
  /// Strikethrough list price shown in-app (USD).
  static const listPriceUsd = 14;
  static const listPriceLabel = '\$14';

  /// Standard Pro offer.
  static const offerPriceUsd = 9;
  static const monthlyUsd = offerPriceUsd;
  static const monthlyLabel = '\$9';
  static const billingNote = 'Subscribe via Google Play · Cancel anytime in Play subscriptions';

  static const offerBadge = 'Save \$5';
  static const offerPercentOff = 36;

  /// Pro Plus - flagship plan with CLIVORA Connect.
  static const plusListPriceUsd = 29;
  static const plusListPriceLabel = '\$29';
  static const plusPriceUsd = 19;
  static const plusMonthlyLabel = '\$19';
  static const plusOfferBadge = 'Connect included';

  /// Legacy aliases kept so older call sites compile during migration.
  @Deprecated('Use listPriceUsd')
  static const listPricePkr = listPriceUsd;
  @Deprecated('Use offerPriceUsd')
  static const offerPricePkr = offerPriceUsd;
  @Deprecated('Use monthlyUsd')
  static const monthlyPkr = monthlyUsd;
  @Deprecated('Use plusListPriceUsd')
  static const plusListPricePkr = plusListPriceUsd;
  @Deprecated('Use plusPriceUsd')
  static const plusPricePkr = plusPriceUsd;
  @Deprecated('Removed, prices are USD')
  static const plusUsdApprox = plusMonthlyLabel;

  static const freelancerTitle = 'Freelancer Pro';
  static const clientTitle = 'Client Pro';
  static const plusTitle = 'Pro Plus';

  static const playStorePackage = 'org.codcrafters.clivora';
  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=$playStorePackage';

  /// Web checkout (bank / JazzCash / EasyPaisa / international wire instructions).
  static const webProCheckoutUrl = 'https://clivora.io/pro';
}
