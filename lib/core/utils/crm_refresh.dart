import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/app_providers.dart';

/// Refresh counts and dashboard after CRM changes. Stream list providers auto-update from Drift.
void invalidateCrmData(WidgetRef ref, {bool customers = false, bool projects = false, bool invoices = false}) {
  if (customers) {
    ref.invalidate(customerCountProvider);
  }
  if (projects) {
    ref.invalidate(projectCountProvider);
    ref.invalidate(projectStatsProvider);
  }
  if (invoices) {
    ref.invalidate(invoiceStatsProvider);
    ref.invalidate(monthlyInvoiceCountProvider);
  }
  ref.invalidate(dashboardStatsProvider);
}
