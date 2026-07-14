import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_service.dart';
import '../auth/user_roles.dart';
import '../cloud/supabase_auth_helper.dart';

final freelancerLinkServiceProvider = Provider<FreelancerLinkService>((ref) {
  return FreelancerLinkService(ref);
});

/// Client invites / links a freelancer by email (two-way onboarding).
class FreelancerLinkService {
  FreelancerLinkService(this.ref);

  final Ref ref;

  Future<String?> linkFreelancerByEmail(String freelancerEmail) async {
    final client = ref.read(authStateProvider).valueOrNull;
    if (client == null || !isClientUser(client)) return 'Sign in as a client first';

    final email = freelancerEmail.trim().toLowerCase();
    if (!email.contains('@')) return 'Enter a valid freelancer email';

    if (email == client.email.toLowerCase()) {
      return 'Enter your freelancer\'s email, not your own';
    }

    final clientUid = SupabaseAuthHelper.currentUid;
    if (clientUid == null || clientUid.isEmpty) {
      return 'Sign in with Google or email (not guest) to connect with a freelancer';
    }

    final sb = SupabaseAuthHelper.client;
    try {
      await sb.rpc(
        'client_invite_freelancer',
        params: {
          'p_freelancer_email': email,
          'p_message':
              'Hi,\n\n'
              '${client.name} (${client.email}) would like to work with you on CLIVORA.\n\n'
              'Please share a project with their email so they can view progress, invoices, and messages.\n\n'
              'Open CLIVORA → Clients → share a project using: ${client.email}',
        },
      );
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('Sign in required')) {
        return 'Sign in with Google or email (not guest) to connect with a freelancer';
      }
      if (msg.contains('Enter a valid') || msg.contains('not your own')) {
        return msg.replaceFirst(RegExp(r'^.*Exception:\s*'), '');
      }
      return 'Could not send link request: $e';
    }

    return null;
  }
}
