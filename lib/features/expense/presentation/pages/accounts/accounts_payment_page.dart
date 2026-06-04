// lib/features/expense/presentation/pages/accounts/accounts_payment_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../injection_container.dart';
import '../../bloc/approval_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../features/expense/domain/entities/expense_request_entity.dart';

class AccountsPaymentPage extends StatelessWidget {
  const AccountsPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ApprovalBloc>()..add(const ApprovalLoadAccountsQueue()),
      child: const _AccountsPaymentView(),
    );
  }
}

class _AccountsPaymentView extends StatelessWidget {
  const _AccountsPaymentView();
  Future<void> _viewBill(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showPaymentDialog(BuildContext context, ExpenseRequestEntity req) {
    final amountCtrl = TextEditingController();
    final remarksCtrl = TextEditingController();
    PaymentType selectedType = PaymentType.full;
    PaymentMode selectedMode = PaymentMode.bank1;
    File? screenshotFile;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Process Payment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment Type
                const Text('Payment Type',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                SegmentedButton<PaymentType>(
                  segments: PaymentType.values
                      .map((t) => ButtonSegment(
                            value: t,
                            label: Text(t.label),
                          ))
                      .toList(),
                  selected: {selectedType},
                  onSelectionChanged: (s) =>
                      setState(() => selectedType = s.first),
                ),

                const SizedBox(height: 16),

                // Bank Channel
                const Text('Bank Channel',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                SegmentedButton<PaymentMode>(
                  segments: PaymentMode.values
                      .map((m) => ButtonSegment(
                            value: m,
                            label: Text(m.label),
                          ))
                      .toList(),
                  selected: {selectedMode},
                  onSelectionChanged: (s) =>
                      setState(() => selectedMode = s.first),
                ),

                const SizedBox(height: 16),

                // Amount
                TextField(
                  controller: amountCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Payment Amount (INR) *',
                    prefixText: '₹ ',
                  ),
                ),

                const SizedBox(height: 12),

                // Remarks
                TextField(
                  controller: remarksCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Remarks (optional)',
                  ),
                  maxLines: 2,
                ),

                const SizedBox(height: 12),

                // Screenshot upload
                InkWell(
                  onTap: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                    );
                    if (result != null && result.files.single.path != null) {
                      setState(() {
                        screenshotFile = File(result.files.single.path!);
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            screenshotFile != null ? Colors.green : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: screenshotFile != null
                          ? Colors.green.withValues(alpha: 0.05)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          screenshotFile != null
                              ? Icons.check_circle_rounded
                              : Icons.screenshot_monitor,
                          color: screenshotFile != null
                              ? Colors.green
                              : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            screenshotFile != null
                                ? screenshotFile!.path.split('/').last
                                : 'Upload payment screenshot *',
                            style: TextStyle(
                              fontSize: 13,
                              color: screenshotFile != null
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountCtrl.text.trim());
                if (amount == null || amount <= 0) return;
                if (screenshotFile == null) return;

                context.read<ApprovalBloc>().add(
                      ApprovalProcessPayment(
                        expenseRequestId: req.id,
                        amount: amount,
                        paymentType: selectedType.dbValue,
                        paymentMode: selectedMode.dbValue,
                        screenshotFile: screenshotFile!,
                        remarks: remarksCtrl.text.trim().isEmpty
                            ? null
                            : remarksCtrl.text.trim(),
                      ),
                    );
                Navigator.pop(ctx);
              },
              child: const Text('Process Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _showReturnDialog(BuildContext context, String expenseId) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Return to HOD'),
        content: TextField(
          controller: reasonCtrl,
          decoration: const InputDecoration(
            labelText: 'Reason for returning *',
            hintText: 'Explain the issue with this request',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              if (reasonCtrl.text.trim().isEmpty) return;
              context.read<ApprovalBloc>().add(
                    ApprovalReturnToHod(
                      expenseRequestId: expenseId,
                      returnReason: reasonCtrl.text.trim(),
                    ),
                  );
              Navigator.pop(ctx);
            },
            child: const Text('Return to HOD'),
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
        title: const Text('Accounts — Payment Queue'),
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

          final requests = state is ApprovalAccountsQueueLoaded
              ? state.requests
              : <ExpenseRequestEntity>[];

          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payments_outlined,
                      size: 64,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text('No pending payments.'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => context
                .read<ApprovalBloc>()
                .add(const ApprovalLoadAccountsQueue()),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final req = requests[index];

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
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: req.isPartiallyPaid
                                    ? Colors.teal.withValues(alpha: 0.1)
                                    : Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                req.status.label,
                                style: TextStyle(
                                  color: req.isPartiallyPaid
                                      ? Colors.teal
                                      : Colors.blue,
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
                        _InfoRow('HOD', req.hodName ?? '-'),
                        _InfoRow('Expense Type', req.expenseTypeName ?? '-'),
                        _InfoRow('Vendor', req.vendorName ?? '-'),
                        _InfoRow('Total', fmt.format(req.totalAmount)),
                        _InfoRow('Advance', fmt.format(req.advancePaid)),
                        _InfoRow('Net Payable', fmt.format(req.netPayable)),
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

                        const SizedBox(height: 16),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _showReturnDialog(context, req.id),
                                icon: const Icon(Icons.undo_rounded,
                                    color: Colors.orange),
                                label: const Text('Return to HOD',
                                    style: TextStyle(color: Colors.orange)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.orange),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _showPaymentDialog(context, req),
                                icon: const Icon(Icons.payment_rounded),
                                label: const Text('Pay Now'),
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
