import '../../data/database/database.dart';
import 'user_roles.dart';

/// Post-login home route based on account type.
String homeRouteForUser(User? user) {
  if (user == null) return '/login';
  if (isClientUser(user)) return '/client-portal';
  return '/dashboard';
}

const _publicRoutes = {'/', '/login', '/signup'};

/// Routes only freelancers (and admin/guest preview as freelancer) may access.
const freelancerShellRoutes = {
  '/dashboard',
  '/customers',
  '/projects',
  '/invoices',
  '/more',
};

const freelancerExtraRoutes = {
  '/tasks',
  '/expenses',
  '/notes',
  '/reports',
  '/calendar',
  '/notifications',
  '/payments',
  '/profile',
  '/upgrade',
  '/ai-assistant',
  '/templates',
  '/contracts',
  '/automations',
  '/admin',
  '/team',
  '/storage',
  '/freelancer-messages',
};

/// Routes only clients may access.
const clientShellRoutes = {
  '/client-portal',
  '/client-messages',
  '/client-invoices',
  '/client-activity',
  '/client-account',
};

bool isPublicRoute(String location) {
  if (_publicRoutes.contains(location)) return true;
  return false;
}

bool isFreelancerRoute(String location) {
  if (freelancerShellRoutes.any((r) => location == r || location.startsWith('$r/'))) {
    return true;
  }
  if (freelancerExtraRoutes.any((r) => location == r || location.startsWith('$r/'))) {
    return true;
  }
  if (location.startsWith('/customers/') ||
      location.startsWith('/projects/') ||
      location.startsWith('/invoices/') ||
      location.startsWith('/tasks/') ||
      location.startsWith('/expenses/') ||
      location.startsWith('/notes/')) {
    return true;
  }
  return false;
}

bool isClientRoute(String location) {
  return clientShellRoutes.any((r) => location == r || location.startsWith('$r/'));
}

bool isRouteAllowedForUser(User? user, String location) {
  if (user == null) return isPublicRoute(location);
  if (isPublicRoute(location)) return true;
  if (isClientUser(user)) return isClientRoute(location);
  return isFreelancerRoute(location);
}

/// GoRouter redirect based on auth session mirror.
String? authRedirect({required String location, required User? user, required bool loading}) {
  if (loading) return null;

  final path = Uri.parse(location).path;

  if (user == null) {
    if (isPublicRoute(path) || path.startsWith('/login') || path.startsWith('/signup')) {
      return null;
    }
    return '/login';
  }

  if (path == '/login' || path == '/signup') {
    return homeRouteForUser(user);
  }

  if (isClientUser(user) && isFreelancerRoute(path)) {
    return '/client-portal';
  }

  if (!isClientUser(user) && isClientRoute(path)) {
    return '/dashboard';
  }

  return null;
}
