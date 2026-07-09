import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';
import 'clivora_email_service.dart';
import '../cloud/cloud_message_repository.dart';
import '../cloud/cloud_notification_repository.dart';
import '../cloud/cloud_project_repository.dart';
import '../cloud/supabase_auth_helper.dart';
import '../cloud/supabase_sync_service.dart';
import '../../data/database/database.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/providers/app_providers.dart';

final teamInviteServiceProvider = Provider<TeamInviteService>((ref) {
  return TeamInviteService(ref);
});

class TeamInvite {
  TeamInvite({
    required this.id,
    required this.ownerUid,
    required this.inviteeEmail,
    required this.inviteeName,
    required this.role,
    required this.projectShareId,
    required this.projectName,
    required this.status,
    required this.createdAt,
    this.inviteeUid,
  });

  final String id;
  final String ownerUid;
  final String inviteeEmail;
  final String inviteeName;
  final String role;
  final String? projectShareId;
  final String projectName;
  final String status;
  final String? inviteeUid;
  final DateTime createdAt;

  factory TeamInvite.fromRow(Map<String, dynamic> row) {
    return TeamInvite(
      id: row['id'] as String,
      ownerUid: row['owner_uid'] as String,
      inviteeEmail: row['invitee_email'] as String? ?? '',
      inviteeName: row['invitee_name'] as String? ?? '',
      role: row['role'] as String? ?? 'member',
      projectShareId: row['project_share_id'] as String?,
      projectName: row['project_name'] as String? ?? '',
      status: row['status'] as String? ?? 'pending',
      inviteeUid: row['invitee_uid'] as String?,
      createdAt: DateTime.tryParse(row['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class TeamInviteService {
  TeamInviteService(this.ref);

  final Ref ref;

  SupabaseClient get _db => SupabaseAuthHelper.client;

  Future<String?> sendInvite({
    required String name,
    required String email,
    required String role,
    required Project? project,
  }) async {
    final ownerUid = SupabaseAuthHelper.currentUid;
    final owner = ref.read(authStateProvider).valueOrNull;
    if (ownerUid == null || owner == null) return 'Sign in to invite team members';

    final inviteeEmail = email.trim().toLowerCase();
    if (!inviteeEmail.contains('@')) return 'Enter a valid email';

    String? shareId;
    var projectName = '';
    if (project != null) {
      shareId = ref.read(cloudProjectRepositoryProvider).shareIdFor(
            freelancerUid: ownerUid,
            localProjectId: project.id,
          );
      projectName = project.name;
      final db = ref.read(databaseProvider);
      final link = await (db.select(db.projectClientLinks)
            ..where((t) => t.projectId.equals(project.id)))
          .getSingleOrNull();
      if (link != null) {
        await ref.read(cloudProjectRepositoryProvider).shareHybrid(
              freelancer: owner,
              clientEmail: link.clientEmail,
              localProjectId: project.id,
              project: project,
            );
      }
    }

    try {
      await _db.from('team_invites').insert({
        'owner_uid': ownerUid,
        'invitee_email': inviteeEmail,
        'invitee_name': name.trim(),
        'role': role,
        if (shareId != null) 'project_share_id': shareId,
        'project_name': projectName,
      });
    } catch (e) {
      debugPrint('team_invites insert: $e');
      return 'Could not send invite. Run migration 014_team_invites.sql in Supabase.';
    }

    await ref.read(databaseProvider).insertTeamMember(
          TeamMembersCompanion.insert(
            ownerUserId: owner.id,
            name: name.trim(),
            email: inviteeEmail,
            role: Value(role),
          ),
        );

    final subject = '${owner.name} invited you to their CLIVORA team';
    final body = projectName.isNotEmpty
        ? 'Hi ${name.trim()},\n\n'
            '${owner.name} invited you to collaborate on $projectName as $role.\n\n'
            'Open CLIVORA, sign in with $inviteeEmail, and accept the invite from Team or Notifications.'
        : 'Hi ${name.trim()},\n\n'
            '${owner.name} invited you to join their CLIVORA team as $role.\n\n'
            'Open CLIVORA and sign in with $inviteeEmail to accept.';

    await ref.read(cloudMessageRepositoryProvider).sendHybrid(
          fromUser: owner,
          toEmail: inviteeEmail,
          subject: subject,
          body: body,
        );

    final toUid = await ref.read(supabaseSyncServiceProvider).uidForEmail(inviteeEmail);
    if (toUid != null) {
      await ref.read(cloudNotificationRepositoryProvider).sendToUid(
            toUid: toUid,
            title: 'Team invite from ${owner.name}',
            body: projectName.isNotEmpty
                ? 'You were invited to collaborate on $projectName.'
                : 'You were invited to join a CLIVORA team.',
            kind: 'team_invite',
          );
    }

    final emailErr = await ref.read(clivoraEmailServiceProvider).sendTeamInviteEmail(
          to: inviteeEmail,
          ownerName: owner.name,
          inviteeName: name.trim(),
          role: role,
          projectName: projectName,
        );
    if (emailErr != null) {
      debugPrint('Team invite email skipped (in-app sent): $emailErr');
      return 'Invite sent via in-app message to $inviteeEmail';
    }

    return 'Invite sent to $inviteeEmail';
  }

  Stream<List<TeamInvite>> watchPendingForCurrentUser() {
    final uid = SupabaseAuthHelper.currentUid;
    final email = SupabaseAuthHelper.currentEmail?.toLowerCase();
    if (uid == null) return const Stream.empty();

    return _db
        .from('team_invites')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((rows) => rows.map(TeamInvite.fromRow).where((i) {
              if (i.status != 'pending') return false;
              if (i.inviteeUid == uid) return true;
              if (email != null && i.inviteeEmail.toLowerCase() == email) return true;
              return false;
            }).toList());
  }

  Future<String?> acceptInvite(TeamInvite invite) async {
    final uid = SupabaseAuthHelper.currentUid;
    if (uid == null) return 'Sign in required';

    try {
      await _db.from('team_invites').update({
        'status': 'accepted',
        'invitee_uid': uid,
        'responded_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', invite.id);
    } catch (e) {
      return 'Could not accept invite: $e';
    }

    await ref.read(cloudNotificationRepositoryProvider).sendToUid(
          toUid: invite.ownerUid,
          title: 'Team invite accepted',
          body: '${SupabaseAuthHelper.currentEmail ?? 'A teammate'} joined ${invite.projectName.isNotEmpty ? invite.projectName : 'your team'}.',
          kind: 'team',
        );
    return null;
  }

  Future<String?> declineInvite(TeamInvite invite) async {
    final uid = SupabaseAuthHelper.currentUid;
    if (uid == null) return 'Sign in required';

    try {
      await _db.from('team_invites').update({
        'status': 'declined',
        'invitee_uid': uid,
        'responded_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', invite.id);
    } catch (e) {
      return 'Could not decline invite: $e';
    }
    return null;
  }
}

final pendingTeamInvitesProvider = StreamProvider<List<TeamInvite>>((ref) {
  return ref.watch(teamInviteServiceProvider).watchPendingForCurrentUser();
});
