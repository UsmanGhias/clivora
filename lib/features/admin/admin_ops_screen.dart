import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/cloud/supabase_auth_helper.dart';
import '../../core/services/feature_flags_service.dart';
import '../../shared/widgets/clivora_scaffold.dart';

class AdminOpsScreen extends ConsumerStatefulWidget {
  const AdminOpsScreen({super.key});

  @override
  ConsumerState<AdminOpsScreen> createState() => _AdminOpsScreenState();
}

class _AdminOpsScreenState extends ConsumerState<AdminOpsScreen> {
  bool? _enabled;
  List<Map<String, dynamic>> _queue = [];
  List<Map<String, dynamic>> _audits = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final on = await ref.read(featureFlagsServiceProvider).adminOps();
    if (!mounted) return;
    setState(() => _enabled = on);
    if (!on) return;
    try {
      final q = await SupabaseAuthHelper.client
          .from('automation_webhook_queue')
          .select('id, event_type, status, attempts, last_error, created_at')
          .order('created_at', ascending: false)
          .limit(50);
      final a = await SupabaseAuthHelper.client
          .from('audit_events')
          .select('id, action, entity_type, entity_id, created_at')
          .order('created_at', ascending: false)
          .limit(50);
      if (!mounted) return;
      setState(() {
        _queue = List<Map<String, dynamic>>.from(q as List);
        _audits = List<Map<String, dynamic>>.from(a as List);
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClivoraScaffold(
      title: 'Ops health',
      subtitle: 'Queue + audit (admin, flag-gated)',
      showBackButton: true,
      body: _enabled == null
          ? const Center(child: CircularProgressIndicator())
          : !_enabled!
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Admin ops dashboard flag is off.'),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                    Text('Automation queue', style: Theme.of(context).textTheme.titleMedium),
                    ..._queue.map(
                      (r) => ListTile(
                        dense: true,
                        title: Text('${r['status']} · ${r['event_type']}'),
                        subtitle: Text('attempts ${r['attempts'] ?? 0}${r['last_error'] != null ? ' · ${r['last_error']}' : ''}'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Audit events', style: Theme.of(context).textTheme.titleMedium),
                    ..._audits.map(
                      (r) => ListTile(
                        dense: true,
                        title: Text('${r['action']} · ${r['entity_type']}'),
                        subtitle: Text('${r['entity_id'] ?? ''}'),
                      ),
                    ),
                  ],
                ),
    );
  }
}
