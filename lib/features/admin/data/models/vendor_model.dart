// lib/features/admin/data/models/vendor_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/vendor_entity.dart';

part 'vendor_model.freezed.dart';
part 'vendor_model.g.dart';

@freezed
class VendorModel with _$VendorModel {
  const factory VendorModel({
    required String id,
    required String name,
    required String pan,
    String? bankName,
    String? accountNumber,
    String? ifsc,
    String? contactName,
    String? contactPhone,
    @Default(true) bool isActive,
    required String createdBy,
    String? createdAt,
    String? updatedAt,
  }) = _VendorModel;

  factory VendorModel.fromJson(Map<String, dynamic> json) =>
      _$VendorModelFromJson(json);
}

extension VendorModelX on VendorModel {
  static VendorModel fromSupabase(Map<String, dynamic> map) {
    return VendorModel(
      id:            map['id']             as String,
      name:          map['name']           as String,
      pan:           map['pan']            as String,
      bankName:      map['bank_name']      as String?,
      accountNumber: map['account_number'] as String?,
      ifsc:          map['ifsc']           as String?,
      contactName:   map['contact_name']   as String?,
      contactPhone:  map['contact_phone']  as String?,
      isActive:      map['is_active']      as bool? ?? true,
      createdBy:     map['created_by']     as String,
      createdAt:     map['created_at']     as String?,
      updatedAt:     map['updated_at']     as String?,
    );
  }

  VendorEntity toEntity() => VendorEntity(
        id:            id,
        name:          name,
        pan:           pan,
        bankName:      bankName,
        accountNumber: accountNumber,
        ifsc:          ifsc,
        contactName:   contactName,
        contactPhone:  contactPhone,
        isActive:      isActive,
        createdBy:     createdBy,
        createdAt:     createdAt,
        updatedAt:     updatedAt,
      );
}