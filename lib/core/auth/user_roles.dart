import '../../data/database/database.dart';
import '../constants/admin_config.dart';

/// Account types: freelancer, client, admin, guest (browse without account).
const kAccountFreelancer = 'freelancer';
const kAccountClient = 'client';
const kAccountAdmin = 'admin';
const kAccountGuest = 'guest';

const kGuestEmail = 'guest@clivora.local';

bool isAdminUser(User? user) {
  if (user == null) return false;
  return user.accountType == kAccountAdmin ||
      user.role == 'admin' ||
      kAdminEmails.contains(user.email.toLowerCase());
}

bool isSuperAdmin(User? user) {
  if (user == null) return false;
  return user.email.toLowerCase() == kSuperAdminEmail;
}

bool isGuestEmail(String email) {
  final lower = email.toLowerCase();
  return lower == kGuestEmail || (lower.startsWith('guest_') && lower.endsWith('@clivora.local'));
}

bool isGuestUser(User? user) {
  if (user == null) return false;
  return isGuestEmail(user.email);
}

bool isFreelancerUser(User? user) {
  if (user == null) return false;
  if (isAdminUser(user)) return true;
  if (isGuestUser(user)) return user.accountType != kAccountClient;
  return user.accountType == kAccountFreelancer || user.accountType == 'user';
}

bool isClientUser(User? user) {
  if (user == null) return false;
  return user.accountType == kAccountClient;
}

String accountTypeLabel(User? user) {
  if (user == null) return 'Guest';
  if (isGuestUser(user)) return 'Guest';
  if (isAdminUser(user)) return 'Admin';
  if (isClientUser(user)) return 'Client';
  return 'Freelancer';
}
