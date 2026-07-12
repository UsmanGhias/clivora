import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/plan_features.dart';
import '../constants/plan_limits.dart';
import 'ai_assistant_service.dart';
import '../../data/database/database.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/providers/app_providers.dart';

final clivoraAiEnhancedProvider = Provider<ClivoraAiEnhancedService>((ref) {
  return ClivoraAiEnhancedService(ref);
});

/// Built-in CLIVORA AI, 100% on-device, no external APIs.
class ClivoraAiEnhancedService {
  ClivoraAiEnhancedService(this.ref);

  final Ref ref;
  final _local = AiAssistantService();

  Future<List<AiInsight>> generateInsights(AppDatabase db, int ownerUserId) async {
    final insights = await _local.generateInsights(db, ownerUserId);
    final plan = await ref.read(planLimitServiceProvider).currentPlan();
    if (!PlanFeatures.aiAssistant(plan)) return insights.take(3).toList();

    final proExtras = await _proInsights(db, ownerUserId);
    return [...proExtras, ...insights];
  }

  Future<List<AiInsight>> _proInsights(AppDatabase db, int ownerUserId) async {
    final extras = <AiInsight>[];
    final invoices = await db.watchInvoicesForUser(ownerUserId).first;
    final customers = await db.watchCustomersForUser(ownerUserId).first;
    final projects = await db.watchProjectsForUser(ownerUserId).first;

    final paidRate = invoices.isEmpty
        ? 0.0
        : invoices.where((i) => i.status == 'paid').length / invoices.length;
    extras.add(AiInsight(
      title: 'Collection health',
      body: paidRate >= 0.7
          ? 'Strong payment rate (${(paidRate * 100).toStringAsFixed(0)}% invoices paid). Keep consistent follow-ups to maintain cash flow.'
          : 'Payment rate is ${(paidRate * 100).toStringAsFixed(0)}%. Consider payment reminders for sent invoices and clearer due dates.',
      actionLabel: 'View invoices',
      category: 'Pro insight',
      route: '/invoices',
    ));

    if (customers.length >= PlanLimits.freeMaxClients) {
      extras.add(AiInsight(
        title: 'Growth opportunity',
        body: 'You are at or near the free client limit. Pro unlocks unlimited clients, workflows, and advanced analytics.',
        actionLabel: 'View Pro',
        category: 'Pro insight',
        route: '/upgrade',
      ));
    }

    final stalled = projects.where((p) => p.status == 'in_progress').length;
    if (stalled > 2) {
      extras.add(AiInsight(
        title: 'Workload balance',
        body: 'You have $stalled active projects. Prioritize the highest-value client this week and update statuses to keep everyone informed.',
        actionLabel: 'Review projects',
        category: 'Pro insight',
        route: '/projects',
      ));
    }

    return extras;
  }
}
