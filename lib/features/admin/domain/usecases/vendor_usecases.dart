// lib/features/admin/domain/usecases/vendor_usecases.dart
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/vendor_entity.dart';
import '../repositories/admin_repository.dart';

// ── Get All Vendors ───────────────────────────────────────────
class GetVendorsUseCase implements NoParamsUseCase<List<VendorEntity>> {
  final AdminRepository repository;
  const GetVendorsUseCase(this.repository);

  @override
  Future<Either<Failure, List<VendorEntity>>> call() =>
      repository.getVendors();
}

// ── Create Vendor ─────────────────────────────────────────────
class CreateVendorUseCase
    implements UseCase<VendorEntity, CreateVendorParams> {
  final AdminRepository repository;
  const CreateVendorUseCase(this.repository);

  @override
  Future<Either<Failure, VendorEntity>> call(CreateVendorParams params) =>
      repository.createVendor(
        name: params.name,
        pan: params.pan,
        bankName: params.bankName,
        accountNumber: params.accountNumber,
        ifsc: params.ifsc,
        contactName: params.contactName,
        contactPhone: params.contactPhone,
      );
}

class CreateVendorParams extends Equatable {
  final String name;
  final String pan;
  final String? bankName;
  final String? accountNumber;
  final String? ifsc;
  final String? contactName;
  final String? contactPhone;

  const CreateVendorParams({
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
        name,
        pan,
        bankName,
        accountNumber,
        ifsc,
        contactName,
        contactPhone,
      ];
}

// ── Update Vendor ─────────────────────────────────────────────
class UpdateVendorUseCase
    implements UseCase<VendorEntity, UpdateVendorParams> {
  final AdminRepository repository;
  const UpdateVendorUseCase(this.repository);

  @override
  Future<Either<Failure, VendorEntity>> call(UpdateVendorParams params) =>
      repository.updateVendor(
        id: params.id,
        name: params.name,
        pan: params.pan,
        bankName: params.bankName,
        accountNumber: params.accountNumber,
        ifsc: params.ifsc,
        contactName: params.contactName,
        contactPhone: params.contactPhone,
        isActive: params.isActive,
      );
}

class UpdateVendorParams extends Equatable {
  final String id;
  final String name;
  final String pan;
  final String? bankName;
  final String? accountNumber;
  final String? ifsc;
  final String? contactName;
  final String? contactPhone;
  final bool isActive;

  const UpdateVendorParams({
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
        id,
        name,
        pan,
        bankName,
        accountNumber,
        ifsc,
        contactName,
        contactPhone,
        isActive,
      ];
}

// ── Delete Vendor ─────────────────────────────────────────────
class DeleteVendorUseCase implements UseCase<Unit, String> {
  final AdminRepository repository;
  const DeleteVendorUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) =>
      repository.deleteVendor(id);
}