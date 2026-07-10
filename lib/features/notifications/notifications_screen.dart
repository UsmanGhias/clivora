import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/user_roles.dart';
import '../../core/cloud/supabase_auth_helper.dart';
import '../../core/cloud/cloud_notification_repository.dart';
import '../../core/services/admin_management_service.dart';
import '../../core/services/team_invite_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cloudAsync = ref.watch(cloudNotificationsProvider);
    final alertsAsync = ref.watch(notificationsProvider);
    final tasksAsync = ref.watch(freelancerClientTasksProvider);
    final mailboxAsync = ref.watch(freelancerMailboxProvider);
    final teamInvitesAsync = ref.watch(pendingTeamInvitesProvider);
    final isClient = isClientUser(ref.watch(authStateProvider).valueOrNull);

    return ClivoraScaffold(
      title: 'Notifications',
      showBackButton: true,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(cloudNotificationsProvider);
          ref.invalidate(notificationsProvider);
          ref.invalidate(freelancerClientTasksProvider);
          ref.invalidate(clientAssignedTasksProvider);
          ref.invalidate(pendingTeamInvitesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
          children: [
            cloudAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Cloud notifications: $e'),
              data: (items) {
                if (items.isEmpty) {
                  return _EmptySection(
                    icon: Icons.notifications_none_rounded,
                    title: 'No notifications',
                    subtitle: 'Invites and updates from CLIVORA appear here.',
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inbox',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    ...items.map(
                      (n) => _CloudNotificationTile(notification: n),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
            teamInvitesAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (invites) {
                if (invites.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Team invites',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    ...invites.map(
                      (invite) => _CompactNotificationRow(
                        onTap: () => context.push('/team-invites'),
                        icon: Icons.groups_outlined,
                        iconColor: ClivoraColors.primaryPurple,
                        title: invite.projectName.isNotEmpty
                            ? invite.projectName
                            : 'Team invite',
                        subtitle: 'Tap to accept or decline',
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
            if (!isClient)
              mailboxAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (messages) {
                  final unread = messages
                      .where(
                        (m) =>
                            !m.isRead &&
                            m.toUid == SupabaseAuthHelper.currentUid,
                      )
                      .take(5)
                      .toList();
                  if (unread.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unread messages',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      ...unread.map(
                        (m) => _CompactNotificationRow(
                          onTap: () => context.push('/freelancer-messages'),
                          icon: Icons.mail_outline,
                          iconColor: ClivoraColors.primary,
                          title: m.fromEmail,
                          subtitle: m.body.length > 80
                              ? '${m.body.substring(0, 80)}…'
                              : m.body,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),
            if (!isClient)
              tasksAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (tasks) {
                  if (tasks.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Client-assigned tasks',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      ...tasks.map(
                        (t) => _ClientTaskTile(task: t, isFreelancer: true),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),
            if (isClient)
              ref
                  .watch(clientAssignedTasksProvider)
                  .when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (tasks) {
                      if (tasks.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your assigned tasks',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          ...tasks.map(
                            (t) =>
                                _ClientTaskTile(task: t, isFreelancer: false),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    },
                  ),
            alertsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (alerts) {
                if (alerts.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reminders',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    ...alerts.map(
                      (n) => _CompactNotificationRow(
                        onTap: () => context.push(n.route),
                        icon: n.type == NotificationType.task
                            ? Icons.task_alt
                            : Icons.receipt_long,
                        iconColor: n.priority <= 1
                            ? ClivoraColors.errorRed
                            : ClivoraColors.warningOrange,
                        title: n.title,
                        subtitle: n.message,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactNotificationRow extends StatelessWidget {
  const _CompactNotificationRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          minLeadingWidth: 28,
          horizontalTitleGap: 10,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          onTap: onTap,
          leading: Icon(icon, color: iconColor, size: 20),
          title: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right, size: 18),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _CloudNotificationTile extends ConsumerWidget {
  const _CloudNotificationTile({required this.notification});

  final CloudNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(cloudNotificationRepositoryProvider);
    final time = DateFormat(
      'MMM d · h:mm a',
    ).format(notification.createdAt.toLocal());
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: ClivoraColors.errorRed,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => _dismiss(ref),
      child: Material(
        color: notification.isRead
            ? Colors.transparent
            : colorScheme.primary.withValues(alpha: 0.08),
        child: InkWell(
          onTap: () async {
            if (!notification.isRead) await repo.markRead(notification.id);
            ref.invalidate(cloudNotificationsProvider);
            ref.invalidate(unreadBadgeCountProvider);
            if (!context.mounted) return;
            final route = _routeForKind(notification.kind, ref);
            if (route != null) context.push(route);
          },
          child: Column(
            children: [
              ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                minLeadingWidth: 28,
                horizontalTitleGap: 10,
                contentPadding: const EdgeInsets.only(left: 4, right: 0),
                leading: Icon(
                  _iconForKind(notification.kind),
                  color: notification.isRead
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.primary,
                  size: 20,
                ),
                title: Text(
                  notification.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${notification.body}\n$time',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Dismiss',
                  onPressed: () => _dismiss(ref),
                ),
              ),
              const Divider(height: 1),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _dismiss(WidgetRef ref) async {
    await ref.read(cloudNotificationRepositoryProvider).delete(notification.id);
    ref.invalidate(cloudNotificationsProvider);
    ref.invalidate(unreadBadgeCountProvider);
  }

  IconData _iconForKind(String kind) {
    switch (kind) {
      case 'invite':
        return Icons.mail_outline;
      case 'task':
        return Icons.assignment_outlined;
      case 'invoice':
        return Icons.receipt_long_outlined;
      case 'project':
        return Icons.work_outline;
      case 'contract':
        return Icons.description_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  String? _routeForKind(String kind, WidgetRef ref) {
    final isClient = isClientUser(ref.read(authStateProvider).valueOrNull);
    switch (kind) {
      case 'task':
        return isClient ? '/client-tasks' : '/notifications';
      case 'invoice':
        return isClient ? '/client-invoices' : '/invoices';
      case 'project':
        return isClient ? '/client-portal' : '/projects';
      case 'contract':
        return isClient ? '/client-contracts' : '/contracts';
      case 'invite':
        return isClient ? '/client-messages' : '/freelancer-messages';
      default:
        return null;
    }
  }
}

class _ClientTaskTile extends ConsumerWidget {
  const _ClientTaskTile({required this.task, required this.isFreelancer});

  final CloudClientTask task;
  final bool isFreelancer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(cloudClientTaskRepositoryProvider);
    final time = DateFormat('MMM d · h:mm a').format(task.createdAt.toLocal());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  if (isFreelancer)
                    PopupMenuButton<String>(
                      onSelected: (v) => repo.updateStatus(task.id, v),
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'in_progress',
                          child: Text('In progress'),
                        ),
                        PopupMenuItem(value: 'done', child: Text('Done')),
                      ],
                      child: Chip(
                        label: Text(task.status.replaceAll('_', ' ')),
                        visualDensity: VisualDensity.compact,
                      ),
                    )
                  else
                    Chip(
                      label: Text(task.status.replaceAll('_', ' ')),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(time, style: Theme.of(context).textTheme.bodySmall),
                  const Spacer(),
                  TextButton(
                    onPressed: () => repo.delete(task.id),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Text(isFreelancer ? 'Delete' : 'Cancel task'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(
            icon,
            size: 56,
            color: ClivoraColors.labelGray.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
