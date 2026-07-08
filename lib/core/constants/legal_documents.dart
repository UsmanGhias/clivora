/// In-app legal copy (mirrors clivora.codcrafters.org/privacy and /terms).
abstract final class LegalDocuments {
  static const privacyTitle = 'Privacy Policy';
  static const privacyUpdated = 'Last updated: July 3, 2026';

  static const privacyBody = '''
CodCrafters ("we", "our") operates the CLIVORA mobile application. This policy explains how we handle your information.

SUMMARY
CLIVORA stores business data locally on your device and syncs selected items through Supabase when you sign in. We do not sell your data.

INFORMATION WE COLLECT
• Account information: name and email when you sign up or use Google sign-in.
• Profile photo: optional image from camera or gallery.
• Business data: customers, projects, invoices, tasks, expenses, contracts, and messages you create.

HOW WE USE INFORMATION
• To provide CRM, invoicing, project tracking, and client portal features.
• To authenticate your account and sync cloud notifications.
• To improve the product through anonymized usage events you can control.

DATA STORAGE
Core business records are stored in a local SQLite database on your device. Cloud sync uses Supabase for shared client features (messages, invoice shares, notifications). Passwords are hashed before storage.

THIRD-PARTY SERVICES
• Google Sign-In for authentication.
• Supabase for cloud sync and notifications.
• Google Fonts may load when online.

PERMISSIONS
• Camera / Photos: profile and attachment uploads (optional).
• Biometrics: optional app lock on your device.
• Internet: sync, fonts, and sign-in.
• Notifications: task and business alerts.

DATA DELETION
Use Security & Privacy → Delete my account to remove local data on this device, or uninstall the app.

CHILDREN'S PRIVACY
CLIVORA is not intended for users under 13.

CONTACT
support@codcrafters.org
''';

  static const termsTitle = 'Terms of Service';
  static const termsUpdated = 'Last updated: July 7, 2026';

  static const termsBody = '''
These Terms of Service ("Terms") govern your use of CLIVORA, operated by CodCrafters.

ACCEPTANCE
By creating an account or using CLIVORA you agree to these Terms and our Privacy Policy.

THE SERVICE
CLIVORA is a business operating system for freelancers and agencies: clients, projects, invoices, tasks, contracts, messaging, and reporting. Features may change as the product evolves.

YOUR ACCOUNT
You are responsible for safeguarding login credentials and activity under your account. You must provide accurate registration information.

ACCEPTABLE USE
You agree not to misuse the service, upload unlawful content, attempt unauthorized access, or interfere with other users.

SUBSCRIPTIONS
CLIVORA Pro is billed through Google Play where available. Fees, renewal, and cancellation follow Google Play policies. Free-tier limits apply when Pro is inactive.

INTELLECTUAL PROPERTY
CLIVORA, its branding, and software are owned by CodCrafters. You retain ownership of business content you enter.

DISCLAIMER
CLIVORA is provided "as is" without warranties. We are not liable for indirect or consequential damages to the extent permitted by law.

TERMINATION
You may stop using CLIVORA at any time. We may suspend accounts that violate these Terms.

CHANGES
We may update these Terms. Continued use after updates constitutes acceptance.

CONTACT
support@codcrafters.org
''';
}
