import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/auth/user_roles.dart';
import '../../core/constants/plan_limits.dart';
import '../../core/constants/pro_pricing.dart';
import '../../core/services/billing_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_logo.dart';

/// Free vs Pro plans — Google Play Billing integration.
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
      final ok = await ref.read(billingServiceProvider).purchaseProMonthly();
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not start purchase. Product may not be live in Play Console yet.')),
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
    final isPro = ref.watch(isProProvider);
    final price = _products.isNotEmpty ? _products.first.price : ProPricing.monthlyLabel;
    final billingOpen = ref.watch(billingServiceProvider).isBillingOpenToUser;

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
                  _PlanCard(
                    title: 'Free',
                    price: 'Rs 0',
                    subtitle: 'Great to get started',
                    features: [
                      'Up to ${PlanLimits.freeMaxClients} clients',
                      'Up to ${PlanLimits.freeMaxProjects} projects',
                      '${PlanLimits.freeMaxInvoicesPerMonth} invoices / month',
                      '3 smart templates',
                    ],
                    selected: !isPro,
                  ),
                  const SizedBox(height: 16),
                  _PlanCard(
                    title: 'Pro',
                    price: '$price/mo',
                    subtitle: 'Unlimited growth',
                    features: const [
                      'Unlimited clients & projects',
                      'Unlimited invoices',
                      'Unlimited templates & AI insights',
                      'Workflow automations',
                      'Priority updates',
                    ],
                    selected: isPro,
                    highlight: true,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    billingOpen
                        ? 'Subscribe securely through Google Play. Product ID: $kProMonthlyProductId'
                        : 'Google Play billing is rolling out. Pro is currently available to admin accounts during testing.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (!isPro && billingOpen)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _purchase,
                        child: _loading
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : Text('Upgrade to Pro — $price/mo'),
                      ),
                    )
                  else if (!isPro)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: null,
                        child: Text('Pro coming soon — $price/mo'),
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
                  const SizedBox(height: 10),
                  if (billingOpen)
                    TextButton(onPressed: _loading ? null : _restore, child: const Text('Restore purchases')),
                ],
              ),
            ),
          ],
        ),
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
        gradient: highlight ? ClivoraColors.brandGradient : null,
        color: highlight ? null : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? ClivoraColors.primary : Theme.of(context).dividerColor, width: selected ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: highlight ? Colors.white : null)),
          Text(price, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: highlight ? Colors.white : ClivoraColors.primary)),
          Text(subtitle, style: TextStyle(color: highlight ? Colors.white70 : ClivoraColors.textSecondary)),
          const SizedBox(height: 12),
          for (final f in features)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, size: 18, color: highlight ? Colors.white : ClivoraColors.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(f, style: TextStyle(color: highlight ? Colors.white : null))),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
