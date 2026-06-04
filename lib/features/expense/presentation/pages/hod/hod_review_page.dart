// lib/features/expense/presentation/pages/hod/hod_review_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../injection_container.dart';
import '../../bloc/approval_bloc.dart';
import '../../../../../features/expense/domain/entities/expense_request_entity.dart';

class HodReviewPage extends StatelessWidget {
  const HodReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ApprovalBloc>()..add(const ApprovalLoadQueue()),
      child: const _HodReviewView(),
    );
  }
}

class _HodReviewView extends StatelessWidget {
  const _HodReviewView();

  Future<void> _viewBill(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showRejectDialog(BuildContext context, String expenseId) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Expense'),
        content: TextField(
          controller: reasonCtrl,
          decoration: const InputDecoration(
            labelText: 'Rejection Reason *',
            hintText: 'Explain why this is being rejected',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              if (reasonCtrl.text.trim().isEmpty) return;
              context.read<ApprovalBloc>().add(
                    ApprovalReject(
                      expenseRequestId: expenseId,
                      rejectionReason: reasonCtrl.text.trim(),
                    ),
                  );
              Navigator.pop(ctx);
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _showReturnReasonDialog(BuildContext context, ExpenseRequestEntity req) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Returned by Accounts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reason:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(req.accountsReturnReason ?? 'No reason provided'),
            const SizedBox(height: 16),
            const Text('You can re-approve or reject:',
                style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          OutlinedButton(
            onPressed: () {
              _showRejectDialog(context, req.id);
              Navigator.pop(ctx);
            },
            child: const Text('Reject to Employee'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ApprovalBloc>().add(
                    ApprovalReApprove(expenseRequestId: req.id),
                  );
              Navigator.pop(ctx);
            },
            child: const Text('Re-Approve'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Approvals'),
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
      body: BlocConsumer<ApprovalBloc, ApprovalState>(
        listener: (context, state) {
          if (state is ApprovalActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is ApprovalFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ApprovalLoading || state is ApprovalInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = state is ApprovalQueueLoaded
              ? state.requests
              : <ExpenseRequestEntity>[];

          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt_rounded,
                      size: 64,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text('No pending approvals.'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<ApprovalBloc>().add(const ApprovalLoadQueue()),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final req = requests[index];
                final isReturned = req.isReturnedToHod;

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
                            if (isReturned)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Returned',
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 4),

                        _InfoRow('Employee', req.employeeName ?? '-'),
                        _InfoRow('Expense Type', req.expenseTypeName ?? '-'),
                        _InfoRow('Vendor', req.vendorName ?? '-'),
                        _InfoRow('Total Amount', fmt.format(req.totalAmount)),
                        if (req.advancePaid > 0)
                          _InfoRow('Advance Paid', fmt.format(req.advancePaid)),
                        _InfoRow('Net Payable', fmt.format(req.netPayable)),
                        _InfoRow('Bill Status', req.paymentStatus.label),
                        if (req.description != null)
                          _InfoRow('Description', req.description!),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _viewBill(req.billAttachmentUrl),
                            icon: const Icon(Icons.receipt_long_rounded,
                                size: 18),
                            label: const Text('View Bill / Invoice'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              side: const BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),

                        // Accounts return reason
                        if (isReturned && req.accountsReturnReason != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.purple.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.purple.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.undo_rounded,
                                    color: Colors.purple, size: 16),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Returned: ${req.accountsReturnReason}',
                                    style: const TextStyle(
                                        color: Colors.purple, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Action buttons
                        if (isReturned)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  _showReturnReasonDialog(context, req),
                              icon: const Icon(Icons.how_to_reg_rounded),
                              label: const Text('Review & Action'),
                            ),
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      _showRejectDialog(context, req.id),
                                  icon: const Icon(Icons.close_rounded,
                                      color: Colors.red),
                                  label: const Text('Reject',
                                      style: TextStyle(color: Colors.red)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => context
                                      .read<ApprovalBloc>()
                                      .add(ApprovalApprove(
                                        expenseRequestId: req.id,
                                      )),
                                  icon: const Icon(Icons.check_rounded),
                                  label: const Text('Approve'),
                                ),
                              ),
                            ],
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
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6))),
          ),
          Expanded(
            child: Text(value,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
