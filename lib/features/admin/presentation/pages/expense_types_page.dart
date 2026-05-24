// lib/features/admin/presentation/pages/expense_types_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/expense_type_entity.dart';
import '../bloc/expense_type_bloc.dart';

class ExpenseTypesPage extends StatelessWidget {
  const ExpenseTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ExpenseTypeBloc>()..add(const ExpenseTypeLoadAll()),
      child: const _ExpenseTypesView(),
    );
  }
}

class _ExpenseTypesView extends StatelessWidget {
  const _ExpenseTypesView();

  void _showDialog(
    BuildContext context, {
    ExpenseTypeEntity? existing,
  }) {
    final nameCtrl =
        TextEditingController(text: existing?.name ?? '');
    final descCtrl =
        TextEditingController(text: existing?.description ?? '');
    bool isActive = existing?.isActive ?? true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(existing == null
              ? 'Create Expense Type'
              : 'Edit Expense Type'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Expense Type Name *',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                  ),
                  maxLines: 2,
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
                if (nameCtrl.text.trim().isEmpty) return;
                if (existing == null) {
                  context.read<ExpenseTypeBloc>().add(
                        ExpenseTypeCreate(
                          name: nameCtrl.text.trim(),
                          description: descCtrl.text.trim().isEmpty
                              ? null
                              : descCtrl.text.trim(),
                        ),
                      );
                } else {
                  context.read<ExpenseTypeBloc>().add(
                        ExpenseTypeUpdate(
                          id: existing.id,
                          name: nameCtrl.text.trim(),
                          description: descCtrl.text.trim().isEmpty
                              ? null
                              : descCtrl.text.trim(),
                          isActive: isActive,
                        ),
                      );
                }
                Navigator.pop(ctx);
              },
              child:
                  Text(existing == null ? 'Create' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, ExpenseTypeEntity type) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense Type'),
        content: Text(
            'Are you sure you want to delete "${type.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red),
            onPressed: () {
              context
                  .read<ExpenseTypeBloc>()
                  .add(ExpenseTypeDelete(id: type.id));
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
      appBar: AppBar(title: const Text('Expense Types')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Type'),
      ),
      body: BlocConsumer<ExpenseTypeBloc, ExpenseTypeState>(
        listener: (context, state) {
          if (state is ExpenseTypeActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ));
          }
          if (state is ExpenseTypeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        },
        builder: (context, state) {
          if (state is ExpenseTypeLoading ||
              state is ExpenseTypeInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          final types = switch (state) {
            ExpenseTypeLoaded(:final expenseTypes) => expenseTypes,
            ExpenseTypeActionSuccess(:final expenseTypes) =>
              expenseTypes,
            _ => <ExpenseTypeEntity>[],
          };

          if (types.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined,
                      size: 64,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text('No expense types yet. Create one!'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: types.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final type = types[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF993C1D)
                        .withValues(alpha: 0.1),
                    child: const Icon(Icons.category_rounded,
                        color: Color(0xFF993C1D)),
                  ),
                  title: Text(type.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600)),
                  subtitle: type.description != null
                      ? Text(type.description!)
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: type.isActive
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          type.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 11,
                            color: type.isActive
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () =>
                            _showDialog(context, existing: type),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.red),
                        onPressed: () =>
                            _confirmDelete(context, type),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}