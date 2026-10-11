import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GeneratedInvoiceItem {
  const GeneratedInvoiceItem({
    required this.description,
    required this.rate,
    required this.quantity,
    required this.amount,
    this.category = 'Service',
  });

  final String description;
  final double rate;
  final double quantity;
  final double amount;
  final String category;

  Map<String, dynamic> toJson() => {
        'description': description,
        'rate': rate,
        'quantity': quantity,
        'amount': amount,
        'category': category,
      };

  factory GeneratedInvoiceItem.fromJson(Map<String, dynamic> json) {
    final qty = (json['quantity'] as num?)?.toDouble() ?? 1.0;
    final rate = (json['rate'] as num?)?.toDouble() ?? 0.0;
    final amt = (json['amount'] as num?)?.toDouble() ?? (qty * rate);
    return GeneratedInvoiceItem(
      description: json['description']?.toString() ?? 'Consulting & Implementation',
      rate: rate,
      quantity: qty,
      amount: amt,
      category: json['category']?.toString() ?? 'Service',
    );
  }
}

class GeneratedJobScope {
  const GeneratedJobScope({
    required this.title,
    required this.summary,
    required this.skills,
    required this.budgetBand,
  });

  final String title;
  final String summary;
  final String skills;
  final String budgetBand;

  Map<String, dynamic> toJson() => {
        'title': title,
        'summary': summary,
        'skills': skills,
        'budget_band': budgetBand,
      };

  factory GeneratedJobScope.fromJson(Map<String, dynamic> json) {
    return GeneratedJobScope(
      title: json['title']?.toString() ?? 'Custom Software Development',
      summary: json['summary']?.toString() ?? '',
      skills: json['skills']?.toString() ?? 'React, TypeScript, Next.js',
      budgetBand: json['budget_band']?.toString() ?? '\$500-1,500',
    );
  }
}

/// Native Google Gemini AI Service for Clivora Mobile.
/// Integrates directly with Gemini API (gemini-flash-lite-latest) with 3-key failover pool.
class GeminiAssistantService {
  static const _primaryKey = 'REDACTED_GEMINI_KEY';
  static const _keyApp = 'REDACTED_GEMINI_KEY';
  static const _keyAi = 'REDACTED_GEMINI_KEY';
  static const _fallbackKey = 'REDACTED_GEMINI_KEY';
  static const _tertiaryKey = 'REDACTED_GEMINI_KEY';

  static const _apiKeys = [_primaryKey, _keyApp, _keyAi, _fallbackKey, _tertiaryKey];
  static const _model = 'gemini-flash-lite-latest';

  /// Sanitizes text to remove em-dashes and en-dashes per CLIVORA standards.
  static String sanitizeDashes(String text) {
    return text.replaceAll('\u2014', '-').replaceAll('\u2013', '-');
  }

  /// Internal caller with automatic 3-key failover.
  Future<String?> _callGemini({
    required String prompt,
    String? systemInstruction,
    int maxOutputTokens = 800,
    double temperature = 0.5,
  }) async {
    for (var i = 0; i < _apiKeys.length; i++) {
      final key = _apiKeys[i];
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$key',
      );

      final contents = <Map<String, dynamic>>[];
      if (systemInstruction != null && systemInstruction.isNotEmpty) {
        contents.add({
          'role': 'user',
          'parts': [{'text': 'System Directive: $systemInstruction'}],
        });
        contents.add({
          'role': 'model',
          'parts': [{'text': 'Understood. I will strictly follow this directive without em dashes.'}],
        });
      }

      contents.add({
        'role': 'user',
        'parts': [{'text': prompt}],
      });

      final body = jsonEncode({
        'contents': contents,
        'generationConfig': {
          'maxOutputTokens': maxOutputTokens,
          'temperature': temperature,
        },
      });

      try {
        final resp = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        ).timeout(const Duration(seconds: 8));

        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body) as Map<String, dynamic>;
          final candidates = data['candidates'] as List<dynamic>?;
          if (candidates != null && candidates.isNotEmpty) {
            final parts = candidates[0]['content']?['parts'] as List<dynamic>?;
            if (parts != null && parts.isNotEmpty) {
              final text = parts[0]['text']?.toString() ?? '';
              return sanitizeDashes(text.trim());
            }
          }
        } else {
          debugPrint('[GeminiAssistant] Key ${i + 1} HTTP ${resp.statusCode}: ${resp.body}');
        }
      } catch (e) {
        debugPrint('[GeminiAssistant] Key ${i + 1} failed with error: $e');
      }
    }
    return null;
  }

  /// Generates a structured, high-conversion project proposal.
  Future<String> generateProposal({
    required String clientName,
    required String projectTitle,
    required double budget,
    required String currency,
    required String timeline,
    required String scopeDetails,
    String? freelancerName,
  }) async {
    final sender = (freelancerName != null && freelancerName.trim().isNotEmpty)
        ? freelancerName.trim()
        : 'Consultant & Architect';

    final prompt = '''
Draft a concise, high-conversion, professional project proposal for a freelance contract.
Client Name: $clientName
Project Title: $projectTitle
Total Budget: $currency ${budget.toStringAsFixed(2)}
Estimated Timeline: $timeline
Scope & Requirements: $scopeDetails
Freelancer / Lead: $sender

Formatting requirements:
- Use clean Markdown with headers:
  # Proposal: $projectTitle
  ## 1. Executive Summary & Objectives
  ## 2. Scope of Work & Deliverables
  ## 3. Milestones & Timeline
  ## 4. Investment & Commercial Terms ($currency ${budget.toStringAsFixed(2)})
  ## 5. Next Steps & Acceptance
- Professional, direct founder/practitioner voice.
- Zero corporate fluff, no breathless buzzwords (no "delve", "testament", "cutting-edge").
- Zero em dashes (use hyphens or clean colons instead).
''';

    final result = await _callGemini(
      prompt: prompt,
      systemInstruction: 'You are an elite contract and commercial proposal specialist for CLIVORA Freelancer OS.',
      maxOutputTokens: 900,
    );

    if (result != null && result.isNotEmpty) {
      return result;
    }

    // Offline / Network fallback template
    return '''# Proposal: $projectTitle
Prepared for: $clientName
Lead: $sender

## 1. Executive Summary
This proposal outlines the implementation plan and delivery structure for $projectTitle. The objective is delivering production-ready, verified software matching the agreed requirements on schedule.

## 2. Scope of Work & Deliverables
- Technical design and specification review
- Implementation: $scopeDetails
- Verification, automated tests, and client review handoff

## 3. Milestones & Timeline
- Milestone 1: Requirements confirmation and foundation ($timeline)
- Milestone 2: Core feature delivery and review
- Milestone 3: Final acceptance and project deployment

## 4. Investment & Commercial Terms
- Total Agreed Fee: $currency ${budget.toStringAsFixed(2)}
- Platform Deal Fee: \$0 (Paid directly to freelancer via CLIVORA)
- Payment Schedule: 50% milestone upon kickoff, 50% on final acceptance

## 5. Next Steps
Reply directly on CLIVORA or accept the linked project milestone to initiate the kickoff.
''';
  }

  /// Parses unstructured scope text into typed invoice line items.
  Future<List<GeneratedInvoiceItem>> generateInvoiceLineItems({
    required String projectScope,
    required double targetBudget,
    String currency = 'USD',
  }) async {
    final prompt = '''
Analyze the following project description and generate 2 to 4 structured invoice line items that add up to exactly $currency ${targetBudget.toStringAsFixed(2)}.

Project Description: $projectScope

Output ONLY a valid JSON array of objects with keys: "description", "rate", "quantity", "amount", "category".
No markdown codeblocks, no explanations. Pure JSON array only.
Example:
[
  {"description": "Core Backend API & Database Implementation", "rate": 500, "quantity": 1, "amount": 500, "category": "Development"},
  {"description": "Frontend UI & Integration", "rate": 500, "quantity": 1, "amount": 500, "category": "Design"}
]
''';

    final result = await _callGemini(
      prompt: prompt,
      systemInstruction: 'You are an accounting automation engine. Always output pure raw JSON arrays only.',
      maxOutputTokens: 500,
      temperature: 0.2,
    );

    if (result != null && result.isNotEmpty) {
      try {
        final cleanJson = result.replaceAll(RegExp(r'^```json\s*|^```\s*|```$', multiLine: true), '').trim();
        final parsed = jsonDecode(cleanJson) as List<dynamic>;
        final items = parsed
            .map((e) => GeneratedInvoiceItem.fromJson(e as Map<String, dynamic>))
            .toList();

        if (items.isNotEmpty) {
          return items;
        }
      } catch (e) {
        debugPrint('[GeminiAssistant] Failed to parse JSON invoice items: $e');
      }
    }

    // Deterministic fallback line items
    final half = targetBudget / 2;
    return [
      GeneratedInvoiceItem(
        description: 'Primary Implementation: $projectScope',
        rate: half,
        quantity: 1,
        amount: half,
        category: 'Services',
      ),
      GeneratedInvoiceItem(
        description: 'Quality Assurance, Deployment & Delivery Verification',
        rate: targetBudget - half,
        quantity: 1,
        amount: targetBudget - half,
        category: 'Delivery',
      ),
    ];
  }

  /// Generates an executive business health briefing based on local data.
  Future<String> generateBusinessBriefing({
    required double monthlyRevenue,
    required int overdueCount,
    required double overdueTotal,
    required int activeProjects,
    required int completedProjects,
    String currency = 'USD',
  }) async {
    final prompt = '''
Analyze the current freelancer performance metrics and provide a 3-bullet executive advisory summary:
- Monthly Revenue: $currency ${monthlyRevenue.toStringAsFixed(2)}
- Overdue Invoices: $overdueCount ($currency ${overdueTotal.toStringAsFixed(2)})
- Active Projects: $activeProjects
- Completed Projects: $completedProjects

Keep it sharp, tactical, and motivating. Zero em dashes. 3 bullet points maximum.
''';

    final result = await _callGemini(
      prompt: prompt,
      systemInstruction: 'You are a veteran business advisor for top independent freelancers.',
      maxOutputTokens: 350,
      temperature: 0.4,
    );

    if (result != null && result.isNotEmpty) {
      return result;
    }

    return '''- Cash Flow: Billed $currency ${monthlyRevenue.toStringAsFixed(2)} this cycle. Follow up promptly on $overdueCount overdue invoice${overdueCount == 1 ? '' : 's'}.
- Delivery Velocity: You have $activeProjects active project${activeProjects == 1 ? '' : 's'} in progress. Prioritize the highest-value milestone.
- Deal Retained Rate: Zero platform fees on negotiated CLIVORA contracts protects 100% of your earnings.
''';
  }

  /// Generates a structured client job posting and scope breakdown.
  Future<GeneratedJobScope> generateJobScope({
    required String rawIdea,
    String? category,
    String? targetBudget,
  }) async {
    final prompt = '''
Analyze this client requirement and generate a structured job posting for CLIVORA Connect (0% platform fee freelance marketplace).

Client Requirement: "$rawIdea"
Target Category: "${category ?? 'Custom Software'}"
Approximate Budget: "${targetBudget ?? '\$500-1,500'}"

Standard Budget Options in CLIVORA:
- Under \$500
- \$500-1,500
- \$1,500-5,000
- \$5,000+
- negotiable

Requirements:
1. Title: Concise, professional role/project title (under 50 chars). E.g. "Full-Stack Next.js E-Commerce Platform"
2. Summary: Clear, professional scope of work (2-4 paragraphs) covering:
   - Project Objectives & Technical Overview
   - Core Features & Acceptance Criteria
   - Phased Delivery Milestones (Milestone 1, Milestone 2, Milestone 3)
   - Zero Platform Commission Notice ("CLIVORA charges 0% fees; both parties keep 100% of negotiated agreement value.")
3. Skills: 4 to 6 comma-separated technical skills matching standard stacks (e.g. "React, Next.js, TypeScript, PostgreSQL").
4. BudgetBand: Exactly one of the standard budget options above that best fits the scope.
5. Zero em dashes (use hyphens or clean colons instead). Zero corporate buzzwords.

Output ONLY a valid JSON object with keys:
"title", "summary", "skills", "budget_band".
No markdown blocks, no commentary. Pure JSON only.
''';

    final result = await _callGemini(
      prompt: prompt,
      systemInstruction: 'You are a senior technical recruiter and system architect structuring job postings for clients. Always return pure JSON only.',
      maxOutputTokens: 900,
      temperature: 0.3,
    );

    if (result != null && result.isNotEmpty) {
      try {
        final clean = result.replaceAll(RegExp(r'^```json\s*|^```\s*|```$', multiLine: true), '').trim();
        final decoded = jsonDecode(clean) as Map<String, dynamic>;
        return GeneratedJobScope(
          title: sanitizeDashes(decoded['title']?.toString() ?? 'Custom Software Development'),
          summary: sanitizeDashes(decoded['summary']?.toString() ?? rawIdea),
          skills: sanitizeDashes(decoded['skills']?.toString() ?? 'React, TypeScript, Next.js'),
          budgetBand: decoded['budget_band']?.toString() ?? (targetBudget ?? '\$500-1,500'),
        );
      } catch (e) {
        debugPrint('[GeminiAssistant] Failed to parse JSON job scope: $e');
      }
    }

    final fallbackTitle = sanitizeDashes(rawIdea.length > 45 ? '${rawIdea.substring(0, 42)}...' : rawIdea);
    final fallbackSummary = sanitizeDashes('''Project Overview:
$rawIdea

Scope & Deliverables:
- Technical design and implementation matching agreed requirements
- Integration testing, quality assurance, and responsive design verification
- Codebase documentation and deployment handoff

Phased Milestones:
- Milestone 1: Requirements sign-off and environment setup
- Milestone 2: Core feature development and demo
- Milestone 3: Final verification and production release

Note: CLIVORA charges 0% platform commissions. 100% of payouts go directly to your hired engineer.''');

    return GeneratedJobScope(
      title: fallbackTitle,
      summary: fallbackSummary,
      skills: 'React, TypeScript, Next.js, PostgreSQL',
      budgetBand: targetBudget ?? '\$500-1,500',
    );
  }
}
