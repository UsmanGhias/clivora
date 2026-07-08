import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/plan_limits.dart';
import '../../core/utils/navigation_helper.dart';
import '../../data/models/invoice_line_item.dart';
import '../../data/models/invoice_line_item.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_bottom_sheet.dart';
import '../../shared/widgets/clivora_scaffold.dart';
import '../../shared/widgets/contact_action_chips.dart';
import '../../shared/widgets/empty_state.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final _searchController = TextEditingController();
  String? _search;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onAddCustomer() async {
    await tryOpenWithPlanCheck(
      context,
      ref: ref,
      canAdd: () => ref.read(planLimitServiceProvider).canAddCustomer(),
      path: '/customers/new',
      resource: 'clients',
      max: PlanLimits.freeMaxClients,
    );
  }

  Future<void> _deleteCustomer(int id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete customer?'),
        content: Text('Remove $name? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(databaseProvider).deleteCustomer(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Customer deleted')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider(_search));
    final customerCountAsync = ref.watch(customerCountProvider);

    return ClivoraScaffold(
      title: 'Customers',
      showMessagesButton: true,
      action: ClivoraIconButton(icon: Icons.add, onPressed: _onAddCustomer),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _search = v.isEmpty ? null : v),
            decoration: const InputDecoration(
              hintText: 'Search customers...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 8),
          customerCountAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (count) => PlanLimitBanner(
              current: count,
              max: PlanLimits.freeMaxClients,
              resource: 'clients',
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: customersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (customers) {
                if (customers.isEmpty) {
                  return EmptyState(
                    icon: Icons.people_outline,
                    message: _search != null ? 'No customers found' : 'No customers yet',
                    actionLabel: _search == null ? 'Add client' : null,
                    onAction: _search == null ? _onAddCustomer : null,
                  );
                }
                return ListView.separated(
                  itemCount: customers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final c = customers[index];
                    final emails = parseStringList(c.emails);
                    final phones = parseStringList(c.phones);
                    return Dismissible(
                      key: ValueKey(c.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete customer?'),
                                content: Text('Remove ${c.contactPerson}?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                  TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                                ],
                              ),
                            ) ??
                            false;
                      },
                      onDismissed: (_) {
                        ref.read(databaseProvider).deleteCustomer(c.id);
                      },
                      child: ListTile(
                        onTap: () => openFormRoute(context, '/customers/${c.id}/edit'),
                        tileColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Theme.of(context).dividerColor),
                        ),
                        leading: CircleAvatar(
                          child: Text(c.contactPerson.isNotEmpty ? c.contactPerson[0].toUpperCase() : '?'),
                        ),
                        title: Text(c.contactPerson, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.company.isNotEmpty
                                  ? c.company
                                  : emails.isNotEmpty
                                      ? emails.first
                                      : 'No contact info',
                            ),
                            ContactActionChips(
                              phone: phones.isNotEmpty ? phones.first : '',
                              email: emails.isNotEmpty ? emails.first : '',
                              whatsapp: c.whatsapp,
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              tooltip: 'Edit',
                              onPressed: () => openFormRoute(context, '/customers/${c.id}/edit'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                              tooltip: 'Delete',
                              onPressed: () => _deleteCustomer(c.id, c.contactPerson),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
