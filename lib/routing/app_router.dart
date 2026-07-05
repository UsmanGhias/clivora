import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/auth_route_helper.dart';
import '../core/auth/auth_session.dart';
import '../features/client/client_invoices_screen.dart';
import '../features/client/client_messages_screen.dart';
import '../features/client/client_portal_screen.dart';
import '../features/client/client_activity_screen.dart';
import '../features/client/client_tasks_screen.dart';
import '../features/client/client_account_screen.dart';
import '../features/team/team_screen.dart';
import '../features/customers/customer_form_screen.dart';
import '../features/customers/customers_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/expenses/expenses_screen.dart';
import '../features/invoices/invoice_form_screen.dart';
import '../features/invoices/invoices_screen.dart';
import '../features/messages/freelancer_messages_screen.dart';
import '../features/more/more_screen.dart';
import '../features/notes/notes_screen.dart';
import '../features/projects/project_form_screen.dart';
import '../features/projects/projects_screen.dart';
import '../features/reports/reports_screen.dart' show CalendarScreen, PaymentsScreen, ReportsScreen;
import '../features/notifications/notifications_screen.dart';
import '../features/auth/auth_screens.dart';
import '../features/profile/profile_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/admin/admin_dashboard_screen.dart';
import '../features/pro/pro_screens.dart';
import '../features/subscription/upgrade_screen.dart';
import '../features/tasks/tasks_screen.dart';
import 'app_shell.dart';
import 'auth_refresh.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  refreshListenable: authRefreshListenable,
  redirect: (context, state) => authRedirect(
    location: state.matchedLocation,
    user: authSessionUser,
    loading: authSessionLoading,
  ),
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: DashboardScreen()),
        ),
        GoRoute(
          path: '/customers',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CustomersScreen()),
        ),
        GoRoute(
          path: '/projects',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProjectsScreen()),
        ),
        GoRoute(
          path: '/invoices',
          pageBuilder: (context, state) {
            final filter = state.uri.queryParameters['filter'];
            return NoTransitionPage(child: InvoicesScreen(initialFilter: filter));
          },
        ),
        GoRoute(
          path: '/client-messages',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ClientMessagesScreen()),
        ),
        GoRoute(
          path: '/client-invoices',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ClientInvoicesScreen()),
        ),
        GoRoute(
          path: '/client-portal',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ClientPortalScreen()),
        ),
        GoRoute(
          path: '/client-activity',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ClientActivityScreen()),
        ),
        GoRoute(
          path: '/client-tasks',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ClientTasksScreen()),
        ),
        GoRoute(
          path: '/client-account',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ClientAccountScreen()),
        ),
        GoRoute(
          path: '/freelancer-messages',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: FreelancerMessagesScreen()),
        ),
        GoRoute(
          path: '/more',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MoreScreen()),
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/customers/new',
      builder: (context, state) => const CustomerFormScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/customers/:id/edit',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return CustomerFormScreen(customerId: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/projects/new',
      builder: (context, state) => const ProjectFormScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/projects/:id/edit',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProjectFormScreen(projectId: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/invoices/new',
      builder: (context, state) => const InvoiceFormScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/invoices/:id/edit',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return InvoiceFormScreen(invoiceId: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/tasks',
      builder: (context, state) => const TasksScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/tasks/new',
      builder: (context, state) => const TaskFormScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/tasks/:id/edit',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return TaskFormScreen(taskId: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/expenses',
      builder: (context, state) => const ExpensesScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/expenses/new',
      builder: (context, state) => const ExpenseFormScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/expenses/:id/edit',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ExpenseFormScreen(expenseId: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/notes',
      builder: (context, state) => const NotesScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/notes/new',
      builder: (context, state) => const NoteFormScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/notes/:id/edit',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return NoteFormScreen(noteId: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/reports',
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/payments',
      builder: (context, state) => const PaymentsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/team',
      builder: (context, state) => const TeamScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/upgrade',
      builder: (context, state) => const UpgradeScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/ai-assistant',
      builder: (context, state) => const AiAssistantScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/templates',
      builder: (context, state) => const MessageTemplatesScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/contracts',
      builder: (context, state) => const ContractsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/automations',
      builder: (context, state) => const AutomationsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/storage',
      builder: (context, state) => const StorageScreen(),
    ),
  ],
);
