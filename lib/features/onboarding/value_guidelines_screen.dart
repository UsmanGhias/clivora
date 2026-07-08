import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/clivora_colors.dart';
import '../../shared/widgets/clivora_logo.dart';

/// One-time value proposition shown after splash for new installs.
class ValueGuidelinesScreen extends StatelessWidget {
  const ValueGuidelinesScreen({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClivoraColors.navyDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Center(child: ClivoraLogo(size: 72, borderRadius: 20)),
              const SizedBox(height: 20),
              Text(
                'Work with integrity',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Most freelancing platforms charge high fees on every invoice, message, and milestone. '
                'CLIVORA brings clients and freelancers together on one honest workspace.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.82), height: 1.5, fontSize: 15),
              ),
              const SizedBox(height: 28),
              _GuidelineCard(
                icon: Icons.handshake_outlined,
                title: 'Clients and freelancers together',
                body: 'Share projects, tasks, invoices, and messages in real time with full transparency.',
              ),
              const SizedBox(height: 12),
              _GuidelineCard(
                icon: Icons.timeline_outlined,
                title: 'Tracking clients can trust',
                body: 'Clients see progress, updates, and completed work without chasing screenshots.',
              ),
              const SizedBox(height: 12),
              _GuidelineCard(
                icon: Icons.savings_outlined,
                title: 'Rs 2,000 / month Pro',
                body: 'About \$7 USD. One fair price for unlimited clients, team collaboration, and Pro tools.',
              ),
              const Spacer(),
              FilledButton(
                onPressed: onContinue,
                style: FilledButton.styleFrom(
                  backgroundColor: ClivoraColors.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Continue to CLIVORA'),
              ),
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text('Already have an account?', style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuidelineCard extends StatelessWidget {
  const _GuidelineCard({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ClivoraColors.primaryPurple, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 6),
                Text(body, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), height: 1.4, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
