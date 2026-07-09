import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/marketplace/connect_marketplace_service.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';

class ConnectListingScreen extends ConsumerStatefulWidget {
  const ConnectListingScreen({super.key});

  @override
  ConsumerState<ConnectListingScreen> createState() => _ConnectListingScreenState();
}

class _ConnectListingScreenState extends ConsumerState<ConnectListingScreen> {
  final _title = TextEditingController();
  final _headline = TextEditingController();
  final _bio = TextEditingController();
  final _skills = TextEditingController();
  final _location = TextEditingController();
  String _rate = 'Rs 2k-5k / project';
  String _availability = 'available';
  bool _listed = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final row = await ref.read(connectMarketplaceServiceProvider).myListing();
    if (row == null || !mounted) return;
    _title.text = row['display_title'] as String? ?? '';
    _headline.text = row['headline'] as String? ?? '';
    _bio.text = row['bio'] as String? ?? '';
    final skills = (row['skills'] as List?)?.map((e) => e.toString()).join(', ') ?? '';
    _skills.text = skills;
    _location.text = row['location_label'] as String? ?? '';
    _rate = row['rate_band'] as String? ?? _rate;
    _availability = row['availability'] as String? ?? _availability;
    _listed = row['is_listed'] as bool? ?? true;
    setState(() {});
  }

  @override
  void dispose() {
    _title.dispose();
    _headline.dispose();
    _bio.dispose();
    _skills.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlus = ref.watch(isProPlusProvider);

    return ClivoraScaffold(
      title: 'My Connect listing',
      showBackButton: true,
      body: !isPlus
          ? Center(
              child: FilledButton(
                onPressed: () => context.push('/upgrade'),
                child: const Text('Upgrade to Pro Plus'),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Show skills and rate band only. Your email stays hidden until someone accepts your Connect request.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
                const SizedBox(height: 16),
                TextField(controller: _title, decoration: const InputDecoration(labelText: 'Public title (not your real name)')),
                const SizedBox(height: 12),
                TextField(controller: _headline, decoration: const InputDecoration(labelText: 'Headline')),
                const SizedBox(height: 12),
                TextField(controller: _bio, maxLines: 4, decoration: const InputDecoration(labelText: 'Bio')),
                const SizedBox(height: 12),
                TextField(controller: _skills, decoration: const InputDecoration(labelText: 'Skills (comma separated)')),
                const SizedBox(height: 12),
                TextField(controller: _location, decoration: const InputDecoration(labelText: 'Location label (optional)')),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _rate,
                  decoration: const InputDecoration(labelText: 'Rate band'),
                  items: const [
                    DropdownMenuItem(value: 'Rs 1k-2k / project', child: Text('Rs 1k-2k / project')),
                    DropdownMenuItem(value: 'Rs 2k-5k / project', child: Text('Rs 2k-5k / project')),
                    DropdownMenuItem(value: 'Rs 5k-15k / project', child: Text('Rs 5k-15k / project')),
                    DropdownMenuItem(value: 'Rs 15k+ / project', child: Text('Rs 15k+ / project')),
                    DropdownMenuItem(value: 'negotiable', child: Text('Negotiable')),
                  ],
                  onChanged: (v) => setState(() => _rate = v ?? _rate),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _availability,
                  decoration: const InputDecoration(labelText: 'Availability'),
                  items: const [
                    DropdownMenuItem(value: 'available', child: Text('Available')),
                    DropdownMenuItem(value: 'limited', child: Text('Limited')),
                    DropdownMenuItem(value: 'booked', child: Text('Booked')),
                  ],
                  onChanged: (v) => setState(() => _availability = v ?? _availability),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('List me on Connect'),
                  value: _listed,
                  onChanged: (v) => setState(() => _listed = v),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _busy ? null : _save,
                  child: Text(_busy ? 'Saving…' : 'Save listing'),
                ),
              ],
            ),
    );
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      final skills = _skills.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      await ref.read(connectMarketplaceServiceProvider).upsertListing(
            displayTitle: _title.text,
            headline: _headline.text,
            bio: _bio.text,
            skills: skills,
            rateBand: _rate,
            availability: _availability,
            locationLabel: _location.text,
            isListed: _listed,
          );
      await ref.read(connectMarketplaceServiceProvider).logConnectEvent('connect_listing_saved');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing saved. Pending moderation unless admin.')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
