import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/cloud/cloud_campaigns_repository.dart';
import '../../core/services/feature_flags_service.dart';
import '../../shared/widgets/clivora_scaffold.dart';

class CampaignsScreen extends ConsumerStatefulWidget {
  const CampaignsScreen({super.key});

  @override
  ConsumerState<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends ConsumerState<CampaignsScreen> {
  bool? _enabled;
  List<Map<String, dynamic>> _rows = [];
  final _title = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final on = await ref.read(featureFlagsServiceProvider).campaigns();
    if (!mounted) return;
    setState(() => _enabled = on);
    if (!on) return;
    try {
      final rows = await ref.read(cloudCampaignsRepositoryProvider).list();
      if (!mounted) return;
      setState(() {
        _rows = rows;
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClivoraScaffold(
      title: 'Campaigns',
      subtitle: 'In-product publish (not email/IMAP)',
      showBackButton: true,
      body: _enabled == null
          ? const Center(child: CircularProgressIndicator())
          : !_enabled!
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Campaigns are behind a feature flag and not enabled yet. Ask an admin after Gates 1–12.',
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _title,
                            decoration: const InputDecoration(
                              labelText: 'Campaign title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: _busy
                              ? null
                              : () async {
                                  if (_title.text.trim().isEmpty) return;
                                  setState(() => _busy = true);
                                  try {
                                    await ref.read(cloudCampaignsRepositoryProvider).createDraft(title: _title.text);
                                    _title.clear();
                                    await _load();
                                  } catch (e) {
                                    setState(() => _error = '$e');
                                  } finally {
                                    if (mounted) setState(() => _busy = false);
                                  }
                                },
                          child: const Text('Draft'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._rows.map((c) {
                      final status = '${c['status'] ?? ''}';
                      return Card(
                        child: ListTile(
                          title: Text('${c['title']}'),
                          subtitle: Text('$status · ${c['platform'] ?? 'connect'}'),
                          trailing: (status == 'draft' || status == 'failed')
                              ? TextButton(
                                  onPressed: _busy
                                      ? null
                                      : () async {
                                          setState(() => _busy = true);
                                          try {
                                            await ref
                                                .read(cloudCampaignsRepositoryProvider)
                                                .publish(c['id'] as String);
                                            await _load();
                                          } catch (e) {
                                            setState(() => _error = '$e');
                                          } finally {
                                            if (mounted) setState(() => _busy = false);
                                          }
                                        },
                                  child: const Text('Publish'),
                                )
                              : null,
                        ),
                      );
                    }),
                  ],
                ),
    );
  }
}
