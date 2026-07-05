import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/clivora_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/database/database.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportsProvider);

    return ClivoraScaffold(
      title: 'Reports',
      showBackButton: true,
      body: reportsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) => ListView(
          children: [
            _SectionTitle(title: 'Financial Overview'),
            _ReportCard(
              title: 'Total Revenue',
              value: formatCurrency(data.revenue),
              subtitle: 'From paid invoices',
              color: ClivoraColors.successGreen,
              icon: Icons.trending_up,
            ),
            _ReportCard(
              title: 'Outstanding',
              value: formatCurrency(data.outstanding),
              subtitle: 'Sent & overdue invoices',
              color: ClivoraColors.warningOrange,
              icon: Icons.pending_outlined,
              onTap: () => context.go('/invoices?filter=outstanding'),
            ),
            _ReportCard(
              title: 'Total Expenses',
              value: formatCurrency(data.totalExpenses),
              subtitle: 'All time',
              color: ClivoraColors.errorRed,
              icon: Icons.receipt_outlined,
              onTap: () => context.push('/expenses'),
            ),
            _ReportCard(
              title: 'Net Profit',
              value: formatCurrency(data.profit),
              subtitle: 'Revenue minus expenses',
              color: ClivoraColors.primaryPurple,
              icon: Icons.account_balance_wallet_outlined,
            ),
            const SizedBox(height: 16),
            _SectionTitle(title: 'This Month'),
            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    label: 'Expenses',
                    value: formatCurrency(data.monthlyExpenses),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniStat(
                    label: 'Profit',
                    value: formatCurrency(data.monthlyProfit),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionTitle(title: 'Business Summary'),
            Row(
              children: [
                Expanded(child: _MiniStat(label: 'Customers', value: '${data.customers}')),
                const SizedBox(width: 12),
                Expanded(child: _MiniStat(label: 'Projects', value: '${data.projects}')),
                const SizedBox(width: 12),
                Expanded(child: _MiniStat(label: 'Pending Tasks', value: '${data.pendingTasks}')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.bodySmall),
                      Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                      Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                if (onTap != null) const Icon(Icons.chevron_right, color: ClivoraColors.labelGray),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(calendarEventsProvider);

    return ClivoraScaffold(
      title: 'Calendar',
      showBackButton: true,
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (events) {
          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 56, color: ClivoraColors.labelGray.withValues(alpha: 0.6)),
                  const SizedBox(height: 16),
                  Text('No upcoming events', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ClivoraColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text('Add tasks, projects, or invoices with due dates', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
                ],
              ),
            );
          }
          return ListView.separated(
            itemCount: events.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                tileColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Theme.of(context).dividerColor),
                ),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: event.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('d').format(event.date),
                        style: TextStyle(fontWeight: FontWeight.w700, color: event.color, fontSize: 16),
                      ),
                      Text(
                        DateFormat('MMM').format(event.date),
                        style: TextStyle(fontSize: 10, color: event.color),
                      ),
                    ],
                  ),
                ),
                title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${event.type[0].toUpperCase()}${event.type.substring(1)} · ${DateFormat('EEEE, MMM d').format(event.date)}'),
              );
            },
          );
        },
      ),
    );
  }
}

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(invoicesProvider('sent'));
    final paidAsync = ref.watch(invoicesProvider('paid'));

    return ClivoraScaffold(
      title: 'Payments',
      showBackButton: true,
      body: ListView(
        children: [
          Text('Pending Payments', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          invoicesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const SizedBox.shrink(),
            data: (invoices) {
              if (invoices.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No pending payments', style: TextStyle(color: ClivoraColors.textSecondary)),
                );
              }
              return Column(
                children: invoices.map((inv) => _PaymentTile(invoice: inv, showMarkPaid: true)).toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          Text('Recent Payments', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          paidAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (invoices) {
              if (invoices.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No payments recorded yet', style: TextStyle(color: ClivoraColors.textSecondary)),
                );
              }
              return Column(
                children: invoices.take(10).map((inv) => _PaymentTile(invoice: inv)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends ConsumerWidget {
  const _PaymentTile({required this.invoice, this.showMarkPaid = false});

  final Invoice invoice;
  final bool showMarkPaid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        tileColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Theme.of(context).dividerColor),
        ),
        leading: Icon(
          showMarkPaid ? Icons.pending_outlined : Icons.check_circle,
          color: showMarkPaid ? ClivoraColors.warningOrange : ClivoraColors.successGreen,
        ),
        title: Text(invoice.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(showMarkPaid ? 'Awaiting payment' : 'Paid'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(formatCurrency(invoice.total), style: const TextStyle(fontWeight: FontWeight.w700)),
            if (showMarkPaid) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.check, color: ClivoraColors.successGreen),
                tooltip: 'Mark as paid',
                onPressed: () async {
                  await ref.read(databaseProvider).updateInvoice(
                        invoice.copyWith(status: 'paid', updatedAt: DateTime.now()),
                      );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${invoice.invoiceNumber} marked as paid')),
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
