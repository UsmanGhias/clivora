import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/app_engagement_service.dart';
import '../../core/services/referral_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../shared/widgets/clivora_scaffold.dart';
import 'upgrade_screen.dart';

/// Referral program — share code, track referrals, earn bonus Pro days.
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

    return ClivoraScaffold(
      title: 'Refer & Earn',
      showBackButton: true,
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (stats) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: ClivoraColors.brandGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Invite friends to CLIVORA',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Share your code. When they subscribe to Pro, you earn '
                    '${ReferralService.bonusDaysPerReferral} bonus days each time.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            stats.code ?? 'N/A',
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 2),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: stats.code == null
                            ? null
                            : () {
                                Clipboard.setData(ClipboardData(text: stats.code!));
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
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _StatBox(label: 'Referrals', value: '${stats.count}')),
                const SizedBox(width: 12),
                Expanded(child: _StatBox(label: 'Bonus days', value: '${stats.bonusDays}')),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.read(appEngagementServiceProvider).shareReferral(),
              icon: const Icon(Icons.share_outlined),
              label: const Text('Share my referral link'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => ref.read(appEngagementServiceProvider).shareApp(),
              icon: const Icon(Icons.ios_share),
              label: const Text('Share CLIVORA app'),
            ),
            const Divider(height: 40),
            Text('Have a friend\'s code?', style: Theme.of(context).textTheme.titleSmall),
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
            OutlinedButton(
              onPressed: () async {
                await ref.read(referralServiceProvider).applyReferralCode(_applyController.text);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Referral code saved — bonus applies when you subscribe')),
                  );
                }
              },
              child: const Text('Apply code'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
