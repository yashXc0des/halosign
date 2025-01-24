// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signature.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Signature _$SignatureFromJson(Map<String, dynamic> json) {
  return _Signature.fromJson(json);
}

/// @nodoc
mixin _$Signature {
  String get id =>
      throw _privateConstructorUsedError; // Unique identifier for the signature.
  String get userId =>
      throw _privateConstructorUsedError; // User ID of the signer.
  String get agreementId =>
      throw _privateConstructorUsedError; // ID of the associated agreement.
  SignatureType get type =>
      throw _privateConstructorUsedError; // Type of the signature (drawn, uploaded, text).
  DateTime get signedAt =>
      throw _privateConstructorUsedError; // Timestamp of when the signature was made.
  String? get signatureUrl =>
      throw _privateConstructorUsedError; // URL of the signature image (nullable).
  String? get textSignature =>
      throw _privateConstructorUsedError; // If text-based, stores the text of the signature (nullable).
  String get ipAddress =>
      throw _privateConstructorUsedError; // IP address of the signer.
  String get deviceInfo => throw _privateConstructorUsedError;

  /// Serializes this Signature to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Signature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignatureCopyWith<Signature> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignatureCopyWith<$Res> {
  factory $SignatureCopyWith(Signature value, $Res Function(Signature) then) =
      _$SignatureCopyWithImpl<$Res, Signature>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String agreementId,
      SignatureType type,
      DateTime signedAt,
      String? signatureUrl,
      String? textSignature,
      String ipAddress,
      String deviceInfo});
}

/// @nodoc
class _$SignatureCopyWithImpl<$Res, $Val extends Signature>
    implements $SignatureCopyWith<$Res> {
  _$SignatureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Signature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? agreementId = null,
    Object? type = null,
    Object? signedAt = null,
    Object? signatureUrl = freezed,
    Object? textSignature = freezed,
    Object? ipAddress = null,
    Object? deviceInfo = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      agreementId: null == agreementId
          ? _value.agreementId
          : agreementId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SignatureType,
      signedAt: null == signedAt
          ? _value.signedAt
          : signedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      signatureUrl: freezed == signatureUrl
          ? _value.signatureUrl
          : signatureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      textSignature: freezed == textSignature
          ? _value.textSignature
          : textSignature // ignore: cast_nullable_to_non_nullable
              as String?,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      deviceInfo: null == deviceInfo
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SignatureImplCopyWith<$Res>
    implements $SignatureCopyWith<$Res> {
  factory _$$SignatureImplCopyWith(
          _$SignatureImpl value, $Res Function(_$SignatureImpl) then) =
      __$$SignatureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String agreementId,
      SignatureType type,
      DateTime signedAt,
      String? signatureUrl,
      String? textSignature,
      String ipAddress,
      String deviceInfo});
}

/// @nodoc
class __$$SignatureImplCopyWithImpl<$Res>
    extends _$SignatureCopyWithImpl<$Res, _$SignatureImpl>
    implements _$$SignatureImplCopyWith<$Res> {
  __$$SignatureImplCopyWithImpl(
      _$SignatureImpl _value, $Res Function(_$SignatureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Signature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? agreementId = null,
    Object? type = null,
    Object? signedAt = null,
    Object? signatureUrl = freezed,
    Object? textSignature = freezed,
    Object? ipAddress = null,
    Object? deviceInfo = null,
  }) {
    return _then(_$SignatureImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      agreementId: null == agreementId
          ? _value.agreementId
          : agreementId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SignatureType,
      signedAt: null == signedAt
          ? _value.signedAt
          : signedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      signatureUrl: freezed == signatureUrl
          ? _value.signatureUrl
          : signatureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      textSignature: freezed == textSignature
          ? _value.textSignature
          : textSignature // ignore: cast_nullable_to_non_nullable
              as String?,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      deviceInfo: null == deviceInfo
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SignatureImpl extends _Signature {
  const _$SignatureImpl(
      {required this.id,
      required this.userId,
      required this.agreementId,
      required this.type,
      required this.signedAt,
      this.signatureUrl,
      this.textSignature,
      required this.ipAddress,
      required this.deviceInfo})
      : super._();

  factory _$SignatureImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignatureImplFromJson(json);

  @override
  final String id;
// Unique identifier for the signature.
  @override
  final String userId;
// User ID of the signer.
  @override
  final String agreementId;
// ID of the associated agreement.
  @override
  final SignatureType type;
// Type of the signature (drawn, uploaded, text).
  @override
  final DateTime signedAt;
// Timestamp of when the signature was made.
  @override
  final String? signatureUrl;
// URL of the signature image (nullable).
  @override
  final String? textSignature;
// If text-based, stores the text of the signature (nullable).
  @override
  final String ipAddress;
// IP address of the signer.
  @override
  final String deviceInfo;

  @override
  String toString() {
    return 'Signature(id: $id, userId: $userId, agreementId: $agreementId, type: $type, signedAt: $signedAt, signatureUrl: $signatureUrl, textSignature: $textSignature, ipAddress: $ipAddress, deviceInfo: $deviceInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignatureImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.agreementId, agreementId) ||
                other.agreementId == agreementId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.signedAt, signedAt) ||
                other.signedAt == signedAt) &&
            (identical(other.signatureUrl, signatureUrl) ||
                other.signatureUrl == signatureUrl) &&
            (identical(other.textSignature, textSignature) ||
                other.textSignature == textSignature) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.deviceInfo, deviceInfo) ||
                other.deviceInfo == deviceInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, agreementId, type,
      signedAt, signatureUrl, textSignature, ipAddress, deviceInfo);

  /// Create a copy of Signature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignatureImplCopyWith<_$SignatureImpl> get copyWith =>
      __$$SignatureImplCopyWithImpl<_$SignatureImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SignatureImplToJson(
      this,
    );
  }
}

abstract class _Signature extends Signature {
  const factory _Signature(
      {required final String id,
      required final String userId,
      required final String agreementId,
      required final SignatureType type,
      required final DateTime signedAt,
      final String? signatureUrl,
      final String? textSignature,
      required final String ipAddress,
      required final String deviceInfo}) = _$SignatureImpl;
  const _Signature._() : super._();

  factory _Signature.fromJson(Map<String, dynamic> json) =
      _$SignatureImpl.fromJson;

  @override
  String get id; // Unique identifier for the signature.
  @override
  String get userId; // User ID of the signer.
  @override
  String get agreementId; // ID of the associated agreement.
  @override
  SignatureType get type; // Type of the signature (drawn, uploaded, text).
  @override
  DateTime get signedAt; // Timestamp of when the signature was made.
  @override
  String? get signatureUrl; // URL of the signature image (nullable).
  @override
  String?
      get textSignature; // If text-based, stores the text of the signature (nullable).
  @override
  String get ipAddress; // IP address of the signer.
  @override
  String get deviceInfo;

  /// Create a copy of Signature
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignatureImplCopyWith<_$SignatureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
