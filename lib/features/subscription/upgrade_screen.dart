import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/user_roles.dart';
import '../../core/constants/plan_limits.dart';
import '../../core/constants/pro_pricing.dart';
import '../../core/services/billing_service.dart';
import '../../core/services/referral_service.dart';
import '../../core/services/subscription_manager.dart';
import '../../core/theme/clivora_colors.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_logo.dart';

/// Free vs Pro vs Pro Plus — Google Play Billing only (Play policy compliant).
class UpgradeScreen extends ConsumerStatefulWidget {
  const UpgradeScreen({super.key});

  @override
  ConsumerState<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends ConsumerState<UpgradeScreen> {
  bool _loading = false;
  String? _status;
  String _proPrice = ProPricing.monthlyLabel;
  String _plusPrice = ProPricing.plusMonthlyLabel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPrices());
  }

  Future<void> _loadPrices() async {
    final billing = ref.read(billingServiceProvider);
    await billing.loadProducts();
    if (!mounted) return;
    setState(() {
      _proPrice = billing.displayPriceForUser(plus: false);
      _plusPrice = billing.displayPriceForUser(plus: true);
    });
  }

  Future<void> _buy({required bool plus}) async {
    setState(() {
      _loading = true;
      _status = null;
    });
    try {
      final billing = ref.read(billingServiceProvider);
      if (!await billing.isAvailable()) {
        setState(() => _status = 'Google Play Billing is unavailable on this device.');
        return;
      }
      final ok = await billing.purchasePlan(plus: plus);
      if (!ok && mounted) {
        setState(() => _status =
            'Could not start purchase. Create the subscription products in Play Console, then try again.');
      }
    } catch (e) {
      if (mounted) setState(() => _status = '$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _restore() async {
    setState(() {
      _loading = true;
      _status = null;
    });
    try {
      await ref.read(billingServiceProvider).restorePurchases();
      if (mounted) {
        setState(() => _status = 'Restoring purchases from Google Play…');
      }
    } catch (e) {
      if (mounted) setState(() => _status = '$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _manageOrCancel() async {
    final ok = await ref.read(billingServiceProvider).openManageSubscription();
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Open Play Store → Payments & subscriptions to cancel.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final isClient = isClientUser(user);
    final isPro = ref.watch(isProProvider);
    final isPlus = ref.watch(isProPlusProvider);
    final referralAsync = ref.watch(referralStatsProvider);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final freeFeatures = isClient ? _clientFreeFeatures : _freelancerFreeFeatures;
    final proFeatures = isClient ? _clientProFeatures : _freelancerProFeatures;
    final plusFeatures = isClient ? _clientPlusFeatures : _freelancerPlusFeatures;

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
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: ClivoraColors.navyDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GOOGLE PLAY · MONTHLY'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isPlus
                              ? 'You are on Pro Plus'
                              : isPro
                                  ? 'Upgrade to Pro Plus'
                                  : 'Grow with CLIVORA Pro',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Subscribe securely through Google Play. Recurring monthly. Cancel anytime in Play subscriptions.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.82),
                            height: 1.45,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<DateTime?>(
                    future: SubscriptionManager.proExpiresAt(),
                    builder: (context, snap) {
                      if (!isPro || snap.data == null) return const SizedBox.shrink();
                      final exp = snap.data!;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? ClivoraColors.darkBorder : ClivoraColors.borderLight,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.verified, color: isPlus ? ClivoraColors.accent : ClivoraColors.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${isPlus ? 'Pro Plus' : 'Pro'} renews / active until '
                                '${exp.year}-${exp.month.toString().padLeft(2, '0')}-${exp.day.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  _PlanCard(
                    title: 'Free',
                    price: r'$0',
                    subtitle: 'Start free',
                    features: freeFeatures,
                    selected: !isPro,
                  ),
                  const SizedBox(height: 12),
                  _PlanCard(
                    title: isClient ? ProPricing.clientTitle : ProPricing.freelancerTitle,
                    price: '$_proPrice/mo',
                    subtitle: 'Core Pro tools · Play Billing',
                    features: proFeatures,
                    selected: isPro && !isPlus,
                    highlight: true,
                  ),
                  const SizedBox(height: 12),
                  _PlanCard(
                    title: ProPricing.plusTitle,
                    price: '$_plusPrice/mo',
                    subtitle: 'Connect marketplace · ${ProPricing.plusOfferBadge}',
                    features: plusFeatures,
                    selected: isPlus,
                    highlight: true,
                    premium: true,
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
                  if (_status != null) ...[
                    const SizedBox(height: 12),
                    Text(_status!, style: TextStyle(color: scheme.error, height: 1.35)),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    'Payments are processed by Google Play only. '
                    'Website /pro is for marketing and admin grants — not used for in-app checkout.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.45,
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                children: [
                  if (!isPlus)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _loading ? null : () => _buy(plus: true),
                        style: FilledButton.styleFrom(
                          backgroundColor: ClivoraColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(
                                isPro
                                    ? 'Upgrade to Pro Plus · $_plusPrice'
                                    : 'Get Pro Plus · $_plusPrice/mo',
                              ),
                      ),
                    ),
                  if (!isPro) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _loading ? null : () => _buy(plus: false),
                        child: Text('Get Pro · $_proPrice/mo'),
                      ),
                    ),
                  ],
                  if (isPro) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _loading ? null : _manageOrCancel,
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Cancel / manage in Google Play'),
                      ),
                    ),
                  ],
                  TextButton(
                    onPressed: _loading ? null : _restore,
                    child: const Text('Restore purchases'),
                  ),
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
  'Milestones + dispute tools',
  'AI assistant & automations',
  'Advanced analytics',
  '5 GB file vault',
  'Team collaboration',
  '500 emails / month',
];

const _freelancerPlusFeatures = [
  'Everything in Pro',
  'CLIVORA Connect marketplace (anonymous until accept)',
  '25 GB vault + 3,000 emails / month',
  'Priority support channel',
  'White-label invoice branding',
  'Unlimited team seats',
  'Milestone automation boosts',
  'Client branded portal extras',
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
  'Leave project reviews',
];

const _clientPlusFeatures = [
  'Everything in Client Pro',
  'CLIVORA Connect: post needs anonymously',
  'Priority support',
  'Branded portal experience',
  'Faster invoice & contract exports',
];

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.features,
    required this.selected,
    this.highlight = false,
    this.premium = false,
  });

  final String title;
  final String price;
  final String subtitle;
  final List<String> features;
  final bool selected;
  final bool highlight;
  final bool premium;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderColor = selected
        ? (premium ? ClivoraColors.accent : ClivoraColors.primary)
        : scheme.outlineVariant;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: premium && selected
            ? ClivoraColors.accent.withValues(alpha: 0.08)
            : highlight && selected
                ? ClivoraColors.primary.withValues(alpha: 0.08)
                : scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: selected ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
              Text(
                price,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: premium ? ClivoraColors.accent : ClivoraColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 10),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 16, color: premium ? ClivoraColors.accent : ClivoraColors.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(f, style: const TextStyle(fontSize: 13, height: 1.3))),
                ],
              ),
            ),
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

  final String code;
  final int referrals;
  final int bonusDays;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.card_giftcard_outlined, color: ClivoraColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  code.isEmpty
                      ? 'Invite friends for bonus Pro days'
                      : 'Code $code · $referrals referrals · $bonusDays bonus days',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
