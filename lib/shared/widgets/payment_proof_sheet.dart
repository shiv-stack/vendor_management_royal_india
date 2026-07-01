// lib/shared/widgets/payment_proof_sheet.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../features/expense/domain/entities/payment_entity.dart';
import '../../features/expense/domain/usecases/payment_usecases.dart';
import '../../injection_container.dart';


/// Shows a modal bottom sheet listing all payment proof records for the given
/// [expenseRequestId]. Calls [GetPaymentsForExpenseUseCase] directly so it can
/// be used from any widget without needing a parent BLoC scope.
Future<void> showPaymentProofSheet(
  BuildContext context,
  String expenseRequestId,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _PaymentProofSheet(
      expenseRequestId: expenseRequestId,
    ),
  );
}

class _PaymentProofSheet extends StatefulWidget {
  final String expenseRequestId;
  const _PaymentProofSheet({required this.expenseRequestId});

  @override
  State<_PaymentProofSheet> createState() => _PaymentProofSheetState();
}

class _PaymentProofSheetState extends State<_PaymentProofSheet> {
  bool _loading = true;
  String? _error;
  List<PaymentEntity> _payments = [];

  final _fmt = NumberFormat.currency(locale: 'en_IN', symbol: '\u20b9');

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result =
        await sl<GetPaymentsForExpenseUseCase>()(widget.expenseRequestId);
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failure.message;
      }),
      (payments) => setState(() {
        _loading = false;
        _payments = payments;
      }),
    );
  }

  Future<void> _viewScreenshot(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Color _typeColor(PaymentType type) {
    switch (type) {
      case PaymentType.advance:
        return Colors.blue;
      case PaymentType.partial:
        return Colors.orange;
      case PaymentType.full:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollController) {
        return Column(
          children: [
            // Handle + Title
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.payment_rounded,
                            color: Colors.teal, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment Proof',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Payment records uploaded by Accounts',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                ],
              ),
            ),
            // Body
            Expanded(
              child: _buildBody(scrollController, theme, colorScheme),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(
    ScrollController scrollController,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48,
                  color: colorScheme.error.withValues(alpha: 0.6)),
              const SizedBox(height: 12),
              Text(
                'Failed to load payments',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_payments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long_outlined,
                  size: 56,
                  color: colorScheme.onSurface.withValues(alpha: 0.25)),
              const SizedBox(height: 14),
              Text(
                'No payments found',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Payment records will appear here once\nprocessed by Accounts.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: _payments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final payment = _payments[index];
        return _PaymentCard(
          payment: payment,
          fmt: _fmt,
          typeColor: _typeColor(payment.paymentType),
          onViewScreenshot: () => _viewScreenshot(payment.screenshotUrl),
        );
      },
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final PaymentEntity payment;
  final NumberFormat fmt;
  final Color typeColor;
  final VoidCallback onViewScreenshot;

  const _PaymentCard({
    required this.payment,
    required this.fmt,
    required this.typeColor,
    required this.onViewScreenshot,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String dateLabel = '-';
    if (payment.createdAt != null) {
      try {
        final dt = DateTime.parse(payment.createdAt!).toLocal();
        dateLabel = DateFormat('d MMM yyyy, h:mm a').format(dt);
      } catch (_) {
        dateLabel = payment.createdAt!;
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Amount + Type badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  fmt.format(payment.amount),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: typeColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  payment.paymentType.label,
                  style: TextStyle(
                    color: typeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Details
          _SheetRow(
            icon: Icons.account_balance_rounded,
            label: 'Bank Mode',
            value: payment.paymentMode.label,
          ),
          const SizedBox(height: 6),
          _SheetRow(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: dateLabel,
          ),
          if (payment.processedByName != null) ...[
            const SizedBox(height: 6),
            _SheetRow(
              icon: Icons.person_rounded,
              label: 'Processed By',
              value: payment.processedByName!,
            ),
          ],
          if (payment.remarks != null && payment.remarks!.isNotEmpty) ...[
            const SizedBox(height: 6),
            _SheetRow(
              icon: Icons.notes_rounded,
              label: 'Remarks',
              value: payment.remarks!,
            ),
          ],

          const SizedBox(height: 14),

          // View Screenshot button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onViewScreenshot,
              icon: const Icon(Icons.image_rounded, size: 18),
              label: const Text('View Screenshot'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.teal,
                side: const BorderSide(color: Colors.teal),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SheetRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.45)),
        const SizedBox(width: 6),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
