import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_service.dart';
import '../../data/database/database.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/providers/app_providers.dart';

final projectTimeTrackerProvider =
    StateNotifierProvider<ProjectTimeTrackerNotifier, ProjectTimeTrackerState>((ref) {
  return ProjectTimeTrackerNotifier(ref);
});

final projectTrackedSecondsMapProvider = StreamProvider<Map<int, int>>((ref) {
  final ownerId = ref.watch(authStateProvider).valueOrNull?.id;
  if (ownerId == null) return const Stream.empty();
  return ref.watch(databaseProvider).watchAllProjectTrackedSecondsForUser(ownerId);
});

class ProjectTimeTrackerState {
  const ProjectTimeTrackerState({
    this.activeProjectId,
    this.activeEntryId,
    this.startedAt,
    this.tick = 0,
  });

  final int? activeProjectId;
  final int? activeEntryId;
  final DateTime? startedAt;
  final int tick;

  bool get isRunning => activeProjectId != null && startedAt != null;

  int elapsedSecondsFor(int projectId, Map<int, int> storedTotals) {
    final base = storedTotals[projectId] ?? 0;
    if (activeProjectId == projectId && startedAt != null) {
      return base + DateTime.now().difference(startedAt!).inSeconds;
    }
    return base;
  }

  ProjectTimeTrackerState copyWith({
    int? activeProjectId,
    int? activeEntryId,
    DateTime? startedAt,
    int? tick,
    bool clearActive = false,
  }) {
    return ProjectTimeTrackerState(
      activeProjectId: clearActive ? null : (activeProjectId ?? this.activeProjectId),
      activeEntryId: clearActive ? null : (activeEntryId ?? this.activeEntryId),
      startedAt: clearActive ? null : (startedAt ?? this.startedAt),
      tick: tick ?? this.tick,
    );
  }
}

class ProjectTimeTrackerNotifier extends StateNotifier<ProjectTimeTrackerState> {
  ProjectTimeTrackerNotifier(this.ref) : super(const ProjectTimeTrackerState()) {
    _loadActive();
  }

  final Ref ref;
  Timer? _timer;

  int? get _ownerId => ref.read(authStateProvider).valueOrNull?.id;

  Future<void> _loadActive() async {
    final ownerId = _ownerId;
    if (ownerId == null) return;
    final active = await ref.read(databaseProvider).getActiveTimeEntryForUser(ownerId);
    if (active != null && mounted) {
      state = ProjectTimeTrackerState(
        activeProjectId: active.projectId,
        activeEntryId: active.id,
        startedAt: active.startedAt,
      );
      _startTicker();
    }
  }

  void _startTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      state = state.copyWith(tick: state.tick + 1);
    });
  }

  void _stopTicker() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> start(int projectId) async {
    final ownerId = _ownerId;
    if (ownerId == null) return;
    final db = ref.read(databaseProvider);
    if (state.activeProjectId == projectId) return;
    if (state.activeEntryId != null) {
      await db.stopTimeEntry(state.activeEntryId!);
    }
    final entryId = await db.startTimeEntryForUser(ownerId, projectId);
    state = ProjectTimeTrackerState(
      activeProjectId: projectId,
      activeEntryId: entryId,
      startedAt: DateTime.now(),
    );
    _startTicker();
    ref.invalidate(projectTrackedSecondsMapProvider);
    ref.invalidate(projectStatsProvider);
  }

  Future<void> stop() async {
    if (state.activeEntryId == null) return;
    await ref.read(databaseProvider).stopTimeEntry(state.activeEntryId!);
    _stopTicker();
    state = const ProjectTimeTrackerState();
    ref.invalidate(projectTrackedSecondsMapProvider);
    ref.invalidate(projectStatsProvider);
  }

  Future<void> toggle(int projectId) async {
    if (state.activeProjectId == projectId) {
      await stop();
    } else {
      await start(projectId);
    }
  }

  @override
  void dispose() {
    _stopTicker();
    super.dispose();
  }
}
