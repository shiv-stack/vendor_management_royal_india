// lib/core/constants/app_constants.dart

// ─────────────────────────────────────────────────────────────
// Mirrors the Supabase PostgreSQL enums exactly.
// These are used throughout the app for type-safe comparisons.
// ─────────────────────────────────────────────────────────────

// ── User Roles (mirrors public.user_role enum) ────────────────
enum UserRole {
  admin,
  employee,
  hod,
  md,
  accounts;

  /// Convert DB string → UserRole
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserRole.employee,
    );
  }

  /// Human-readable label
  String get label {
    switch (this) {
      case UserRole.admin:    return 'Admin';
      case UserRole.employee: return 'Employee';
      case UserRole.hod:      return 'HOD';
      case UserRole.md:       return 'MD';
      case UserRole.accounts: return 'Accounts';
    }
  }
}

// ── Expense Status (mirrors public.expense_status enum) ───────
enum ExpenseStatus {
  pendingHod,
  pendingAccounts,
  returnedToHod,
  rejected,
  partiallyPaid,
  paid;

  /// Convert DB string → ExpenseStatus
  static ExpenseStatus fromString(String value) {
    const map = {
      'PENDING_HOD':       ExpenseStatus.pendingHod,
      'PENDING_ACCOUNTS':  ExpenseStatus.pendingAccounts,
      'RETURNED_TO_HOD':   ExpenseStatus.returnedToHod,
      'REJECTED':          ExpenseStatus.rejected,
      'PARTIALLY_PAID':    ExpenseStatus.partiallyPaid,
      'PAID':              ExpenseStatus.paid,
    };
    return map[value] ?? ExpenseStatus.pendingHod;
  }

  /// Convert ExpenseStatus → DB string
  String get dbValue {
    const map = {
      ExpenseStatus.pendingHod:      'PENDING_HOD',
      ExpenseStatus.pendingAccounts: 'PENDING_ACCOUNTS',
      ExpenseStatus.returnedToHod:   'RETURNED_TO_HOD',
      ExpenseStatus.rejected:        'REJECTED',
      ExpenseStatus.partiallyPaid:   'PARTIALLY_PAID',
      ExpenseStatus.paid:            'PAID',
    };
    return map[this]!;
  }

  String get label {
    switch (this) {
      case ExpenseStatus.pendingHod:      return 'Pending HOD';
      case ExpenseStatus.pendingAccounts: return 'Pending Accounts';
      case ExpenseStatus.returnedToHod:   return 'Returned to HOD';
      case ExpenseStatus.rejected:        return 'Rejected';
      case ExpenseStatus.partiallyPaid:   return 'Partially Paid';
      case ExpenseStatus.paid:            return 'Paid';
    }
  }
}

// ── Payment Type (mirrors public.payment_type enum) ───────────
enum PaymentType {
  advance,
  partial,
  full;

  static PaymentType fromString(String v) => PaymentType.values
      .firstWhere((e) => e.name.toUpperCase() == v);

  String get dbValue => name.toUpperCase();

  String get label {
    switch (this) {
      case PaymentType.advance: return 'Advance';
      case PaymentType.partial: return 'Partial';
      case PaymentType.full:    return 'Full';
    }
  }
}

// ── Payment Mode (mirrors public.payment_mode enum) ───────────
enum PaymentMode {
  bank1,
  bank2;

  static PaymentMode fromString(String v) {
    return v == 'BANK_1' ? PaymentMode.bank1 : PaymentMode.bank2;
  }

  String get dbValue => this == PaymentMode.bank1 ? 'BANK_1' : 'BANK_2';

  String get label => this == PaymentMode.bank1 ? 'Bank 1' : 'Bank 2';
}

// ── Expense Payment Status (mirrors public.expense_payment_status) ──
enum ExpensePaymentStatus {
  paidByEmployee,
  outstanding;

  static ExpensePaymentStatus fromString(String v) {
    return v == 'PAID_BY_EMPLOYEE'
        ? ExpensePaymentStatus.paidByEmployee
        : ExpensePaymentStatus.outstanding;
  }

  String get dbValue =>
      this == ExpensePaymentStatus.paidByEmployee
          ? 'PAID_BY_EMPLOYEE'
          : 'OUTSTANDING';

  String get label =>
      this == ExpensePaymentStatus.paidByEmployee
          ? 'Paid by Employee'
          : 'Outstanding';
}

// ── App String Constants ──────────────────────────────────────
class AppStrings {
  AppStrings._();

  static const String appName = 'VPMS — Royal India Vacation';

  // Auth
  static const String loginTitle       = 'Welcome back';
  static const String loginSubtitle    = 'Sign in to continue';
  static const String emailHint        = 'Email address';
  static const String passwordHint     = 'Password';
  static const String signInButton     = 'Sign in';
  static const String signingIn        = 'Signing in...';
  static const String invalidEmail     = 'Enter a valid email';
  static const String invalidPassword  = 'Password must be 6+ characters';

  // Common
  static const String loading      = 'Loading...';
  static const String retry        = 'Retry';
  static const String cancel       = 'Cancel';
  static const String confirm      = 'Confirm';
  static const String save         = 'Save';
  static const String submit       = 'Submit';
  static const String approve      = 'Approve';
  static const String reject       = 'Reject';
  static const String resubmit     = 'Resubmit';

  // Errors
  static const String genericError       = 'Something went wrong. Try again.';
  static const String networkError       = 'No internet connection.';
  static const String sessionExpired     = 'Session expired. Please sign in again.';
  static const String unauthorised       = 'You are not authorised to do this.';
}