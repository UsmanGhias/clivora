import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/cloud/cloud_project_repository.dart';
import '../../core/utils/navigation_helper.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/duration_formatter.dart';
import '../../core/utils/greeting.dart';
import '../../core/auth/auth_service.dart';
import '../../core/auth/user_roles.dart';
import '../../data/database/database.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/providers/app_providers.dart';

/// Client home — shared projects, hours, and progress (read-only).
class ClientPortalScreen extends ConsumerWidget {
  const ClientPortalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final projectsAsync = ref.watch(clientSharedProjectsProvider);
    final firstName = user?.name.split(' ').first ?? 'there';
    final isGuest = isGuestUser(user);
    final unreadAsync = ref.watch(unreadMessagesProvider);
    final unread = unreadAsync.valueOrNull ?? 0;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(clientSharedProjectsProvider);
            ref.invalidate(clientPortalStatsProvider);
            ref.invalidate(unreadMessagesProvider);
          },
          child: projectsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (projects) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Client Portal',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: ClivoraColors.clientAccent),
                        ),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () => openFormRoute(context, '/notifications'),
                            icon: const Icon(Icons.notifications_outlined, color: ClivoraColors.clientAccent),
                          ),
                          if (unread > 0)
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: const BoxDecoration(color: ClivoraColors.errorRed, shape: BoxShape.circle),
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => openFormRoute(context, '/client-messages'),
                        icon: const Icon(Icons.mail_outline_rounded, color: ClivoraColors.clientAccent),
                      ),
                    ],
                  ),
                  _ClientWelcomeHeader(firstName: firstName, projectCount: projects.length, isGuest: isGuest),
                  const SizedBox(height: 20),
                  _ClientStatsRow(projects: projects, clientUserId: user?.id),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => openFormRoute(context, '/client-tasks'),
                      icon: const Icon(Icons.add_task_rounded),
                      label: const Text('Assign task to freelancer'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ClivoraColors.clientAccent,
                        side: const BorderSide(color: ClivoraColors.clientAccent),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text('Shared Projects', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                      const Spacer(),
                      if (projects.isNotEmpty)
                        Text('${projects.length} total', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (projects.isEmpty)
                    _EmptyProjects(email: user?.email ?? '')
                  else
                    ...projects.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ClientProjectCard(projectView: p, clientUserId: user?.id),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ClientWelcomeHeader extends StatelessWidget {
  const _ClientWelcomeHeader({required this.firstName, required this.projectCount, this.isGuest = false});

  final String firstName;
  final int projectCount;
  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: ClivoraColors.clientGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isGuest)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'GUEST PREVIEW · CLIENT',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.6),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'CLIENT PORTAL',
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            timeBasedGreeting(),
            style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12),
          ),
          Text(
            firstName,
            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            projectCount == 0
                ? 'Projects shared with you will appear below.'
                : 'You have $projectCount shared ${projectCount == 1 ? 'project' : 'projects'} to review.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ClientStatsRow extends ConsumerWidget {
  const _ClientStatsRow({required this.projects, required this.clientUserId});

  final List<ClientSharedProjectView> projects;
  final int? clientUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(clientPortalStatsProvider);

    return statsAsync.when(
      loading: () => const SizedBox(height: 88, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
      error: (_, _) => const SizedBox.shrink(),
      data: (stats) => Row(
        children: [
          Expanded(child: _StatCard(label: 'Projects', value: '${projects.length}', icon: Icons.folder_shared_outlined)),
          const SizedBox(width: 10),
          Expanded(child: _StatCard(label: 'Active', value: '${stats.activeCount}', icon: Icons.play_circle_outline)),
          const SizedBox(width: 10),
          Expanded(child: _StatCard(label: 'Hours', value: stats.hoursLabel, icon: Icons.schedule_rounded)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: ClivoraColors.clientAccentLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ClivoraColors.clientAccent.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: ClivoraColors.clientAccent, size: 20),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: ClivoraColors.clientAccent)),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  const _EmptyProjects({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 56, color: ClivoraColors.clientAccent.withValues(alpha: 0.45)),
          const SizedBox(height: 16),
          Text('Waiting for your freelancer', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Ask them to share a project using $email. You\'ll see hours logged, status updates, and progress here.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ClientProjectCard extends ConsumerStatefulWidget {
  const _ClientProjectCard({required this.projectView, required this.clientUserId});

  final ClientSharedProjectView projectView;
  final int? clientUserId;

  @override
  ConsumerState<_ClientProjectCard> createState() => _ClientProjectCardState();
}

class _ClientProjectCardState extends ConsumerState<_ClientProjectCard> {
  int _seconds = 0;
  bool _loadingSeconds = true;

  @override
  void initState() {
    super.initState();
    if (!widget.projectView.isCloudOnly && widget.clientUserId != null) {
      _loadSeconds();
    } else {
      _loadingSeconds = false;
    }
  }

  Future<void> _loadSeconds() async {
    final project = widget.projectView.localProject;
    final clientUserId = widget.clientUserId;
    if (project == null || clientUserId == null) {
      if (mounted) setState(() => _loadingSeconds = false);
      return;
    }
    final entries = await ref.read(databaseProvider).getTimeEntriesForClientProject(
          clientUserId,
          project.id,
        );
    var total = 0;
    for (final e in entries) {
      total += e.endedAt != null
          ? e.durationSeconds
          : DateTime.now().difference(e.startedAt).inSeconds;
    }
    if (mounted) setState(() { _seconds = total; _loadingSeconds = false; });
  }

  @override
  Widget build(BuildContext context) {
    final view = widget.projectView;
    final status = view.status.replaceAll('_', ' ');
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: ClivoraColors.clientAccentLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.folder_open_rounded, color: ClivoraColors.clientAccent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(view.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        ),
                        if (view.isCloudOnly)
                          Icon(Icons.cloud_done_outlined, size: 16, color: ClivoraColors.labelGray),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(status.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: ClivoraColors.clientAccent, letterSpacing: 0.5)),
                  ],
                ),
              ),
            ],
          ),
          if (view.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(view.description, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              if (!view.isCloudOnly) ...[
                const Icon(Icons.timer_outlined, size: 18, color: ClivoraColors.successGreen),
                const SizedBox(width: 6),
                Text(
                  _loadingSeconds ? 'Loading hours…' : '${formatTrackedDuration(_seconds)} tracked',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ] else
                Text(
                  'Synced from your freelancer',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (view.deadline != null) ...[
                const Spacer(),
                Icon(Icons.event_outlined, size: 16, color: ClivoraColors.labelGray),
                const SizedBox(width: 4),
                Text(
                  'Due ${view.deadline!.toLocal().toString().split(' ').first}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
          if (!view.isCloudOnly && widget.clientUserId != null && view.localProject != null) ...[
            const SizedBox(height: 14),
            Text('Recent updates', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            _ClientTrackingTimeline(clientUserId: widget.clientUserId!, projectId: view.localProject!.id),
          ],
        ],
      ),
    );
  }
}

class _ClientTrackingTimeline extends ConsumerWidget {
  const _ClientTrackingTimeline({required this.clientUserId, required this.projectId});

  final int clientUserId;
  final int projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(
      _clientTrackingProvider(ClientTrackingKey(clientUserId: clientUserId, projectId: projectId)),
    );
    return eventsAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => const Text('Could not load updates'),
      data: (events) {
        if (events.isEmpty) {
          return Text('No updates yet', style: Theme.of(context).textTheme.bodySmall);
        }
        return Column(
          children: events.take(3).map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.fiber_manual_record, size: 8, color: ClivoraColors.clientAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${e.status.replaceAll('_', ' ')}${e.note.isNotEmpty ? ' — ${e.note}' : ''}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class ClientTrackingKey {
  const ClientTrackingKey({required this.clientUserId, required this.projectId});
  final int clientUserId;
  final int projectId;

  @override
  bool operator ==(Object other) =>
      other is ClientTrackingKey && other.clientUserId == clientUserId && other.projectId == projectId;
  @override
  int get hashCode => Object.hash(clientUserId, projectId);
}

class ClientPortalStats {
  const ClientPortalStats({required this.activeCount, required this.hoursLabel});
  final int activeCount;
  final String hoursLabel;
}

final clientPortalStatsProvider = FutureProvider<ClientPortalStats>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const ClientPortalStats(activeCount: 0, hoursLabel: '0h');
  final projects = await ref.watch(clientSharedProjectsProvider.future);
  var active = 0;
  var totalSeconds = 0;
  final db = ref.watch(databaseProvider);
  for (final p in projects) {
    if (p.status == 'in_progress' || p.status == 'not_started') active++;
    final local = p.localProject;
    if (local != null) {
      final entries = await db.getTimeEntriesForClientProject(user.id, local.id);
      for (final e in entries) {
        totalSeconds += e.endedAt != null
            ? e.durationSeconds
            : DateTime.now().difference(e.startedAt).inSeconds;
      }
    }
  }
  return ClientPortalStats(
    activeCount: active,
    hoursLabel: formatTrackedDuration(totalSeconds),
  );
});

final _clientTrackingProvider = StreamProvider.family<List<TrackingEvent>, ClientTrackingKey>((ref, key) {
  return ref.watch(databaseProvider).watchTrackingForClientProject(
        clientUserId: key.clientUserId,
        projectId: key.projectId,
      );
});
