/// Free vs Pro numeric limits for CLIVORA.
abstract final class PlanLimits {
  static const freePlan = 'free';
  static const proPlan = 'pro';
  static const proPlusPlan = 'pro_plus';
  static const starterPlan = 'starter';
  static const professionalPlan = 'professional';
  static const agencyPlan = 'agency';

  // Free tier caps
  static const freeMaxClients = 3;
  static const freeMaxProjects = 5;
  static const freeMaxInvoicesPerMonth = 10;
  static const freeMaxEmailsPerMonth = 5;
  static const freeMaxTemplates = 3;
  static const freeMaxTasksPerProject = 15;
  static const freeMaxWorkflows = 0;
  static const freeStorageBytes = 100 * 1024 * 1024; // 100 MB

  // Pro tier
  static const proStorageBytes = 5 * 1024 * 1024 * 1024; // 5 GB
  static const proMaxEmailsPerMonth = 500;

  // Pro Plus tier. Plus includes all Pro limits/features, plus higher caps below
  static const proPlusStorageBytes = 50 * 1024 * 1024 * 1024; // 50 GB
  static const proPlusMaxEmailsPerMonth = 3000;

  // Client free caps
  static const freeMaxClientContracts = 2;
  static const freeMaxClientInvoiceDownloads = 5;
}
