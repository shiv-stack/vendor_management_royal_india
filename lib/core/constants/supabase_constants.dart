// lib/core/constants/supabase_constants.dart

// ─────────────────────────────────────────────────────────────
// FILL IN YOUR VALUES from Supabase Dashboard → Settings → API
// ─────────────────────────────────────────────────────────────
class SupabaseConstants {
  SupabaseConstants._();

  // From: Settings → API → Project URL
  static const String supabaseUrl = 'https://umacgocqbrstcycxdfwo.supabase.co';
  // e.g. 'https://abcdefghijkl.supabase.co'

  // From: Settings → API → Project API Keys → anon public
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVtYWNnb2NxYnJzdGN5Y3hkZndvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg0OTQxMDcsImV4cCI6MjA5NDA3MDEwN30.SJF-AMmBUk4JP8FMxYqGwoOUZ5RDrtrb1cBkvCOjkRU';
  // e.g. 'eyJhbGciOiJIUzI1NiIsInR5cCI6...'

  // ── Supabase Table Names ───────────────────────────────────
  static const String tableProfiles = 'profiles';
  static const String tableEvents = 'events';
  static const String tableExpenseTypes = 'expense_types';
  static const String tableVendors = 'vendors';
  static const String tableExpenseRequests = 'expense_requests';
  static const String tablePayments = 'payments';
  static const String tableNotifications = 'notifications';

  // ── Supabase View Names ────────────────────────────────────
  static const String viewEventDashboard = 'v_event_dashboard';
  static const String viewEventExpenseDetail = 'v_event_expense_detail';

  // ── Supabase Storage Bucket Names ─────────────────────────
  static const String bucketBillAttachments = 'bill-attachments';
  static const String bucketPaymentScreenshots = 'payment-screenshots';
}
