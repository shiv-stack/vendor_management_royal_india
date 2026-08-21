// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Look up email by employee_id, then sign in with Supabase Auth.
  Future<UserModel> signIn({
    required String employeeId,
    required String password,
  });
  Future<void> signOut();
  Future<UserModel> getCurrentUser();
  Future<void> updateFcmToken(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  const AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> signIn({
    required String employeeId,
    required String password,
  }) async {
    try {
      // Step 1: Resolve employee_id → email (anon select, only email column)
      final rows = await supabaseClient
          .from(SupabaseConstants.tableProfiles)
          .select('email, employee_id')
          .eq('employee_id', employeeId.trim())
          .limit(1);

      if (rows.isEmpty) {
        throw const AppAuthException(
            message: 'Employee ID not found. Please contact your administrator.');
      }
      final email = rows.first['email'] as String;

      // Step 2: Authenticate with Supabase using the resolved email + password
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const AppAuthException(
            message: 'Sign in failed. No user returned.');
      }

      // Step 3: Fetch full profile (authenticated call)
      final profileData = await supabaseClient
          .from(SupabaseConstants.tableProfiles)
          .select()
          .eq('id', user.id)
          .single();

      return UserModelX.fromSupabase(profileData);
    } on AppAuthException {
      rethrow;
    } catch (e) {
      throw AppAuthException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw AppAuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw const AppAuthException(message: 'No active session.');
      }

      final profileData = await supabaseClient
          .from(SupabaseConstants.tableProfiles)
          .select()
          .eq('id', user.id)
          .single();

      return UserModelX.fromSupabase(profileData);
    } on AppAuthException {
      rethrow;
    } catch (e) {
      throw AppAuthException(message: e.toString());
    }
  }

  @override
  Future<void> updateFcmToken(String token) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return;

      await supabaseClient
          .from(SupabaseConstants.tableProfiles)
          .update({'fcm_token': token})
          .eq('id', user.id);
    } catch (_) {
      // Non-critical — silent fail
    }
  }
}