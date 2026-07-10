import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart' show Value;

import '../../auth/auth_service.dart';
import '../../auth/user_roles.dart';
import '../../constants/plan_features.dart';
import '../../../data/database/database.dart';
import '../../../data/database/user_scoped_queries.dart';
import '../../../data/models/invoice_line_item.dart';
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

  bool get hasConnectAccess {
    return ref.read(isProPlusProvider) ||
        PlanFeatures.isProPlus(ref.read(subscriptionPlanProvider).valueOrNull);
  }

  /// Legacy alias — prefer [hasConnectAccess].
  bool get hasProPlus => hasConnectAccess;

  Future<List<Map<String, dynamic>>> browseFreelancers({String? skill}) async {
    return _browseProfiles(accountType: 'freelancer', skill: skill);
  }

  /// Client Pro Plus about/listings so freelancers can discover & connect.
  Future<List<Map<String, dynamic>>> browseClients({String? skill}) async {
    return _browseProfiles(accountType: 'client', skill: skill);
  }

  Future<List<Map<String, dynamic>>> _browseProfiles({
    required String accountType,
    String? skill,
  }) async {
    final c = client;
    if (c == null) return [];
    final rows = await c
        .from('connect_profiles')
        .select(
          'id,user_id,display_title,headline,bio,skills,rate_band,availability,location_label,is_verified,account_type',
        )
        .eq('account_type', accountType)
        .eq('is_listed', true)
        .eq('moderation_status', 'approved')
        .order('updated_at', ascending: false)
        .limit(50);
    final list = (rows as List).cast<Map<String, dynamic>>();
    if (skill == null || skill.trim().isEmpty) return list;
    final needle = skill.trim().toLowerCase();
    return list.where((r) {
      final skills = (r['skills'] as List?)?.map((e) => e.toString().toLowerCase()) ?? [];
      final title = (r['display_title'] as String? ?? '').toLowerCase();
      final headline = (r['headline'] as String? ?? '').toLowerCase();
      return skills.any((s) => s.contains(needle)) ||
          title.contains(needle) ||
          headline.contains(needle);
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
    if (!hasConnectAccess) {
      throw StateError('CLIVORA Connect requires Pro Plus');
    }

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
    if (!hasConnectAccess) {
      throw StateError('CLIVORA Connect requires Pro Plus');
    }

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
    if (!hasConnectAccess) {
      throw StateError('CLIVORA Connect requires Pro Plus');
    }
    if (toUserId == uid) throw StateError('Cannot contact yourself');

    final payload = <String, dynamic>{
      'from_user_id': uid,
      'to_user_id': toUserId,
      'message': message.trim(),
      'status': 'pending',
    };
    if (targetProfileId != null) {
      payload['target_profile_id'] = targetProfileId;
    }
    if (targetNeedId != null) {
      payload['target_need_id'] = targetNeedId;
    }

    await c.from('connect_requests').insert(payload);
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

    if (accept) {
      await logConnectEvent('connect_request_accepted', payload: {'request_id': requestId});
    }
  }

  /// After mutual accept: create a local CRM customer from revealed partner identity.
  Future<int?> linkAcceptedPartnerToWorkspace(Map<String, dynamic> request) async {
    final myUid = currentUserId;
    if (myUid == null) return null;
    final incoming = request['to_user_id'] == myUid;
    final name = (incoming ? request['from_name'] : request['to_name']) as String? ?? 'Connect partner';
    final email = (incoming ? request['from_email'] : request['to_email']) as String? ?? '';
    if (email.trim().isEmpty) return null;

    final ownerId = ref.read(authStateProvider).valueOrNull?.id;
    if (ownerId == null) return null;

    final db = ref.read(databaseProvider);
    final existing = await db.watchCustomersForUser(ownerId).first;
    final needle = email.trim().toLowerCase();
    final match = existing.where((c) {
      return parseStringList(c.emails).any((e) => e.trim().toLowerCase() == needle);
    }).toList();
    if (match.isNotEmpty) return match.first.id;

    final id = await db.insertCustomer(
      CustomersCompanion.insert(
        ownerUserId: ownerId,
        contactPerson: name.trim().isEmpty ? email.split('@').first : name.trim(),
        emails: Value(encodeStringList([email.trim()])),
        notes: const Value('Added from CLIVORA Connect after mutual accept.'),
      ),
    );
    await logConnectEvent('connect_workspace_linked', payload: {
      'customer_email': email,
      'customer_id': id,
    });
    ref.invalidate(customersProvider);
    ref.invalidate(dashboardStatsProvider);
    return id;
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
