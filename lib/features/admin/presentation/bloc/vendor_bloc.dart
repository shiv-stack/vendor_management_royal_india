// lib/features/admin/presentation/bloc/vendor_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/vendor_entity.dart';
import '../../domain/usecases/vendor_usecases.dart';

// ── Events ────────────────────────────────────────────────────
abstract class VendorEvent extends Equatable {
  const VendorEvent();
  @override
  List<Object?> get props => [];
}

class VendorLoadAll extends VendorEvent {
  const VendorLoadAll();
}

class VendorCreate extends VendorEvent {
  final String name;
  final String pan;
  final String? bankName;
  final String? accountNumber;
  final String? ifsc;
  final String? contactName;
  final String? contactPhone;

  const VendorCreate({
    required this.name,
    required this.pan,
    this.bankName,
    this.accountNumber,
    this.ifsc,
    this.contactName,
    this.contactPhone,
  });

  @override
  List<Object?> get props => [
        name, pan, bankName,
        accountNumber, ifsc,
        contactName, contactPhone,
      ];
}

class VendorUpdate extends VendorEvent {
  final String id;
  final String name;
  final String pan;
  final String? bankName;
  final String? accountNumber;
  final String? ifsc;
  final String? contactName;
  final String? contactPhone;
  final bool isActive;

  const VendorUpdate({
    required this.id,
    required this.name,
    required this.pan,
    this.bankName,
    this.accountNumber,
    this.ifsc,
    this.contactName,
    this.contactPhone,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id, name, pan, bankName,
        accountNumber, ifsc,
        contactName, contactPhone, isActive,
      ];
}

class VendorDelete extends VendorEvent {
  final String id;
  const VendorDelete({required this.id});
  @override
  List<Object?> get props => [id];
}

// ── States ────────────────────────────────────────────────────
abstract class VendorState extends Equatable {
  const VendorState();
  @override
  List<Object?> get props => [];
}

class VendorInitial extends VendorState {
  const VendorInitial();
}

class VendorLoading extends VendorState {
  const VendorLoading();
}

class VendorLoaded extends VendorState {
  final List<VendorEntity> vendors;
  const VendorLoaded({required this.vendors});
  @override
  List<Object?> get props => [vendors];
}

class VendorActionSuccess extends VendorState {
  final String message;
  final List<VendorEntity> vendors;
  const VendorActionSuccess({
    required this.message,
    required this.vendors,
  });
  @override
  List<Object?> get props => [message, vendors];
}

class VendorFailure extends VendorState {
  final String message;
  const VendorFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

// ── BLoC ──────────────────────────────────────────────────────
class VendorBloc extends Bloc<VendorEvent, VendorState> {
  final GetVendorsUseCase getVendors;
  final CreateVendorUseCase createVendor;
  final UpdateVendorUseCase updateVendor;
  final DeleteVendorUseCase deleteVendor;

  VendorBloc({
    required this.getVendors,
    required this.createVendor,
    required this.updateVendor,
    required this.deleteVendor,
  }) : super(const VendorInitial()) {
    on<VendorLoadAll>(_onLoadAll);
    on<VendorCreate>(_onCreate);
    on<VendorUpdate>(_onUpdate);
    on<VendorDelete>(_onDelete);
  }

  Future<void> _onLoadAll(
    VendorLoadAll event,
    Emitter<VendorState> emit,
  ) async {
    emit(const VendorLoading());
    final result = await getVendors();
    result.fold(
      (f) => emit(VendorFailure(message: f.message)),
      (vendors) => emit(VendorLoaded(vendors: vendors)),
    );
  }

  Future<void> _onCreate(
    VendorCreate event,
    Emitter<VendorState> emit,
  ) async {
    emit(const VendorLoading());
    final result = await createVendor(
      CreateVendorParams(
        name: event.name,
        pan: event.pan,
        bankName: event.bankName,
        accountNumber: event.accountNumber,
        ifsc: event.ifsc,
        contactName: event.contactName,
        contactPhone: event.contactPhone,
      ),
    );
    await result.fold(
      (f) async => emit(VendorFailure(message: f.message)),
      (_) async {
        final listResult = await getVendors();
        listResult.fold(
          (f) => emit(VendorFailure(message: f.message)),
          (vendors) => emit(VendorActionSuccess(
              message: 'Vendor created successfully.',
              vendors: vendors)),
        );
      },
    );
  }

  Future<void> _onUpdate(
    VendorUpdate event,
    Emitter<VendorState> emit,
  ) async {
    emit(const VendorLoading());
    final result = await updateVendor(
      UpdateVendorParams(
        id: event.id,
        name: event.name,
        pan: event.pan,
        bankName: event.bankName,
        accountNumber: event.accountNumber,
        ifsc: event.ifsc,
        contactName: event.contactName,
        contactPhone: event.contactPhone,
        isActive: event.isActive,
      ),
    );
    await result.fold(
      (f) async => emit(VendorFailure(message: f.message)),
      (_) async {
        final listResult = await getVendors();
        listResult.fold(
          (f) => emit(VendorFailure(message: f.message)),
          (vendors) => emit(VendorActionSuccess(
              message: 'Vendor updated successfully.',
              vendors: vendors)),
        );
      },
    );
  }

  Future<void> _onDelete(
    VendorDelete event,
    Emitter<VendorState> emit,
  ) async {
    emit(const VendorLoading());
    final result = await deleteVendor(event.id);
    await result.fold(
      (f) async => emit(VendorFailure(message: f.message)),
      (_) async {
        final listResult = await getVendors();
        listResult.fold(
          (f) => emit(VendorFailure(message: f.message)),
          (vendors) => emit(VendorActionSuccess(
              message: 'Vendor deleted successfully.',
              vendors: vendors)),
        );
      },
    );
  }
}