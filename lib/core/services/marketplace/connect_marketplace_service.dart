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
import '../sync_outbox_service.dart';
import 'connect_credits.dart';

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

  /// Legacy alias, prefer [hasConnectAccess].
  bool get hasProPlus => hasConnectAccess;

  Future<List<Map<String, dynamic>>> browseFreelancers({
    String? skill,
    String sort = 'featured',
  }) async {
    return _browseProfiles(accountType: 'freelancer', skill: skill, sort: sort);
  }

  /// Client Pro Plus about/listings so freelancers can discover & connect.
  Future<List<Map<String, dynamic>>> browseClients({
    String? skill,
    String sort = 'featured',
  }) async {
    return _browseProfiles(accountType: 'client', skill: skill, sort: sort);
  }

  Future<ConnectCreditSummary?> creditSummary() async {
    final c = client;
    if (c == null || c.auth.currentUser == null) return null;
    try {
      final rows = await c.rpc('connect_credit_summary');
      final list = (rows as List?) ?? const [];
      if (list.isEmpty) return null;
      return ConnectCreditSummary.fromRow(Map<String, dynamic>.from(list.first as Map));
    } catch (e) {
      // Fall back to account row when eligibility blocks summary RPC.
      try {
        final row = await c
            .from('connect_credit_accounts')
            .select()
            .eq('user_id', c.auth.currentUser!.id)
            .maybeSingle();
        if (row == null) return null;
        return ConnectCreditSummary.fromRow(Map<String, dynamic>.from(row));
      } catch (_) {
        throw mapConnectRpcError(e);
      }
    }
  }

  Future<void> acceptProposal({
    required String proposalId,
    required String clientUserId,
    required String freelancerUserId,
    String? requestId,
    double amount = 0,
  }) async {
    final c = client;
    final uid = c?.auth.currentUser?.id;
    if (c == null || uid == null) throw StateError('Sign in required');
    try {
      await c.rpc('connect_accept_proposal', params: {'p_proposal_id': proposalId});
    } catch (e) {
      throw mapConnectRpcError(e);
    }
    if (requestId == null || requestId.isEmpty) {
      return;
    }
    // Kickoff milestone remains a free follow-up after accepting an engagement request.
    await c.from('connect_milestones').insert({
      'engagement_request_id': requestId,
      'client_user_id': clientUserId,
      'freelancer_user_id': freelancerUserId,
      'title': 'Kickoff milestone',
      'amount': amount,
      'currency': 'USD',
      'status': 'pending',
    });
  }

  Future<List<Map<String, dynamic>>> _browseProfiles({
    required String accountType,
    String? skill,
    String sort = 'featured',
  }) async {
    final c = client;
    if (c == null) return [];
    final base = c
        .from('connect_profiles')
        .select(
          'id,user_id,display_title,headline,bio,skills,rate_band,availability,location_label,is_verified,account_type,created_at,avg_rating,review_count,completion_rate,reputation_score,profile_completeness',
        )
        .eq('account_type', accountType)
        .eq('is_listed', true)
        .eq('moderation_status', 'approved');
    final ordered = sort == 'newest'
        ? base.order('created_at', ascending: false)
        : sort == 'rating'
            ? base.order('avg_rating', ascending: false)
            : base.order('reputation_score', ascending: false);
    final rows = await ordered.limit(50);
    final list = (rows as List).cast<Map<String, dynamic>>();
    final enriched = await _attachAvatarUrls(list);
    if (skill == null || skill.trim().isEmpty) return enriched;
    final needle = skill.trim().toLowerCase();
    return enriched.where((r) {
      final skills = (r['skills'] as List?)?.map((e) => e.toString().toLowerCase()) ?? [];
      final title = (r['display_title'] as String? ?? '').toLowerCase();
      final headline = (r['headline'] as String? ?? '').toLowerCase();
      return skills.any((s) => s.contains(needle)) ||
          title.contains(needle) ||
          headline.contains(needle);
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _attachAvatarUrls(List<Map<String, dynamic>> rows) async {
    final c = client;
    if (c == null || rows.isEmpty) return rows;
    final ids = rows
        .map((r) => r['user_id']?.toString())
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();
    if (ids.isEmpty) return rows;
    try {
      final avatars = await c.from('profiles').select('id, avatar_url').inFilter('id', ids);
      final map = <String, String?>{};
      for (final row in (avatars as List)) {
        final m = Map<String, dynamic>.from(row as Map);
        map[m['id'].toString()] = m['avatar_url'] as String?;
      }
      return rows
          .map((r) => {
                ...r,
                'avatar_url': map[r['user_id']?.toString()] ?? r['avatar_url'],
              })
          .toList();
    } catch (_) {
      return rows;
    }
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
    final existing = await myListing();
    final wasListed = existing?['is_listed'] == true;
    final wantFirstPublish =
        isListed && !wasListed && accountType == 'freelancer';

    // Upsert content first. For first freelancer publish, keep unlisted until
    // connect_publish_profile succeeds (avoids PROFILE_INCOMPLETE / spend-before-row).
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
      'is_listed': wantFirstPublish ? false : isListed,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id');

    if (wantFirstPublish) {
      try {
        await c.rpc('connect_publish_profile', params: {
          'p_headline': headline.trim().isEmpty ? displayTitle.trim() : headline.trim(),
          'p_bio': bio.trim(),
          'p_skills': skills,
          'p_rate': double.tryParse(rateBand.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0,
        });
      } catch (e) {
        throw mapConnectRpcError(e);
      }
    }
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
    try {
      await c.rpc('connect_publish_need', params: {
        'p_title': title.trim(),
        'p_summary': summary.trim(),
        'p_skills': skills,
        'p_budget_band': budgetBand,
      });
    } catch (e) {
      throw mapConnectRpcError(e);
    }
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
    try {
      await c.rpc('connect_send_request', params: {
        'p_to_user_id': toUserId,
        'p_target_profile_id': targetProfileId,
        'p_target_need_id': targetNeedId,
        'p_message': message.trim(),
      });
    } catch (e) {
      throw mapConnectRpcError(e);
    }
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

    try {
      await c.rpc('connect_respond_request', params: {
        'p_request_id': requestId,
        'p_accept': accept,
      });
    } catch (e) {
      throw mapConnectRpcError(e);
    }

    if (accept) {
      await logConnectEvent('connect_request_accepted', payload: {'request_id': requestId});
    }
  }

  Future<void> leaveReview({
    required String toUserId,
    required int rating,
    String body = '',
    String? requestId,
  }) async {
    final c = client;
    final uid = c?.auth.currentUser?.id;
    if (c == null || uid == null) throw StateError('Sign in required');
    if (rating < 1 || rating > 5) throw StateError('Rating must be 1–5');
    if (requestId == null || requestId.isEmpty) {
      throw StateError('A released milestone engagement is required to leave a review');
    }
    try {
      await c.rpc('connect_submit_review', params: {
        'p_to_user_id': toUserId,
        'p_request_id': requestId,
        'p_rating': rating,
        'p_body': body.trim(),
      });
    } catch (e) {
      throw mapConnectRpcError(e);
    }
  }

  Future<void> submitProposal({
    required String toUserId,
    required double amount,
    required String message,
    String? needId,
    String? requestId,
    int? timelineDays,
    String currency = 'USD',
  }) async {
    final c = client;
    final uid = c?.auth.currentUser?.id;
    if (c == null || uid == null) throw StateError('Sign in required');
    if (!hasConnectAccess) throw StateError('CLIVORA Connect requires Pro Plus');
    try {
      await c.rpc('connect_submit_proposal', params: {
        'p_to_user_id': toUserId,
        'p_need_id': needId,
        'p_amount': amount,
        'p_currency': currency,
        'p_timeline_days': timelineDays,
        'p_message': message.trim(),
      });
    } catch (e) {
      throw mapConnectRpcError(e);
    }
  }

  Future<List<Map<String, dynamic>>> milestonesForRequest(String requestId) async {
    final c = client;
    if (c == null) return [];
    final rows = await c
        .from('connect_milestones')
        .select()
        .eq('engagement_request_id', requestId)
        .order('created_at');
    return (rows as List).cast<Map<String, dynamic>>();
  }

  Future<void> addMilestone({
    required String requestId,
    required String clientUserId,
    required String freelancerUserId,
    required String title,
    required double amount,
    String currency = 'USD',
  }) async {
    final c = client;
    final uid = c?.auth.currentUser?.id;
    if (c == null || uid == null) throw StateError('Sign in required');
    await c.from('connect_milestones').insert({
      'engagement_request_id': requestId,
      'client_user_id': clientUserId,
      'freelancer_user_id': freelancerUserId,
      'title': title.trim(),
      'amount': amount,
      'currency': currency,
      'status': 'pending',
    });
  }

  Future<void> updateMilestoneStatus(String milestoneId, String status) async {
    final c = client;
    if (c == null) throw StateError('Offline');
    try {
      await c.rpc('connect_transition_milestone', params: {
        'p_milestone_id': milestoneId,
        'p_status': status,
      });
    } catch (e) {
      throw mapConnectRpcError(e);
    }
  }

  Future<Map<String, dynamic>> homeSummary({required bool client}) async {
    final c = this.client;
    if (c == null || c.auth.currentUser == null) return {};
    try {
      final data = await c.rpc(client ? 'client_home_summary' : 'freelancer_home_summary');
      if (data is Map) return Map<String, dynamic>.from(data);
      return {};
    } catch (e) {
      throw mapConnectRpcError(e);
    }
  }

  Future<String> createMeetingRoom({String title = 'CLIVORA Meeting', String? projectId}) async {
    final c = client;
    final uid = c?.auth.currentUser?.id;
    if (c == null || uid == null) throw StateError('Sign in required');
    final slug = 'clivora-${DateTime.now().millisecondsSinceEpoch}';
    final url = 'https://meet.jit.si/$slug';
    await c.from('meeting_links').insert({
      'owner_uid': uid,
      'project_id': projectId,
      'title': title,
      'room_url': url,
      'scheduled_at': DateTime.now().toIso8601String(),
    });
    return url;
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
    try {
      await ref.read(syncOutboxServiceProvider).enqueue(
            SyncOutboxItem(kind: 'crm_customer', payload: {'localId': id}),
          );
    } catch (e) {
      debugPrint('Connect partner CRM enqueue failed: $e');
    }
    try {
      await ref.read(syncOutboxServiceProvider).enqueue(
            SyncOutboxItem(kind: 'crm_customer', payload: {'localId': id}),
          );
    } catch (e) {
      debugPrint('Connect partner CRM enqueue failed: $e');
    }
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
