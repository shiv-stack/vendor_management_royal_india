// lib/features/expense/presentation/pages/employee/my_requests_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../injection_container.dart';
import '../../bloc/expense_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../features/expense/domain/entities/expense_request_entity.dart';
import 'submit_expense_page.dart';
import '../../../../../shared/widgets/payment_proof_sheet.dart';

class MyRequestsPage extends StatelessWidget {
  const MyRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExpenseBloc>()..add(const ExpenseLoadMyRequests()),
      child: const _MyRequestsView(),
    );
  }
}

class _MyRequestsView extends StatelessWidget {
  const _MyRequestsView();

  Color _statusColor(ExpenseStatus status) {
    switch (status) {
      case ExpenseStatus.pendingHod:
        return Colors.orange;
      case ExpenseStatus.pendingAccounts:
        return Colors.blue;
      case ExpenseStatus.returnedToHod:
        return Colors.purple;
      case ExpenseStatus.rejected:
        return Colors.red;
      case ExpenseStatus.partiallyPaid:
        return Colors.teal;
      case ExpenseStatus.paid:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expense Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SubmitExpensePage()),
          );
          if (result == true && context.mounted) {
            context.read<ExpenseBloc>().add(const ExpenseLoadMyRequests());
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Expense'),
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading || state is ExpenseInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ExpenseFailure) {
            return Center(child: Text(state.message));
          }

          final requests = state is ExpenseMyRequestsLoaded
              ? state.requests
              : <ExpenseRequestEntity>[];

          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 64,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text('No expense requests yet.'),
                  const SizedBox(height: 8),
                  const Text('Tap + to submit a new expense.'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<ExpenseBloc>().add(const ExpenseLoadMyRequests()),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final req = requests[index];
                final color = _statusColor(req.status);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
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
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: color.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                req.status.label,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Details
                        _DetailRow('Type', req.expenseTypeName ?? '-'),
                        _DetailRow('Vendor', req.vendorName ?? '-'),
                        _DetailRow('HOD', req.hodName ?? '-'),
                        _DetailRow('Amount', fmt.format(req.totalAmount)),
                        if (req.advancePaid > 0)
                          _DetailRow('Advance', fmt.format(req.advancePaid)),
                        _DetailRow('Status', req.paymentStatus.label),

                        // Rejection reason
                        if (req.rejectionReason != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.red.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_outline,
                                    color: Colors.red, size: 16),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Rejected: ${req.rejectionReason}',
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Resubmit button
                        if (req.isRejected) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SubmitExpensePage(
                                      existingExpenseId: req.id,
                                    ),
                                  ),
                                );
                                if (result == true && context.mounted) {
                                  context
                                      .read<ExpenseBloc>()
                                      .add(const ExpenseLoadMyRequests());
                                }
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Resubmit'),
                            ),
                          ),
                        ],

                        // View Payment Proof button
                        if (req.isPartiallyPaid || req.isPaid) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  showPaymentProofSheet(context, req.id),
                              icon: const Icon(
                                  Icons.payment_rounded,
                                  size: 18),
                              label: const Text('View Payment Proof'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.teal,
                                side:
                                    const BorderSide(color: Colors.teal),
                              ),
                            ),
                          ),
                        ],
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
