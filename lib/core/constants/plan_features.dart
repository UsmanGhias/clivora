import 'plan_limits.dart';

/// Free vs Pro feature matrix for freelancers and clients.
abstract final class PlanFeatures {
  static bool isPro(String? plan) =>
      plan == PlanLimits.proPlan ||
      plan == PlanLimits.proPlusPlan ||
      plan == PlanLimits.professionalPlan ||
      plan == PlanLimits.agencyPlan;

  static bool isProPlus(String? plan) => plan == PlanLimits.proPlusPlan;

  // ── Shared free tier ──────────────────────────────────────────────
  static bool chatTextMessages(String? plan) => true;
  static bool chatImageSharing(String? plan) => true;
  static bool notificationsCenter(String? plan) => true;
  static bool coachMarks(String? plan) => true;

  static int fileVaultLimitBytes(String? plan) {
    if (isProPlus(plan)) return PlanLimits.proPlusStorageBytes;
    if (isPro(plan)) return PlanLimits.proStorageBytes;
    return PlanLimits.freeStorageBytes;
  }

  static int emailLimitPerMonth(String? plan) {
    if (isProPlus(plan)) return PlanLimits.proPlusMaxEmailsPerMonth;
    if (isPro(plan)) return PlanLimits.proMaxEmailsPerMonth;
    return PlanLimits.freeMaxEmailsPerMonth;
  }

  /// Pro Plus exclusives
  static bool whiteLabelInvoices(String? plan) => isProPlus(plan);
  static bool prioritySupportPlus(String? plan) => isProPlus(plan);
  static bool unlimitedTeamSeats(String? plan) => isProPlus(plan);
  static bool advancedMilestoneAutomation(String? plan) => isProPlus(plan);
  static bool clientBrandedPortal(String? plan) => isProPlus(plan);

  // ── Freelancer free ───────────────────────────────────────────────
  static bool freelancerGlobalSearch(String? plan) => isPro(plan);
  static bool freelancerCalendar(String? plan) => isPro(plan);
  static bool freelancerBasicReports(String? plan) => true;
  static bool freelancerBasicAnalytics(String? plan) => true;

  // ── Freelancer Pro ────────────────────────────────────────────────
  static bool verifiedProfileBadge(String? plan) => isPro(plan);
  static bool biometricLock(String? plan) => isPro(plan);
  static bool teamCollaboration(String? plan) => isPro(plan);
  static bool aiAssistant(String? plan) => isPro(plan);
  static bool automations(String? plan) => isPro(plan);
  static bool customWorkflows(String? plan) => isPro(plan);
  static bool advancedAnalytics(String? plan) => isPro(plan);
  static bool unlimitedClients(String? plan) => isPro(plan);
  static bool unlimitedProjects(String? plan) => isPro(plan);
  static bool unlimitedInvoices(String? plan) => isPro(plan);
  static bool dataExport(String? plan) => isPro(plan);
  static bool invoiceAttachments(String? plan) => isPro(plan);
  static bool contractPdfStorage(String? plan) => isPro(plan);
  static bool vaultManualUpload(String? plan) => isPro(plan);
  static bool unlimitedTemplates(String? plan) => isPro(plan);
  static bool prioritySupport(String? plan) => isPro(plan);
  static bool fileVault(String? plan) => true;

  // Legacy aliases used across freelancer screens
  static bool globalSearch(String? plan) => freelancerGlobalSearch(plan);
  static bool calendarView(String? plan) => freelancerCalendar(plan);
  static bool basicReports(String? plan) => freelancerBasicReports(plan);
  static bool basicAnalytics(String? plan) => freelancerBasicAnalytics(plan);
  static bool clientPortal(String? plan) => true;

  // ── Client free ───────────────────────────────────────────────────
  static bool clientPortalBasic(String? plan) => true;
  static bool clientViewSharedProjects(String? plan) => true;
  static bool clientBasicChat(String? plan) => true;

  // ── Client Pro ────────────────────────────────────────────────────
  static bool clientVerifiedBadge(String? plan) => isPro(plan);
  static bool clientBiometricLock(String? plan) => isPro(plan);
  static bool clientUnlimitedContracts(String? plan) => isPro(plan);
  static bool clientContractPdfExport(String? plan) => isPro(plan);
  static bool clientInvoicePdfDownload(String? plan) => isPro(plan);
  static bool clientAdvancedActivity(String? plan) => isPro(plan);
  static bool clientPriorityNotifications(String? plan) => isPro(plan);
  static bool clientDataExport(String? plan) => isPro(plan);

  /// Account-type aware Pro check for a specific feature name.
  static bool hasFeature({required String? plan, required bool isClient, required String feature}) {
    if (!isPro(plan)) return _freeAllows(isClient: isClient, feature: feature);
    return true;
  }

  static bool _freeAllows({required bool isClient, required String feature}) {
    if (isClient) {
      switch (feature) {
        case 'contracts':
        case 'contract_pdf':
        case 'invoice_pdf':
          return true;
        case 'advanced_activity':
          return false;
        case 'export':
          return false;
        default:
          return true;
      }
    }
    switch (feature) {
      case 'ai':
      case 'workflows':
      case 'analytics_advanced':
      case 'export':
      case 'team':
      case 'biometric':
        return false;
      case 'calendar':
      case 'search':
        return false;
      default:
        return true;
    }
  }
}
