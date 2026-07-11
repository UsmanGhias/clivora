import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/user_roles.dart';
import '../../core/constants/pro_pricing.dart';
import '../../core/services/marketplace/connect_marketplace_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';

const _savedPrefsKey = 'connect_saved_ids';
const _teal = Color(0xFF0F766E);

/// CLIVORA Connect — Pro Plus marketplace for freelancers and clients.
class ConnectMarketplaceScreen extends ConsumerStatefulWidget {
  const ConnectMarketplaceScreen({super.key});

  @override
  ConsumerState<ConnectMarketplaceScreen> createState() =>
      _ConnectMarketplaceScreenState();
}

class _ConnectMarketplaceScreenState
    extends ConsumerState<ConnectMarketplaceScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _skillCtrl = TextEditingController();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _profiles = [];
  List<Map<String, dynamic>> _needs = [];
  List<Map<String, dynamic>> _requests = [];
  Set<String> _savedIds = {};
  String _profileFilter = 'all'; // all | verified | available
  String _inboxFilter = 'all'; // all | pending | accepted | declined
  bool _showSavedOnly = false;

  bool _hasConnectAccess(WidgetRef ref) => ref.read(isProPlusProvider);

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedIds();
      _reload();
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    _skillCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSavedIds() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(
      () => _savedIds = (prefs.getStringList(_savedPrefsKey) ?? []).toSet(),
    );
  }

  Future<void> _persistSavedIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_savedPrefsKey, _savedIds.toList()..sort());
  }

  Future<void> _toggleSaved(Map<String, dynamic> row) async {
    final id = _connectRowId(row);
    if (id.isEmpty) return;
    setState(() {
      if (_savedIds.contains(id)) {
        _savedIds.remove(id);
      } else {
        _savedIds.add(id);
      }
    });
    await _persistSavedIds();
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

  void _showSaved() {
    _tabs.animateTo(0);
    setState(() => _showSavedOnly = true);
  }

  @override
  Widget build(BuildContext context) {
    final hasAccess = ref.watch(isProPlusProvider);
    final user = ref.watch(authStateProvider).valueOrNull;
    final isClient = isClientUser(user);
    final scheme = Theme.of(context).colorScheme;
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    return ClivoraScaffold(
      title: 'Connect',
      showBackButton: false,
      action: IconButton(
        tooltip: 'Refresh',
        onPressed: _loading ? null : _reload,
        icon: const Icon(Icons.refresh),
      ),
      body: !hasAccess
          ? const _ConnectGate()
          : Column(
              children: [
                const _SlimConnectBanner(),
                _QuickActionsRow(
                  isClient: isClient,
                  savedCount: _savedIds.length,
                  onListing: () => context.push('/connect/listing'),
                  onPostJob: () => context.push('/connect/need'),
                  onSaved: _showSaved,
                  onInbox: () => _tabs.animateTo(2),
                ),
                TabBar(
                  controller: _tabs,
                  labelColor: scheme.primary,
                  unselectedLabelColor: scheme.onSurface.withValues(
                    alpha: 0.55,
                  ),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  tabs: [
                    Tab(text: isClient ? 'Talent' : 'Clients'),
                    Tab(text: isClient ? 'Jobs' : 'Open jobs'),
                    Tab(text: 'Inbox (${_requests.length})'),
                  ],
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _error!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: scheme.error, fontSize: 12),
                    ),
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
                                profiles: _profiles,
                                skillCtrl: _skillCtrl,
                                filter: _profileFilter,
                                showSavedOnly: _showSavedOnly,
                                savedIds: _savedIds,
                                onFilterChanged: (filter) {
                                  setState(() {
                                    _profileFilter = filter;
                                    _showSavedOnly = false;
                                  });
                                },
                                onClearSavedFilter: () =>
                                    setState(() => _showSavedOnly = false),
                                onSearch: _reload,
                                onContact: _contactProfile,
                                onToggleSaved: _toggleSaved,
                                browseClients: !isClient,
                              ),
                              _NeedsTab(
                                needs: _needs,
                                isClient: isClient,
                                onCreate: () => context.push('/connect/need'),
                                onContact: _contactNeed,
                              ),
                              _InboxTab(
                                requests: _requests,
                                myUid: ref
                                    .read(connectMarketplaceServiceProvider)
                                    .currentUserId,
                                filter: _inboxFilter,
                                onFilterChanged: (f) =>
                                    setState(() => _inboxFilter = f),
                                onAccept: (id) async {
                                  await ref
                                      .read(connectMarketplaceServiceProvider)
                                      .respondToRequest(id, accept: true);
                                  if (!mounted) return;
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Accepted. Identity unlocked.',
                                      ),
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
                                onReview: (row) => _leaveConnectReview(row),
                                onLinkWorkspace: (row) async {
                                  try {
                                    final id = await ref
                                        .read(connectMarketplaceServiceProvider)
                                        .linkAcceptedPartnerToWorkspace(row);
                                    if (!mounted) return;
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          id == null
                                              ? 'Could not link partner.'
                                              : 'Added to Clients.',
                                        ),
                                      ),
                                    );
                                    if (id != null) {
                                      router.push('/customers');
                                    }
                                  } catch (e) {
                                    if (!mounted) return;
                                    messenger.showSnackBar(
                                      SnackBar(content: Text('$e')),
                                    );
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

  Future<void> _leaveConnectReview(Map<String, dynamic> row) async {
    final myUid = ref.read(connectMarketplaceServiceProvider).currentUserId;
    if (myUid == null) return;
    final peerId = row['to_user_id'] == myUid
        ? row['from_user_id'] as String?
        : row['to_user_id'] as String?;
    if (peerId == null) return;

    var rating = 5;
    final bodyCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return AlertDialog(
              title: const Text('Leave a Connect review'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 1; i <= 5; i++)
                        IconButton(
                          onPressed: () => setLocal(() => rating = i),
                          icon: Icon(
                            i <= rating ? Icons.star : Icons.star_border,
                            color: Colors.amber.shade700,
                          ),
                        ),
                    ],
                  ),
                  TextField(
                    controller: bodyCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Optional feedback',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(connectMarketplaceServiceProvider).leaveReview(
            toUserId: peerId,
            rating: rating,
            body: bodyCtrl.text,
            requestId: row['id'] as String?,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted. Thanks!')),
      );
      await _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      bodyCtrl.dispose();
    }
  }

  Future<void> _contactProfile(Map<String, dynamic> row) async {
    final message = await _askMessage(
      'Introduce yourself without sharing personal details yet.',
    );
    if (message == null || message.isEmpty) return;
    try {
      await ref
          .read(connectMarketplaceServiceProvider)
          .sendContactRequest(
            toUserId: row['user_id'] as String,
            targetProfileId: row['id'] as String?,
            message: message,
          );
      await ref
          .read(connectMarketplaceServiceProvider)
          .logConnectEvent('connect_request_sent');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request sent. Email stays hidden until accept.'),
          ),
        );
        await _reload();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<void> _contactNeed(Map<String, dynamic> row) async {
    final message = await _askMessage(
      'Pitch your fit for this need. Stay anonymous for now.',
    );
    if (message == null || message.isEmpty) return;
    try {
      await ref
          .read(connectMarketplaceServiceProvider)
          .sendContactRequest(
            toUserId: row['client_user_id'] as String,
            targetNeedId: row['id'] as String?,
            message: message,
          );
      await ref
          .read(connectMarketplaceServiceProvider)
          .logConnectEvent('connect_need_pitch_sent');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pitch sent anonymously.')),
        );
        await _reload();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
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
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

class _ConnectGate extends StatelessWidget {
  const _ConnectGate();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hub_outlined, size: 56, color: scheme.primary),
            const SizedBox(height: 14),
            Text(
              'What is CLIVORA Connect?',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'A private marketplace where freelancers list services and clients post needs. '
              'Browse listings, save matches, send requests, and message after both sides accept — '
              'without sharing contact details too early.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.7),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Connect is included with Pro Plus (${ProPricing.plusMonthlyLabel}/mo) and appears as a bottom tab.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.65),
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () => context.push('/upgrade'),
              icon: const Icon(Icons.lock_open_outlined),
              label: Text(
                'Upgrade to Pro Plus · ${ProPricing.plusMonthlyLabel}',
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.push('/upgrade'),
              child: const Text('Compare Pro & Pro Plus plans'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlimConnectBanner extends StatelessWidget {
  const _SlimConnectBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ClivoraColors.navyDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.hub_outlined, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Private marketplace: skills first, identity after mutual accept.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({
    required this.isClient,
    required this.savedCount,
    required this.onListing,
    required this.onPostJob,
    required this.onSaved,
    required this.onInbox,
  });

  final bool isClient;
  final int savedCount;
  final VoidCallback onListing;
  final VoidCallback onPostJob;
  final VoidCallback onSaved;
  final VoidCallback onInbox;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          _ActionTextButton(
            icon: Icons.badge_outlined,
            label: 'My listing',
            onPressed: onListing,
          ),
          if (isClient)
            _ActionTextButton(
              icon: Icons.add_business_outlined,
              label: 'Post job',
              onPressed: onPostJob,
            ),
          _ActionTextButton(
            icon: Icons.favorite_border,
            label: savedCount == 0 ? 'Saved' : 'Saved $savedCount',
            onPressed: onSaved,
          ),
          _ActionTextButton(
            icon: Icons.inbox_outlined,
            label: 'Inbox',
            onPressed: onInbox,
          ),
        ],
      ),
    );
  }
}

class _ActionTextButton extends StatelessWidget {
  const _ActionTextButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        ),
      ),
    );
  }
}

class _TalentTab extends StatelessWidget {
  const _TalentTab({
    required this.profiles,
    required this.skillCtrl,
    required this.filter,
    required this.showSavedOnly,
    required this.savedIds,
    required this.onFilterChanged,
    required this.onClearSavedFilter,
    required this.onSearch,
    required this.onContact,
    required this.onToggleSaved,
    this.browseClients = false,
  });

  final List<Map<String, dynamic>> profiles;
  final TextEditingController skillCtrl;
  final String filter;
  final bool showSavedOnly;
  final Set<String> savedIds;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onClearSavedFilter;
  final VoidCallback onSearch;
  final void Function(Map<String, dynamic>) onContact;
  final Future<void> Function(Map<String, dynamic>) onToggleSaved;
  final bool browseClients;

  @override
  Widget build(BuildContext context) {
    final filtered = profiles.where((row) {
      final id = _connectRowId(row);
      if (showSavedOnly && !savedIds.contains(id)) return false;
      if (filter == 'verified' && row['is_verified'] != true) return false;
      if (filter == 'available' &&
          (row['availability'] as String? ?? '').toLowerCase() != 'available') {
        return false;
      }
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 88),
      children: [
        _TalentControls(
          skillCtrl: skillCtrl,
          filter: filter,
          showSavedOnly: showSavedOnly,
          browseClients: browseClients,
          onFilterChanged: onFilterChanged,
          onClearSavedFilter: onClearSavedFilter,
          onSearch: onSearch,
        ),
        if (filtered.isEmpty)
          _CompactEmpty(
            icon: Icons.person_search_outlined,
            text: showSavedOnly
                ? 'No saved listings yet.'
                : browseClients
                ? 'No client listings yet.'
                : 'No freelancers yet.',
          )
        else
          ..._withDividers(
            context,
            filtered.map(
              (row) => _ProfileFeedRow(
                row: row,
                browseClients: browseClients,
                saved: savedIds.contains(_connectRowId(row)),
                onTap: () => onContact(row),
                onToggleSaved: () => onToggleSaved(row),
              ),
            ),
          ),
      ],
    );
  }
}

class _TalentControls extends StatelessWidget {
  const _TalentControls({
    required this.skillCtrl,
    required this.filter,
    required this.showSavedOnly,
    required this.browseClients,
    required this.onFilterChanged,
    required this.onClearSavedFilter,
    required this.onSearch,
  });

  final TextEditingController skillCtrl;
  final String filter;
  final bool showSavedOnly;
  final bool browseClients;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onClearSavedFilter;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        children: [
          SizedBox(
            height: 42,
            child: TextField(
              controller: skillCtrl,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isDense: true,
                hintText: browseClients ? 'Filter clients' : 'Filter by skill',
                prefixIcon: const Icon(Icons.search, size: 18),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  onPressed: onSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => onSearch(),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final entry in const [
                        ('all', 'All'),
                        ('verified', 'Verified'),
                        ('available', 'Available'),
                      ])
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(entry.$2),
                            selected: filter == entry.$1 && !showSavedOnly,
                            onSelected: (_) => onFilterChanged(entry.$1),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      if (showSavedOnly)
                        InputChip(
                          label: const Text('Saved'),
                          selected: true,
                          onDeleted: onClearSavedFilter,
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.sort, size: 15, color: scheme.onSurfaceVariant),
              const SizedBox(width: 3),
              Text(
                'Top rated',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileFeedRow extends StatelessWidget {
  const _ProfileFeedRow({
    required this.row,
    required this.browseClients,
    required this.saved,
    required this.onTap,
    required this.onToggleSaved,
  });

  final Map<String, dynamic> row;
  final bool browseClients;
  final bool saved;
  final VoidCallback onTap;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final title =
        row['display_title'] as String? ??
        (browseClients ? 'Client' : 'Freelancer');
    final headline = row['headline'] as String? ?? '';
    final skills = _stringList(row['skills']);
    final meta = [
      row['rate_band'] as String? ?? 'Negotiable',
      ...skills.take(2),
    ].where((value) => value.trim().isNotEmpty).join(' · ');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _InitialDot(text: title, fallback: browseClients ? 'C' : 'F'),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (row['is_verified'] == true) ...[
                          const SizedBox(width: 5),
                          const Icon(Icons.verified, color: _teal, size: 15),
                        ],
                      ],
                    ),
                    if (headline.isNotEmpty)
                      Text(
                        headline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: onSurface.withValues(alpha: 0.68),
                          fontSize: 12.5,
                        ),
                      ),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _teal,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      () {
                        final count =
                            (row['review_count'] as num?)?.toInt() ?? 0;
                        final avg =
                            (row['avg_rating'] as num?)?.toDouble() ?? 0;
                        final since = row['created_at'] as String?;
                        final parts = <String>[];
                        if (count > 0 && avg > 0) {
                          parts.add('★ ${avg.toStringAsFixed(1)} ($count)');
                        } else {
                          parts.add('New');
                        }
                        if (since != null && since.length >= 7) {
                          parts.add('Since ${since.substring(0, 7)}');
                        }
                        final completion =
                            (row['completion_rate'] as num?)?.toDouble() ?? 0;
                        if (completion > 0) {
                          parts.add('${completion.toStringAsFixed(0)}% done');
                        }
                        return parts.join(' · ');
                      }(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: onSurface.withValues(alpha: 0.55),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: saved ? 'Unsave' : 'Save',
                onPressed: onToggleSaved,
                icon: Icon(
                  saved ? Icons.favorite : Icons.favorite_border,
                  color: saved ? _teal : onSurface.withValues(alpha: 0.45),
                  size: 20,
                ),
                visualDensity: VisualDensity.compact,
              ),
              Icon(
                Icons.chevron_right,
                color: onSurface.withValues(alpha: 0.35),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NeedsTab extends StatelessWidget {
  const _NeedsTab({
    required this.needs,
    required this.isClient,
    required this.onCreate,
    required this.onContact,
  });

  final List<Map<String, dynamic>> needs;
  final bool isClient;
  final VoidCallback onCreate;
  final void Function(Map<String, dynamic>) onContact;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 88),
      children: [
        if (isClient)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Post job'),
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ),
        if (needs.isEmpty)
          _CompactEmpty(
            icon: Icons.work_outline,
            text: isClient ? 'No jobs posted yet.' : 'No open jobs yet.',
          )
        else
          ..._withDividers(
            context,
            needs.map(
              (row) => _NeedFeedRow(
                row: row,
                onTap: isClient ? null : () => onContact(row),
              ),
            ),
          ),
      ],
    );
  }
}

class _NeedFeedRow extends StatelessWidget {
  const _NeedFeedRow({required this.row, required this.onTap});

  final Map<String, dynamic> row;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final title = row['title'] as String? ?? 'Job';
    final summary = row['summary'] as String? ?? '';
    final skills = _stringList(row['skills']);
    final meta = [
      row['budget_band'] as String? ?? 'Negotiable',
      ...skills.take(2),
    ].where((value) => value.trim().isNotEmpty).join(' · ');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _InitialDot(text: title, fallback: 'J'),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    if (summary.isNotEmpty)
                      Text(
                        summary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: onSurface.withValues(alpha: 0.68),
                          fontSize: 12.5,
                        ),
                      ),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _teal,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                onTap == null ? Icons.work_outline : Icons.chevron_right,
                color: onSurface.withValues(alpha: 0.35),
                size: 20,
              ),
            ],
          ),
        ),
      ),
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
    required this.onReview,
    required this.onLinkWorkspace,
  });

  final List<Map<String, dynamic>> requests;
  final String? myUid;
  final String filter;
  final ValueChanged<String> onFilterChanged;
  final Future<void> Function(String id) onAccept;
  final Future<void> Function(String id) onDecline;
  final Future<void> Function(Map<String, dynamic> row) onReview;
  final Future<void> Function(Map<String, dynamic> row) onLinkWorkspace;

  @override
  Widget build(BuildContext context) {
    final filtered = filter == 'all'
        ? requests
        : requests
              .where((r) => (r['status'] as String? ?? 'pending') == filter)
              .toList();

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 88),
      children: [
        _InboxFilters(filter: filter, onFilterChanged: onFilterChanged),
        if (requests.isEmpty)
          const _CompactEmpty(
            icon: Icons.inbox_outlined,
            text: 'No Connect requests yet.',
          )
        else if (filtered.isEmpty)
          const _CompactEmpty(
            icon: Icons.filter_alt_off_outlined,
            text: 'No requests here.',
          )
        else
          ..._withDividers(
            context,
            filtered.map((row) {
              final incoming = row['to_user_id'] == myUid;
              final status = row['status'] as String? ?? 'pending';
              return _InboxFeedRow(
                row: row,
                incoming: incoming,
                status: status,
                onAccept: () => onAccept(row['id'] as String),
                onDecline: () => onDecline(row['id'] as String),
                onReview: () => onReview(row),
                onLinkWorkspace: () => onLinkWorkspace(row),
              );
            }),
          ),
      ],
    );
  }
}

class _InboxFilters extends StatelessWidget {
  const _InboxFilters({required this.filter, required this.onFilterChanged});

  final String filter;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          for (final f in const ['all', 'pending', 'accepted', 'declined'])
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(f[0].toUpperCase() + f.substring(1)),
                selected: filter == f,
                onSelected: (_) => onFilterChanged(f),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }
}

class _InboxFeedRow extends StatelessWidget {
  const _InboxFeedRow({
    required this.row,
    required this.incoming,
    required this.status,
    required this.onAccept,
    required this.onDecline,
    required this.onReview,
    required this.onLinkWorkspace,
  });

  final Map<String, dynamic> row;
  final bool incoming;
  final String status;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onReview;
  final VoidCallback onLinkWorkspace;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final accepted = status == 'accepted';
    final title = incoming ? 'Incoming request' : 'Sent request';
    final partnerName =
        (incoming ? row['from_name'] : row['to_name']) as String?;
    final partnerEmail =
        (incoming ? row['from_email'] : row['to_email']) as String?;
    final message = row['message'] as String? ?? '';
    final meta = accepted
        ? 'Unlocked · ${partnerName ?? 'Partner'}${partnerEmail == null ? '' : ' · $partnerEmail'}'
        : '${incoming ? 'Incoming' : 'Sent'} · $status';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _InitialDot(
            text: accepted ? partnerName ?? title : title,
            fallback: incoming ? 'I' : 'S',
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                if (message.isNotEmpty)
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: onSurface.withValues(alpha: 0.68),
                      fontSize: 12.5,
                    ),
                  ),
                Text(
                  meta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: accepted ? _teal : onSurface.withValues(alpha: 0.56),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (incoming && status == 'pending') ...[
            IconButton(
              tooltip: 'Decline',
              onPressed: onDecline,
              icon: const Icon(Icons.close, size: 18),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              tooltip: 'Accept',
              onPressed: onAccept,
              icon: const Icon(Icons.check, size: 18, color: _teal),
              visualDensity: VisualDensity.compact,
            ),
          ] else if (accepted) ...[
            IconButton(
              tooltip: 'Leave review',
              onPressed: onReview,
              icon: Icon(Icons.star_outline, size: 18, color: Colors.amber.shade800),
              visualDensity: VisualDensity.compact,
            ),
            TextButton(
              onPressed: onLinkWorkspace,
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text('Add'),
            ),
          ] else
            Icon(
              Icons.chevron_right,
              color: onSurface.withValues(alpha: 0.28),
              size: 20,
            ),
        ],
      ),
    );
  }
}

class _InitialDot extends StatelessWidget {
  const _InitialDot({required this.text, required this.fallback});

  final String text;
  final String fallback;

  @override
  Widget build(BuildContext context) {
    final initial = _initialFor(text, fallback);
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _teal.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Text(
        initial,
        style: const TextStyle(
          color: _teal,
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _CompactEmpty extends StatelessWidget {
  const _CompactEmpty({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 42),
      child: Column(
        children: [
          Icon(icon, size: 32, color: onSurface.withValues(alpha: 0.35)),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: onSurface.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _withDividers(BuildContext context, Iterable<Widget> rows) {
  final color = Theme.of(context).dividerColor.withValues(alpha: 0.55);
  final widgets = <Widget>[];
  for (final row in rows) {
    if (widgets.isNotEmpty) {
      widgets.add(Divider(height: 1, thickness: 0.6, color: color));
    }
    widgets.add(row);
  }
  return widgets;
}

List<String> _stringList(Object? value) {
  if (value is List) return value.map((e) => e.toString()).toList();
  return const [];
}

String _connectRowId(Map<String, dynamic> row) =>
    (row['id'] ?? row['user_id'] ?? '').toString();

String _initialFor(String value, String fallback) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return fallback;
  return trimmed.substring(0, 1).toUpperCase();
}
