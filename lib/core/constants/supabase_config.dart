/// Clivora Supabase configuration.
/// Defaults are provided for client connectivity; override via --dart-define in custom deployments.
const kSupabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://jtzjwgovqczlccyeujhq.supabase.co',
);

/// Anon public client key (subject to Postgres Row Level Security).
const kSupabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp0emp3Z292cWN6bGNjeWV1amhxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODMxODAwNzMsImV4cCI6MjA5ODc1NjA3M30.BwatkYlqX88GRCdyAvTCiUmsCF3Nc171an8XfosuuLM',
);

/// Modern publishable key.
const kSupabasePublishableKey = String.fromEnvironment(
  'SUPABASE_PUBLISHABLE_KEY',
  defaultValue: 'sb_publishable_mJ31lSIXL7PwDE_XT6mIfw_z79Zz5ZJ',
);

const kSupabaseProjectRef = String.fromEnvironment(
  'SUPABASE_PROJECT_REF',
  defaultValue: 'jtzjwgovqczlccyeujhq',
);
