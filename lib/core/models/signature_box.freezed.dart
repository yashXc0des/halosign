// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signature_box.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SignatureBox _$SignatureBoxFromJson(Map<String, dynamic> json) {
  return _SignatureBox.fromJson(json);
}

/// @nodoc
mixin _$SignatureBox {
  String get id => throw _privateConstructorUsedError;
  String get agreementId => throw _privateConstructorUsedError;
  String get assignedToUserId => throw _privateConstructorUsedError;
  double get pageNumber => throw _privateConstructorUsedError;
  double get x =>
      throw _privateConstructorUsedError; // X coordinate on the page (normalized 0-1)
  double get y =>
      throw _privateConstructorUsedError; // Y coordinate on the page (normalized 0-1)
  double get width =>
      throw _privateConstructorUsedError; // Width of box (normalized 0-1)
  double get height =>
      throw _privateConstructorUsedError; // Height of box (normalized 0-1)
  String? get signatureId => throw _privateConstructorUsedError;

  /// Serializes this SignatureBox to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SignatureBox
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignatureBoxCopyWith<SignatureBox> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignatureBoxCopyWith<$Res> {
  factory $SignatureBoxCopyWith(
          SignatureBox value, $Res Function(SignatureBox) then) =
      _$SignatureBoxCopyWithImpl<$Res, SignatureBox>;
  @useResult
  $Res call(
      {String id,
      String agreementId,
      String assignedToUserId,
      double pageNumber,
      double x,
      double y,
      double width,
      double height,
      String? signatureId});
}

/// @nodoc
class _$SignatureBoxCopyWithImpl<$Res, $Val extends SignatureBox>
    implements $SignatureBoxCopyWith<$Res> {
  _$SignatureBoxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignatureBox
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? agreementId = null,
    Object? assignedToUserId = null,
    Object? pageNumber = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? signatureId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      agreementId: null == agreementId
          ? _value.agreementId
          : agreementId // ignore: cast_nullable_to_non_nullable
              as String,
      assignedToUserId: null == assignedToUserId
          ? _value.assignedToUserId
          : assignedToUserId // ignore: cast_nullable_to_non_nullable
              as String,
      pageNumber: null == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as double,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      signatureId: freezed == signatureId
          ? _value.signatureId
          : signatureId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SignatureBoxImplCopyWith<$Res>
    implements $SignatureBoxCopyWith<$Res> {
  factory _$$SignatureBoxImplCopyWith(
          _$SignatureBoxImpl value, $Res Function(_$SignatureBoxImpl) then) =
      __$$SignatureBoxImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String agreementId,
      String assignedToUserId,
      double pageNumber,
      double x,
      double y,
      double width,
      double height,
      String? signatureId});
}

/// @nodoc
class __$$SignatureBoxImplCopyWithImpl<$Res>
    extends _$SignatureBoxCopyWithImpl<$Res, _$SignatureBoxImpl>
    implements _$$SignatureBoxImplCopyWith<$Res> {
  __$$SignatureBoxImplCopyWithImpl(
      _$SignatureBoxImpl _value, $Res Function(_$SignatureBoxImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignatureBox
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? agreementId = null,
    Object? assignedToUserId = null,
    Object? pageNumber = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? signatureId = freezed,
  }) {
    return _then(_$SignatureBoxImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      agreementId: null == agreementId
          ? _value.agreementId
          : agreementId // ignore: cast_nullable_to_non_nullable
              as String,
      assignedToUserId: null == assignedToUserId
          ? _value.assignedToUserId
          : assignedToUserId // ignore: cast_nullable_to_non_nullable
              as String,
      pageNumber: null == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as double,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      signatureId: freezed == signatureId
          ? _value.signatureId
          : signatureId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SignatureBoxImpl extends _SignatureBox {
  const _$SignatureBoxImpl(
      {required this.id,
      required this.agreementId,
      required this.assignedToUserId,
      required this.pageNumber,
      required this.x,
      required this.y,
      required this.width,
      required this.height,
      this.signatureId})
      : super._();

  factory _$SignatureBoxImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignatureBoxImplFromJson(json);

  @override
  final String id;
  @override
  final String agreementId;
  @override
  final String assignedToUserId;
  @override
  final double pageNumber;
  @override
  final double x;
// X coordinate on the page (normalized 0-1)
  @override
  final double y;
// Y coordinate on the page (normalized 0-1)
  @override
  final double width;
// Width of box (normalized 0-1)
  @override
  final double height;
// Height of box (normalized 0-1)
  @override
  final String? signatureId;

  @override
  String toString() {
    return 'SignatureBox(id: $id, agreementId: $agreementId, assignedToUserId: $assignedToUserId, pageNumber: $pageNumber, x: $x, y: $y, width: $width, height: $height, signatureId: $signatureId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignatureBoxImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.agreementId, agreementId) ||
                other.agreementId == agreementId) &&
            (identical(other.assignedToUserId, assignedToUserId) ||
                other.assignedToUserId == assignedToUserId) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.signatureId, signatureId) ||
                other.signatureId == signatureId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, agreementId,
      assignedToUserId, pageNumber, x, y, width, height, signatureId);

  /// Create a copy of SignatureBox
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignatureBoxImplCopyWith<_$SignatureBoxImpl> get copyWith =>
      __$$SignatureBoxImplCopyWithImpl<_$SignatureBoxImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SignatureBoxImplToJson(
      this,
    );
  }
}

abstract class _SignatureBox extends SignatureBox {
  const factory _SignatureBox(
      {required final String id,
      required final String agreementId,
      required final String assignedToUserId,
      required final double pageNumber,
      required final double x,
      required final double y,
      required final double width,
      required final double height,
      final String? signatureId}) = _$SignatureBoxImpl;
  const _SignatureBox._() : super._();

  factory _SignatureBox.fromJson(Map<String, dynamic> json) =
      _$SignatureBoxImpl.fromJson;

  @override
  String get id;
  @override
  String get agreementId;
  @override
  String get assignedToUserId;
  @override
  double get pageNumber;
  @override
  double get x; // X coordinate on the page (normalized 0-1)
  @override
  double get y; // Y coordinate on the page (normalized 0-1)
  @override
  double get width; // Width of box (normalized 0-1)
  @override
  double get height; // Height of box (normalized 0-1)
  @override
  String? get signatureId;

  /// Create a copy of SignatureBox
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignatureBoxImplCopyWith<_$SignatureBoxImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
