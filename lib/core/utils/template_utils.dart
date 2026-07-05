import '../../data/database/database.dart';
import '../../data/database/user_scoped_queries.dart';

/// Fills {{placeholders}} in message templates with real business data.
String fillTemplate(
  String template, {
  String clientName = '',
  String businessName = '',
  String invoiceNumber = '',
  String amount = '',
  String projectName = '',
}) {
  return template
      .replaceAll('{{clientName}}', clientName)
      .replaceAll('{{businessName}}', businessName)
      .replaceAll('{{invoiceNumber}}', invoiceNumber)
      .replaceAll('{{amount}}', amount)
      .replaceAll('{{projectName}}', projectName);
}

Future<String> fillTemplateForInvoice(
  AppDatabase db,
  int ownerUserId,
  String template,
  Invoice invoice,
) async {
  final customer = await db.getCustomerForUser(ownerUserId, invoice.customerId);
  final profile = await db.watchBusinessProfileForUser(ownerUserId).first;
  return fillTemplate(
    template,
    clientName: customer?.contactPerson ?? customer?.company ?? 'Client',
    businessName: profile.businessName.isNotEmpty ? profile.businessName : profile.ownerName,
    invoiceNumber: invoice.invoiceNumber,
    amount: '${invoice.currency} ${invoice.total.toStringAsFixed(2)}',
  );
}
