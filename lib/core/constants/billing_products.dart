/// Google Play product IDs — create matching subscriptions in Play Console.
abstract final class BillingProducts {
  /// Freelancer Pro monthly subscription (Rs 2,000 offer).
  static const freelancerProMonthly = 'clivora_pro_freelancer_monthly';

  /// Client Pro monthly subscription (Rs 2,000 offer).
  static const clientProMonthly = 'clivora_pro_client_monthly';

  static const all = {freelancerProMonthly, clientProMonthly};

  static String forAccountType(String accountType) {
    return accountType == 'client' ? clientProMonthly : freelancerProMonthly;
  }
}
