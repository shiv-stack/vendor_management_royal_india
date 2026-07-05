// lib/shared/utils/csv_export_helper.dart
//
// CsvExportHelper — builds the CSV string and delegates the actual
// file-save / download to the platform-specific implementation.

import 'package:flutter/material.dart';
import '../../features/dashboard/domain/entities/expense_detail_entity.dart';
import 'platform/csv_downloader.dart';

class CsvExportHelper {
  CsvExportHelper._();

  // ── Public API ────────────────────────────────────────────────

  /// Export all [details] for the given [eventName] as a CSV file.
  /// Triggers a browser download on Web; saves to Documents on native.
  static Future<void> exportExpenses({
    required BuildContext context,
    required String eventName,
    required List<ExpenseDetailEntity> details,
  }) async {
    final content  = _buildCsv(eventName, details);
    final filename = _buildFilename(eventName);
    await downloadCsvPlatform(context, filename, content);
  }

  // ── Private helpers ───────────────────────────────────────────

  /// Produces a filename safe for all platforms.
  /// Example: "Vijay_Parv_-_26th_April_2026_2026-07-04.csv"
  static String _buildFilename(String eventName) {
    final date      = DateTime.now().toIso8601String().split('T').first;
    final sanitized = eventName
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '') // strip OS-forbidden chars
        .replaceAll(' ', '_');
    return '${sanitized}_$date.csv';
  }

  /// Builds the CSV content matching the user-specified format:
  ///
  /// ```
  /// Name of Event,Vijay Parv - 26th April 2026
  ///
  /// Name of Vendor,Expense Type,Expense Amount,Bank 1 Payment,Bank 2 Payment,Balance Amount
  /// Shivam,Catering,50000,20000,0,30000
  /// TOTAL,,50000,20000,0,30000
  /// ```
  static String _buildCsv(
    String eventName,
    List<ExpenseDetailEntity> details,
  ) {
    final buf = StringBuffer();

    // ── Row 1: Event name ──────────────────────────────────────
    buf.writeln('Name of Event,${_esc(eventName)}');

    // ── Row 2: blank separator ─────────────────────────────────
    buf.writeln();

    // ── Row 3: Column headers ──────────────────────────────────
    buf.writeln(
      'Name of Vendor,'
      'Expense Type,'
      'Expense Amount,'
      'Bank 1 Payment,'
      'Bank 2 Payment,'
      'Balance Amount',
    );

    // ── Data rows + running totals ─────────────────────────────
    double totalAmount  = 0;
    double totalBank1   = 0;
    double totalBalance = 0;

    for (final d in details) {
      // _safe() clamps NaN / Infinity → 0 so those never appear as text
      final amount  = _safe(d.totalAmount);
      final bank1   = _safe(d.totalPaid);   // Bank 1 = total paid from DB
      final balance = _safe(d.outstanding);

      buf.writeln([
        _esc(d.vendorName),
        _esc(d.expenseType),
        _fmt(amount),
        _fmt(bank1),
        '0',          // Bank 2 Payment — no DB split required, always 0
        _fmt(balance),
      ].join(','));

      totalAmount  += amount;
      totalBank1   += bank1;
      totalBalance += balance;
    }

    // ── Totals row ─────────────────────────────────────────────
    buf.writeln([
      'TOTAL',
      '',
      _fmt(totalAmount),
      _fmt(totalBank1),
      '0',
      _fmt(totalBalance),
    ].join(','));

    // ── UTF-8 BOM prefix ───────────────────────────────────────
    // \uFEFF → 0xEF 0xBB 0xBF when UTF-8 encoded.
    // Excel / mobile viewers use this to detect UTF-8 and parse
    // commas as column delimiters instead of showing a single blob.
    return '\uFEFF${buf.toString()}';
  }

  /// Guards against NaN / Infinity values that can appear when a DB
  /// field is unexpectedly null and arithmetic is applied to it.
  /// Dart's [double.toStringAsFixed] returns "Infinity" for infinite
  /// values, which corrupts the CSV — this clamps them to 0.
  static double _safe(double v) {
    if (v.isNaN || v.isInfinite) return 0.0;
    return v;
  }

  /// Formats a safe double as a whole-number string (no decimals).
  static String _fmt(double v) => v.toStringAsFixed(0);

  /// Escapes a CSV field — wraps in double-quotes if the value
  /// contains a comma, quote character, or newline.
  static String _esc(String value) {
    if (value.contains(',') ||
        value.contains('"') ||
        value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
