import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/app_engagement_service.dart';
import '../../core/services/referral_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../shared/widgets/clivora_scaffold.dart';

/// Referral program, share code, track referrals, earn bonus Pro days.
class ReferralScreen extends ConsumerStatefulWidget {
  const ReferralScreen({super.key});

  @override
  ConsumerState<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends ConsumerState<ReferralScreen> {
  final _applyController = TextEditingController();

  @override
  void dispose() {
    _applyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(referralStatsProvider);
    final scheme = Theme.of(context).colorScheme;

    return ClivoraScaffold(
      title: 'Refer & Earn',
      showBackButton: true,
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (stats) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: ClivoraColors.brandGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Invite friends to CLIVORA',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'When they subscribe to Pro, you earn ${ReferralService.bonusDaysPerReferral} bonus days.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), height: 1.35, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            stats.code.isEmpty ? 'N/A' : stats.code,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: stats.code.isEmpty
                            ? null
                            : () {
                                Clipboard.setData(ClipboardData(text: stats.code));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Code copied')),
                                );
                              },
                        icon: const Icon(Icons.copy, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _LongStatRow(label: 'Successful referrals', value: '${stats.count}'),
            const SizedBox(height: 8),
            _LongStatRow(label: 'Bonus Pro days earned', value: '${stats.bonusDays}'),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => ref.read(appEngagementServiceProvider).shareReferral(),
                icon: const Icon(Icons.share_outlined, size: 18),
                label: const Text('Share my referral link'),
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => ref.read(appEngagementServiceProvider).shareApp(),
                icon: const Icon(Icons.ios_share, size: 18),
                label: const Text('Share CLIVORA app'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            const SizedBox(height: 28),
            Text('Have a friend\'s code?', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: scheme.onSurface)),
            const SizedBox(height: 8),
            TextField(
              controller: _applyController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                hintText: 'CLVXXXXXXXXXX',
                prefixIcon: Icon(Icons.redeem_outlined),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  final err = await ref.read(referralServiceProvider).applyReferralCode(_applyController.text);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(err ?? 'Referral code saved. Bonus applies when you subscribe to Pro.')),
                  );
                  if (err == null) _applyController.clear();
                },
                child: const Text('Apply code'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LongStatRow extends StatelessWidget {
  const _LongStatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? ClivoraColors.darkBorder : ClivoraColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
