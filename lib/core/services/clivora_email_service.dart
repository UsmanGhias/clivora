import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cloud/supabase_auth_helper.dart';
import '../constants/plan_limits.dart';
import 'email_quota_service.dart';

/// Sends special-purpose emails via Supabase Edge Function.
final clivoraEmailServiceProvider = Provider<ClivoraEmailService>((ref) {
  return ClivoraEmailService(ref);
});

class ClivoraEmailService {
  ClivoraEmailService(this.ref);

  final Ref ref;

  Future<String?> sendSpecialEmail({
    required String to,
    required String subject,
    required String htmlBody,
    required ClivoraEmailPurpose purpose,
    bool countTowardQuota = true,
  }) async {
    if (countTowardQuota && purpose != ClivoraEmailPurpose.passwordReset) {
      if (!await ref.read(emailQuotaServiceProvider).canSendEmail()) {
        return 'Free plan limit: ${PlanLimits.freeMaxEmailsPerMonth} emails/month. Upgrade to Pro for more.';
      }
    }

    try {
      final response = await SupabaseAuthHelper.client.functions.invoke(
        'send-clivora-email',
        body: {
          'to': to.trim().toLowerCase(),
          'subject': subject,
          'html': htmlBody,
          'purpose': purpose.name,
        },
      );
      if (response.status != 200) {
        final data = response.data;
        return data is Map ? '${data['error'] ?? response.status}' : 'Email failed (${response.status})';
      }
      if (countTowardQuota && purpose != ClivoraEmailPurpose.passwordReset) {
        await ref.read(emailQuotaServiceProvider).recordSent();
      }
      return null;
    } catch (e) {
      debugPrint('Clivora email error: $e');
      return 'Email service unavailable. Set RESEND_API_KEY on send-clivora-email Edge Function.';
    }
  }

  Future<String?> sendPasswordResetNotice(String email) {
    return sendSpecialEmail(
      to: email,
      subject: 'CLIVORA: Password reset requested',
      htmlBody:
          '<p>A password reset was requested for your CLIVORA account.</p>'
          '<p>If you did not request this, ignore this email.</p>'
          '<p>Use the reset link from the app or contact support.</p>',
      purpose: ClivoraEmailPurpose.passwordReset,
      countTowardQuota: false,
    );
  }

  Future<String?> sendClientInviteEmail({
    required String to,
    required String freelancerName,
    required String clientName,
  }) {
    return sendSpecialEmail(
      to: to,
      subject: '$freelancerName invited you to CLIVORA',
      htmlBody:
          '<p>Hi $clientName,</p>'
          '<p><strong>$freelancerName</strong> added you as a client on CLIVORA.</p>'
          '<p>Download the app, sign up as a <strong>Client</strong> with this email, and view shared projects, invoices, and messages.</p>',
      purpose: ClivoraEmailPurpose.clientInvite,
    );
  }
}

enum ClivoraEmailPurpose {
  passwordReset,
  adminNotice,
  clientInvite,
}

extension on ClivoraEmailPurpose {
  String get name {
    switch (this) {
      case ClivoraEmailPurpose.passwordReset:
        return 'password_reset';
      case ClivoraEmailPurpose.adminNotice:
        return 'admin_notice';
      case ClivoraEmailPurpose.clientInvite:
        return 'client_invite';
    }
  }
}
