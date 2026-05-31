// lib/features/admin/domain/entities/vendor_entity.dart
import 'package:equatable/equatable.dart';

class VendorEntity extends Equatable {
  final String id;
  final String name;
  final String pan;
  final String? bankName;
  final String? accountNumber;
  final String? ifsc;
  final String? contactName;
  final String? contactPhone;
  final String? gstNumber;
  final bool isActive;
  final String createdBy;
  final String? createdAt;
  final String? updatedAt;

  const VendorEntity({
    required this.id,
    required this.name,
    required this.pan,
    this.bankName,
    this.accountNumber,
    this.ifsc,
    this.contactName,
    this.contactPhone,
    this.gstNumber,
    this.isActive = true,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
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
        gstNumber,
        isActive,
        createdBy,
        createdAt,
        updatedAt,
      ];
}