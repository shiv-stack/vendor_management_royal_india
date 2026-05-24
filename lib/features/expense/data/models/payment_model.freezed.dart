// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return _PaymentModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentModel {
  String get id => throw _privateConstructorUsedError;
  String get expenseRequestId => throw _privateConstructorUsedError;
  String get processedBy => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get paymentType => throw _privateConstructorUsedError;
  String get paymentMode => throw _privateConstructorUsedError;
  String get screenshotUrl => throw _privateConstructorUsedError;
  String? get remarks => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError; // Joined
  String? get processedByName => throw _privateConstructorUsedError;

  /// Serializes this PaymentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentModelCopyWith<PaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentModelCopyWith<$Res> {
  factory $PaymentModelCopyWith(
          PaymentModel value, $Res Function(PaymentModel) then) =
      _$PaymentModelCopyWithImpl<$Res, PaymentModel>;
  @useResult
  $Res call(
      {String id,
      String expenseRequestId,
      String processedBy,
      double amount,
      String paymentType,
      String paymentMode,
      String screenshotUrl,
      String? remarks,
      String? createdAt,
      String? processedByName});
}

/// @nodoc
class _$PaymentModelCopyWithImpl<$Res, $Val extends PaymentModel>
    implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expenseRequestId = null,
    Object? processedBy = null,
    Object? amount = null,
    Object? paymentType = null,
    Object? paymentMode = null,
    Object? screenshotUrl = null,
    Object? remarks = freezed,
    Object? createdAt = freezed,
    Object? processedByName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      expenseRequestId: null == expenseRequestId
          ? _value.expenseRequestId
          : expenseRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      processedBy: null == processedBy
          ? _value.processedBy
          : processedBy // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentType: null == paymentType
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMode: null == paymentMode
          ? _value.paymentMode
          : paymentMode // ignore: cast_nullable_to_non_nullable
              as String,
      screenshotUrl: null == screenshotUrl
          ? _value.screenshotUrl
          : screenshotUrl // ignore: cast_nullable_to_non_nullable
              as String,
      remarks: freezed == remarks
          ? _value.remarks
          : remarks // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      processedByName: freezed == processedByName
          ? _value.processedByName
          : processedByName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentModelImplCopyWith<$Res>
    implements $PaymentModelCopyWith<$Res> {
  factory _$$PaymentModelImplCopyWith(
          _$PaymentModelImpl value, $Res Function(_$PaymentModelImpl) then) =
      __$$PaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String expenseRequestId,
      String processedBy,
      double amount,
      String paymentType,
      String paymentMode,
      String screenshotUrl,
      String? remarks,
      String? createdAt,
      String? processedByName});
}

/// @nodoc
class __$$PaymentModelImplCopyWithImpl<$Res>
    extends _$PaymentModelCopyWithImpl<$Res, _$PaymentModelImpl>
    implements _$$PaymentModelImplCopyWith<$Res> {
  __$$PaymentModelImplCopyWithImpl(
      _$PaymentModelImpl _value, $Res Function(_$PaymentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expenseRequestId = null,
    Object? processedBy = null,
    Object? amount = null,
    Object? paymentType = null,
    Object? paymentMode = null,
    Object? screenshotUrl = null,
    Object? remarks = freezed,
    Object? createdAt = freezed,
    Object? processedByName = freezed,
  }) {
    return _then(_$PaymentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      expenseRequestId: null == expenseRequestId
          ? _value.expenseRequestId
          : expenseRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      processedBy: null == processedBy
          ? _value.processedBy
          : processedBy // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentType: null == paymentType
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMode: null == paymentMode
          ? _value.paymentMode
          : paymentMode // ignore: cast_nullable_to_non_nullable
              as String,
      screenshotUrl: null == screenshotUrl
          ? _value.screenshotUrl
          : screenshotUrl // ignore: cast_nullable_to_non_nullable
              as String,
      remarks: freezed == remarks
          ? _value.remarks
          : remarks // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      processedByName: freezed == processedByName
          ? _value.processedByName
          : processedByName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentModelImpl implements _PaymentModel {
  const _$PaymentModelImpl(
      {required this.id,
      required this.expenseRequestId,
      required this.processedBy,
      required this.amount,
      required this.paymentType,
      required this.paymentMode,
      required this.screenshotUrl,
      this.remarks,
      this.createdAt,
      this.processedByName});

  factory _$PaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String expenseRequestId;
  @override
  final String processedBy;
  @override
  final double amount;
  @override
  final String paymentType;
  @override
  final String paymentMode;
  @override
  final String screenshotUrl;
  @override
  final String? remarks;
  @override
  final String? createdAt;
// Joined
  @override
  final String? processedByName;

  @override
  String toString() {
    return 'PaymentModel(id: $id, expenseRequestId: $expenseRequestId, processedBy: $processedBy, amount: $amount, paymentType: $paymentType, paymentMode: $paymentMode, screenshotUrl: $screenshotUrl, remarks: $remarks, createdAt: $createdAt, processedByName: $processedByName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.expenseRequestId, expenseRequestId) ||
                other.expenseRequestId == expenseRequestId) &&
            (identical(other.processedBy, processedBy) ||
                other.processedBy == processedBy) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentType, paymentType) ||
                other.paymentType == paymentType) &&
            (identical(other.paymentMode, paymentMode) ||
                other.paymentMode == paymentMode) &&
            (identical(other.screenshotUrl, screenshotUrl) ||
                other.screenshotUrl == screenshotUrl) &&
            (identical(other.remarks, remarks) || other.remarks == remarks) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.processedByName, processedByName) ||
                other.processedByName == processedByName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      expenseRequestId,
      processedBy,
      amount,
      paymentType,
      paymentMode,
      screenshotUrl,
      remarks,
      createdAt,
      processedByName);

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      __$$PaymentModelImplCopyWithImpl<_$PaymentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentModel implements PaymentModel {
  const factory _PaymentModel(
      {required final String id,
      required final String expenseRequestId,
      required final String processedBy,
      required final double amount,
      required final String paymentType,
      required final String paymentMode,
      required final String screenshotUrl,
      final String? remarks,
      final String? createdAt,
      final String? processedByName}) = _$PaymentModelImpl;

  factory _PaymentModel.fromJson(Map<String, dynamic> json) =
      _$PaymentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get expenseRequestId;
  @override
  String get processedBy;
  @override
  double get amount;
  @override
  String get paymentType;
  @override
  String get paymentMode;
  @override
  String get screenshotUrl;
  @override
  String? get remarks;
  @override
  String? get createdAt; // Joined
  @override
  String? get processedByName;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
