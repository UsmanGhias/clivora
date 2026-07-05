import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_service.dart';
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
