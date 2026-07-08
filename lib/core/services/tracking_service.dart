import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_service.dart';
import '../../core/cloud/cloud_notification_repository.dart';
import '../../core/cloud/cloud_project_repository.dart';
import '../../data/database/database.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/providers/app_providers.dart';

final trackingServiceProvider = Provider<TrackingService>((ref) {
  return TrackingService(ref);
});

class TrackingService {
  TrackingService(this.ref);

  final Ref ref;

  Future<void> logStatusChange({
    required String entityType,
    required int entityId,
    required String status,
    String note = '',
  }) async {
    final ownerId = ref.read(authStateProvider).valueOrNull?.id;
    if (ownerId == null) return;
    await ref.read(databaseProvider).insertTrackingEvent(
          TrackingEventsCompanion.insert(
            ownerUserId: ownerId,
            entityType: entityType,
            entityId: entityId,
            status: status,
            note: Value(note),
          ),
        );

    if (entityType == 'project') {
      await _notifyClientProjectUpdate(ownerId, entityId, status, note);
    }
  }

  Future<void> _notifyClientProjectUpdate(
    int ownerId,
    int projectId,
    String status,
    String note,
  ) async {
    final db = ref.read(databaseProvider);
    final project = await db.getProjectForUser(ownerId, projectId);
    if (project == null) return;

    final link = await (db.select(db.projectClientLinks)..where((t) => t.projectId.equals(projectId)))
        .getSingleOrNull();
    if (link == null) return;

    final freelancer = ref.read(authStateProvider).valueOrNull;
    if (freelancer != null) {
      await ref.read(cloudProjectRepositoryProvider).shareHybrid(
            freelancer: freelancer,
            clientEmail: link.clientEmail,
            localProjectId: projectId,
            project: project,
          );
    }

    final label = status.replaceAll('_', ' ');
    final body = note.isNotEmpty ? '$label: $note' : 'Project status is now $label';
    await ref.read(cloudNotificationRepositoryProvider).send(
          toEmail: link.clientEmail,
          title: 'Update: ${project.name}',
          body: body,
          kind: 'project',
        );
  }
}

final trackingEventsProvider = StreamProvider.family<List<TrackingEvent>, TrackingQuery>((ref, query) {
  final ownerId = ref.watch(authStateProvider).valueOrNull?.id;
  if (ownerId == null) return const Stream.empty();
  return ref.watch(databaseProvider).watchTrackingEventsForUser(
        ownerUserId: ownerId,
        entityType: query.entityType,
        entityId: query.entityId,
      );
});

class TrackingQuery {
  const TrackingQuery({required this.entityType, required this.entityId});

  final String entityType;
  final int entityId;

  @override
  bool operator ==(Object other) =>
      other is TrackingQuery && other.entityType == entityType && other.entityId == entityId;

  @override
  int get hashCode => Object.hash(entityType, entityId);
}
