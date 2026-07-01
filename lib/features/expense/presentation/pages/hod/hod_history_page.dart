// lib/features/expense/presentation/pages/hod/hod_history_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../injection_container.dart';
import '../../../../../shared/widgets/payment_proof_sheet.dart';
import '../../bloc/approval_bloc.dart';
import '../../../../../features/expense/domain/entities/expense_request_entity.dart';

class HodHistoryPage extends StatelessWidget {
  const HodHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ApprovalBloc>()..add(const ApprovalLoadHodHistory()),
      child: const _HodHistoryView(),
    );
  }
}

class _HodHistoryView extends StatelessWidget {
  const _HodHistoryView();

  Future<void> _viewBill(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Color _statusColor(ExpenseStatus status) {
    switch (status) {
      case ExpenseStatus.partiallyPaid:
        return Colors.teal;
      case ExpenseStatus.paid:
        return Colors.green;
      case ExpenseStatus.pendingHod:
      case ExpenseStatus.pendingAccounts:
      case ExpenseStatus.returnedToHod:
      case ExpenseStatus.rejected:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'en_IN', symbol: '\u20b9');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => context
                .read<ApprovalBloc>()
                .add(const ApprovalLoadHodHistory()),
          ),
        ],
      ),
      body: BlocBuilder<ApprovalBloc, ApprovalState>(
        builder: (context, state) {
          if (state is ApprovalLoading || state is ApprovalInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ApprovalFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded,
                        size: 56,
                        color: Theme.of(context)
                            .colorScheme
                            .error
                            .withValues(alpha: 0.6)),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => context
                          .read<ApprovalBloc>()
                          .add(const ApprovalLoadHodHistory()),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final requests = state is ApprovalHodHistoryLoaded
              ? state.requests
              : <ExpenseRequestEntity>[];

          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 64,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.25),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No paid expenses yet.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Expenses that have been paid will appear here.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.4),
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => context
                .read<ApprovalBloc>()
                .add(const ApprovalLoadHodHistory()),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final req = requests[index];
                final statusColor = _statusColor(req.status);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                req.eventName ?? 'Event',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: statusColor.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                req.status.label,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 4),

                        _InfoRow('Employee', req.employeeName ?? '-'),
                        _InfoRow(
                            'Expense Type', req.expenseTypeName ?? '-'),
                        _InfoRow('Vendor', req.vendorName ?? '-'),
                        _InfoRow(
                            'Total Amount', fmt.format(req.totalAmount)),
                        if (req.advancePaid > 0)
                          _InfoRow(
                              'Advance Paid', fmt.format(req.advancePaid)),
                        _InfoRow(
                            'Net Payable', fmt.format(req.netPayable)),
                        _InfoRow(
                            'Bill Status', req.paymentStatus.label),

                        const SizedBox(height: 12),

                        // View Bill button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _viewBill(req.billAttachmentUrl),
                            icon: const Icon(Icons.receipt_long_rounded,
                                size: 18),
                            label: const Text('View Bill / Invoice'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              side: const BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // View Payment Proof button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                showPaymentProofSheet(context, req.id),
                            icon: const Icon(Icons.payment_rounded,
                                size: 18),
                            label: const Text('View Payment Proof'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.teal,
                              side: const BorderSide(color: Colors.teal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
