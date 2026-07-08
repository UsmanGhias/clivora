abstract final class ProPricing {
  /// Strikethrough list price shown in-app.
  static const listPricePkr = 2800;
  static const listPriceLabel = 'Rs 2,800';

  /// Limited-time offer price (both freelancer & client pay separately).
  static const offerPricePkr = 2000;
  static const monthlyPkr = offerPricePkr;
  static const monthlyLabel = 'Rs 2,000';
  static const billingNote = 'Billed monthly via Google Play · Cancel anytime';

  static const offerBadge = 'Save Rs 800';
  static const offerPercentOff = 29;

  static const freelancerTitle = 'Freelancer Pro';
  static const clientTitle = 'Client Pro';

  static const playStorePackage = 'org.codcrafters.clivora';
  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=$playStorePackage';
}
