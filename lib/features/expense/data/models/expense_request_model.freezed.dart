// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExpenseRequestModel _$ExpenseRequestModelFromJson(Map<String, dynamic> json) {
  return _ExpenseRequestModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get expenseTypeId => throw _privateConstructorUsedError;
  String get vendorId => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  String get hodId => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get advancePaid => throw _privateConstructorUsedError;
  String get paymentStatus => throw _privateConstructorUsedError;
  String get billAttachmentUrl => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  String? get accountsReturnReason => throw _privateConstructorUsedError;
  int get resubmissionCount => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt =>
      throw _privateConstructorUsedError; // Joined fields from views (nullable)
  String? get eventName => throw _privateConstructorUsedError;
  String? get expenseTypeName => throw _privateConstructorUsedError;
  String? get vendorName => throw _privateConstructorUsedError;
  String? get employeeName => throw _privateConstructorUsedError;
  String? get hodName => throw _privateConstructorUsedError;

  /// Serializes this ExpenseRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseRequestModelCopyWith<ExpenseRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseRequestModelCopyWith<$Res> {
  factory $ExpenseRequestModelCopyWith(
          ExpenseRequestModel value, $Res Function(ExpenseRequestModel) then) =
      _$ExpenseRequestModelCopyWithImpl<$Res, ExpenseRequestModel>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String expenseTypeId,
      String vendorId,
      String employeeId,
      String hodId,
      double totalAmount,
      double advancePaid,
      String paymentStatus,
      String billAttachmentUrl,
      String status,
      String? rejectionReason,
      String? accountsReturnReason,
      int resubmissionCount,
      String? createdAt,
      String? updatedAt,
      String? eventName,
      String? expenseTypeName,
      String? vendorName,
      String? employeeName,
      String? hodName});
}

/// @nodoc
class _$ExpenseRequestModelCopyWithImpl<$Res, $Val extends ExpenseRequestModel>
    implements $ExpenseRequestModelCopyWith<$Res> {
  _$ExpenseRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? expenseTypeId = null,
    Object? vendorId = null,
    Object? employeeId = null,
    Object? hodId = null,
    Object? totalAmount = null,
    Object? advancePaid = null,
    Object? paymentStatus = null,
    Object? billAttachmentUrl = null,
    Object? status = null,
    Object? rejectionReason = freezed,
    Object? accountsReturnReason = freezed,
    Object? resubmissionCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? eventName = freezed,
    Object? expenseTypeName = freezed,
    Object? vendorName = freezed,
    Object? employeeName = freezed,
    Object? hodName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      expenseTypeId: null == expenseTypeId
          ? _value.expenseTypeId
          : expenseTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      hodId: null == hodId
          ? _value.hodId
          : hodId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      advancePaid: null == advancePaid
          ? _value.advancePaid
          : advancePaid // ignore: cast_nullable_to_non_nullable
              as double,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      billAttachmentUrl: null == billAttachmentUrl
          ? _value.billAttachmentUrl
          : billAttachmentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      accountsReturnReason: freezed == accountsReturnReason
          ? _value.accountsReturnReason
          : accountsReturnReason // ignore: cast_nullable_to_non_nullable
              as String?,
      resubmissionCount: null == resubmissionCount
          ? _value.resubmissionCount
          : resubmissionCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      eventName: freezed == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String?,
      expenseTypeName: freezed == expenseTypeName
          ? _value.expenseTypeName
          : expenseTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      vendorName: freezed == vendorName
          ? _value.vendorName
          : vendorName // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeName: freezed == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String?,
      hodName: freezed == hodName
          ? _value.hodName
          : hodName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseRequestModelImplCopyWith<$Res>
    implements $ExpenseRequestModelCopyWith<$Res> {
  factory _$$ExpenseRequestModelImplCopyWith(_$ExpenseRequestModelImpl value,
          $Res Function(_$ExpenseRequestModelImpl) then) =
      __$$ExpenseRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String expenseTypeId,
      String vendorId,
      String employeeId,
      String hodId,
      double totalAmount,
      double advancePaid,
      String paymentStatus,
      String billAttachmentUrl,
      String status,
      String? rejectionReason,
      String? accountsReturnReason,
      int resubmissionCount,
      String? createdAt,
      String? updatedAt,
      String? eventName,
      String? expenseTypeName,
      String? vendorName,
      String? employeeName,
      String? hodName});
}

/// @nodoc
class __$$ExpenseRequestModelImplCopyWithImpl<$Res>
    extends _$ExpenseRequestModelCopyWithImpl<$Res, _$ExpenseRequestModelImpl>
    implements _$$ExpenseRequestModelImplCopyWith<$Res> {
  __$$ExpenseRequestModelImplCopyWithImpl(_$ExpenseRequestModelImpl _value,
      $Res Function(_$ExpenseRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? expenseTypeId = null,
    Object? vendorId = null,
    Object? employeeId = null,
    Object? hodId = null,
    Object? totalAmount = null,
    Object? advancePaid = null,
    Object? paymentStatus = null,
    Object? billAttachmentUrl = null,
    Object? status = null,
    Object? rejectionReason = freezed,
    Object? accountsReturnReason = freezed,
    Object? resubmissionCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? eventName = freezed,
    Object? expenseTypeName = freezed,
    Object? vendorName = freezed,
    Object? employeeName = freezed,
    Object? hodName = freezed,
  }) {
    return _then(_$ExpenseRequestModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      expenseTypeId: null == expenseTypeId
          ? _value.expenseTypeId
          : expenseTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      hodId: null == hodId
          ? _value.hodId
          : hodId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      advancePaid: null == advancePaid
          ? _value.advancePaid
          : advancePaid // ignore: cast_nullable_to_non_nullable
              as double,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      billAttachmentUrl: null == billAttachmentUrl
          ? _value.billAttachmentUrl
          : billAttachmentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      accountsReturnReason: freezed == accountsReturnReason
          ? _value.accountsReturnReason
          : accountsReturnReason // ignore: cast_nullable_to_non_nullable
              as String?,
      resubmissionCount: null == resubmissionCount
          ? _value.resubmissionCount
          : resubmissionCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      eventName: freezed == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String?,
      expenseTypeName: freezed == expenseTypeName
          ? _value.expenseTypeName
          : expenseTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      vendorName: freezed == vendorName
          ? _value.vendorName
          : vendorName // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeName: freezed == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String?,
      hodName: freezed == hodName
          ? _value.hodName
          : hodName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseRequestModelImpl implements _ExpenseRequestModel {
  const _$ExpenseRequestModelImpl(
      {required this.id,
      required this.eventId,
      required this.expenseTypeId,
      required this.vendorId,
      required this.employeeId,
      required this.hodId,
      required this.totalAmount,
      this.advancePaid = 0.0,
      required this.paymentStatus,
      required this.billAttachmentUrl,
      required this.status,
      this.rejectionReason,
      this.accountsReturnReason,
      this.resubmissionCount = 0,
      this.createdAt,
      this.updatedAt,
      this.eventName,
      this.expenseTypeName,
      this.vendorName,
      this.employeeName,
      this.hodName});

  factory _$ExpenseRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseRequestModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String expenseTypeId;
  @override
  final String vendorId;
  @override
  final String employeeId;
  @override
  final String hodId;
  @override
  final double totalAmount;
  @override
  @JsonKey()
  final double advancePaid;
  @override
  final String paymentStatus;
  @override
  final String billAttachmentUrl;
  @override
  final String status;
  @override
  final String? rejectionReason;
  @override
  final String? accountsReturnReason;
  @override
  @JsonKey()
  final int resubmissionCount;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;
// Joined fields from views (nullable)
  @override
  final String? eventName;
  @override
  final String? expenseTypeName;
  @override
  final String? vendorName;
  @override
  final String? employeeName;
  @override
  final String? hodName;

  @override
  String toString() {
    return 'ExpenseRequestModel(id: $id, eventId: $eventId, expenseTypeId: $expenseTypeId, vendorId: $vendorId, employeeId: $employeeId, hodId: $hodId, totalAmount: $totalAmount, advancePaid: $advancePaid, paymentStatus: $paymentStatus, billAttachmentUrl: $billAttachmentUrl, status: $status, rejectionReason: $rejectionReason, accountsReturnReason: $accountsReturnReason, resubmissionCount: $resubmissionCount, createdAt: $createdAt, updatedAt: $updatedAt, eventName: $eventName, expenseTypeName: $expenseTypeName, vendorName: $vendorName, employeeName: $employeeName, hodName: $hodName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.expenseTypeId, expenseTypeId) ||
                other.expenseTypeId == expenseTypeId) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.hodId, hodId) || other.hodId == hodId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.advancePaid, advancePaid) ||
                other.advancePaid == advancePaid) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.billAttachmentUrl, billAttachmentUrl) ||
                other.billAttachmentUrl == billAttachmentUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.accountsReturnReason, accountsReturnReason) ||
                other.accountsReturnReason == accountsReturnReason) &&
            (identical(other.resubmissionCount, resubmissionCount) ||
                other.resubmissionCount == resubmissionCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.expenseTypeName, expenseTypeName) ||
                other.expenseTypeName == expenseTypeName) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.hodName, hodName) || other.hodName == hodName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        eventId,
        expenseTypeId,
        vendorId,
        employeeId,
        hodId,
        totalAmount,
        advancePaid,
        paymentStatus,
        billAttachmentUrl,
        status,
        rejectionReason,
        accountsReturnReason,
        resubmissionCount,
        createdAt,
        updatedAt,
        eventName,
        expenseTypeName,
        vendorName,
        employeeName,
        hodName
      ]);

  /// Create a copy of ExpenseRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseRequestModelImplCopyWith<_$ExpenseRequestModelImpl> get copyWith =>
      __$$ExpenseRequestModelImplCopyWithImpl<_$ExpenseRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseRequestModelImplToJson(
      this,
    );
  }
}

abstract class _ExpenseRequestModel implements ExpenseRequestModel {
  const factory _ExpenseRequestModel(
      {required final String id,
      required final String eventId,
      required final String expenseTypeId,
      required final String vendorId,
      required final String employeeId,
      required final String hodId,
      required final double totalAmount,
      final double advancePaid,
      required final String paymentStatus,
      required final String billAttachmentUrl,
      required final String status,
      final String? rejectionReason,
      final String? accountsReturnReason,
      final int resubmissionCount,
      final String? createdAt,
      final String? updatedAt,
      final String? eventName,
      final String? expenseTypeName,
      final String? vendorName,
      final String? employeeName,
      final String? hodName}) = _$ExpenseRequestModelImpl;

  factory _ExpenseRequestModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get expenseTypeId;
  @override
  String get vendorId;
  @override
  String get employeeId;
  @override
  String get hodId;
  @override
  double get totalAmount;
  @override
  double get advancePaid;
  @override
  String get paymentStatus;
  @override
  String get billAttachmentUrl;
  @override
  String get status;
  @override
  String? get rejectionReason;
  @override
  String? get accountsReturnReason;
  @override
  int get resubmissionCount;
  @override
  String? get createdAt;
  @override
  String? get updatedAt; // Joined fields from views (nullable)
  @override
  String? get eventName;
  @override
  String? get expenseTypeName;
  @override
  String? get vendorName;
  @override
  String? get employeeName;
  @override
  String? get hodName;

  /// Create a copy of ExpenseRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseRequestModelImplCopyWith<_$ExpenseRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
