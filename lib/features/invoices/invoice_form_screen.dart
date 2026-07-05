import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/services/invoice_share_helper.dart';
import '../../core/services/invoice_pdf_service.dart';
import '../../core/auth/auth_service.dart';
import '../../core/constants/currencies.dart';
import '../../core/services/automation_service.dart';
import '../../core/services/tracking_service.dart';
import '../../core/theme/clivora_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/database/database.dart';
import '../../data/database/user_scoped_queries.dart';
import '../../data/models/invoice_line_item.dart';
import '../../core/utils/crm_refresh.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/step_progress_card.dart';
import '../../shared/widgets/tracking_timeline.dart';

class InvoiceFormScreen extends ConsumerStatefulWidget {
  const InvoiceFormScreen({super.key, this.invoiceId});

  final int? invoiceId;

  @override
  ConsumerState<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  final _numberController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _taxController = TextEditingController(text: '0');
  final _discountController = TextEditingController(text: '0');
  int? _selectedCustomerId;
  int? _selectedProjectId;
  String _status = 'draft';
  String? _previousStatus;
  String _currency = kDefaultCurrency;
  DateTime? _dueDate;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    for (final c in [_amountController, _taxController, _discountController]) {
      c.addListener(() {
        if (mounted) setState(() {});
      });
    }
    if (widget.invoiceId != null) {
      _loadInvoice();
    } else {
      _numberController.text = 'INV-${DateFormat('yyyyMMdd-HHmm').format(DateTime.now())}';
      _loading = false;
    }
  }

  Future<void> _loadInvoice() async {
    final ownerId = ref.read(authStateProvider).valueOrNull?.id;
    if (ownerId == null) return;
    final invoice = await ref.read(databaseProvider).getInvoiceForUser(ownerId, widget.invoiceId!);
    if (invoice != null && mounted) {
      _numberController.text = invoice.invoiceNumber;
      _selectedCustomerId = invoice.customerId;
      _selectedProjectId = invoice.projectId;
      _status = invoice.status;
      _previousStatus = invoice.status;
      _currency = invoice.currency.isNotEmpty ? invoice.currency : kDefaultCurrency;
      _taxController.text = invoice.taxRate.toString();
      _discountController.text = invoice.discount.toString();
      _dueDate = invoice.dueDate;
      final items = parseLineItems(invoice.lineItems);
      if (items.isNotEmpty) {
        _descriptionController.text = items.first.description;
        _amountController.text = items.first.unitPrice.toString();
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _numberController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _taxController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  double _calculateTotal() {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final taxRate = double.tryParse(_taxController.text.trim()) ?? 0;
    final discount = double.tryParse(_discountController.text.trim()) ?? 0;
    final subtotal = amount;
    final tax = subtotal * (taxRate / 100);
    return subtotal + tax - discount;
  }

  Future<void> _save() async {
    if (_numberController.text.trim().isEmpty || _selectedCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice number and customer are required')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final taxRate = double.tryParse(_taxController.text.trim()) ?? 0;
    final discount = double.tryParse(_discountController.text.trim()) ?? 0;
    final subtotal = amount;
    final total = _calculateTotal();
    final lineItems = encodeLineItems([
      InvoiceLineItem(
        description: _descriptionController.text.trim().isEmpty ? 'Service' : _descriptionController.text.trim(),
        quantity: 1,
        unitPrice: amount,
      ),
    ]);

    final db = ref.read(databaseProvider);
    final ownerId = ref.read(authStateProvider).valueOrNull!.id;
    int? savedId = widget.invoiceId;

    if (widget.invoiceId != null) {
      final existing = await db.getInvoiceForUser(ownerId, widget.invoiceId!);
      if (existing != null) {
        await db.updateInvoice(
          existing.copyWith(
            invoiceNumber: _numberController.text.trim(),
            customerId: _selectedCustomerId!,
            projectId: Value(_selectedProjectId),
            status: _status,
            currency: _currency,
            subtotal: subtotal,
            taxRate: taxRate,
            discount: discount,
            total: total,
            lineItems: lineItems,
            dueDate: Value(_dueDate),
            updatedAt: DateTime.now(),
          ),
        );
      }
    } else {
      savedId = await db.insertInvoice(
        InvoicesCompanion.insert(
          ownerUserId: ownerId,
          invoiceNumber: _numberController.text.trim(),
          customerId: _selectedCustomerId!,
          projectId: Value(_selectedProjectId),
          status: Value(_status),
          currency: Value(_currency),
          subtotal: Value(subtotal),
          taxRate: Value(taxRate),
          discount: Value(discount),
          total: Value(total),
          lineItems: Value(lineItems),
          dueDate: Value(_dueDate),
        ),
      );
    }

    if (savedId != null && (_previousStatus != _status || widget.invoiceId == null)) {
      await ref.read(trackingServiceProvider).logStatusChange(
            entityType: 'invoice',
            entityId: savedId,
            status: _status,
            note: widget.invoiceId == null ? 'Invoice created' : 'Status updated',
          );
    }

    final savedInvoice = await db.getInvoiceForUser(ownerId, savedId!);
    if (savedInvoice != null) {
      await ref.read(automationServiceProvider).onInvoiceSaved(
            savedInvoice,
            previousStatus: _previousStatus,
          );
    }

    if (mounted) {
      invalidateCrmData(ref, invoices: true);
      ref.invalidate(dashboardStatsProvider);
      ref.invalidate(invoiceStatsProvider);
      ref.invalidate(invoicesProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _status == 'paid'
                ? 'Invoice saved and counted as revenue'
                : 'Invoice saved. Set status to Paid to track revenue.',
          ),
        ),
      );
      context.pop();
    }
  }

  Future<void> _exportPdf({bool share = true}) async {
    if (widget.invoiceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Save the invoice first to export PDF')),
      );
      return;
    }
    if (share) {
      await shareInvoicePdf(ref, context, widget.invoiceId!);
      return;
    }
    final db = ref.read(databaseProvider);
    final ownerId = ref.read(authStateProvider).valueOrNull?.id;
    if (ownerId == null) return;
    final invoice = await db.getInvoiceForUser(ownerId, widget.invoiceId!);
    if (_selectedCustomerId == null || invoice == null) return;
    final customer = await db.getCustomerForUser(ownerId, _selectedCustomerId!);
    final business = await ref.read(businessProfileProvider.future);
    final branding = await ref.read(invoiceBrandingProvider.future);
    Project? project;
    if (_selectedProjectId != null) {
      project = await db.getProjectForUser(ownerId, _selectedProjectId!);
    }
    if (customer == null) return;

    try {
      await InvoicePdfService.previewPdf(
        invoice: invoice,
        customer: customer,
        business: business,
        branding: branding,
        project: project,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final customersAsync = ref.watch(customersProvider(null));
    final projectsAsync = ref.watch(projectsProvider(const ProjectFilter()));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  Text(
                    widget.invoiceId != null ? 'Edit Invoice' : 'New Invoice',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  if (widget.invoiceId != null) ...[
                    const Spacer(),
                    IconButton(
                      tooltip: 'Preview PDF',
                      onPressed: () => _exportPdf(share: false),
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                    ),
                    IconButton(
                      tooltip: 'Share PDF',
                      onPressed: () => _exportPdf(share: true),
                      icon: const Icon(Icons.share_outlined),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const StepProgressCard(
                    currentStep: 1,
                    totalSteps: 1,
                    title: 'Invoice Details',
                    nextLabel: 'Save',
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClivoraTextField(controller: _numberController, label: 'Invoice Number', required: true),
                        const SizedBox(height: 16),
                        const ClivoraFieldLabel(label: 'Customer', required: true),
                        customersAsync.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (_, _) => const Text('Could not load customers'),
                          data: (customers) {
                            if (customers.isEmpty) {
                              return const Text('Add a customer first');
                            }
                            final unique = {for (final c in customers) c.id: c}.values.toList();
                            final validIds = unique.map((c) => c.id).toSet();
                            final selectedId = _selectedCustomerId != null && validIds.contains(_selectedCustomerId)
                                ? _selectedCustomerId
                                : null;
                            return DropdownButtonFormField<int>(
                              initialValue: selectedId,
                              decoration: const InputDecoration(hintText: 'Select customer'),
                              items: unique
                                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.contactPerson)))
                                  .toList(),
                              onChanged: (v) => setState(() {
                                _selectedCustomerId = v;
                                _selectedProjectId = null;
                              }),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const ClivoraFieldLabel(label: 'Project (optional)'),
                        projectsAsync.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (projects) {
                            final filtered = _selectedCustomerId == null
                                ? projects
                                : projects.where((p) => p.customerId == _selectedCustomerId).toList();
                            final validProjectIds = filtered.map((p) => p.id).toSet();
                            final projectId = _selectedProjectId != null && validProjectIds.contains(_selectedProjectId)
                                ? _selectedProjectId
                                : null;
                            return DropdownButtonFormField<int?>(
                              initialValue: projectId,
                              decoration: const InputDecoration(hintText: 'Select project'),
                              items: [
                                const DropdownMenuItem<int?>(value: null, child: Text('None')),
                                ...filtered.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))),
                              ],
                              onChanged: (v) async {
                                setState(() => _selectedProjectId = v);
                                if (v == null) return;
                                final ownerId = ref.read(authStateProvider).valueOrNull?.id;
                                if (ownerId == null) return;
                                final project = await ref.read(databaseProvider).getProjectForUser(ownerId, v);
                                if (project == null || !mounted) return;
                                setState(() {
                                  if (project.budget > 0) {
                                    _amountController.text = project.budget.toStringAsFixed(
                                      project.budget == project.budget.roundToDouble() ? 0 : 2,
                                    );
                                  }
                                  if (project.description.isNotEmpty && _descriptionController.text.isEmpty) {
                                    _descriptionController.text = project.description;
                                  }
                                  if (project.currency.isNotEmpty) {
                                    _currency = project.currency;
                                  }
                                });
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const ClivoraFieldLabel(label: 'Currency'),
                        DropdownButtonFormField<String>(
                          value: _currency,
                          decoration: const InputDecoration(hintText: 'Select currency'),
                          items: kSupportedCurrencies
                              .map((c) => DropdownMenuItem(value: c, child: Text('$c (${currencySymbol(c)})')))
                              .toList(),
                          onChanged: (v) => setState(() => _currency = v ?? kDefaultCurrency),
                        ),
                        const SizedBox(height: 16),
                        ClivoraTextField(controller: _descriptionController, label: 'Description', hint: 'Service or item description'),
                        const SizedBox(height: 16),
                        ClivoraTextField(controller: _amountController, label: 'Amount', hint: '0', keyboardType: TextInputType.number, required: true),
                        const SizedBox(height: 16),
                        ClivoraTextField(controller: _taxController, label: 'Tax Rate (%)', keyboardType: TextInputType.number),
                        const SizedBox(height: 16),
                        ClivoraTextField(controller: _discountController, label: 'Discount', keyboardType: TextInputType.number),
                        const SizedBox(height: 16),
                        const ClivoraFieldLabel(label: 'Status'),
                        DropdownButtonFormField<String>(
                          initialValue: _status,
                          decoration: const InputDecoration(),
                          items: const [
                            DropdownMenuItem(value: 'draft', child: Text('Draft')),
                            DropdownMenuItem(value: 'sent', child: Text('Sent')),
                            DropdownMenuItem(value: 'paid', child: Text('Paid')),
                            DropdownMenuItem(value: 'overdue', child: Text('Overdue')),
                          ],
                          onChanged: (v) => setState(() => _status = v ?? 'draft'),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Due Date'),
                          subtitle: Text(_dueDate != null ? DateFormat.yMMMd().format(_dueDate!) : 'Not set'),
                          trailing: TextButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now().add(const Duration(days: 30)),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2035),
                              );
                              if (picked != null) setState(() => _dueDate = picked);
                            },
                            child: const Text('Pick'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total: ${formatCurrency(_calculateTotal(), symbol: currencySymbol(_currency))}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: ClivoraColors.primaryPurple),
                        ),
                      ],
                    ),
                  ),
                  if (widget.invoiceId != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: TrackingTimeline(entityType: 'invoice', entityId: widget.invoiceId!),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _save, child: const Text('Save Invoice')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
