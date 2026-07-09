import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/user_roles.dart';
import '../../core/constants/pro_pricing.dart';
import '../../core/services/marketplace/connect_marketplace_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';

/// CLIVORA Connect — Pro Plus marketplace. Anonymous until mutual accept.
class ConnectMarketplaceScreen extends ConsumerStatefulWidget {
  const ConnectMarketplaceScreen({super.key});

  @override
  ConsumerState<ConnectMarketplaceScreen> createState() => _ConnectMarketplaceScreenState();
}

class _ConnectMarketplaceScreenState extends ConsumerState<ConnectMarketplaceScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _skillCtrl = TextEditingController();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _freelancers = [];
  List<Map<String, dynamic>> _needs = [];
  List<Map<String, dynamic>> _requests = [];
  String _inboxFilter = 'all'; // all | pending | accepted | declined

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  @override
  void dispose() {
    _tabs.dispose();
    _skillCtrl.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final isPlus = ref.read(isProPlusProvider);
    if (!isPlus) {
      setState(() {
        _loading = false;
        _error = null;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final svc = ref.read(connectMarketplaceServiceProvider);
      final freelancers = await svc.browseFreelancers(skill: _skillCtrl.text);
      final needs = await svc.browseNeeds();
      final requests = await svc.myRequests();
      if (!mounted) return;
      setState(() {
        _freelancers = freelancers;
        _needs = needs;
        _requests = requests;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPlus = ref.watch(isProPlusProvider);
    final user = ref.watch(authStateProvider).valueOrNull;
    final isClient = isClientUser(user);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClivoraScaffold(
      title: 'Connect',
      showBackButton: false,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: isClient ? 'Post a need' : 'My listing',
            onPressed: () => context.push(isClient ? '/connect/need' : '/connect/listing'),
            icon: Icon(isClient ? Icons.add_circle_outline : Icons.badge_outlined),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading ? null : _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: !isPlus
          ? const _ProPlusGate()
          : Column(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutCubic,
                  builder: (context, t, child) => Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, 8 * (1 - t)),
                      child: child,
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          ClivoraColors.navyDark,
                          const Color(0xFF0F766E).withValues(alpha: 0.88),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Skills first · identity later',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Anonymous browse · private contact · emails unlock on accept',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 11,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.hub_outlined, color: Colors.white.withValues(alpha: 0.85), size: 22),
                      ],
                    ),
                  ),
                ),
                TabBar(
                  controller: _tabs,
                  labelColor: scheme.primary,
                  unselectedLabelColor: scheme.onSurface.withValues(alpha: 0.55),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  tabs: [
                    Tab(text: isClient ? 'Talent' : 'Browse'),
                    Tab(text: isClient ? 'My needs' : 'Open needs'),
                    Tab(text: 'Inbox (${_requests.length})'),
                  ],
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(_error!, style: TextStyle(color: scheme.error)),
                  ),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: _reload,
                          child: TabBarView(
                          controller: _tabs,
                          children: [
                            _TalentTab(
                              freelancers: _freelancers,
                              skillCtrl: _skillCtrl,
                              onSearch: _reload,
                              onContact: (row) => _contactProfile(row),
                              isDark: isDark,
                            ),
                            _NeedsTab(
                              needs: _needs,
                              isClient: isClient,
                              onCreate: () => context.push('/connect/need'),
                              onContact: (row) => _contactNeed(row),
                              isDark: isDark,
                            ),
                            _InboxTab(
                              requests: _requests,
                              myUid: ref.read(connectMarketplaceServiceProvider).currentUserId,
                              filter: _inboxFilter,
                              onFilterChanged: (f) => setState(() => _inboxFilter = f),
                              onAccept: (id) async {
                                await ref
                                    .read(connectMarketplaceServiceProvider)
                                    .respondToRequest(id, accept: true);
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Accepted. Identity unlocked — add them to your workspace.'),
                                  ),
                                );
                                await _reload();
                              },
                              onDecline: (id) async {
                                await ref
                                    .read(connectMarketplaceServiceProvider)
                                    .respondToRequest(id, accept: false);
                                await _reload();
                              },
                              onLinkWorkspace: (row) async {
                                try {
                                  final id = await ref
                                      .read(connectMarketplaceServiceProvider)
                                      .linkAcceptedPartnerToWorkspace(row);
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        id == null
                                            ? 'Could not link partner (missing email).'
                                            : 'Added to Clients. Open workspace to start work.',
                                      ),
                                    ),
                                  );
                                  if (id != null && mounted) context.push('/customers');
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                ),
              ],
            ),
    );
  }

  Future<void> _contactProfile(Map<String, dynamic> row) async {
    final message = await _askMessage('Introduce yourself without sharing personal details yet.');
    if (message == null || message.isEmpty) return;
    try {
      await ref.read(connectMarketplaceServiceProvider).sendContactRequest(
            toUserId: row['user_id'] as String,
            targetProfileId: row['id'] as String?,
            message: message,
          );
      await ref.read(connectMarketplaceServiceProvider).logConnectEvent('connect_request_sent');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request sent. Email stays hidden until they accept.')),
        );
        await _reload();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<void> _contactNeed(Map<String, dynamic> row) async {
    final message = await _askMessage('Pitch your fit for this need. Stay anonymous for now.');
    if (message == null || message.isEmpty) return;
    try {
      await ref.read(connectMarketplaceServiceProvider).sendContactRequest(
            toUserId: row['client_user_id'] as String,
            targetNeedId: row['id'] as String?,
            message: message,
          );
      await ref.read(connectMarketplaceServiceProvider).logConnectEvent('connect_need_pitch_sent');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pitch sent anonymously.')),
        );
        await _reload();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<String?> _askMessage(String hint) async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Send Connect request'),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          decoration: InputDecoration(hintText: hint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, ctrl.text.trim()), child: const Text('Send')),
        ],
      ),
    );
  }
}

class _ProPlusGate extends StatelessWidget {
  const _ProPlusGate();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Icon(Icons.hub_outlined, size: 64, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          'CLIVORA Connect is Pro Plus',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'A private marketplace built for trust: skills and briefs first, identity only after mutual accept. ${ProPricing.plusMonthlyLabel}/mo.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.45,
              ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => context.push('/upgrade'),
          child: Text('Upgrade to Pro Plus · ${ProPricing.plusMonthlyLabel}'),
        ),
      ],
    );
  }
}

class _TalentTab extends StatelessWidget {
  const _TalentTab({
    required this.freelancers,
    required this.skillCtrl,
    required this.onSearch,
    required this.onContact,
    required this.isDark,
  });

  final List<Map<String, dynamic>> freelancers;
  final TextEditingController skillCtrl;
  final VoidCallback onSearch;
  final void Function(Map<String, dynamic>) onContact;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
      children: [
        TextField(
          controller: skillCtrl,
          decoration: InputDecoration(
            hintText: 'Filter by skill',
            isDense: true,
            filled: false,
            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            suffixIcon: IconButton(icon: const Icon(Icons.search, size: 20), onPressed: onSearch),
            border: const UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: onSurface.withValues(alpha: 0.18)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: scheme.primary, width: 1.5),
            ),
          ),
          onSubmitted: (_) => onSearch(),
        ),
        const SizedBox(height: 8),
        if (freelancers.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 36),
            child: Column(
              children: [
                Icon(Icons.person_search_outlined, size: 40, color: onSurface.withValues(alpha: 0.35)),
                const SizedBox(height: 10),
                Text(
                  'No listed freelancers yet. Be the first from My listing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: onSurface.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
        ...freelancers.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;
          final skills = (row['skills'] as List?)?.map((e) => e.toString()).toList() ?? [];
          final title = row['display_title'] as String? ?? 'Freelancer';
          final rate = _usdBand(row['rate_band'] as String?);
          return TweenAnimationBuilder<double>(
            key: ValueKey(row['id'] ?? index),
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 260 + (index.clamp(0, 8) * 28)),
            curve: Curves.easeOutCubic,
            builder: (context, t, child) => Opacity(
              opacity: t,
              child: Transform.translate(offset: Offset(0, 6 * (1 - t)), child: child),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onContact(row),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? ClivoraColors.darkBorder : ClivoraColors.borderLight,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.isNotEmpty ? title.characters.first.toUpperCase() : 'F',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                  ),
                                ),
                                if (row['is_verified'] == true)
                                  const Icon(Icons.verified, color: Color(0xFF0F766E), size: 15),
                              ],
                            ),
                            if ((row['headline'] as String?)?.isNotEmpty == true)
                              Text(
                                row['headline'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: onSurface.withValues(alpha: 0.62), fontSize: 12),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              [
                                rate,
                                ...skills.take(3),
                              ].where((s) => s.trim().isNotEmpty).join(' · '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: scheme.primary.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.chevron_right, size: 18, color: onSurface.withValues(alpha: 0.35)),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

String _usdBand(String? raw) {
  if (raw == null || raw.trim().isEmpty) return 'negotiable';
  var s = raw.trim();
  s = s.replaceAll(RegExp(r'Rs\.?\s*', caseSensitive: false), r'$');
  s = s.replaceAll('₹', r'$');
  s = s.replaceAll(RegExp(r'\bINR\b', caseSensitive: false), 'USD');
  if (!s.contains(r'$') && !s.toLowerCase().contains('negotiable') && RegExp(r'\d').hasMatch(s)) {
    s = '\$$s';
  }
  return s;
}

class _NeedsTab extends StatelessWidget {
  const _NeedsTab({
    required this.needs,
    required this.isClient,
    required this.onCreate,
    required this.onContact,
    required this.isDark,
  });

  final List<Map<String, dynamic>> needs;
  final bool isClient;
  final VoidCallback onCreate;
  final void Function(Map<String, dynamic>) onContact;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
      children: [
        if (isClient)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Post a need'),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
        if (needs.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 36),
            child: Text(
              isClient ? 'No open needs yet. Post your first brief.' : 'No open needs yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: onSurface.withValues(alpha: 0.6)),
            ),
          ),
        ...needs.map((row) {
          final skills = (row['skills'] as List?)?.map((e) => e.toString()).toList() ?? [];
          final budget = _usdBand(row['budget_band'] as String?);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isClient ? null : () => onContact(row),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? ClivoraColors.darkBorder : ClivoraColors.borderLight,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.work_outline, size: 18, color: scheme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row['title'] as String? ?? 'Need',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          if ((row['summary'] as String?)?.isNotEmpty == true)
                            Text(
                              row['summary'] as String,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, height: 1.3, color: onSurface.withValues(alpha: 0.72)),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            [
                              budget,
                              ...skills.take(3),
                            ].where((s) => s.trim().isNotEmpty).join(' · '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: scheme.primary.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isClient)
                      TextButton(
                        onPressed: () => onContact(row),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: const Text('Pitch'),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _InboxTab extends StatelessWidget {
  const _InboxTab({
    required this.requests,
    required this.myUid,
    required this.filter,
    required this.onFilterChanged,
    required this.onAccept,
    required this.onDecline,
    required this.onLinkWorkspace,
  });

  final List<Map<String, dynamic>> requests;
  final String? myUid;
  final String filter;
  final ValueChanged<String> onFilterChanged;
  final Future<void> Function(String id) onAccept;
  final Future<void> Function(String id) onDecline;
  final Future<void> Function(Map<String, dynamic> row) onLinkWorkspace;

  @override
  Widget build(BuildContext context) {
    final filtered = filter == 'all'
        ? requests
        : requests.where((r) => (r['status'] as String? ?? 'pending') == filter).toList();
    if (requests.isEmpty) {
      return const Center(child: Text('No Connect requests yet.'));
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              for (final f in const ['all', 'pending', 'accepted', 'declined'])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f[0].toUpperCase() + f.substring(1)),
                    selected: filter == f,
                    onSelected: (_) => onFilterChanged(f),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('No requests in this filter.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final r = filtered[i];
                    final incoming = r['to_user_id'] == myUid;
                    final status = r['status'] as String? ?? 'pending';
                    final accepted = status == 'accepted';
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? ClivoraColors.darkBorder : ClivoraColors.borderLight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            incoming ? 'Incoming request' : 'Sent request',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(r['message'] as String? ?? ''),
                          const SizedBox(height: 8),
                          Text('Status: $status', style: Theme.of(context).textTheme.bodySmall),
                          if (accepted) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Identity unlocked\n'
                              '${incoming ? r['from_name'] : r['to_name'] ?? 'Partner'}\n'
                              '${incoming ? r['from_email'] : r['to_email'] ?? ''}',
                              style: const TextStyle(fontWeight: FontWeight.w600, height: 1.35),
                            ),
                            const SizedBox(height: 8),
                            FilledButton.tonalIcon(
                              onPressed: () => onLinkWorkspace(r),
                              icon: const Icon(Icons.person_add_alt_1_outlined),
                              label: const Text('Add to workspace'),
                            ),
                          ],
                          if (incoming && status == 'pending')
                            Row(
                              children: [
                                TextButton(onPressed: () => onDecline(r['id'] as String), child: const Text('Decline')),
                                FilledButton(
                                  onPressed: () => onAccept(r['id'] as String),
                                  child: const Text('Accept & reveal'),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
