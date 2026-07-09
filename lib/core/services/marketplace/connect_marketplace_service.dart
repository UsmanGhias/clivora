import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/auth_service.dart';
import '../../auth/user_roles.dart';
import '../../constants/plan_features.dart';
import '../../../data/providers/app_providers.dart';

final connectMarketplaceServiceProvider = Provider<ConnectMarketplaceService>((ref) {
  return ConnectMarketplaceService(ref);
});

class ConnectMarketplaceService {
  ConnectMarketplaceService(this.ref);
  final Ref ref;

  SupabaseClient? get client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  String? get currentUserId => client?.auth.currentUser?.id;

  bool get hasProPlus {
    final plan = ref.read(subscriptionPlanProvider).valueOrNull;
    return PlanFeatures.isProPlus(plan) || ref.read(isProPlusProvider);
  }

  Future<List<Map<String, dynamic>>> browseFreelancers({String? skill}) async {
    final c = client;
    if (c == null) return [];
    final rows = await c
        .from('connect_profiles')
        .select(
          'id,user_id,display_title,headline,bio,skills,rate_band,availability,location_label,is_verified,account_type',
        )
        .eq('account_type', 'freelancer')
        .eq('is_listed', true)
        .eq('moderation_status', 'approved')
        .order('updated_at', ascending: false)
        .limit(50);
    final list = (rows as List).cast<Map<String, dynamic>>();
    if (skill == null || skill.trim().isEmpty) return list;
    final needle = skill.trim().toLowerCase();
    return list.where((r) {
      final skills = (r['skills'] as List?)?.map((e) => e.toString().toLowerCase()) ?? [];
      return skills.any((s) => s.contains(needle));
    }).toList();
  }

  Future<List<Map<String, dynamic>>> browseNeeds() async {
    final c = client;
    if (c == null) return [];
    final rows = await c
        .from('connect_need_posts')
        .select('id,client_user_id,title,summary,skills,budget_band,created_at')
        .eq('is_open', true)
        .eq('moderation_status', 'approved')
        .order('created_at', ascending: false)
        .limit(50);
    return (rows as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> myListing() async {
    final c = client;
    final uid = c?.auth.currentUser?.id;
    if (c == null || uid == null) return null;
    return await c.from('connect_profiles').select().eq('user_id', uid).maybeSingle();
  }

  Future<void> upsertListing({
    required String displayTitle,
    required String headline,
    required String bio,
    required List<String> skills,
    required String rateBand,
    required String availability,
    required String locationLabel,
    required bool isListed,
  }) async {
    final c = client;
    final uid = c?.auth.currentUser?.id;
    if (c == null || uid == null) throw StateError('Sign in required');
    if (!hasProPlus) throw StateError('CLIVORA Connect requires Pro Plus');

    final user = ref.read(authStateProvider).valueOrNull;
    final accountType = isClientUser(user) ? 'client' : 'freelancer';

    await c.from('connect_profiles').upsert({
      'user_id': uid,
      'account_type': accountType,
      'display_title': displayTitle.trim(),
      'headline': headline.trim(),
      'bio': bio.trim(),
      'skills': skills,
      'rate_band': rateBand,
      'availability': availability,
      'location_label': locationLabel.trim(),
      'is_listed': isListed,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id');
  }

  Future<void> createNeedPost({
    required String title,
    required String summary,
    required List<String> skills,
    required String budgetBand,
  }) async {
    final c = client;
    final uid = c?.auth.currentUser?.id;
    if (c == null || uid == null) throw StateError('Sign in required');
    if (!hasProPlus) throw StateError('CLIVORA Connect requires Pro Plus');

    await c.from('connect_need_posts').insert({
      'client_user_id': uid,
      'title': title.trim(),
      'summary': summary.trim(),
      'skills': skills,
      'budget_band': budgetBand,
      'is_open': true,
    });
  }

  Future<void> sendContactRequest({
    required String toUserId,
    String? targetProfileId,
    String? targetNeedId,
    required String message,
  }) async {
    final c = client;
    final uid = c?.auth.currentUser?.id;
    if (c == null || uid == null) throw StateError('Sign in required');
    if (!hasProPlus) throw StateError('CLIVORA Connect requires Pro Plus');
    if (toUserId == uid) throw StateError('Cannot contact yourself');

    await c.from('connect_requests').insert({
      'from_user_id': uid,
      'to_user_id': toUserId,
      if (targetProfileId != null) 'target_profile_id': targetProfileId,
      if (targetNeedId != null) 'target_need_id': targetNeedId,
      'message': message.trim(),
      'status': 'pending',
    });
  }

  Future<List<Map<String, dynamic>>> myRequests() async {
    final c = client;
    final uid = c?.auth.currentUser?.id;
    if (c == null || uid == null) return [];
    final rows = await c
        .from('connect_request_details')
        .select()
        .or('from_user_id.eq.$uid,to_user_id.eq.$uid')
        .order('created_at', ascending: false)
        .limit(100);
    return (rows as List).cast<Map<String, dynamic>>();
  }

  Future<void> respondToRequest(String requestId, {required bool accept}) async {
    final c = client;
    final uid = c?.auth.currentUser?.id;
    if (c == null || uid == null) throw StateError('Sign in required');

    await c.from('connect_requests').update({
      'status': accept ? 'accepted' : 'declined',
      if (accept) 'revealed_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', requestId).eq('to_user_id', uid);
  }

  Future<void> logConnectEvent(String type, {Map<String, dynamic>? payload}) async {
    try {
      final c = client;
      final email = c?.auth.currentUser?.email ?? '';
      if (c == null) return;
      await c.from('clivora_events').insert({
        'event_type': type,
        'user_email': email,
        'user_name': '',
        'plan': 'pro_plus',
        'amount': 0,
        'payload': payload ?? {},
        'source': 'connect',
      });
    } catch (e) {
      debugPrint('Connect event log: $e');
    }
  }
}
