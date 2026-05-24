// lib/features/expense/presentation/pages/employee/submit_expense_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../injection_container.dart';
import '../../bloc/expense_bloc.dart';

class SubmitExpensePage extends StatelessWidget {
  final String? existingExpenseId; // null = new, set = resubmit
  const SubmitExpensePage({super.key, this.existingExpenseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExpenseBloc>()
        ..add(const ExpenseLoadFormData()),
      child: _SubmitExpenseView(
          existingExpenseId: existingExpenseId),
    );
  }
}

class _SubmitExpenseView extends StatefulWidget {
  final String? existingExpenseId;
  const _SubmitExpenseView({this.existingExpenseId});

  @override
  State<_SubmitExpenseView> createState() =>
      _SubmitExpenseViewState();
}

class _SubmitExpenseViewState
    extends State<_SubmitExpenseView> {
  final _formKey = GlobalKey<FormState>();

  // Selected values
  String? _selectedEventId;
  String? _selectedExpenseTypeId;
  String? _selectedVendorId;
  String? _selectedHodId;
  ExpensePaymentStatus _paymentStatus =
      ExpensePaymentStatus.outstanding;
  File? _billFile;

  // Controllers
  final _totalAmountCtrl = TextEditingController();
  final _advancePaidCtrl = TextEditingController();

  @override
  void dispose() {
    _totalAmountCtrl.dispose();
    _advancePaidCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _billFile = File(result.files.single.path!);
      });
    }
  }

  void _submit(ExpenseFormReady formData) {
    if (!_formKey.currentState!.validate()) return;
    if (_billFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please attach a bill document.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final total =
        double.tryParse(_totalAmountCtrl.text.trim()) ?? 0;
    final advance =
        double.tryParse(_advancePaidCtrl.text.trim()) ?? 0;

    if (widget.existingExpenseId == null) {
      context.read<ExpenseBloc>().add(ExpenseSubmit(
            eventId:       _selectedEventId!,
            expenseTypeId: _selectedExpenseTypeId!,
            vendorId:      _selectedVendorId!,
            hodId:         _selectedHodId!,
            totalAmount:   total,
            advancePaid:   advance,
            paymentStatus: _paymentStatus,
            billFile:      _billFile!,
          ));
    } else {
      context.read<ExpenseBloc>().add(ExpenseResubmit(
            expenseRequestId: widget.existingExpenseId!,
            eventId:          _selectedEventId!,
            expenseTypeId:    _selectedExpenseTypeId!,
            vendorId:         _selectedVendorId!,
            hodId:            _selectedHodId!,
            totalAmount:      total,
            advancePaid:      advance,
            paymentStatus:    _paymentStatus,
            newBillFile:      _billFile,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingExpenseId == null
            ? 'Submit Expense'
            : 'Resubmit Expense'),
      ),
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Expense submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
          if (state is ExpenseFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ExpenseLoading ||
              state is ExpenseInitial) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (state is ExpenseFormReady) {
            return _buildForm(context, state);
          }

          if (state is ExpenseFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<ExpenseBloc>()
                        .add(const ExpenseLoadFormData()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(
              child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildForm(
      BuildContext context, ExpenseFormReady formData) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Event ───────────────────────────────────
          _SectionLabel('Event *'),
          DropdownButtonFormField<String>(
            value: _selectedEventId,
            decoration: const InputDecoration(
                hintText: 'Select Event'),
            items: formData.events
                .map((e) => DropdownMenuItem(
                      value: e['id'] as String,
                      child: Text(e['name'] as String),
                    ))
                .toList(),
            onChanged: (v) =>
                setState(() => _selectedEventId = v),
            validator: (v) =>
                v == null ? 'Please select an event' : null,
          ),

          const SizedBox(height: 16),

          // ── Expense Type ─────────────────────────────
          _SectionLabel('Expense Type *'),
          DropdownButtonFormField<String>(
            value: _selectedExpenseTypeId,
            decoration: const InputDecoration(
                hintText: 'Select Expense Type'),
            items: formData.expenseTypes
                .map((e) => DropdownMenuItem(
                      value: e['id'] as String,
                      child: Text(e['name'] as String),
                    ))
                .toList(),
            onChanged: (v) =>
                setState(() => _selectedExpenseTypeId = v),
            validator: (v) => v == null
                ? 'Please select an expense type'
                : null,
          ),

          const SizedBox(height: 16),

          // ── Vendor ───────────────────────────────────
          _SectionLabel('Vendor *'),
          DropdownButtonFormField<String>(
            value: _selectedVendorId,
            decoration: const InputDecoration(
                hintText: 'Select Vendor'),
            items: formData.vendors
                .map((e) => DropdownMenuItem(
                      value: e['id'] as String,
                      child: Text(e['name'] as String),
                    ))
                .toList(),
            onChanged: (v) =>
                setState(() => _selectedVendorId = v),
            validator: (v) =>
                v == null ? 'Please select a vendor' : null,
          ),

          const SizedBox(height: 16),

          // ── HOD ──────────────────────────────────────
          _SectionLabel('Select HOD *'),
          DropdownButtonFormField<String>(
            value: _selectedHodId,
            decoration: const InputDecoration(
                hintText: 'Select HOD'),
            items: formData.hodList
                .map((e) => DropdownMenuItem(
                      value: e['id'] as String,
                      child: Text(e['full_name'] as String),
                    ))
                .toList(),
            onChanged: (v) =>
                setState(() => _selectedHodId = v),
            validator: (v) =>
                v == null ? 'Please select a HOD' : null,
          ),

          const SizedBox(height: 16),

          // ── Total Amount ──────────────────────────────
          _SectionLabel('Total Amount (INR) *'),
          TextFormField(
            controller: _totalAmountCtrl,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true),
            decoration: const InputDecoration(
              prefixText: '₹ ',
              hintText: '0.00',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Enter total amount';
              }
              if (double.tryParse(v.trim()) == null) {
                return 'Enter a valid amount';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // ── Advance Paid ──────────────────────────────
          _SectionLabel('Advance Paid (INR)'),
          TextFormField(
            controller: _advancePaidCtrl,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true),
            decoration: const InputDecoration(
              prefixText: '₹ ',
              hintText: '0.00',
            ),
            validator: (v) {
              if (v != null && v.trim().isNotEmpty) {
                if (double.tryParse(v.trim()) == null) {
                  return 'Enter a valid amount';
                }
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // ── Payment Status ────────────────────────────
          _SectionLabel('Expense Status *'),
          Row(
            children: ExpensePaymentStatus.values.map((status) {
              return Expanded(
                child: RadioListTile<ExpensePaymentStatus>(
                  title: Text(status.label,
                      style: const TextStyle(fontSize: 13)),
                  value: status,
                  groupValue: _paymentStatus,
                  onChanged: (v) =>
                      setState(() => _paymentStatus = v!),
                  contentPadding: EdgeInsets.zero,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // ── Bill Attachment ───────────────────────────
          _SectionLabel('Bill Attachment *'),
          InkWell(
            onTap: _pickFile,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _billFile != null
                      ? Colors.green
                      : Theme.of(context).colorScheme.outline,
                  width: _billFile != null ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(10),
                color: _billFile != null
                    ? Colors.green.withValues(alpha: 0.05)
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    _billFile != null
                        ? Icons.check_circle_rounded
                        : Icons.upload_file_rounded,
                    color: _billFile != null
                        ? Colors.green
                        : Theme.of(context)
                            .colorScheme
                            .primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _billFile != null
                          ? _billFile!.path.split('/').last
                          : 'Tap to upload bill (PDF/JPG/PNG)',
                      style: TextStyle(
                        color: _billFile != null
                            ? Colors.green
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  if (_billFile != null)
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.red, size: 18),
                      onPressed: () =>
                          setState(() => _billFile = null),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ── Submit Button ─────────────────────────────
          ElevatedButton.icon(
            onPressed: () {
              final state = context.read<ExpenseBloc>().state;
              if (state is ExpenseFormReady) _submit(state);
            },
            icon: const Icon(Icons.send_rounded),
            label: Text(widget.existingExpenseId == null
                ? 'Submit Expense'
                : 'Resubmit Expense'),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}