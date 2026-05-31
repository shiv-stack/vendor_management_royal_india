// lib/features/admin/presentation/pages/vendors_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/vendor_entity.dart';
import '../bloc/vendor_bloc.dart';

class VendorsPage extends StatelessWidget {
  const VendorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VendorBloc>()..add(const VendorLoadAll()),
      child: const _VendorsView(),
    );
  }
}

class _VendorsView extends StatelessWidget {
  const _VendorsView();

  void _showDialog(BuildContext context, {VendorEntity? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final panCtrl = TextEditingController(text: existing?.pan ?? '');
    final bankCtrl = TextEditingController(text: existing?.bankName ?? '');
    final accCtrl = TextEditingController(text: existing?.accountNumber ?? '');
    final ifscCtrl = TextEditingController(text: existing?.ifsc ?? '');
    final contactNameCtrl =
        TextEditingController(text: existing?.contactName ?? '');
    final contactPhoneCtrl =
        TextEditingController(text: existing?.contactPhone ?? '');
    bool isActive = existing?.isActive ?? true;
    final gstCtrl = TextEditingController(text: existing?.gstNumber ?? '');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(existing == null ? 'Create Vendor' : 'Edit Vendor'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Vendor Name *'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: panCtrl,
                  decoration: const InputDecoration(labelText: 'PAN *'),
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bankCtrl,
                  decoration: const InputDecoration(labelText: 'Bank Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: accCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Account Number'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ifscCtrl,
                  decoration: const InputDecoration(labelText: 'IFSC Code'),
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contactNameCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Contact Person'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contactPhoneCtrl,
                  decoration: const InputDecoration(labelText: 'Contact Phone'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: gstCtrl,
                  decoration: const InputDecoration(
                    labelText: 'GST Number',
                    hintText: 'e.g. 22AAAAA0000A1Z5',
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
                if (existing != null) ...[
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Active'),
                    value: isActive,
                    onChanged: (v) => setState(() => isActive = v),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
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
                if (nameCtrl.text.trim().isEmpty || panCtrl.text.trim().isEmpty)
                  return;
                if (existing == null) {
                  context.read<VendorBloc>().add(VendorCreate(
                        name: nameCtrl.text.trim(),
                        pan: panCtrl.text.trim(),
                        bankName: bankCtrl.text.trim().isEmpty
                            ? null
                            : bankCtrl.text.trim(),
                        accountNumber: accCtrl.text.trim().isEmpty
                            ? null
                            : accCtrl.text.trim(),
                        ifsc: ifscCtrl.text.trim().isEmpty
                            ? null
                            : ifscCtrl.text.trim(),
                        contactName: contactNameCtrl.text.trim().isEmpty
                            ? null
                            : contactNameCtrl.text.trim(),
                        contactPhone: contactPhoneCtrl.text.trim().isEmpty
                            ? null
                            : contactPhoneCtrl.text.trim(),
                        gstNumber: gstCtrl.text.trim().isEmpty
                            ? null
                            : gstCtrl.text.trim(),
                      ));
                } else {
                  context.read<VendorBloc>().add(VendorUpdate(
                        id: existing.id,
                        name: nameCtrl.text.trim(),
                        pan: panCtrl.text.trim(),
                        bankName: bankCtrl.text.trim().isEmpty
                            ? null
                            : bankCtrl.text.trim(),
                        accountNumber: accCtrl.text.trim().isEmpty
                            ? null
                            : accCtrl.text.trim(),
                        ifsc: ifscCtrl.text.trim().isEmpty
                            ? null
                            : ifscCtrl.text.trim(),
                        contactName: contactNameCtrl.text.trim().isEmpty
                            ? null
                            : contactNameCtrl.text.trim(),
                        contactPhone: contactPhoneCtrl.text.trim().isEmpty
                            ? null
                            : contactPhoneCtrl.text.trim(),
                        isActive: isActive,
                      ));
                }
                Navigator.pop(ctx);
              },
              child: Text(existing == null ? 'Create' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, VendorEntity vendor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Vendor'),
        content: Text('Are you sure you want to delete "${vendor.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<VendorBloc>().add(VendorDelete(id: vendor.id));
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendors')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Vendor'),
      ),
      body: BlocConsumer<VendorBloc, VendorState>(
        listener: (context, state) {
          if (state is VendorActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ));
          }
          if (state is VendorFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        },
        builder: (context, state) {
          if (state is VendorLoading || state is VendorInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          final vendors = switch (state) {
            VendorLoaded(:final vendors) => vendors,
            VendorActionSuccess(:final vendors) => vendors,
            _ => <VendorEntity>[],
          };

          if (vendors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.store_outlined,
                      size: 64,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text('No vendors yet. Create one!'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vendors.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final vendor = vendors[index];
              return Card(
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        const Color(0xFF1565C0).withValues(alpha: 0.1),
                    child: const Icon(Icons.store_rounded,
                        color: Color(0xFF1565C0)),
                  ),
                  title: Text(vendor.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('PAN: ${vendor.pan}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: vendor.isActive
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          vendor.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 11,
                            color: vendor.isActive ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _showDialog(context, existing: vendor),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _confirmDelete(context, vendor),
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          if (vendor.bankName != null)
                            _InfoRow('Bank', vendor.bankName!),
                          if (vendor.accountNumber != null)
                            _InfoRow('Account', vendor.accountNumber!),
                          if (vendor.ifsc != null)
                            _InfoRow('IFSC', vendor.ifsc!),
                          if (vendor.contactName != null)
                            _InfoRow('Contact', vendor.contactName!),
                          if (vendor.contactPhone != null)
                            _InfoRow('Phone', vendor.contactPhone!),
                          if (vendor.gstNumber != null)
                            _InfoRow('GST', vendor.gstNumber!),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                    fontSize: 13)),
          ),
          Expanded(
              child: Text(value,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
