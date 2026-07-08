import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    Map<String, dynamic>? extraFields,
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
          'purpose': purpose.name,
          if (htmlBody.isNotEmpty) 'html': htmlBody,
          ...?extraFields,
        },
      );
      if (response.status != 200) {
        final data = response.data;
        final detail = data is Map ? '${data['error'] ?? response.status}' : 'Email failed (${response.status})';
        return detail;
      }
      if (countTowardQuota && purpose != ClivoraEmailPurpose.passwordReset) {
        await ref.read(emailQuotaServiceProvider).recordSent();
      }
      return null;
    } on FunctionException catch (e) {
      debugPrint('Clivora email FunctionException: ${e.details}');
      final details = e.details;
      if (details is Map && details['error'] != null) {
        return '${details['error']}';
      }
      return 'Email service error (${e.status}). Check RESEND_API_KEY on send-clivora-email.';
    } catch (e) {
      debugPrint('Clivora email error: $e');
      return 'Email service unavailable. Deploy send-clivora-email with RESEND_API_KEY set.';
    }
  }

  Future<String?> sendPasswordResetNotice(String email) {
    return sendSpecialEmail(
      to: email,
      subject: 'Reset your CLIVORA password',
      htmlBody: '',
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
      htmlBody: '',
      purpose: ClivoraEmailPurpose.clientInvite,
      extraFields: {
        'freelancerName': freelancerName,
        'clientName': clientName,
      },
    );
  }

  Future<String?> sendAdminNotice({
    required String to,
    required String subject,
    required String message,
  }) {
    return sendSpecialEmail(
      to: to,
      subject: subject,
      htmlBody: message,
      purpose: ClivoraEmailPurpose.adminNotice,
      extraFields: {'adminMessage': message},
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
