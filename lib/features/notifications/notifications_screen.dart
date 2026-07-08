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
          padding: const EdgeInsets.all(20),
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
                    Text('Inbox', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    ...items.map((n) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _CloudNotificationTile(notification: n),
                        )),
                    const SizedBox(height: 16),
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
                    Text('Team invites', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    ...invites.map((invite) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            onTap: () => context.push('/team-invites'),
                            tileColor: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Theme.of(context).dividerColor),
                            ),
                            leading: const Icon(Icons.groups_outlined, color: ClivoraColors.primaryPurple),
                            title: Text(
                              invite.projectName.isNotEmpty ? invite.projectName : 'Team invite',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: const Text('Tap to accept or decline'),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        )),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
            if (!isClient)
              mailboxAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (messages) {
                  final unread = messages.where((m) => !m.isRead && m.toUid == SupabaseAuthHelper.currentUid).take(5).toList();
                  if (unread.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Unread messages', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 10),
                      ...unread.map((m) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              onTap: () => context.push('/freelancer-messages'),
                              tileColor: Theme.of(context).cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Theme.of(context).dividerColor),
                              ),
                              leading: const Icon(Icons.mail_outline, color: ClivoraColors.primary),
                              title: Text(m.fromEmail, style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text(m.body.length > 80 ? '${m.body.substring(0, 80)}…' : m.body),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                          )),
                      const SizedBox(height: 16),
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
                      Text('Client-assigned tasks', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 10),
                      ...tasks.map((t) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _ClientTaskTile(task: t, isFreelancer: true),
                          )),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            if (isClient)
              ref.watch(clientAssignedTasksProvider).when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (tasks) {
                      if (tasks.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your assigned tasks', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 10),
                          ...tasks.map((t) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _ClientTaskTile(task: t, isFreelancer: false),
                              )),
                          const SizedBox(height: 16),
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
                    Text('Reminders', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    ...alerts.map((n) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            onTap: () => context.push(n.route),
                            tileColor: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Theme.of(context).dividerColor),
                            ),
                            leading: Icon(
                              n.type == NotificationType.task ? Icons.task_alt : Icons.receipt_long,
                              color: n.priority <= 1 ? ClivoraColors.errorRed : ClivoraColors.warningOrange,
                            ),
                            title: Text(n.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(n.message),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        )),
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

class _CloudNotificationTile extends ConsumerWidget {
  const _CloudNotificationTile({required this.notification});

  final CloudNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(cloudNotificationRepositoryProvider);
    final time = DateFormat('MMM d · h:mm a').format(notification.createdAt.toLocal());

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: ClivoraColors.errorRed,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => _dismiss(ref),
      child: Material(
        color: notification.isRead ? Theme.of(context).cardColor : ClivoraColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            if (!notification.isRead) await repo.markRead(notification.id);
            ref.invalidate(cloudNotificationsProvider);
            ref.invalidate(unreadBadgeCountProvider);
            if (!context.mounted) return;
            final route = _routeForKind(notification.kind, ref);
            if (route != null) context.push(route);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _iconForKind(notification.kind),
                  color: notification.isRead ? ClivoraColors.labelGray : ClivoraColors.primary,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(notification.body, style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 6),
                      Text(time, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ClivoraColors.labelGray)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => _dismiss(ref),
                ),
              ],
            ),
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w700))),
              if (isFreelancer)
                PopupMenuButton<String>(
                  onSelected: (v) => repo.updateStatus(task.id, v),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'in_progress', child: Text('In progress')),
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
            const SizedBox(height: 6),
            Text(task.description, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Text(time, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ClivoraColors.labelGray)),
              const Spacer(),
              if (isFreelancer)
                TextButton(
                  onPressed: () => repo.delete(task.id),
                  child: const Text('Delete'),
                )
              else
                TextButton(
                  onPressed: () => repo.delete(task.id),
                  child: const Text('Cancel task'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(icon, size: 56, color: ClivoraColors.labelGray.withValues(alpha: 0.6)),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
