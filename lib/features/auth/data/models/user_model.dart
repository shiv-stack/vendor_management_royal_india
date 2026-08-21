// lib/features/auth/data/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/constants/app_constants.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String fullName,
    required String role,
    String? fcmToken,
    @Default(true) bool isActive,
    String? createdAt,
    String? updatedAt,
    // Unique employee login ID (e.g. RIV001). Nullable for legacy rows.
    String? employeeId,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// Extension — converts raw DB map → UserModel
extension UserModelX on UserModel {
  // DB column names → model fields
  static UserModel fromSupabase(Map<String, dynamic> map) {
    return UserModel(
      id:         map['id']          as String,
      email:      map['email']       as String,
      fullName:   map['full_name']   as String,
      role:       map['role']        as String,
      fcmToken:   map['fcm_token']   as String?,
      isActive:   map['is_active']   as bool? ?? true,
      createdAt:  map['created_at']  as String?,
      updatedAt:  map['updated_at']  as String?,
      employeeId: map['employee_id'] as String?,
    );
  }

  // Model → Domain entity
  UserEntity toEntity() {
    return UserEntity(
      id:         id,
      email:      email,
      fullName:   fullName,
      role:       UserRole.fromString(role),
      fcmToken:   fcmToken,
      isActive:   isActive,
      employeeId: employeeId,
    );
  }
}