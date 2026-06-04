// lib/features/expense/presentation/pages/employee/submit_expense_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../injection_container.dart';
import '../../bloc/expense_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class SubmitExpensePage extends StatelessWidget {
  final String? existingExpenseId; // null = new, set = resubmit
  const SubmitExpensePage({super.key, this.existingExpenseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExpenseBloc>()..add(const ExpenseLoadFormData()),
      child: _SubmitExpenseView(existingExpenseId: existingExpenseId),
    );
  }
}

class _SubmitExpenseView extends StatefulWidget {
  final String? existingExpenseId;
  const _SubmitExpenseView({this.existingExpenseId});

  @override
  State<_SubmitExpenseView> createState() => _SubmitExpenseViewState();
}

class _SubmitExpenseViewState extends State<_SubmitExpenseView> {
  final _formKey = GlobalKey<FormState>();

  // Selected values
  String? _selectedEventId;
  String? _selectedExpenseTypeId;
  String? _selectedVendorId;
  String? _selectedHodId;
  ExpensePaymentStatus _paymentStatus = ExpensePaymentStatus.outstanding;
  // Cross-platform file handling
  File? _billFile; // mobile only
  Uint8List? _billFileBytes; // web only
  String? _billFileName; // both platforms
  String? _billFileExtension; // for upload
  XFile? _pickedXFile; // camera preview
  // Controllers
  final _totalAmountCtrl = TextEditingController();
  final _advancePaidCtrl = TextEditingController();

  final _descriptionCtrl = TextEditingController();

  @override
  void dispose() {
    _totalAmountCtrl.dispose();
    _advancePaidCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    // On web — no camera/gallery distinction, just file picker
    if (kIsWeb) {
      await _pickFromFilesWeb();
      return;
    }
    // On mobile — show bottom sheet
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Upload Bill / Invoice',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      const Icon(Icons.camera_alt_rounded, color: Colors.green),
                ),
                title: const Text('Take Photo'),
                subtitle: const Text('Click bill using camera'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickFromCamera();
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.photo_library_rounded,
                      color: Colors.blue),
                ),
                title: const Text('Choose from Gallery'),
                subtitle: const Text('Select image from gallery'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickFromGallery();
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.folder_rounded, color: Colors.orange),
                ),
                title: const Text('Browse Files'),
                subtitle: const Text('Select PDF or image from files'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickFromFilesMobile();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ── Mobile: Camera ────────────────────────────────────────────
  Future<void> _pickFromCamera() async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (xfile != null) {
      final bytes = await xfile.readAsBytes();
      setState(() {
        _billFile = File(xfile.path);
        _billFileBytes = bytes;
        _billFileName = xfile.name;
        _billFileExtension = xfile.path.split('.').last;
        _pickedXFile = xfile;
      });
    }
  }

  // ── Mobile: Gallery ───────────────────────────────────────────
  Future<void> _pickFromGallery() async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (xfile != null) {
      final bytes = await xfile.readAsBytes();
      setState(() {
        _billFile = File(xfile.path);
        _billFileBytes = bytes;
        _billFileName = xfile.name;
        _billFileExtension = xfile.path.split('.').last;
        _pickedXFile = xfile;
      });
    }
  }

// ── Mobile: File picker ───────────────────────────────────────
  Future<void> _pickFromFilesMobile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      final file = result.files.single;
      setState(() {
        _billFile = File(file.path!);
        _billFileBytes = file.bytes;
        _billFileName = file.name;
        _billFileExtension = file.extension ?? 'jpg';
        _pickedXFile = null; // not from camera
      });
    }
  }

// ── Web: File picker (bytes only) ─────────────────────────────
  Future<void> _pickFromFilesWeb() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true, // critical for web — loads bytes
    );
    if (result != null) {
      final file = result.files.single;
      setState(() {
        _billFile = null; // no path on web
        _billFileBytes = file.bytes;
        _billFileName = file.name;
        _billFileExtension = file.extension ?? 'jpg';
        _pickedXFile = null;
      });
    }
  }

  void _submit(ExpenseFormReady formData) {
    if (!_formKey.currentState!.validate()) return;
    final hasFile = kIsWeb ? (_billFileBytes != null) : (_billFile != null);

    if (!hasFile) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please attach a bill document.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final total = double.tryParse(_totalAmountCtrl.text.trim()) ?? 0;
    final advance = double.tryParse(_advancePaidCtrl.text.trim()) ?? 0;

    if (widget.existingExpenseId == null) {
      context.read<ExpenseBloc>().add(ExpenseSubmit(
            eventId: _selectedEventId!,
            expenseTypeId: _selectedExpenseTypeId!,
            vendorId: _selectedVendorId!,
            hodId: _selectedHodId!,
            totalAmount: total,
            advancePaid: advance,
            paymentStatus: _paymentStatus,
            description: _descriptionCtrl.text.trim(),
            billFile: kIsWeb ? null : _billFile,
            billFileBytes: _billFileBytes,
            billFileExtension: _billFileExtension ?? 'jpg',
          ));
    } else {
      context.read<ExpenseBloc>().add(ExpenseResubmit(
            expenseRequestId: widget.existingExpenseId!,
            eventId: _selectedEventId!,
            expenseTypeId: _selectedExpenseTypeId!,
            vendorId: _selectedVendorId!,
            hodId: _selectedHodId!,
            totalAmount: total,
            advancePaid: advance,
            paymentStatus: _paymentStatus,
            description:       _descriptionCtrl.text.trim(), 
            newBillFile: _billFile,
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
          if (state is ExpenseLoading || state is ExpenseInitial) {
            return const Center(child: CircularProgressIndicator());
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

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, ExpenseFormReady formData) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Event ───────────────────────────────────
          _SectionLabel('Event *'),
          DropdownButtonFormField<String>(
            value: _selectedEventId,
            decoration: const InputDecoration(hintText: 'Select Event'),
            items: formData.events
                .map((e) => DropdownMenuItem(
                      value: e['id'] as String,
                      child: Text(e['name'] as String),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _selectedEventId = v),
            validator: (v) => v == null ? 'Please select an event' : null,
          ),

          const SizedBox(height: 16),

          // ── Expense Type ─────────────────────────────
          _SectionLabel('Expense Type *'),
          DropdownButtonFormField<String>(
            value: _selectedExpenseTypeId,
            decoration: const InputDecoration(hintText: 'Select Expense Type'),
            items: formData.expenseTypes
                .map((e) => DropdownMenuItem(
                      value: e['id'] as String,
                      child: Text(e['name'] as String),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _selectedExpenseTypeId = v),
            validator: (v) =>
                v == null ? 'Please select an expense type' : null,
          ),

          const SizedBox(height: 16),

          // ── Vendor ───────────────────────────────────
          _SectionLabel('Vendor *'),
          DropdownButtonFormField<String>(
            value: _selectedVendorId,
            decoration: const InputDecoration(hintText: 'Select Vendor'),
            items: formData.vendors
                .map((e) => DropdownMenuItem(
                      value: e['id'] as String,
                      child: Text(e['name'] as String),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _selectedVendorId = v),
            validator: (v) => v == null ? 'Please select a vendor' : null,
          ),

          const SizedBox(height: 16),

          // ── HOD ──────────────────────────────────────
          _SectionLabel('Select HOD *'),
          DropdownButtonFormField<String>(
            value: _selectedHodId,
            decoration: const InputDecoration(hintText: 'Select HOD'),
            items: formData.hodList
                .map((e) => DropdownMenuItem(
                      value: e['id'] as String,
                      child: Text(e['full_name'] as String),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _selectedHodId = v),
            validator: (v) => v == null ? 'Please select a HOD' : null,
          ),

          const SizedBox(height: 16),

          // ── Total Amount ──────────────────────────────
          _SectionLabel('Total Amount (INR) *'),
          TextFormField(
            controller: _totalAmountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                  title:
                      Text(status.label, style: const TextStyle(fontSize: 13)),
                  value: status,
                  groupValue: _paymentStatus,
                  onChanged: (v) => setState(() => _paymentStatus = v!),
                  contentPadding: EdgeInsets.zero,
                ),
              );
            }).toList(),
          ),

          //des
          _SectionLabel('Description of Expense *'),
          TextFormField(
            controller: _descriptionCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe the expense in detail'
                  ' (minimum 15 words)',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Please enter a description';
              }
              final wordCount = v
                  .trim()
                  .split(RegExp(r'\s+'))
                  .where((w) => w.isNotEmpty)
                  .length;
              if (wordCount < 15) {
                return 'Minimum 15 words required ($wordCount entered)';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          const SizedBox(height: 16),

          // ── Bill Attachment ───────────────────────────────────────────
          _SectionLabel('Bill Attachment *'),

// Preview image if picked from camera or gallery
          if (_pickedXFile != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: kIsWeb
                  ? Image.memory(
                      _billFileBytes!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      _billFile!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: Colors.green, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _billFileName ?? 'Photo captured',
                    style: const TextStyle(color: Colors.green, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Change'),
                  style: TextButton.styleFrom(foregroundColor: Colors.orange),
                ),
              ],
            ),
          ] else ...[
            InkWell(
              onTap: _pickFile,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: (_billFile != null || _billFileBytes != null)
                        ? Colors.green
                        : Theme.of(context).colorScheme.outline,
                    width:
                        (_billFile != null || _billFileBytes != null) ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: (_billFile != null || _billFileBytes != null)
                      ? Colors.green.withValues(alpha: 0.05)
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      (_billFile != null || _billFileBytes != null)
                          ? Icons.check_circle_rounded
                          : Icons.upload_file_rounded,
                      color: (_billFile != null || _billFileBytes != null)
                          ? Colors.green
                          : Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _billFileName ?? 'Tap to upload bill (PDF/JPG/PNG)',
                        style: TextStyle(
                          color: (_billFile != null || _billFileBytes != null)
                              ? Colors.green
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_billFile != null || _billFileBytes != null)
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.red, size: 18),
                        onPressed: () => setState(() {
                          _billFile = null;
                          _billFileBytes = null;
                          _billFileName = null;
                          _billFileExtension = null;
                          _pickedXFile = null;
                        }),
                      ),
                  ],
                ),
              ),
            ),
          ],

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
