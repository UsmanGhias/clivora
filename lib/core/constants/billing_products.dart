/// Google Play product IDs — create matching subscriptions in Play Console.
abstract final class BillingProducts {
  /// Freelancer Pro monthly subscription ($9).
  static const freelancerProMonthly = 'clivora_pro_freelancer_monthly';

  /// Client Pro monthly subscription ($9).
  static const clientProMonthly = 'clivora_pro_client_monthly';

  /// Freelancer Pro Plus monthly ($19) — includes CLIVORA Connect.
  static const freelancerProPlusMonthly = 'clivora_pro_plus_freelancer_monthly';

  /// Client Pro Plus monthly ($19) — includes CLIVORA Connect.
  static const clientProPlusMonthly = 'clivora_pro_plus_client_monthly';

  static const all = {
    freelancerProMonthly,
    clientProMonthly,
    freelancerProPlusMonthly,
    clientProPlusMonthly,
  };

  static String proForAccountType(String accountType) {
    return accountType == 'client' ? clientProMonthly : freelancerProMonthly;
  }

  static String plusForAccountType(String accountType) {
    return accountType == 'client' ? clientProPlusMonthly : freelancerProPlusMonthly;
  }

  /// Legacy helper — Pro product for account type.
  static String forAccountType(String accountType) => proForAccountType(accountType);

  static bool isProPlusProduct(String? id) =>
      id == freelancerProPlusMonthly || id == clientProPlusMonthly;

  static bool isProProduct(String? id) =>
      id == freelancerProMonthly || id == clientProMonthly || isProPlusProduct(id);

  static String planForProduct(String? id) {
    if (isProPlusProduct(id)) return 'pro_plus';
    if (isProProduct(id)) return 'pro';
    return 'free';
  }

  /// Deep link to manage / cancel the subscription in Google Play.
  static Uri manageSubscriptionUri({String? sku}) {
    final q = <String, String>{'package': 'org.codcrafters.clivora'};
    if (sku != null && sku.isNotEmpty) q['sku'] = sku;
    return Uri.https('play.google.com', '/store/account/subscriptions', q);
  }
}
