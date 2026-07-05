import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' show Value;

import '../../core/cloud/cloud_message_repository.dart';
import '../../core/auth/auth_service.dart';
import '../../data/models/invoice_line_item.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/database/database.dart';
import '../../data/providers/app_providers.dart';

final automationSettingsProvider =
    StateNotifierProvider<AutomationSettingsNotifier, AutomationSettings>((ref) {
  return AutomationSettingsNotifier();
});

class AutomationSettings {
  const AutomationSettings({
    this.overdueFollowUp = true,
    this.customerWelcome = true,
    this.weeklySummary = false,
  });

  final bool overdueFollowUp;
  final bool customerWelcome;
  final bool weeklySummary;

  AutomationSettings copyWith({
    bool? overdueFollowUp,
    bool? customerWelcome,
    bool? weeklySummary,
  }) {
    return AutomationSettings(
      overdueFollowUp: overdueFollowUp ?? this.overdueFollowUp,
      customerWelcome: customerWelcome ?? this.customerWelcome,
      weeklySummary: weeklySummary ?? this.weeklySummary,
    );
  }
}

class AutomationSettingsNotifier extends StateNotifier<AutomationSettings> {
  AutomationSettingsNotifier() : super(const AutomationSettings()) {
    _load();
  }

  static const _kOverdue = 'auto_overdue_followup';
  static const _kWelcome = 'auto_customer_welcome';
  static const _kWeekly = 'auto_weekly_summary';
  static const _kWeeklyLast = 'auto_weekly_summary_last';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = AutomationSettings(
      overdueFollowUp: prefs.getBool(_kOverdue) ?? true,
      customerWelcome: prefs.getBool(_kWelcome) ?? true,
      weeklySummary: prefs.getBool(_kWeekly) ?? false,
    );
  }

  Future<void> setOverdueFollowUp(bool value) async {
    state = state.copyWith(overdueFollowUp: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOverdue, value);
  }

  Future<void> setCustomerWelcome(bool value) async {
    state = state.copyWith(customerWelcome: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kWelcome, value);
  }

  Future<void> setWeeklySummary(bool value) async {
    state = state.copyWith(weeklySummary: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kWeekly, value);
  }
}

final automationServiceProvider = Provider<AutomationService>((ref) {
  return AutomationService(ref);
});

class AutomationService {
  AutomationService(this.ref);

  final Ref ref;

  Future<void> onCustomerCreated(Customer customer) async {
    if (!ref.read(automationSettingsProvider).customerWelcome) return;
    final ownerId = ref.read(authStateProvider).valueOrNull?.id;
    if (ownerId == null) return;
    final db = ref.read(databaseProvider);
    final emails = parseStringList(customer.emails);
    if (emails.isEmpty) return;

    await db.insertNote(
      NotesCompanion.insert(
        ownerUserId: ownerId,
        title: 'Welcome ${customer.contactPerson}',
        content: Value('Invite sent to ${emails.first}. Confirm project scope and next steps.'),
        type: Value('client'),
        customerId: Value(customer.id),
      ),
    );
    await db.insertTask(
      TasksCompanion.insert(
        ownerUserId: ownerId,
        title: 'Welcome ${customer.contactPerson}',
        description: Value('Confirm client received invite and project details.'),
        customerId: Value(customer.id),
        priority: Value('medium'),
      ),
    );
    // Welcome / invite message is sent via ClientInviteService when the customer is created.
  }

  Future<void> onClientAccountLinked(int clientUserId, int freelancerUserId) async {
    if (!ref.read(automationSettingsProvider).customerWelcome) return;
    final db = ref.read(databaseProvider);
    final freelancer = await db.getUser(freelancerUserId);
    final client = await db.getUser(clientUserId);
    if (freelancer == null || client == null) return;
    final profile = await db.watchBusinessProfileForUser(freelancerUserId).first;
    final businessName = profile.businessName.isNotEmpty ? profile.businessName : profile.ownerName;
    await ref.read(cloudMessageRepositoryProvider).sendHybrid(
      fromUser: freelancer,
      toEmail: client.email,
      subject: 'Welcome to $businessName',
      body:
          'Hi! Your freelancer has connected you on Clivora. You can now view shared projects, hours tracked, invoices, and messages here.',
      localToUserId: clientUserId,
    );
  }

  Future<void> onInvoiceSaved(Invoice invoice, {String? previousStatus}) async {
    if (!ref.read(automationSettingsProvider).overdueFollowUp) return;
    if (invoice.status != 'overdue') return;
    if (previousStatus == 'overdue') return;

    final db = ref.read(databaseProvider);
    final ownerId = ref.read(authStateProvider).valueOrNull?.id;
    if (ownerId == null) return;
    final existing = await db.watchTasksForUser(ownerId).first;
    final already = existing.any(
      (t) => t.title.contains(invoice.invoiceNumber) && !t.completed,
    );
    if (already) return;

    await db.insertTask(
      TasksCompanion.insert(
        ownerUserId: ownerId,
        title: 'Follow up: ${invoice.invoiceNumber}',
        description: Value('Invoice is overdue. Send payment reminder to client.'),
        customerId: Value(invoice.customerId),
        projectId: Value(invoice.projectId),
        priority: Value('high'),
        dueDate: Value(DateTime.now()),
      ),
    );

    if (invoice.projectId != null) {
      final link = await (db.select(db.projectClientLinks)
            ..where((t) => t.projectId.equals(invoice.projectId!)))
          .getSingleOrNull();
      final fromUser = ref.read(authStateProvider).valueOrNull;
      if (fromUser != null && link != null) {
        final clientUser = link.clientUserId != null ? await db.getUser(link.clientUserId!) : null;
        final clientEmail = clientUser?.email ?? link.clientEmail;
        await ref.read(cloudMessageRepositoryProvider).sendHybrid(
          fromUser: fromUser,
          toEmail: clientEmail,
          subject: 'Invoice ${invoice.invoiceNumber} is overdue',
          body:
              'This is a reminder that invoice ${invoice.invoiceNumber} for ${invoice.currency} ${invoice.total.toStringAsFixed(2)} is now overdue. Please contact us if you need assistance.',
          localToUserId: link.clientUserId,
          localProjectId: invoice.projectId,
        );
      }
    }
  }

  Future<void> runWeeklySummaryIfDue() async {
    if (!ref.read(automationSettingsProvider).weeklySummary) return;
    final ownerId = ref.read(authStateProvider).valueOrNull?.id;
    if (ownerId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final lastMs = prefs.getInt(AutomationSettingsNotifier._kWeeklyLast) ?? 0;
    final last = DateTime.fromMillisecondsSinceEpoch(lastMs);
    final now = DateTime.now();
    if (now.difference(last).inDays < 7) return;

    final db = ref.read(databaseProvider);
    final invoices = await db.watchInvoicesForUser(ownerId).first;
    final paid = invoices.where((i) => i.status == 'paid').fold<double>(0, (s, i) => s + i.total);
    final outstanding = invoices.where((i) => i.status == 'sent' || i.status == 'overdue').fold<double>(0, (s, i) => s + i.total);

    await db.insertNote(
      NotesCompanion.insert(
        ownerUserId: ownerId,
        title: 'Weekly revenue summary',
        content: Value(
          'Collected: USD ${paid.toStringAsFixed(0)} · Outstanding: USD ${outstanding.toStringAsFixed(0)} · ${invoices.length} total invoices.',
        ),
        type: Value('report'),
      ),
    );
    await prefs.setInt(AutomationSettingsNotifier._kWeeklyLast, now.millisecondsSinceEpoch);
  }
}
