import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/user_roles.dart';
import '../../core/constants/admin_config.dart';
import '../../core/constants/pro_pricing.dart';
import '../../core/services/admin_management_service.dart';
import '../../core/services/admin_sync_service.dart';
import '../../core/services/analytics_export_service.dart';
import '../../core/services/analytics_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/admin_helper.dart';
import '../../shared/widgets/clivora_scaffold.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  final _adminEmailCtrl = TextEditingController();

  @override
  void dispose() {
    _adminEmailCtrl.dispose();
    super.dispose();
  }

  Future<void> _grantAdmin() async {
    final err = await ref.read(adminManagementServiceProvider).grantAdminByEmail(_adminEmailCtrl.text);
    if (!mounted) return;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    } else {
      _adminEmailCtrl.clear();
      ref.invalidate(adminUsersProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin access granted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final isSuper = isSuperAdmin(user);
    if (!isAdminUser(user)) {
      return const ClivoraScaffold(
        title: 'Admin',
        showBackButton: true,
        body: Center(child: Text('Admin access required')),
      );
    }

    final statsAsync = ref.watch(adminStatsProvider);
    final eventsAsync = ref.watch(analyticsEventsProvider);
    final usersAsync = ref.watch(adminUsersProvider);

    return ClivoraScaffold(
      title: 'CLIVORA Admin',
      showBackButton: true,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(adminSyncServiceProvider).syncPendingEvents();
          ref.invalidate(adminStatsProvider);
          ref.invalidate(analyticsEventsProvider);
          ref.invalidate(adminUsersProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: ClivoraColors.brandGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Platform Overview', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  const Text('CLIVORA Analytics', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  statsAsync.when(
                    loading: () => const CircularProgressIndicator(color: Colors.white),
                    error: (_, _) => const Text('Could not load stats', style: TextStyle(color: Colors.white)),
                    data: (s) => Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _AdminStat(label: 'Users', value: '${s.totalUsers}'),
                        _AdminStat(label: 'Sign-ups', value: '${s.signups}'),
                        _AdminStat(label: 'Pro', value: '${s.proUsers}'),
                        _AdminStat(label: 'MRR', value: 'Rs ${s.monthlyRevenue}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Pro (future): ${ProPricing.monthlyLabel}/month via Google Play', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(adminSyncServiceProvider).syncPendingEvents();
                      ref.invalidate(adminStatsProvider);
                      ref.invalidate(analyticsEventsProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Synced to clivora.codcrafters.org')),
                        );
                      }
                    },
                    icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                    label: const Text('Sync to Web'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        await ref.read(analyticsExportServiceProvider).exportAndShare();
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Export failed: $e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.download_outlined, size: 18),
                    label: const Text('Export'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(kAdminPanelUrl);
                  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
                  if (!ok && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not open $kAdminPanelUrl')),
                    );
                  }
                },
                icon: const Icon(Icons.open_in_browser, size: 18),
                label: const Text('Open Web Admin Panel'),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ClivoraColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ClivoraColors.borderLight),
              ),
              child: Text(
                'Sign-ups and Pro events sync to $kAdminPanelUrl',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45),
              ),
            ),
            const SizedBox(height: 24),
            if (isSuper) ...[
              Text('Admin management', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ClivoraColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ClivoraColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Only $kSuperAdminEmail can add admins. User must already have a CLIVORA account.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _adminEmailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email to promote',
                        hintText: 'user@example.com',
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _grantAdmin,
                      icon: const Icon(Icons.admin_panel_settings_outlined, size: 18),
                      label: const Text('Grant admin + Pro'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            Text('Activity log', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'All sign-ups, Pro activations, and sync events from this device and Supabase.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text('Registered users', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            usersAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (users) {
                if (users.isEmpty) return const Text('No users on this device yet.');
                return Column(
                  children: users.map((u) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: ClivoraColors.primary.withValues(alpha: 0.12),
                        child: Text(u.name.isNotEmpty ? u.name[0].toUpperCase() : '?'),
                      ),
                      title: Text(u.name),
                      subtitle: Text(u.email),
                      trailing: Text(u.role == 'admin' ? 'Admin' : u.role),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            Text('Recent events', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            eventsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (events) {
                if (events.isEmpty) return const Text('No events yet.');
                return Column(
                  children: events.map((e) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: ClivoraColors.primary.withValues(alpha: 0.12),
                        child: Icon(
                          e.eventType == 'pro_activate' ? Icons.diamond_outlined : Icons.person_add_outlined,
                          color: ClivoraColors.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(e.eventType.replaceAll('_', ' ').toUpperCase()),
                      subtitle: Text(
                        '${e.userEmail.isNotEmpty ? e.userEmail : e.userName} · ${e.createdAt.toString().substring(0, 16)}',
                      ),
                      trailing: e.synced
                          ? const Icon(Icons.cloud_done, size: 18, color: ClivoraColors.successGreen)
                          : const Icon(Icons.cloud_off, size: 18, color: ClivoraColors.labelGray),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminStat extends StatelessWidget {
  const _AdminStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}
