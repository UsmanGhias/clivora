import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/user_roles.dart';
import '../../core/constants/plan_limits.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/greeting.dart';
import '../../core/utils/navigation_helper.dart';
import '../../core/services/admin_management_service.dart';
import '../../core/services/coach_marks_service.dart';
import '../../core/services/email_verification_service.dart';
import '../../data/database/database.dart';
import '../../data/providers/app_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/clivora_logo.dart';
import '../../shared/widgets/simple_coach_tour.dart';
import '../../shared/widgets/messages_icon_button.dart';
import '../../shared/widgets/notification_icon_button.dart';
import '../../shared/widgets/skeleton_loading.dart';
import '../../shared/widgets/today_overdue_card.dart';
import 'priority_strips.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowCoachMarks());
  }

  Future<void> _maybeShowCoachMarks() async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null || isClientUser(user)) return;
    final show = await ref.read(coachMarksServiceProvider).shouldShowForRole(isClient: false);
    if (!show || !mounted) return;
    try {
      await ref.read(dashboardStatsProvider.future);
    } catch (_) {}
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    await showSimpleCoachTour(
      context,
      steps: [
        SimpleCoachStep(
          icon: Icons.insights_outlined,
          title: l10n.coachMarkStatsTitle,
          body: l10n.coachMarkStatsBody,
        ),
        SimpleCoachStep(
          icon: Icons.bolt_outlined,
          title: l10n.coachMarkQuickTitle,
          body: l10n.coachMarkQuickBody,
        ),
        SimpleCoachStep(
          icon: Icons.search_rounded,
          title: l10n.coachMarkSearchTitle,
          body: l10n.coachMarkSearchBody,
        ),
      ],
      onComplete: () => ref.read(coachMarksServiceProvider).markDashboardCompleteForRole(isClient: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(dashboardStatsProvider);
    final profileAsync = ref.watch(businessProfileProvider);
    final authUser = ref.watch(authStateProvider).valueOrNull;
    final projectsAsync = ref.watch(projectsProvider(const ProjectFilter(status: 'in_progress')));
    final customersAsync = ref.watch(customersProvider(null));

    final ownerName = authUser?.name.isNotEmpty == true
        ? authUser!.name.split(' ').first
        : profileAsync.maybeWhen(
            data: (p) => p.ownerName.isNotEmpty ? p.ownerName.split(' ').first : 'there',
            orElse: () => 'there',
          );
    final photoPath = authUser?.profilePhotoPath ?? profileAsync.valueOrNull?.ownerPhotoPath;
    final isGuest = isGuestUser(authUser);

    return Scaffold(
      body: SafeArea(
        child: _dashboardBody(context, l10n, statsAsync, profileAsync, authUser, projectsAsync, customersAsync, ownerName, photoPath, isGuest),
      ),
    );
  }

  Widget _dashboardBody(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<DashboardStats> statsAsync,
    AsyncValue<BusinessProfile> profileAsync,
    User? authUser,
    AsyncValue<List<Project>> projectsAsync,
    AsyncValue<List<Customer>> customersAsync,
    String ownerName,
    String? photoPath,
    bool isGuest,
  ) {
    return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardStatsProvider);
            ref.invalidate(projectsProvider);
            ref.invalidate(customersProvider);
            ref.invalidate(notificationsProvider);
            ref.invalidate(cloudNotificationsProvider);
          },
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: ClivoraColors.brandGradient,
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
                          'GUEST PREVIEW · FREELANCER',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.6),
                        ),
                      ),
                    Row(
                      children: [
                        ProfileAvatar(
                          photoPath: photoPath,
                          name: ownerName,
                          radius: 22,
                          showVerified: ref.watch(isProProvider),
                          onTap: () => openFormRoute(context, '/profile'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(timeBasedGreeting(), style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12)),
                              Text(
                                ownerName,
                                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const MessagesIconButton(
                          route: '/freelancer-messages',
                          iconColor: Colors.white,
                          useFilledStyle: true,
                        ),
                        const SizedBox(width: 8),
                        const NotificationIconButton(
                          isClient: false,
                          iconColor: Colors.white,
                          useFilledStyle: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.dashboardGreeting,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
                    ),
                  ],
                ),
              ),
              if (authUser != null &&
                  !isGuestUser(authUser) &&
                  !ref.watch(emailVerificationServiceProvider).isVerified(authUser)) ...[
                const SizedBox(height: 12),
                Material(
                  color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => openFormRoute(context, '/profile'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.mark_email_unread_outlined, color: Theme.of(context).colorScheme.error),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Verify your email to create clients, invoices, and projects. Tap to open Profile.',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              const FreelancerPriorityStrip(),
              Container(
                width: double.infinity,
                child: statsAsync.when(
                  loading: () => const _StatsGridPlaceholder(),
                  error: (_, __) => const _StatsGridPlaceholder(),
                  data: (stats) => _StatsGrid(stats: stats, onNavigate: context.go),
                ),
              ),
              const SizedBox(height: 12),
              const _RevenueSparklineCard(),
              const SizedBox(height: 14),
              const TodayOverdueCard(),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: _QuickActions(ref: ref, l10n: l10n),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => openFormRoute(context, '/search'),
                  icon: const Icon(Icons.search, size: 18),
                  label: Text(l10n.searchWorkspace),
                ),
              ),
              const SizedBox(height: 24),
              _GetStartedCard(ref: ref),
              const SizedBox(height: 24),
              Text('Active Projects', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              projectsAsync.when(
                loading: () => const _SectionCardLoading(),
                error: (_, __) => const SizedBox.shrink(),
                data: (projects) {
                  final active = projects.where((p) => p.status == 'in_progress').take(3).toList();
                  if (active.isEmpty) {
                    return _EmptySectionCard(
                      icon: Icons.work_outline,
                      message: 'No active projects',
                      actionLabel: 'Create Project',
                      onAction: () => tryOpenWithPlanCheck(
                        context,
                        ref: ref,
                        canAdd: () => ref.read(planLimitServiceProvider).canAddProject(),
                        path: '/projects/new',
                        resource: 'projects',
                        max: PlanLimits.freeMaxProjects,
                      ),
                    );
                  }
                  return Column(
                    children: active
                        .map(
                          (p) => _ProjectTile(
                            name: p.name,
                            onTap: () => openFormRoute(context, '/projects/${p.id}/edit'),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text('Recent Customers', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              customersAsync.when(
                loading: () => const _SectionCardLoading(),
                error: (_, __) => const SizedBox.shrink(),
                data: (customers) {
                  if (customers.isEmpty) {
                    return _EmptySectionCard(
                      icon: Icons.people_outline,
                      message: 'No customers yet',
                      actionLabel: 'Add Customer',
                      onAction: () => tryOpenWithPlanCheck(
                        context,
                        ref: ref,
                        canAdd: () => ref.read(planLimitServiceProvider).canAddCustomer(),
                        path: '/customers/new',
                        resource: 'clients',
                        max: PlanLimits.freeMaxClients,
                      ),
                    );
                  }
                  return Column(
                    children: customers
                        .take(3)
                        .map(
                          (c) => _CustomerTile(
                            name: c.contactPerson,
                            onTap: () => openFormRoute(context, '/customers/${c.id}/edit'),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats, required this.onNavigate});

  final DashboardStats stats;
  final void Function(String) onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: formatCurrency(stats.revenue > 0 ? stats.revenue : stats.totalInvoiced),
                subtitle: stats.revenue > 0 ? 'Paid Revenue' : 'Total Invoiced',
                background: ClivoraColors.navyDark,
                foreground: Colors.white,
                icon: Icons.account_balance_wallet_outlined,
                onTap: () => onNavigate(stats.revenue > 0 ? '/invoices?filter=paid' : '/invoices'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: formatCurrency(stats.outstanding),
                subtitle: 'Outstanding',
                background: ClivoraColors.outstandingPink,
                foreground: ClivoraColors.errorRed,
                icon: Icons.error_outline,
                onTap: () => onNavigate('/invoices?filter=outstanding'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: '${stats.customers}',
                subtitle: 'Customers',
                background: Theme.of(context).cardColor,
                foreground: Theme.of(context).colorScheme.onSurface,
                icon: Icons.people_outline,
                iconColor: ClivoraColors.primaryPurple,
                bordered: true,
                onTap: () => context.go('/customers'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: '${stats.activeProjects}',
                subtitle: 'Active Projects',
                background: Theme.of(context).cardColor,
                foreground: Theme.of(context).colorScheme.onSurface,
                icon: Icons.work_outline,
                iconColor: ClivoraColors.warningOrange,
                bordered: true,
                onTap: () => context.go('/projects'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.subtitle,
    required this.background,
    required this.foreground,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.bordered = false,
  });

  final String title;
  final String subtitle;
  final Color background;
  final Color foreground;
  final IconData icon;
  final Color? iconColor;
  final bool bordered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: bordered
                ? Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? ClivoraColors.darkBorder
                        : ClivoraColors.borderLight,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor ?? foreground.withValues(alpha: 0.8), size: 20),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: foreground.withValues(alpha: 0.5), size: 20),
                ],
              ),
              const SizedBox(height: 12),
              Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: foreground)),
              Text(subtitle, style: TextStyle(fontSize: 13, color: foreground.withValues(alpha: 0.7))),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends ConsumerWidget {
  const _QuickActions({required this.ref, required this.l10n});

  final WidgetRef ref;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef _) {
    Future<void> addCustomer() => tryOpenWithPlanCheck(
          context,
          ref: ref,
          canAdd: () => ref.read(planLimitServiceProvider).canAddCustomer(),
          path: '/customers/new',
          resource: 'clients',
          max: PlanLimits.freeMaxClients,
        );
    Future<void> addProject() => tryOpenWithPlanCheck(
          context,
          ref: ref,
          canAdd: () => ref.read(planLimitServiceProvider).canAddProject(),
          path: '/projects/new',
          resource: 'projects',
          max: PlanLimits.freeMaxProjects,
        );
    Future<void> addInvoice() => tryOpenWithPlanCheck(
          context,
          ref: ref,
          canAdd: () => ref.read(planLimitServiceProvider).canAddInvoice(),
          path: '/invoices/new',
          resource: 'invoices this month',
          max: PlanLimits.freeMaxInvoicesPerMonth,
        );

    final actions = [
      _QuickAction(Icons.person_add_outlined, l10n.quickActionClient, ClivoraColors.iconPurple, ClivoraColors.primaryPurple, () => addCustomer()),
      _QuickAction(Icons.create_new_folder_outlined, l10n.quickActionProject, ClivoraColors.iconOrange, ClivoraColors.warningOrange, () => addProject()),
      _QuickAction(Icons.receipt_long_outlined, l10n.quickActionInvoice, ClivoraColors.iconGreen, ClivoraColors.successGreen, () => addInvoice()),
      _QuickAction(Icons.task_alt_outlined, l10n.quickActionTask, ClivoraColors.iconBlue, Colors.blue, () async {
        if (!await requireEmailVerified(context, ref, actionLabel: 'create tasks')) return;
        if (context.mounted) openFormRoute(context, '/tasks/new');
      }),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((a) {
        return GestureDetector(
          onTap: a.onTap,
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: a.bg, borderRadius: BorderRadius.circular(16)),
                child: Icon(a.icon, color: a.color),
              ),
              const SizedBox(height: 8),
              Text(a.label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _QuickAction {
  const _QuickAction(this.icon, this.label, this.bg, this.color, this.onTap);
  final IconData icon;
  final String label;
  final Color bg;
  final Color color;
  final VoidCallback onTap;
}

class _GetStartedCard extends ConsumerWidget {
  const _GetStartedCard({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef _) {
    final stats = ref.watch(dashboardStatsProvider).valueOrNull;
    if (stats != null && stats.customers > 0 && stats.activeProjects > 0) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ClivoraColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Get started', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('Complete these steps to set up your workspace.', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          _ChecklistItem(Icons.person_outline, ClivoraColors.primaryPurple, 'Add client', () {
            tryOpenWithPlanCheck(
              context,
              ref: ref,
              canAdd: () => ref.read(planLimitServiceProvider).canAddCustomer(),
              path: '/customers/new',
              resource: 'clients',
              max: PlanLimits.freeMaxClients,
            );
          }),
          _ChecklistItem(Icons.folder_outlined, ClivoraColors.warningOrange, 'Create a project', () {
            tryOpenWithPlanCheck(
              context,
              ref: ref,
              canAdd: () => ref.read(planLimitServiceProvider).canAddProject(),
              path: '/projects/new',
              resource: 'projects',
              max: PlanLimits.freeMaxProjects,
            );
          }),
          _ChecklistItem(Icons.receipt_long_outlined, ClivoraColors.successGreen, 'Send invoice', () {
            tryOpenWithPlanCheck(
              context,
              ref: ref,
              canAdd: () => ref.read(planLimitServiceProvider).canAddInvoice(),
              path: '/invoices/new',
              resource: 'invoices this month',
              max: PlanLimits.freeMaxInvoicesPerMonth,
            );
          }),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem(this.icon, this.color, this.label, this.onTap);

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
            const Icon(Icons.chevron_right, color: ClivoraColors.labelGray),
          ],
        ),
      ),
    );
  }
}

class _EmptySectionCard extends StatelessWidget {
  const _EmptySectionCard({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ClivoraColors.borderLight),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: ClivoraColors.labelGray),
          const SizedBox(height: 12),
          Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ClivoraColors.textSecondary)),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.add, size: 18, color: ClivoraColors.primaryPurple),
            label: Text(actionLabel, style: const TextStyle(color: ClivoraColors.primaryPurple, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({required this.name, required this.onTap});
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ClivoraColors.borderLight),
          ),
          child: Row(
            children: [
              const Icon(Icons.work_outline, color: ClivoraColors.primaryPurple),
              const SizedBox(width: 12),
              Expanded(child: Text(name, style: Theme.of(context).textTheme.titleMedium)),
              const Icon(Icons.chevron_right, color: ClivoraColors.labelGray),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({required this.name, required this.onTap});
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ClivoraColors.borderLight),
          ),
          child: Row(
            children: [
              const Icon(Icons.person_outline, color: ClivoraColors.primaryPurple),
              const SizedBox(width: 12),
              Expanded(child: Text(name, style: Theme.of(context).textTheme.titleMedium)),
              const Icon(Icons.chevron_right, color: ClivoraColors.labelGray),
            ],
          ),
        ),
      ),
    );
  }
}

class _RevenueSparklineCard extends ConsumerWidget {
  const _RevenueSparklineCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(revenueSparklineProvider);
    return seriesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (series) {
        final max = series.fold<double>(0, (m, v) => v > m ? v : m);
        final total = series.fold<double>(0, (s, v) => s + v);
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? ClivoraColors.darkBorder
                  : ClivoraColors.borderLight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Paid revenue · 30 days',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    formatCurrency(total),
                    style: const TextStyle(fontWeight: FontWeight.w800, color: ClivoraColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final v in series)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            height: max <= 0 ? 4 : (8 + (v / max) * 40),
                            decoration: BoxDecoration(
                              color: v > 0
                                  ? ClivoraColors.primary.withValues(alpha: 0.85)
                                  : (Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white24
                                      : ClivoraColors.borderLight),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatsGridPlaceholder extends StatelessWidget {
  const _StatsGridPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const StatsGridSkeleton();
  }
}

class _SectionCardLoading extends StatelessWidget {
  const _SectionCardLoading();

  @override
  Widget build(BuildContext context) {
    return const CardSkeleton(height: 100);
  }
}
