import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/user_roles.dart';
import '../../core/cloud/admin_cloud_repository.dart';
import '../../core/cloud/supabase_auth_helper.dart';
import '../../core/constants/admin_config.dart';
import '../../core/constants/plan_limits.dart';
import '../../core/constants/plan_features.dart';
import '../../core/constants/pro_pricing.dart';
import '../../core/services/clivora_email_service.dart';
import '../../core/services/admin_management_service.dart';
import '../../core/services/admin_sync_service.dart';
import '../../core/services/analytics_service.dart';
import '../../core/services/audit_log_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../data/database/database.dart';
import '../../data/providers/app_providers.dart';

/// Super-admin command center — full platform control.
class AdminConsoleScreen extends ConsumerStatefulWidget {
  const AdminConsoleScreen({super.key});

  @override
  ConsumerState<AdminConsoleScreen> createState() => _AdminConsoleScreenState();
}

class _AdminConsoleScreenState extends ConsumerState<AdminConsoleScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _adminEmailCtrl = TextEditingController();
  final _proEmailCtrl = TextEditingController();
  final _resetEmailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _adminEmailCtrl.dispose();
    _proEmailCtrl.dispose();
    _resetEmailCtrl.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await ref.read(adminSyncServiceProvider).syncPendingEvents();
    ref.invalidate(adminStatsProvider);
    ref.invalidate(adminCloudProfilesProvider);
    ref.invalidate(adminCloudActivityProvider);
    ref.invalidate(adminUsersProvider);
    ref.invalidate(analyticsEventsProvider);
    ref.invalidate(auditLogsProvider);
  }

  Future<void> _logout() async {
    await ref.read(authStateProvider.notifier).signOut();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    if (!isSuperAdmin(user)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin')),
        body: const Center(child: Text('Super admin access only')),
      );
    }

    final statsAsync = ref.watch(adminStatsProvider);
    final profilesAsync = ref.watch(adminCloudProfilesProvider);
    final activityAsync = ref.watch(adminCloudActivityProvider);
    final localUsersAsync = ref.watch(adminUsersProvider);
    final cloudUid = SupabaseAuthHelper.currentUid;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CLIVORA Command Center', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 11, color: Colors.white60, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          IconButton(tooltip: 'Refresh', onPressed: _refresh, icon: const Icon(Icons.refresh_rounded)),
          IconButton(
            tooltip: 'Web admin',
            onPressed: () => launchUrl(Uri.parse(kAdminPanelUrl), mode: LaunchMode.externalApplication),
            icon: const Icon(Icons.language_rounded),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (v) async {
              if (v == 'freelancer') context.go('/dashboard');
              if (v == 'more') context.go('/more');
              if (v == 'logout') await _logout();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'freelancer', child: Text('Freelancer dashboard')),
              PopupMenuItem(value: 'more', child: Text('Hub / settings')),
              PopupMenuDivider(),
              PopupMenuItem(value: 'logout', child: Text('Sign out')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          indicatorColor: ClivoraColors.primary,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Cloud users'),
            Tab(text: 'Activity'),
            Tab(text: 'Local'),
            Tab(text: 'Audit'),
            Tab(text: 'Plans'),
            Tab(text: 'Controls'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _OverviewTab(statsAsync: statsAsync, cloudUid: cloudUid, onRefresh: _refresh),
          _CloudUsersTab(profilesAsync: profilesAsync, onRefresh: _refresh),
          _ActivityTab(activityAsync: activityAsync, onRefresh: _refresh),
          _LocalUsersTab(usersAsync: localUsersAsync, onRefresh: _refresh),
          _AuditTab(onRefresh: _refresh),
          const _PlansTab(),
          _ControlsTab(
            adminEmailCtrl: _adminEmailCtrl,
            proEmailCtrl: _proEmailCtrl,
            resetEmailCtrl: _resetEmailCtrl,
            onGrantAdmin: () async {
              final err = await ref.read(adminManagementServiceProvider).grantAdminByEmail(_adminEmailCtrl.text);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err ?? 'Admin granted (account type preserved)')));
              if (err == null) {
                _adminEmailCtrl.clear();
                await _refresh();
              }
            },
            onGrantPro: () async {
              final err = await ref.read(adminManagementServiceProvider).grantProByEmail(_proEmailCtrl.text);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err ?? 'Pro granted (freelancer or client)')));
              if (err == null) {
                _proEmailCtrl.clear();
                await _refresh();
              }
            },
            onRevokePro: () async {
              final err = await ref.read(adminManagementServiceProvider).grantProByEmail(
                    _proEmailCtrl.text,
                    revoke: true,
                  );
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err ?? 'Pro revoked')));
              if (err == null) {
                _proEmailCtrl.clear();
                await _refresh();
              }
            },
            onResetPassword: () async {
              final email = _resetEmailCtrl.text.trim();
              var err = await ref.read(adminCloudRepositoryProvider).sendPasswordReset(email);
              if (err != null) {
                final backup = await ref.read(clivoraEmailServiceProvider).sendPasswordResetNotice(email);
                if (backup == null) {
                  err = null;
                }
              } else {
                await ref.read(clivoraEmailServiceProvider).sendPasswordResetNotice(email);
              }
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(err ?? 'Reset email sent (check inbox and spam)')),
              );
              if (err == null) _resetEmailCtrl.clear();
            },
            onSync: () async {
              await ref.read(adminSyncServiceProvider).syncPendingEvents();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Synced to web admin')));
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/dashboard'),
                  icon: const Icon(Icons.space_dashboard_outlined, size: 18),
                  label: const Text('Freelancer view'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white70),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Sign out'),
                  style: ElevatedButton.styleFrom(backgroundColor: ClivoraColors.errorRed),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.statsAsync, required this.cloudUid, required this.onRefresh});

  final AsyncValue<AdminStats> statsAsync;
  final String? cloudUid;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: ClivoraColors.brandGradient,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Platform health', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Text(
                  cloudUid != null ? 'Supabase connected' : 'Supabase offline',
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  cloudUid ?? 'Sign in again if cloud sync fails',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          statsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Stats error: $e', style: const TextStyle(color: Colors.white70)),
            data: (s) => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _MetricCard(label: 'Local users', value: '${s.totalUsers}'),
                _MetricCard(label: 'Sign-ups', value: '${s.signups}'),
                _MetricCard(label: 'Pro users', value: '${s.proUsers}'),
                _MetricCard(label: 'MRR (PKR)', value: 'Rs ${s.monthlyRevenue}'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Quick links', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
          const SizedBox(height: 10),
          _LinkTile(
            icon: Icons.language,
            title: 'Web admin panel',
            subtitle: kAdminPanelUrl,
            onTap: () => launchUrl(Uri.parse(kAdminPanelUrl), mode: LaunchMode.externalApplication),
          ),
          _LinkTile(
            icon: Icons.receipt_long_outlined,
            title: 'Pro billing',
            subtitle: '${ProPricing.monthlyLabel}/mo · admin-only rollout',
            onTap: () => context.push('/upgrade'),
          ),
        ],
      ),
    );
  }
}

class _CloudUsersTab extends StatelessWidget {
  const _CloudUsersTab({required this.profilesAsync, required this.onRefresh});

  final AsyncValue<List<CloudProfileRow>> profilesAsync;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: profilesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ListView(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Could not load cloud users: $e\n\nRun migration 003+004 in Supabase.', style: const TextStyle(color: Colors.white70)),
          ),
        ]),
        data: (profiles) {
          if (profiles.isEmpty) {
            return ListView(children: const [
              SizedBox(height: 80),
              Center(child: Text('No Supabase profiles yet', style: TextStyle(color: Colors.white54))),
            ]);
          }
          final freelancers = profiles.where((p) => p.accountType == 'freelancer' || p.accountType == 'user').length;
          final clients = profiles.where((p) => p.accountType == 'client').length;
          final admins = profiles.where((p) => p.accountType == 'admin' || p.role == 'admin').length;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Wrap(
                spacing: 8,
                children: [
                  Chip(label: Text('$freelancers Freelancers')),
                  Chip(label: Text('$clients Clients')),
                  Chip(label: Text('$admins Admins')),
                ],
              ),
              const SizedBox(height: 12),
              ...profiles.map((p) => Card(
                    color: const Color(0xFF1E293B),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _typeColor(p.accountType),
                        child: Text(p.typeLabel[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                      title: Text(p.name.isNotEmpty ? p.name : p.email, style: const TextStyle(color: Colors.white)),
                      subtitle: Text('${p.email} · ${p.typeLabel}', style: const TextStyle(color: Colors.white54)),
                      trailing: Text(
                        p.updatedAt != null ? DateFormat('MMM d').format(p.updatedAt!.toLocal()) : '',
                        style: const TextStyle(fontSize: 11, color: Colors.white38),
                      ),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}

class _ActivityTab extends StatelessWidget {
  const _ActivityTab({required this.activityAsync, required this.onRefresh});

  final AsyncValue<List<AdminActivityItem>> activityAsync;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: activityAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ListView(children: [Padding(padding: const EdgeInsets.all(20), child: Text('$e'))]),
        data: (items) {
          if (items.isEmpty) {
            return ListView(children: const [
              SizedBox(height: 80),
              Center(child: Text('No activity yet', style: TextStyle(color: Colors.white54))),
            ]);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _ActivityCard(item: items[i]),
          );
        },
      ),
    );
  }
}

class _LocalUsersTab extends StatelessWidget {
  const _LocalUsersTab({required this.usersAsync, required this.onRefresh});

  final AsyncValue<List<User>> usersAsync;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ListView(children: [Text('Error: $e')]),
        data: (users) => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: users.length,
          itemBuilder: (_, i) {
            final u = users[i];
            return Card(
              color: const Color(0xFF1E293B),
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(u.name, style: const TextStyle(color: Colors.white)),
                subtitle: Text(u.email, style: const TextStyle(color: Colors.white54)),
                trailing: Chip(label: Text(accountTypeLabel(u))),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PlansTab extends StatelessWidget {
  const _PlansTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Free vs Pro matrix', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
        const SizedBox(height: 12),
        _PlanRow('Clients', 'Up to ${PlanLimits.freeMaxClients}', 'Unlimited'),
        _PlanRow('Projects', 'Up to ${PlanLimits.freeMaxProjects}', 'Unlimited'),
        _PlanRow('Invoices / month', '${PlanLimits.freeMaxInvoicesPerMonth}', 'Unlimited'),
        _PlanRow('Emails / month', '${PlanLimits.freeMaxEmailsPerMonth}', '${PlanLimits.proMaxEmailsPerMonth}'),
        _PlanRow('Storage', '100 MB', '5 GB'),
        _PlanRow('Biometric lock', '—', '✓'),
        _PlanRow('Verified badge', '—', '✓'),
        _PlanRow('Custom workflows', '—', '✓'),
        _PlanRow('CLIVORA AI Pro', 'Local only', 'Cloud + local'),
        _PlanRow('Advanced analytics', 'Basic', 'Full trends'),
        const SizedBox(height: 20),
        const Text('Feature flags (read-only)', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...[
          'chatTextMessages',
          'biometricLock',
          'aiAssistant',
          'customWorkflows',
          'advancedAnalytics',
          'dataExport',
        ].map(
          (f) => ListTile(
            dense: true,
            title: Text(f, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            trailing: const Icon(Icons.check_circle, color: ClivoraColors.primary, size: 18),
          ),
        ),
      ],
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow(this.feature, this.free, this.pro);
  final String feature;
  final String free;
  final String pro;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(feature, style: const TextStyle(color: Colors.white))),
          Expanded(child: Text(free, style: const TextStyle(color: Colors.white54, fontSize: 12))),
          Expanded(child: Text(pro, style: const TextStyle(color: ClivoraColors.primary, fontSize: 12, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _ControlsTab extends StatelessWidget {
  const _ControlsTab({
    required this.adminEmailCtrl,
    required this.proEmailCtrl,
    required this.resetEmailCtrl,
    required this.onGrantAdmin,
    required this.onGrantPro,
    required this.onRevokePro,
    required this.onResetPassword,
    required this.onSync,
  });

  final TextEditingController adminEmailCtrl;
  final TextEditingController proEmailCtrl;
  final TextEditingController resetEmailCtrl;
  final VoidCallback onGrantAdmin;
  final VoidCallback onGrantPro;
  final VoidCallback onRevokePro;
  final VoidCallback onResetPassword;
  final VoidCallback onSync;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Grant admin access', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text(
          'Keeps client or freelancer account type. Only adds admin role.',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: adminEmailCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'User email', hintText: 'user@example.com'),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: onGrantAdmin,
          icon: const Icon(Icons.admin_panel_settings_outlined),
          label: const Text('Grant admin role'),
        ),
        const SizedBox(height: 24),
        const Text('Grant Pro (freelancer or client)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextField(
          controller: proEmailCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'User email for Pro', hintText: 'client@example.com'),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onGrantPro,
                icon: const Icon(Icons.verified_rounded),
                label: const Text('Grant Pro'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onRevokePro,
                icon: const Icon(Icons.remove_circle_outline),
                label: const Text('Revoke Pro'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white70),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Password reset', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text('Sends Supabase password reset email.', style: TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          controller: resetEmailCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'User email'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(onPressed: onResetPassword, icon: const Icon(Icons.lock_reset_rounded), label: const Text('Send reset email')),
        const SizedBox(height: 24),
        OutlinedButton.icon(onPressed: onSync, icon: const Icon(Icons.cloud_upload_outlined), label: const Text('Sync events to web admin')),
        const SizedBox(height: 24),
        const Text('Platform access', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text(
          'Super admins can grant Pro, reset passwords, view cloud users, audit logs, and import analytics from any device.',
          style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 12),
        ListTile(
          leading: const Icon(Icons.people_outline, color: Colors.white70),
          title: const Text('Cloud users tab', style: TextStyle(color: Colors.white)),
          subtitle: const Text('Live Supabase profiles', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ),
        ListTile(
          leading: const Icon(Icons.receipt_long_outlined, color: Colors.white70),
          title: const Text('Audit tab', style: TextStyle(color: Colors.white)),
          subtitle: const Text('Invoice, admin, payment events', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ),
        ListTile(
          leading: const Icon(Icons.workspace_premium_outlined, color: Colors.white70),
          title: const Text('Plans tab', style: TextStyle(color: Colors.white)),
          subtitle: const Text('Free vs Pro limits reference', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ),
      ],
    );
  }
}

Color _typeColor(String type) {
  switch (type) {
    case 'client':
      return ClivoraColors.clientAccent;
    case 'admin':
      return ClivoraColors.navyDark;
    default:
      return ClivoraColors.primary;
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: ClivoraColors.primary),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white38),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.item});

  final AdminActivityItem item;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('MMM d · h:mm a').format(item.createdAt.toLocal());
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.bolt, size: 18, color: ClivoraColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                Text(item.subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditTab extends ConsumerWidget {
  const _AuditTab({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditAsync = ref.watch(auditLogsProvider);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: auditAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: ClivoraColors.primary)),
        error: (e, _) => Center(child: Text('Audit error: $e', style: const TextStyle(color: Colors.white70))),
        data: (logs) {
          if (logs.isEmpty) {
            return ListView(
              children: const [
                SizedBox(height: 120),
                Center(child: Text('No audit events yet', style: TextStyle(color: Colors.white54))),
              ],
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: logs.length,
            itemBuilder: (_, i) {
              final log = logs[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.eventType.replaceFirst('audit_', '').replaceAll('_', ' '),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    if (log.userEmail.isNotEmpty)
                      Text(log.userEmail, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    Text(
                      DateFormat.yMMMd().add_jm().format(log.createdAt.toLocal()),
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                    if (log.payload.isNotEmpty && log.payload != '{}')
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(log.payload, style: const TextStyle(color: Colors.white38, fontSize: 10), maxLines: 3, overflow: TextOverflow.ellipsis),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
