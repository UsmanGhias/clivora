import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/cloud/cloud_ai_suggestions_repository.dart';
import '../../core/services/feature_flags_service.dart';
import '../../shared/widgets/clivora_scaffold.dart';

class AiSuggestionsScreen extends ConsumerStatefulWidget {
  const AiSuggestionsScreen({super.key});

  @override
  ConsumerState<AiSuggestionsScreen> createState() => _AiSuggestionsScreenState();
}

class _AiSuggestionsScreenState extends ConsumerState<AiSuggestionsScreen> {
  bool? _enabled;
  List<Map<String, dynamic>> _rows = [];
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final on = await ref.read(featureFlagsServiceProvider).aiStructured();
    if (!mounted) return;
    setState(() => _enabled = on);
    if (!on) return;
    try {
      final rows = await ref.read(cloudAiSuggestionsRepositoryProvider).listPending();
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
      title: 'AI suggestions',
      subtitle: 'Human review required - never auto-pay/publish',
      showBackButton: true,
      body: _enabled == null
          ? const Center(child: CircularProgressIndicator())
          : !_enabled!
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Structured AI suggestions are behind a feature flag and not enabled yet.'),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                    FilledButton(
                      onPressed: _busy
                          ? null
                          : () async {
                              setState(() => _busy = true);
                              try {
                                await ref.read(cloudAiSuggestionsRepositoryProvider).createSample();
                                await _load();
                              } catch (e) {
                                setState(() => _error = '$e');
                              } finally {
                                if (mounted) setState(() => _busy = false);
                              }
                            },
                      child: const Text('Create sample suggestion'),
                    ),
                    const SizedBox(height: 12),
                    ..._rows.map((s) {
                      final payload = s['payload'];
                      final pretty = const JsonEncoder.withIndent('  ').convert(payload);
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '${s['suggestion_type']} · ${s['entity_type']}',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Text(pretty, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: _busy
                                        ? null
                                        : () async {
                                            setState(() => _busy = true);
                                            try {
                                              await ref
                                                  .read(cloudAiSuggestionsRepositoryProvider)
                                                  .review(s['id'] as String, accept: true);
                                              await _load();
                                            } catch (e) {
                                              setState(() => _error = '$e');
                                            } finally {
                                              if (mounted) setState(() => _busy = false);
                                            }
                                          },
                                    child: const Text('Accept'),
                                  ),
                                  TextButton(
                                    onPressed: _busy
                                        ? null
                                        : () async {
                                            setState(() => _busy = true);
                                            try {
                                              await ref
                                                  .read(cloudAiSuggestionsRepositoryProvider)
                                                  .review(s['id'] as String, accept: false);
                                              await _load();
                                            } catch (e) {
                                              setState(() => _error = '$e');
                                            } finally {
                                              if (mounted) setState(() => _busy = false);
                                            }
                                          },
                                    child: const Text('Reject'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
    );
  }
}
