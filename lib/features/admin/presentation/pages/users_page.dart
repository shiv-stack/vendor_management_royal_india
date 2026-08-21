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

  /// Dialog to assign or update the Employee ID for a (legacy) user.
  void _showEditEmployeeIdDialog(BuildContext context, UserEntity user) {
    final bloc = context.read<UserManagementBloc>();
    final controller = TextEditingController(text: user.employeeId ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogCtx) => BlocProvider.value(
        value: bloc,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6A1B9A).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: Color(0xFF6A1B9A),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Edit Employee ID'),
                    Text(
                      user.fullName,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 320,
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Employee ID',
                  hintText: 'Enter Employee ID',
                  prefixIcon: Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Employee ID is required';
                  }
                  return null;
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A1B9A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  bloc.add(UserManagementUpdateEmployeeId(
                    userId: user.id,
                    employeeId: controller.text.trim(),
                  ));
                  Navigator.of(dialogCtx).pop();
                }
              },
              icon: const Icon(Icons.save_outlined, size: 18),
              label: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateUserDialog(BuildContext context) {
    // ⚠️ Capture the bloc BEFORE showDialog — dialog gets a new route context
    // that is not under the BlocProvider, so we must inject it manually.
    final bloc = context.read<UserManagementBloc>();

    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final employeeIdController = TextEditingController();
    UserRole selectedRole = UserRole.employee;
    bool obscurePassword = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => BlocProvider.value(
        // Inject the existing bloc into the dialog's route context
        value: bloc,
        child: BlocListener<UserManagementBloc, UserManagementState>(
          listener: (_, state) {
            if (state is UserManagementActionSuccess) {
              // Close dialog — SnackBar is shown by the outer page listener
              Navigator.of(dialogCtx).pop();
            }
            // On failure: dialog stays open, SnackBar shown by outer listener
          },
          child: StatefulBuilder(
            builder: (ctx, setState) {
              return BlocBuilder<UserManagementBloc, UserManagementState>(
                builder: (ctx, state) {
                  final isLoading = state is UserManagementLoading;

                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6A1B9A).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.person_add_rounded,
                            color: Color(0xFF6A1B9A),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('Create New User'),
                      ],
                    ),
                    content: SizedBox(
                      width: 360,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Employee ID field (required, auto-uppercase)
                            TextFormField(
                              controller: employeeIdController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: 'Employee ID',
                                hintText: 'Enter Employee ID',
                                prefixIcon: Icon(Icons.badge_outlined),
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Employee ID is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Email field
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              decoration: const InputDecoration(
                                labelText: 'Email address',
                                prefixIcon: Icon(Icons.email_outlined),
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                final emailRegex = RegExp(
                                    r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$');
                                if (!emailRegex.hasMatch(v.trim())) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password field
                            StatefulBuilder(builder: (_, setObscure) {
                              return TextFormField(
                                controller: passwordController,
                                obscureText: obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined),
                                    onPressed: () => setObscure(() =>
                                        obscurePassword = !obscurePassword),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (v.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              );
                            }),
                            const SizedBox(height: 20),

                            // Role selection
                            Text(
                              'Assign Role',
                              style: Theme.of(ctx)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            StatefulBuilder(builder: (_, setRole) {
                              return Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: UserRole.values.map((role) {
                                  final isSelected = selectedRole == role;
                                  final roleColor = _roleColor(role);
                                  return GestureDetector(
                                    onTap: () =>
                                        setRole(() => selectedRole = role),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 180),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? roleColor.withValues(alpha: 0.15)
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isSelected
                                              ? roleColor
                                              : Theme.of(ctx)
                                                  .colorScheme
                                                  .outline
                                                  .withValues(alpha: 0.4),
                                          width: isSelected ? 1.5 : 1,
                                        ),
                                      ),
                                      child: Text(
                                        role.label,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                          color: isSelected
                                              ? roleColor
                                              : Theme.of(ctx)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed:
                            isLoading ? null : () => Navigator.of(dialogCtx).pop(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A1B9A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                if (formKey.currentState?.validate() ?? false) {
                                  ctx
                                      .read<UserManagementBloc>()
                                      .add(UserManagementCreateUser(
                                        email: emailController.text.trim(),
                                        password: passwordController.text,
                                        role: selectedRole,
                                        employeeId: employeeIdController.text
                                            .trim(),
                                      ));
                                }
                              },
                        icon: isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.person_add_rounded, size: 18),
                        label: Text(isLoading ? 'Creating...' : 'Create User'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateUserDialog(context),
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add User'),
        tooltip: 'Create a new user',
      ),
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.email),
                      // Show Employee ID or a warning badge if not yet assigned
                      if (user.employeeId != null)
                        Text(
                          user.employeeId!,
                          style: TextStyle(
                            fontSize: 12,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        const Text(
                          '⚠ No Employee ID assigned',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  isThreeLine: true,
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
                      // Edit role button
                      IconButton(
                        icon: const Icon(Icons.manage_accounts),
                        tooltip: 'Change role',
                        onPressed: () =>
                            _showRoleDialog(context, user),
                      ),
                      // Edit Employee ID button (badge icon)
                      IconButton(
                        icon: Icon(
                          Icons.badge_outlined,
                          color: user.employeeId == null
                              ? Colors.orange
                              : null,
                        ),
                        tooltip: user.employeeId == null
                            ? 'Assign Employee ID'
                            : 'Edit Employee ID',
                        onPressed: () =>
                            _showEditEmployeeIdDialog(context, user),
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