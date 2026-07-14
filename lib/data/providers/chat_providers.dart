import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_service.dart';
import '../../core/cloud/cloud_message_repository.dart';
import '../../core/cloud/supabase_auth_helper.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/models/invoice_line_item.dart';
import 'database_provider.dart';

class ChatBubble {
  const ChatBubble({
    required this.id,
    required this.text,
    required this.isMine,
    required this.createdAt,
  });

  final String id;
  final String text;
  final bool isMine;
  final DateTime createdAt;
}

class ChatThreadKey {
  const ChatThreadKey({required this.peerEmail, required this.isClient});

  final String peerEmail;
  final bool isClient;

  @override
  bool operator ==(Object other) =>
      other is ChatThreadKey && other.peerEmail == peerEmail && other.isClient == isClient;

  @override
  int get hashCode => Object.hash(peerEmail, isClient);
}

/// Linked peer emails for chat: local CRM/project links + server Connect/invoice peers.
final linkedPeerEmailsProvider = FutureProvider.family<List<String>, bool>((ref, isClient) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return [];
  final db = ref.watch(databaseProvider);
  final emails = <String>{};

  if (isClient) {
    final links = await db.getFreelancerLinksForClient(user.id);
    for (final link in links) {
      final freelancer = await db.getUser(link.freelancerUserId);
      if (freelancer != null && freelancer.email.isNotEmpty) {
        emails.add(freelancer.email.trim().toLowerCase());
      }
    }
  } else {
    final customers = await db.watchCustomersForUser(user.id).first;
    for (final c in customers) {
      for (final e in parseStringList(c.emails)) {
        if (e.contains('@')) emails.add(e.trim().toLowerCase());
      }
    }
    final projectLinks = await (db.select(db.projectClientLinks)
          ..where((t) => t.freelancerUserId.equals(user.id)))
        .get();
    for (final link in projectLinks) {
      if (link.clientEmail.contains('@')) {
        emails.add(link.clientEmail.trim().toLowerCase());
      }
    }
  }

  // Align with require_message_link / Connect accept / hired proposals
  try {
    final rows = await SupabaseAuthHelper.client.rpc('message_allowed_peer_emails');
    if (rows is List) {
      for (final row in rows) {
        if (row is Map && row['peer_email'] != null) {
          final e = row['peer_email'].toString().trim().toLowerCase();
          if (e.contains('@')) emails.add(e);
        } else if (row is String && row.contains('@')) {
          emails.add(row.trim().toLowerCase());
        }
      }
    }
  } catch (_) {
    // Fallback: accepted Connect requests visible via details view
    try {
      final uid = SupabaseAuthHelper.currentUid;
      if (uid != null) {
        final reqs = await SupabaseAuthHelper.client
            .from('connect_request_details')
            .select('from_email,to_email,from_user_id,to_user_id,status')
            .eq('status', 'accepted')
            .or('from_user_id.eq.$uid,to_user_id.eq.$uid')
            .limit(100);
        for (final r in (reqs as List)) {
          final map = Map<String, dynamic>.from(r as Map);
          final from = (map['from_email'] as String? ?? '').trim().toLowerCase();
          final to = (map['to_email'] as String? ?? '').trim().toLowerCase();
          final me = user.email.trim().toLowerCase();
          if (from.isNotEmpty && from != me) emails.add(from);
          if (to.isNotEmpty && to != me) emails.add(to);
        }
      }
    } catch (_) {}
  }

  return emails.toList()..sort();
});

/// First linked peer email for chat (freelancer for client, client for freelancer).
final linkedPeerEmailProvider = FutureProvider.family<String?, bool>((ref, isClient) async {
  final list = await ref.watch(linkedPeerEmailsProvider(isClient).future);
  return list.isEmpty ? null : list.first;
});

final chatThreadProvider = StreamProvider.family<List<ChatBubble>, ChatThreadKey>((ref, key) {
  final user = ref.watch(authStateProvider).valueOrNull;
  final uid = SupabaseAuthHelper.currentUid;
  if (user == null || uid == null || key.peerEmail.isEmpty) {
    return Stream.value(const <ChatBubble>[]);
  }

  final repo = ref.watch(cloudMessageRepositoryProvider);
  return repo
      .watchThread(myUid: uid, myEmail: user.email, peerEmail: key.peerEmail)
      .map((messages) {
    for (final m in messages) {
      final toMe = m.toUid == uid ||
          m.toEmail.trim().toLowerCase() == user.email.trim().toLowerCase();
      if (!m.isRead && toMe && m.fromUid != uid) {
        repo.markMessageReadById(m.id);
      }
    }
    return messages
        .map(
          (m) => ChatBubble(
            id: m.id,
            text: m.subject.isNotEmpty && !m.body.contains('\n')
                ? '${m.subject}\n${m.body}'.trim()
                : (m.body.isNotEmpty ? m.body : m.subject),
            isMine: m.fromUid == uid,
            createdAt: m.createdAt,
          ),
        )
        .toList();
  });
});
