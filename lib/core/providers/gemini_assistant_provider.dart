import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/gemini_assistant_service.dart';
import '../../data/database/database.dart';
import '../../data/providers/app_providers.dart';

final geminiAssistantServiceProvider = Provider<GeminiAssistantService>((ref) {
  return GeminiAssistantService();
});

class GeminiAssistantState {
  const GeminiAssistantState({
    this.isLoading = false,
    this.proposal,
    this.invoiceItems = const [],
    this.briefing,
    this.jobScope,
    this.error,
  });

  final bool isLoading;
  final String? proposal;
  final List<GeneratedInvoiceItem> invoiceItems;
  final String? briefing;
  final GeneratedJobScope? jobScope;
  final String? error;

  GeminiAssistantState copyWith({
    bool? isLoading,
    String? proposal,
    List<GeneratedInvoiceItem>? invoiceItems,
    String? briefing,
    GeneratedJobScope? jobScope,
    String? error,
  }) {
    return GeminiAssistantState(
      isLoading: isLoading ?? this.isLoading,
      proposal: proposal ?? this.proposal,
      invoiceItems: invoiceItems ?? this.invoiceItems,
      briefing: briefing ?? this.briefing,
      jobScope: jobScope ?? this.jobScope,
      error: error,
    );
  }
}

class GeminiAssistantNotifier extends StateNotifier<GeminiAssistantState> {
  GeminiAssistantNotifier(this.ref) : super(const GeminiAssistantState());

  final Ref ref;

  GeminiAssistantService get _service => ref.read(geminiAssistantServiceProvider);
  AppDatabase get _db => ref.read(databaseProvider);

  /// Generates a project proposal and persists it into Drift Notes for offline durability.
  Future<String> draftProposal({
    required int ownerUserId,
    required String clientName,
    required String projectTitle,
    required double budget,
    required String currency,
    required String timeline,
    required String scopeDetails,
    String? freelancerName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final proposal = await _service.generateProposal(
        clientName: clientName,
        projectTitle: projectTitle,
        budget: budget,
        currency: currency,
        timeline: timeline,
        scopeDetails: scopeDetails,
        freelancerName: freelancerName,
      );

      // Cache locally into Notes so the user never loses it
      try {
        await _db.into(_db.notes).insert(
              NotesCompanion.insert(
                ownerUserId: ownerUserId,
                title: 'AI Proposal: $projectTitle',
                content: Value(proposal),
              ),
            );
      } catch (_) {}

      state = state.copyWith(isLoading: false, proposal: proposal);
      return proposal;
    } catch (e) {
      final err = 'Error generating proposal: $e';
      state = state.copyWith(isLoading: false, error: err);
      return '';
    }
  }

  /// Builds structured invoice line items matching the target budget.
  Future<List<GeneratedInvoiceItem>> buildInvoiceItems({
    required String projectScope,
    required double targetBudget,
    String currency = 'USD',
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final items = await _service.generateInvoiceLineItems(
        projectScope: projectScope,
        targetBudget: targetBudget,
        currency: currency,
      );
      state = state.copyWith(isLoading: false, invoiceItems: items);
      return items;
    } catch (e) {
      final err = 'Error building line items: $e';
      state = state.copyWith(isLoading: false, error: err);
      return [];
    }
  }

  /// Generates executive business briefing from metrics.
  Future<String> generateBriefing({
    required double monthlyRevenue,
    required int overdueCount,
    required double overdueTotal,
    required int activeProjects,
    required int completedProjects,
    String currency = 'USD',
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final summary = await _service.generateBusinessBriefing(
        monthlyRevenue: monthlyRevenue,
        overdueCount: overdueCount,
        overdueTotal: overdueTotal,
        activeProjects: activeProjects,
        completedProjects: completedProjects,
        currency: currency,
      );
      state = state.copyWith(isLoading: false, briefing: summary);
      return summary;
    } catch (e) {
      final err = 'Error generating briefing: $e';
      state = state.copyWith(isLoading: false, error: err);
      return '';
    }
  }

  /// Generates a structured client job posting from raw project idea.
  Future<GeneratedJobScope?> draftJobScope({
    required String rawIdea,
    String? category,
    String? targetBudget,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final scope = await _service.generateJobScope(
        rawIdea: rawIdea,
        category: category,
        targetBudget: targetBudget,
      );
      state = state.copyWith(isLoading: false, jobScope: scope);
      return scope;
    } catch (e) {
      final err = 'Error generating job scope: $e';
      state = state.copyWith(isLoading: false, error: err);
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const GeminiAssistantState();
  }
}

final geminiAssistantProvider =
    StateNotifierProvider<GeminiAssistantNotifier, GeminiAssistantState>((ref) {
  return GeminiAssistantNotifier(ref);
});
