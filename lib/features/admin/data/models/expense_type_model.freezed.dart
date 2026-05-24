// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExpenseTypeModel _$ExpenseTypeModelFromJson(Map<String, dynamic> json) {
  return _ExpenseTypeModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseTypeModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ExpenseTypeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseTypeModelCopyWith<ExpenseTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseTypeModelCopyWith<$Res> {
  factory $ExpenseTypeModelCopyWith(
          ExpenseTypeModel value, $Res Function(ExpenseTypeModel) then) =
      _$ExpenseTypeModelCopyWithImpl<$Res, ExpenseTypeModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      bool isActive,
      String createdBy,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class _$ExpenseTypeModelCopyWithImpl<$Res, $Val extends ExpenseTypeModel>
    implements $ExpenseTypeModelCopyWith<$Res> {
  _$ExpenseTypeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? createdBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseTypeModelImplCopyWith<$Res>
    implements $ExpenseTypeModelCopyWith<$Res> {
  factory _$$ExpenseTypeModelImplCopyWith(_$ExpenseTypeModelImpl value,
          $Res Function(_$ExpenseTypeModelImpl) then) =
      __$$ExpenseTypeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      bool isActive,
      String createdBy,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class __$$ExpenseTypeModelImplCopyWithImpl<$Res>
    extends _$ExpenseTypeModelCopyWithImpl<$Res, _$ExpenseTypeModelImpl>
    implements _$$ExpenseTypeModelImplCopyWith<$Res> {
  __$$ExpenseTypeModelImplCopyWithImpl(_$ExpenseTypeModelImpl _value,
      $Res Function(_$ExpenseTypeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? createdBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ExpenseTypeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseTypeModelImpl implements _ExpenseTypeModel {
  const _$ExpenseTypeModelImpl(
      {required this.id,
      required this.name,
      this.description,
      this.isActive = true,
      required this.createdBy,
      this.createdAt,
      this.updatedAt});

  factory _$ExpenseTypeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseTypeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String createdBy;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'ExpenseTypeModel(id: $id, name: $name, description: $description, isActive: $isActive, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseTypeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, isActive,
      createdBy, createdAt, updatedAt);

  /// Create a copy of ExpenseTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseTypeModelImplCopyWith<_$ExpenseTypeModelImpl> get copyWith =>
      __$$ExpenseTypeModelImplCopyWithImpl<_$ExpenseTypeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseTypeModelImplToJson(
      this,
    );
  }
}

abstract class _ExpenseTypeModel implements ExpenseTypeModel {
  const factory _ExpenseTypeModel(
      {required final String id,
      required final String name,
      final String? description,
      final bool isActive,
      required final String createdBy,
      final String? createdAt,
      final String? updatedAt}) = _$ExpenseTypeModelImpl;

  factory _ExpenseTypeModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseTypeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  bool get isActive;
  @override
  String get createdBy;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of ExpenseTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseTypeModelImplCopyWith<_$ExpenseTypeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
