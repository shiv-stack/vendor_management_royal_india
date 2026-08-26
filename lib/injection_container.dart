// lib/injection_container.dart
//
// Register everything here in order:
//   External → DataSources → Repositories → UseCases → BLoCs
//
// Phase 1: Auth only.
// Phases 2-5 will add more registrations below each section.

import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/services/session_service.dart';
import 'package:vpms_royal_india/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:vpms_royal_india/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:vpms_royal_india/features/admin/domain/repositories/admin_repository.dart';
import 'package:vpms_royal_india/features/admin/domain/usecases/event_usecases.dart';
import 'package:vpms_royal_india/features/admin/domain/usecases/expense_type_usecases.dart';
import 'package:vpms_royal_india/features/admin/domain/usecases/vendor_usecases.dart';
import 'package:vpms_royal_india/features/admin/presentation/bloc/event_bloc.dart';
import 'package:vpms_royal_india/features/admin/presentation/bloc/expense_type_bloc.dart';
import 'package:vpms_royal_india/features/admin/presentation/bloc/user_management_bloc.dart';
import 'package:vpms_royal_india/features/admin/presentation/bloc/vendor_bloc.dart';
import 'package:vpms_royal_india/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:vpms_royal_india/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:vpms_royal_india/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:vpms_royal_india/features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'package:vpms_royal_india/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:vpms_royal_india/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:vpms_royal_india/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:vpms_royal_india/features/expense/domain/repositories/expense_repository.dart';
import 'package:vpms_royal_india/features/expense/domain/usecases/expense_usecases.dart';
import 'package:vpms_royal_india/features/expense/domain/usecases/payment_usecases.dart';
import 'package:vpms_royal_india/features/expense/presentation/bloc/approval_bloc.dart';
import 'package:vpms_royal_india/features/expense/presentation/bloc/expense_bloc.dart';

import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── Session cache (must run before router is created) ─────
  // Restores the role from shared_preferences so the router guard has a
  // valid cachedRole immediately on cold start / browser restore.
  await SessionService.instance.init();

  // ── External ──────────────────────────────────────────────
  sl.registerLazySingleton<SupabaseClient>(
    () => Supabase.instance.client,
  );

  // ── Auth Feature ──────────────────────────────────────────
  _registerAuth();

  // ── Phase 2 will add: ─────────────────────────────────────
  _registerAdmin();

  // ── Phase 3 will add: ─────────────────────────────────────
  _registerExpense();

  // ── Phase 4 will add: ─────────────────────────────────────
  // _registerPayments();

  // ── Phase 5 will add: ─────────────────────────────────────
  _registerDashboard();
}

void _registerDashboard() {
  // DataSource
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => DashboardBloc(
        getEventSummaries: sl(),
        getExpenseDetails: sl(),
      ));

  // UseCases
  sl.registerLazySingleton(() => GetEventSummariesUseCase(sl()));
  sl.registerLazySingleton(() => GetExpenseDetailsUseCase(sl()));
}

void _registerAuth() {
  // DataSource
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // BLoC — registerFactory gives a fresh instance each time
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
    ),
  );
}

// Add this new function:
void _registerAdmin() {
  // DataSource
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases — Events
  sl.registerLazySingleton(() => GetEventsUseCase(sl()));
  sl.registerLazySingleton(() => CreateEventUseCase(sl()));
  sl.registerLazySingleton(() => UpdateEventUseCase(sl()));
  sl.registerLazySingleton(() => DeleteEventUseCase(sl()));

  // UseCases — Expense Types
  sl.registerLazySingleton(() => GetExpenseTypesUseCase(sl()));
  sl.registerLazySingleton(() => CreateExpenseTypeUseCase(sl()));
  sl.registerLazySingleton(() => UpdateExpenseTypeUseCase(sl()));
  sl.registerLazySingleton(() => DeleteExpenseTypeUseCase(sl()));

  // UseCases — Vendors
  sl.registerLazySingleton(() => GetVendorsUseCase(sl()));
  sl.registerLazySingleton(() => CreateVendorUseCase(sl()));
  sl.registerLazySingleton(() => UpdateVendorUseCase(sl()));
  sl.registerLazySingleton(() => DeleteVendorUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => EventBloc(
        getEvents: sl(),
        createEvent: sl(),
        updateEvent: sl(),
        deleteEvent: sl(),
      ));

  sl.registerFactory(() => ExpenseTypeBloc(
        getExpenseTypes: sl(),
        createExpenseType: sl(),
        updateExpenseType: sl(),
        deleteExpenseType: sl(),
      ));

  sl.registerFactory(() => VendorBloc(
        getVendors: sl(),
        createVendor: sl(),
        updateVendor: sl(),
        deleteVendor: sl(),
      ));

  sl.registerFactory(() => UserManagementBloc(repository: sl()));
}

void _registerExpense() {
  // DataSource
  sl.registerLazySingleton<ExpenseRemoteDataSource>(
    () => ExpenseRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => UploadBillAttachmentUseCase(sl()));
  sl.registerLazySingleton(() => SubmitExpenseUseCase(sl()));
  sl.registerLazySingleton(() => ResubmitExpenseUseCase(sl()));
  sl.registerLazySingleton(() => GetEmployeeExpensesUseCase(sl()));
  sl.registerLazySingleton(() => GetAssignedExpensesUseCase(sl()));
  sl.registerLazySingleton(() => ApproveExpenseUseCase(sl()));
  sl.registerLazySingleton(() => RejectExpenseUseCase(sl()));
  sl.registerLazySingleton(() => ReApproveExpenseUseCase(sl()));
  sl.registerLazySingleton(() => GetAccountsQueueUseCase(sl()));
  sl.registerLazySingleton(() => ReturnToHodUseCase(sl()));
  sl.registerLazySingleton(() => GetHodListUseCase(sl()));
  sl.registerLazySingleton(() => GetMdUserUseCase(sl()));
  sl.registerLazySingleton(() => UploadPaymentScreenshotUseCase(sl()));
  sl.registerLazySingleton(() => ProcessPaymentUseCase(sl()));
  sl.registerLazySingleton(() => GetPaymentsForExpenseUseCase(sl()));
  sl.registerLazySingleton(() => GetHodHistoryExpensesUseCase(sl()));

// Add inside _registerExpense() after usecases:

  sl.registerFactory(() => ExpenseBloc(
        submitExpense: sl(),
        resubmitExpense: sl(),
        getEmployeeExpenses: sl(),
        uploadBill: sl(),
        getHodList: sl(),
        getMdUser: sl(),
        fetchEvents: () async {
          final result = await sl<GetEventsUseCase>()();
          return result.fold(
            (_) => [],
            (list) => list
                .map((e) => {
                      'id': e.id,
                      'name': e.name,
                    })
                .toList(),
          );
        },
        fetchExpenseTypes: () async {
          final result = await sl<GetExpenseTypesUseCase>()();
          return result.fold(
            (_) => [],
            (list) => list
                .map((e) => {
                      'id': e.id,
                      'name': e.name,
                    })
                .toList(),
          );
        },
        fetchVendors: () async {
          final result = await sl<GetVendorsUseCase>()();
          return result.fold(
            (_) => [],
            (list) => list
                .map((e) => {
                      'id': e.id,
                      'name': e.name,
                      'pan': e.pan,
                    })
                .toList(),
          );
        },
      ));

  sl.registerFactory(() => ApprovalBloc(
        getAssignedExpenses: sl(),
        approveExpense: sl(),
        rejectExpense: sl(),
        reApproveExpense: sl(),
        getAccountsQueue: sl(),
        returnToHod: sl(),
        processPayment: sl(),
        uploadScreenshot: sl(),
        getPayments: sl(),
        getHodHistoryExpenses: sl(),
      ));
}
