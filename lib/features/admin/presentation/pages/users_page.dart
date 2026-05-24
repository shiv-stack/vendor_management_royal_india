// lib/features/admin/presentation/pages/users_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../bloc/user_management_bloc.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UserManagementBloc>()
        ..add(const UserManagementLoadAll()),
      child: const _UsersView(),
    );
  }
}

class _UsersView extends StatelessWidget {
  const _UsersView();

  void _showRoleDialog(BuildContext context, UserEntity user) {
    UserRole selectedRole = user.role;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text('Update Role — ${user.fullName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: UserRole.values.map((role) {
              return RadioListTile<UserRole>(
                title: Text(role.label),
                value: role,
                groupValue: selectedRole,
                onChanged: (v) =>
                    setState(() => selectedRole = v!),
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<UserManagementBloc>().add(
                      UserManagementUpdateRole(
                        userId: user.id,
                        role: selectedRole,
                      ),
                    );
                Navigator.pop(ctx);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Color _roleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:    return const Color(0xFF993C1D);
      case UserRole.employee: return const Color(0xFF1565C0);
      case UserRole.hod:      return const Color(0xFF0F6E56);
      case UserRole.md:       return const Color(0xFF6A1B9A);
      case UserRole.accounts: return const Color(0xFFE65100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: BlocConsumer<UserManagementBloc, UserManagementState>(
        listener: (context, state) {
          if (state is UserManagementActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ));
          }
          if (state is UserManagementFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        },
        builder: (context, state) {
          if (state is UserManagementLoading ||
              state is UserManagementInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = switch (state) {
            UserManagementLoaded(:final users) => users,
            UserManagementActionSuccess(:final users) => users,
            _ => <UserEntity>[],
          };

          if (users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final user = users[index];
              final color = _roleColor(user.role);
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Text(
                      user.fullName.isNotEmpty
                          ? user.fullName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                          color: color, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(user.fullName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600)),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: color.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          user.role.label,
                          style: TextStyle(
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Switch(
                        value: user.isActive,
                        onChanged: (v) {
                          context.read<UserManagementBloc>().add(
                                UserManagementToggleActive(
                                  userId: user.id,
                                  isActive: v,
                                ),
                              );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.manage_accounts),
                        onPressed: () =>
                            _showRoleDialog(context, user),
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