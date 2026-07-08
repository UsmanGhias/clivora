import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/user_roles.dart';
import '../../core/constants/billing_products.dart';
import '../../core/constants/plan_limits.dart';
import '../../core/constants/pro_pricing.dart';
import '../../core/services/billing_service.dart';
import '../../core/services/referral_service.dart';
import '../../core/services/subscription_manager.dart';
import '../../core/theme/clivora_colors.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_logo.dart';

/// Free vs Pro — separate Google Play subscriptions for freelancers and clients.
class UpgradeScreen extends ConsumerStatefulWidget {
  const UpgradeScreen({super.key});

  @override
  ConsumerState<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends ConsumerState<UpgradeScreen> {
  bool _loading = false;
  List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await ref.read(billingServiceProvider).loadProducts();
    if (mounted) setState(() => _products = products);
  }

  Future<void> _purchase() async {
    setState(() => _loading = true);
    try {
      final ok = await ref.read(billingServiceProvider).purchaseProForCurrentUser();
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not start purchase. Ensure the subscription is active in Google Play Console.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _restore() async {
    setState(() => _loading = true);
    try {
      await ref.read(billingServiceProvider).restorePurchases();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Restore requested')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final isClient = isClientUser(user);
    final isPro = ref.watch(isProProvider);
    final billing = ref.watch(billingServiceProvider);
    final livePrice = billing.displayPriceForUser();
    final productId = billing.productIdForCurrentUser();
    final expiresAsync = ref.watch(proExpiresAtProvider);
    final referralAsync = ref.watch(referralStatsProvider);

    final freeFeatures = isClient ? _clientFreeFeatures : _freelancerFreeFeatures;
    final proFeatures = isClient ? _clientProFeatures : _freelancerProFeatures;
    final planTitle = isClient ? ProPricing.clientTitle : ProPricing.freelancerTitle;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close, size: 22)),
                  const Spacer(),
                  const ClivoraLogo(size: 28, borderRadius: 8),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: ClivoraColors.warningOrange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'LIMITED OFFER · ${ProPricing.offerBadge}',
                      style: const TextStyle(
                        color: ClivoraColors.warningOrange,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    planTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isClient
                        ? 'Unlock contracts, PDF downloads, and priority updates on the client portal.'
                        : 'Unlimited clients, AI, workflows, analytics, and everything to grow your freelance business.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
                  ),
                  const SizedBox(height: 20),
                  _PriceHero(
                    listPrice: ProPricing.listPriceLabel,
                    offerPrice: livePrice != ProPricing.monthlyLabel ? livePrice : ProPricing.monthlyLabel,
                    isPro: isPro,
                  ),
                  const SizedBox(height: 20),
                  _PlanCard(
                    title: 'Free',
                    price: 'Rs 0',
                    subtitle: 'Get started',
                    features: freeFeatures,
                    selected: !isPro,
                  ),
                  const SizedBox(height: 16),
                  _PlanCard(
                    title: planTitle,
                    price: '$livePrice/mo',
                    subtitle: ProPricing.billingNote,
                    features: proFeatures,
                    selected: isPro,
                    highlight: true,
                  ),
                  const SizedBox(height: 16),
                  referralAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (stats) => _ReferralTeaser(
                      code: stats.code,
                      referrals: stats.count,
                      bonusDays: stats.bonusDays,
                      onTap: () => context.push('/referral'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Product ID: $productId\n'
                    '${_products.isEmpty ? "Products not loaded from Play yet — configure in Play Console." : "Google Play price: $livePrice"}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45),
                  ),
                  expiresAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (expires) {
                      if (expires == null || !isPro) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Pro active until ${expires.toLocal().toString().split(' ').first}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ClivoraColors.successGreen),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (!isPro && billing.isBillingOpenToUser)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _purchase,
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text('Subscribe — $livePrice/mo'),
                      ),
                    )
                  else if (!isPro)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: null,
                        child: const Text('Sign in to subscribe'),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.pop(),
                        child: const Text('You\'re on Pro'),
                      ),
                    ),
                  if (billing.isBillingOpenToUser) ...[
                    const SizedBox(height: 8),
                    TextButton(onPressed: _loading ? null : _restore, child: const Text('Restore purchases')),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _freelancerFreeFeatures = [
  'Up to ${PlanLimits.freeMaxClients} clients',
  'Up to ${PlanLimits.freeMaxProjects} projects',
  '${PlanLimits.freeMaxInvoicesPerMonth} invoices / month',
  '${PlanLimits.freeMaxEmailsPerMonth} emails / month',
  '100 MB storage',
  'Basic reports',
];

const _freelancerProFeatures = [
  'Unlimited clients, projects & invoices',
  'Verified profile badge',
  'Biometric app lock',
  'Built-in CLIVORA AI (on-device)',
  'Custom workflows & automations',
  'Advanced analytics',
  '5 GB file vault',
  'Data export & team tools',
  'Calendar & global search',
  '500 emails / month',
];

const _clientFreeFeatures = [
  'View shared projects',
  'In-app chat with freelancer',
  'Basic notifications',
  'Up to ${PlanLimits.freeMaxClientContracts} contracts',
  '${PlanLimits.freeMaxClientInvoiceDownloads} invoice PDF downloads / month',
];

const _clientProFeatures = [
  'Unlimited contracts & PDF export',
  'Unlimited invoice downloads',
  'Verified client badge',
  'Biometric app lock',
  'Advanced activity timeline',
  'Priority notifications',
  'Data export',
  'Full client portal access',
];

class _PriceHero extends StatelessWidget {
  const _PriceHero({required this.listPrice, required this.offerPrice, required this.isPro});

  final String listPrice;
  final String offerPrice;
  final bool isPro;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: ClivoraColors.brandGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isPro) ...[
                  Text(
                    listPrice,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      decoration: TextDecoration.lineThrough,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  isPro ? 'Active' : offerPrice,
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                ),
                Text(
                  isPro ? 'Thank you for supporting CLIVORA' : 'per month · ${ProPricing.offerPercentOff}% off',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
                ),
              ],
            ),
          ),
          if (!isPro)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('BEST VALUE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11)),
            ),
        ],
      ),
    );
  }
}

class _ReferralTeaser extends StatelessWidget {
  const _ReferralTeaser({
    required this.code,
    required this.referrals,
    required this.bonusDays,
    required this.onTap,
  });

  final String? code;
  final int referrals;
  final int bonusDays;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.card_giftcard, color: ClivoraColors.primary),
        title: const Text('Refer friends', style: TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          code != null
              ? 'Your code: $code · $referrals referrals · $bonusDays bonus days earned'
              : 'Earn bonus Pro days when friends subscribe',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.features,
    required this.selected,
    this.highlight = false,
  });

  final String title;
  final String price;
  final String subtitle;
  final List<String> features;
  final bool selected;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? ClivoraColors.primary : Theme.of(context).dividerColor,
          width: selected ? 2 : 1,
        ),
        color: highlight ? ClivoraColors.primary.withValues(alpha: 0.06) : Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const Spacer(),
              if (selected) const Icon(Icons.check_circle, color: ClivoraColors.primary, size: 22),
            ],
          ),
          const SizedBox(height: 4),
          Text(price, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          for (final f in features)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check, size: 16, color: highlight ? ClivoraColors.primary : ClivoraColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(f, style: Theme.of(context).textTheme.bodySmall)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

final proExpiresAtProvider = FutureProvider<DateTime?>((ref) {
  return SubscriptionManager.proExpiresAt();
});

final referralStatsProvider = FutureProvider<({String? code, int count, int bonusDays})>((ref) async {
  final referral = ref.read(referralServiceProvider);
  return (
    code: await referral.myCode(),
    count: await referral.referralCount(),
    bonusDays: await referral.bonusDaysEarned(),
  );
});
