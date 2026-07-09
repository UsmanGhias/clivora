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

/// CLIVORA Connect — freelancer Pro Plus / client Pro marketplace.
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
  List<Map<String, dynamic>> _profiles = [];
  List<Map<String, dynamic>> _needs = [];
  List<Map<String, dynamic>> _requests = [];
  String _inboxFilter = 'all'; // all | pending | accepted | declined

  bool _hasConnectAccess(WidgetRef ref) {
    final user = ref.read(authStateProvider).valueOrNull;
    if (isClientUser(user)) return ref.read(isProProvider);
    return ref.read(isProPlusProvider);
  }

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
    if (!_hasConnectAccess(ref)) {
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
      final user = ref.read(authStateProvider).valueOrNull;
      final isClient = isClientUser(user);
      // Clients browse freelancers; freelancers browse client about-listings.
      final profiles = isClient
          ? await svc.browseFreelancers(skill: _skillCtrl.text)
          : await svc.browseClients(skill: _skillCtrl.text);
      final needs = await svc.browseNeeds();
      final requests = await svc.myRequests();
      if (!mounted) return;
      setState(() {
        _profiles = profiles;
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
    final hasAccess = _hasConnectAccess(ref);
    final user = ref.watch(authStateProvider).valueOrNull;
    final isClient = isClientUser(user);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClivoraScaffold(
      title: 'CLIVORA Connect',
      showBackButton: false,
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: isClient ? 'My about / listing' : 'My listing',
            onPressed: () => context.push('/connect/listing'),
            icon: const Icon(Icons.badge_outlined),
          ),
          const SizedBox(width: 4),
          if (isClient)
            IconButton(
              tooltip: 'Post a job',
              onPressed: () => context.push('/connect/need'),
              icon: const Icon(Icons.work_outline),
            ),
          if (isClient) const SizedBox(width: 4),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading ? null : _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: !hasAccess
          ? _ConnectGate(isClient: isClient)
          : Column(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 520),
                  curve: Curves.easeOutCubic,
                  builder: (context, t, child) => Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, 12 * (1 - t)),
                      child: child,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ClivoraColors.navyDark,
                          ClivoraColors.navyDark.withValues(alpha: 0.92),
                          const Color(0xFF0F766E).withValues(alpha: 0.85),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CLIVORA Connect',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                                letterSpacing: 0.6,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Skills first. Identity later.',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Browse anonymously. Contact requests stay private until both sides accept. Then emails unlock and you work inside CLIVORA.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                                height: 1.4,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                TabBar(
                  controller: _tabs,
                  labelColor: scheme.primary,
                  unselectedLabelColor: scheme.onSurface.withValues(alpha: 0.55),
                  tabs: [
                    Tab(text: isClient ? 'Talent' : 'Clients'),
                    Tab(text: isClient ? 'My jobs' : 'Open jobs'),
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
                              freelancers: _profiles,
                              skillCtrl: _skillCtrl,
                              onSearch: _reload,
                              onContact: (row) => _contactProfile(row),
                              isDark: isDark,
                              browseClients: !isClient,
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

class _ConnectGate extends StatelessWidget {
  const _ConnectGate({required this.isClient});

  final bool isClient;

  @override
  Widget build(BuildContext context) {
    final title = isClient ? 'CLIVORA Connect is Client Pro' : 'CLIVORA Connect is Pro Plus';
    final body = isClient
        ? 'Publish your about, post jobs, and connect with freelancers — identity unlocks only after mutual accept. ${ProPricing.monthlyLabel}/mo.'
        : 'A private marketplace built for trust: skills and briefs first, identity only after mutual accept. ${ProPricing.plusMonthlyLabel}/mo.';
    final cta = isClient
        ? 'Upgrade to Client Pro · ${ProPricing.monthlyLabel}'
        : 'Upgrade to Pro Plus · ${ProPricing.plusMonthlyLabel}';
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Icon(Icons.hub_outlined, size: 64, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.45,
              ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => context.push('/upgrade'),
          child: Text(cta),
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
    this.browseClients = false,
  });

  final List<Map<String, dynamic>> freelancers;
  final TextEditingController skillCtrl;
  final VoidCallback onSearch;
  final void Function(Map<String, dynamic>) onContact;
  final bool isDark;
  final bool browseClients;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: skillCtrl,
          decoration: InputDecoration(
            hintText: browseClients
                ? 'Filter clients (e.g. SaaS, e‑commerce)'
                : 'Filter by skill (e.g. Flutter, SEO)',
            suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: onSearch),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onSubmitted: (_) => onSearch(),
        ),
        const SizedBox(height: 12),
        if (freelancers.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              children: [
                Icon(Icons.person_search_outlined, size: 48, color: onSurface.withValues(alpha: 0.35)),
                const SizedBox(height: 12),
                Text(
                  browseClients
                      ? 'No client about listings yet. Clients with Pro can publish theirs from My listing.'
                      : 'No listed freelancers yet. Be the first from My listing.',
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
          return TweenAnimationBuilder<double>(
            key: ValueKey(row['id'] ?? index),
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 320 + (index.clamp(0, 6) * 40)),
            curve: Curves.easeOutCubic,
            builder: (context, t, child) => Opacity(
              opacity: t,
              child: Transform.translate(offset: Offset(0, 10 * (1 - t)), child: child),
            ),
            child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? ClivoraColors.navyDark.withValues(alpha: 0.55) : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? ClivoraColors.darkBorder : ClivoraColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: ClivoraColors.primary.withValues(alpha: 0.15),
                      child: Text(
                        (row['display_title'] as String? ?? (browseClients ? 'C' : 'F')).isNotEmpty
                            ? (row['display_title'] as String).characters.first.toUpperCase()
                            : (browseClients ? 'C' : 'F'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  row['display_title'] as String? ??
                                      (browseClients ? 'Client' : 'Freelancer'),
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              if (row['is_verified'] == true) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.verified, color: Color(0xFF0F766E), size: 18),
                              ],
                            ],
                          ),
                          Text(
                            row['headline'] as String? ?? '',
                            style: TextStyle(color: onSurface.withValues(alpha: 0.65), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  row['bio'] as String? ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: onSurface.withValues(alpha: 0.8), height: 1.35),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      label: Text(row['rate_band'] as String? ?? 'negotiable'),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: ClivoraColors.iconTeal,
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    ...skills.take(4).map(
                          (s) => Chip(
                            label: Text(s),
                            visualDensity: VisualDensity.compact,
                            side: BorderSide(
                              color: isDark ? ClivoraColors.darkBorder : ClivoraColors.borderLight,
                            ),
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                        ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => onContact(row),
                    icon: const Icon(Icons.handshake_outlined),
                    label: Text(browseClients ? 'Connect' : 'Request contact'),
                  ),
                ),
              ],
            ),
            ),
          );
        }),
      ],
    );
  }
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (isClient)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OutlinedButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Post a need (anonymous)'),
            ),
          ),
        if (needs.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              isClient ? 'No open needs yet. Post your first brief.' : 'No open needs yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: onSurface.withValues(alpha: 0.6)),
            ),
          ),
        ...needs.map((row) {
          final skills = (row['skills'] as List?)?.map((e) => e.toString()).toList() ?? [];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
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
                  row['title'] as String? ?? 'Need',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 6),
                Text(row['summary'] as String? ?? '', style: TextStyle(height: 1.35, color: onSurface.withValues(alpha: 0.8))),
                const SizedBox(height: 8),
                Text(
                  'Budget: ${row['budget_band'] ?? 'negotiable'} · ${skills.take(3).join(', ')}',
                  style: TextStyle(fontSize: 12, color: onSurface.withValues(alpha: 0.6)),
                ),
                if (!isClient)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => onContact(row),
                      icon: const Icon(Icons.send_outlined),
                      label: const Text('Pitch anonymously'),
                    ),
                  ),
              ],
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
