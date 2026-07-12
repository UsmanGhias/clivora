import '../../core/utils/template_utils.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/database/database.dart';

class AiInsight {
  const AiInsight({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.category,
    this.route,
    this.copyable = false,
  });

  final String title;
  final String body;
  final String actionLabel;
  final String category;
  final String? route;
  final bool copyable;
}

/// Local smart insights generated from your business data, no cloud AI required.
class AiAssistantService {
  Future<List<AiInsight>> generateInsights(AppDatabase db, int ownerUserId) async {
    final insights = <AiInsight>[];
    final invoices = await db.watchInvoicesForUser(ownerUserId).first;
    final customers = await db.watchCustomersForUser(ownerUserId).first;
    final projects = await db.watchProjectsForUser(ownerUserId).first;
    final tasks = await db.watchTasksForUser(ownerUserId).first;
    final expenses = await db.watchExpensesForUser(ownerUserId).first;
    final profile = await db.watchBusinessProfileForUser(ownerUserId).first;
    final settings = await db.watchAppSettingsForUser(ownerUserId).first;
    final currency = settings.currency.isNotEmpty ? settings.currency : 'USD';

    final overdue = invoices.where((i) => i.status == 'overdue').toList();
    final outstanding = invoices.where((i) => i.status == 'sent' || i.status == 'overdue');
    final outstandingTotal = outstanding.fold<double>(0, (s, i) => s + i.total);
    final paidTotal = invoices.where((i) => i.status == 'paid').fold<double>(0, (s, i) => s + i.total);
    final expenseTotal = expenses.fold<double>(0, (s, e) => s + e.amount);

    if (overdue.isNotEmpty) {
      final inv = overdue.first;
      final body = await fillTemplateForInvoice(
        db,
        ownerUserId,
        'Hi {{clientName}},\n\nThis is a friendly reminder that invoice {{invoiceNumber}} for {{amount}} is now overdue. Please let us know if you need a copy resent or wish to discuss payment options.\n\nBest regards,\n{{businessName}}',
        inv,
      );
      insights.add(AiInsight(
        title: 'Follow up on ${overdue.length} overdue invoice${overdue.length > 1 ? 's' : ''}',
        body: body,
        actionLabel: 'View invoices',
        category: 'Follow-up',
        route: '/invoices',
        copyable: true,
      ));
    }

    if (outstandingTotal > 0) {
      insights.add(AiInsight(
        title: 'Outstanding balance: ${_formatMoney(outstandingTotal, currency)}',
        body: 'You have ${outstanding.length} unpaid invoice${outstanding.length > 1 ? 's' : ''} totalling ${_formatMoney(outstandingTotal, currency)}. Consider sending a payment reminder this week to improve cash flow.',
        actionLabel: 'View outstanding',
        category: 'Finance',
        route: '/invoices?filter=outstanding',
      ));
    }

    // 30-day cash-flow forecast from due invoices
    final now = DateTime.now();
    final dueSoon = invoices.where((i) {
      if (i.status != 'sent' && i.status != 'overdue') return false;
      final due = i.dueDate;
      if (due == null) return true;
      return !due.isAfter(now.add(const Duration(days: 30)));
    }).toList();
    if (dueSoon.isNotEmpty) {
      final forecast = dueSoon.fold<double>(0, (s, i) => s + i.total);
      insights.add(AiInsight(
        title: '30-day cash-flow forecast',
        body: '${dueSoon.length} invoice(s) due within 30 days total ${_formatMoney(forecast, currency)}. Prioritize collections on the oldest first.',
        actionLabel: 'Open invoices',
        category: 'Forecast',
        route: '/invoices',
      ));
    }

    // Clients with unpaid > 14 days
    final longUnpaid = invoices.where((i) {
      if (i.status != 'sent' && i.status != 'overdue') return false;
      final due = i.dueDate ?? i.updatedAt;
      return now.difference(due).inDays >= 14;
    }).toList();
    if (longUnpaid.isNotEmpty) {
      insights.add(AiInsight(
        title: '${longUnpaid.length} client invoice(s) unpaid 14+ days',
        body: 'Oldest: ${longUnpaid.first.invoiceNumber}. Send a firm follow-up or offer a payment plan.',
        actionLabel: 'Follow up',
        category: 'Collections',
        route: '/invoices',
        copyable: true,
      ));
    }

    // Bill unbilled time prompt
    try {
      final entries = await (db.select(db.projectTimeEntries)
            ..where((t) => t.ownerUserId.equals(ownerUserId)))
          .get();
      final thisMonth = DateTime(now.year, now.month);
      final billedProjectIds = invoices
          .where((i) => i.createdAt.isAfter(thisMonth) && i.projectId != null)
          .map((i) => i.projectId!)
          .toSet();
      final unbilledSeconds = <int, int>{};
      for (final e in entries) {
        if (e.endedAt == null) continue;
        if (e.startedAt.isBefore(thisMonth)) continue;
        if (billedProjectIds.contains(e.projectId)) continue;
        unbilledSeconds[e.projectId] = (unbilledSeconds[e.projectId] ?? 0) +
            e.endedAt!.difference(e.startedAt).inSeconds;
      }
      if (unbilledSeconds.isNotEmpty) {
        final projectId = unbilledSeconds.entries.first.key;
        final hours = (unbilledSeconds[projectId]! / 3600).toStringAsFixed(1);
        insights.add(AiInsight(
          title: 'Bill unbilled time',
          body: 'Project #$projectId has ~$hours tracked hours this month with no invoice yet. Create a draft from Hub → Bill work.',
          actionLabel: 'Open projects',
          category: 'Billing',
          route: '/projects',
        ));
      }
    } catch (_) {}

    if (paidTotal > 0 && customers.isNotEmpty) {
      final margin = paidTotal - expenseTotal;
      insights.add(AiInsight(
        title: 'Revenue snapshot',
        body: 'Collected: ${_formatMoney(paidTotal, currency)} · Expenses: ${_formatMoney(expenseTotal, currency)} · Net: ${_formatMoney(margin, currency)} across ${customers.length} client${customers.length > 1 ? 's' : ''}.',
        actionLabel: 'Open reports',
        category: 'Analytics',
        route: '/reports',
      ));
    }

    final staleProjects = projects.where((p) => p.status == 'in_progress').toList();
    if (staleProjects.isNotEmpty) {
      insights.add(AiInsight(
        title: '${staleProjects.length} active project${staleProjects.length > 1 ? 's' : ''} need attention',
        body: 'Review progress on: ${staleProjects.take(3).map((p) => p.name).join(', ')}${staleProjects.length > 3 ? '…' : ''}. Update status or add tasks to keep delivery on track.',
        actionLabel: 'Review projects',
        category: 'Projects',
        route: '/projects',
      ));
    }

    final dueTasks = tasks.where((t) => !t.completed && t.dueDate != null).toList();
    if (dueTasks.isNotEmpty) {
      insights.add(AiInsight(
        title: '${dueTasks.length} upcoming task${dueTasks.length > 1 ? 's' : ''}',
        body: 'Priority: ${dueTasks.first.title}${dueTasks.length > 1 ? ' and ${dueTasks.length - 1} more' : ''}. Completing these will keep your client commitments on schedule.',
        actionLabel: 'View tasks',
        category: 'Tasks',
        route: '/tasks',
      ));
    }

    final draftInvoices = invoices.where((i) => i.status == 'draft').length;
    if (draftInvoices > 0) {
      insights.add(AiInsight(
        title: '$draftInvoices draft invoice${draftInvoices > 1 ? 's' : ''} ready to send',
        body: 'Finalize and send drafts to accelerate payments. Use your saved templates for consistent, professional client communication.',
        actionLabel: 'Open invoices',
        category: 'Billing',
        route: '/invoices',
      ));
    }

    if (customers.isEmpty) {
      insights.add(AiInsight(
        title: 'Get started with your first client',
        body: 'Add a customer with full address details to unlock invoicing, contracts, and AI-powered follow-up drafts tailored to each client.',
        actionLabel: 'Add client',
        category: 'Getting started',
        route: '/customers/new',
      ));
    } else if (profile.businessName.isEmpty) {
      insights.add(AiInsight(
        title: 'Complete your business profile',
        body: 'Add your business name and logo to unlock branded invoices and professional contracts for ${profile.ownerName.isNotEmpty ? profile.ownerName : 'your studio'}.',
        actionLabel: 'Edit profile',
        category: 'Branding',
        route: '/profile',
      ));
    }

    if (insights.isEmpty) {
      insights.add(AiInsight(
        title: 'Your business looks healthy',
        body: 'No urgent actions detected. Use CLIVORA to log expenses, create templates, and stay ahead of deadlines.',
        actionLabel: 'Explore workspace',
        category: 'Summary',
        route: '/more',
      ));
    }

    return insights;
  }

  String _formatMoney(double amount, String currency) => '$currency ${amount.toStringAsFixed(0)}';
}
