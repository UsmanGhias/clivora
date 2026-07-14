import '../../core/cloud/cloud_message_repository.dart';
import '../../data/database/database.dart';

/// Client-facing contract (from shared message or linked local record).
class ClientContractView {
  const ClientContractView({
    required this.id,
    required this.title,
    required this.status,
    required this.content,
    required this.updatedAt,
    this.localContractId,
  });

  final String id;
  final String title;
  final String status;
  final String content;
  final DateTime updatedAt;
  final int? localContractId;

  static const contractPrefix = '[Contract]';
  static const signedPrefix = '[Contract Signed]';

  static ClientContractView? fromInboxEntry({
    required String id,
    required String subject,
    required String body,
    required DateTime createdAt,
  }) {
    if (!subject.startsWith(contractPrefix) && !subject.startsWith(signedPrefix)) {
      return null;
    }
    final title = subject
        .replaceFirst(contractPrefix, '')
        .replaceFirst(signedPrefix, '')
        .trim();
    final status = subject.startsWith(signedPrefix) ? 'signed' : 'sent';
    return ClientContractView(
      id: id,
      title: title.isEmpty ? 'Agreement' : title,
      status: status,
      content: body,
      updatedAt: createdAt,
    );
  }
}

List<ClientContractView> mergeClientContractViews({
  required List<ClientInboxEntry> inbox,
  required List<Contract> local,
}) {
  final views = <ClientContractView>[];
  final byTitle = <String, ClientContractView>{};

  void upsert(ClientContractView view) {
    final existing = byTitle[view.title];
    if (existing == null) {
      byTitle[view.title] = view;
      return;
    }
    // Prefer signed over sent; then prefer newer.
    final preferSigned =
        view.status == 'signed' && existing.status != 'signed';
    final preferNewer = view.updatedAt.isAfter(existing.updatedAt) &&
        !(existing.status == 'signed' && view.status != 'signed');
    if (preferSigned || preferNewer) {
      byTitle[view.title] = view;
    }
  }

  for (final entry in inbox) {
    final view = ClientContractView.fromInboxEntry(
      id: entry.id,
      subject: entry.subject,
      body: entry.body,
      createdAt: entry.createdAt,
    );
    if (view != null) upsert(view);
  }
  for (final c in local) {
    upsert(
      ClientContractView(
        id: 'local_${c.id}',
        title: c.title,
        status: c.status,
        content: c.content,
        updatedAt: c.updatedAt,
        localContractId: c.id,
      ),
    );
  }
  views.addAll(byTitle.values);
  views.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  return views;
}
