// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agreement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Agreement _$AgreementFromJson(Map<String, dynamic> json) {
  return _Agreement.fromJson(json);
}

/// @nodoc
mixin _$Agreement {
  String get id =>
      throw _privateConstructorUsedError; // Unique identifier for the agreement.
  String get title =>
      throw _privateConstructorUsedError; // Title of the agreement.
  String? get description =>
      throw _privateConstructorUsedError; // Description of the agreement (nullable).
  String get createdBy =>
      throw _privateConstructorUsedError; // User ID of the creator.
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Timestamp when the agreement was created.
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Timestamp for the last update (nullable).
  AgreementStatus get status =>
      throw _privateConstructorUsedError; // Status of the agreement.
  List<String> get signatories =>
      throw _privateConstructorUsedError; // List of user IDs required to sign.
  List<String> get signedBy =>
      throw _privateConstructorUsedError; // List of user IDs who have signed.
  String? get pdfUrl =>
      throw _privateConstructorUsedError; // URL of the agreement PDF (nullable).
  DateTime? get validFrom =>
      throw _privateConstructorUsedError; // Start date of validity
  DateTime? get validUntil => throw _privateConstructorUsedError;

  /// Serializes this Agreement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Agreement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AgreementCopyWith<Agreement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgreementCopyWith<$Res> {
  factory $AgreementCopyWith(Agreement value, $Res Function(Agreement) then) =
      _$AgreementCopyWithImpl<$Res, Agreement>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String createdBy,
      DateTime createdAt,
      DateTime? updatedAt,
      AgreementStatus status,
      List<String> signatories,
      List<String> signedBy,
      String? pdfUrl,
      DateTime? validFrom,
      DateTime? validUntil});
}

/// @nodoc
class _$AgreementCopyWithImpl<$Res, $Val extends Agreement>
    implements $AgreementCopyWith<$Res> {
  _$AgreementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Agreement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? status = null,
    Object? signatories = null,
    Object? signedBy = null,
    Object? pdfUrl = freezed,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AgreementStatus,
      signatories: null == signatories
          ? _value.signatories
          : signatories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      signedBy: null == signedBy
          ? _value.signedBy
          : signedBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      validFrom: freezed == validFrom
          ? _value.validFrom
          : validFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      validUntil: freezed == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AgreementImplCopyWith<$Res>
    implements $AgreementCopyWith<$Res> {
  factory _$$AgreementImplCopyWith(
          _$AgreementImpl value, $Res Function(_$AgreementImpl) then) =
      __$$AgreementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String createdBy,
      DateTime createdAt,
      DateTime? updatedAt,
      AgreementStatus status,
      List<String> signatories,
      List<String> signedBy,
      String? pdfUrl,
      DateTime? validFrom,
      DateTime? validUntil});
}

/// @nodoc
class __$$AgreementImplCopyWithImpl<$Res>
    extends _$AgreementCopyWithImpl<$Res, _$AgreementImpl>
    implements _$$AgreementImplCopyWith<$Res> {
  __$$AgreementImplCopyWithImpl(
      _$AgreementImpl _value, $Res Function(_$AgreementImpl) _then)
      : super(_value, _then);

  /// Create a copy of Agreement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? status = null,
    Object? signatories = null,
    Object? signedBy = null,
    Object? pdfUrl = freezed,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
  }) {
    return _then(_$AgreementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AgreementStatus,
      signatories: null == signatories
          ? _value._signatories
          : signatories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      signedBy: null == signedBy
          ? _value._signedBy
          : signedBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      validFrom: freezed == validFrom
          ? _value.validFrom
          : validFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      validUntil: freezed == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AgreementImpl extends _Agreement {
  const _$AgreementImpl(
      {required this.id,
      required this.title,
      this.description,
      required this.createdBy,
      required this.createdAt,
      this.updatedAt,
      this.status = AgreementStatus.draft,
      final List<String> signatories = const [],
      final List<String> signedBy = const [],
      this.pdfUrl,
      this.validFrom,
      this.validUntil})
      : _signatories = signatories,
        _signedBy = signedBy,
        super._();

  factory _$AgreementImpl.fromJson(Map<String, dynamic> json) =>
      _$$AgreementImplFromJson(json);

  @override
  final String id;
// Unique identifier for the agreement.
  @override
  final String title;
// Title of the agreement.
  @override
  final String? description;
// Description of the agreement (nullable).
  @override
  final String createdBy;
// User ID of the creator.
  @override
  final DateTime createdAt;
// Timestamp when the agreement was created.
  @override
  final DateTime? updatedAt;
// Timestamp for the last update (nullable).
  @override
  @JsonKey()
  final AgreementStatus status;
// Status of the agreement.
  final List<String> _signatories;
// Status of the agreement.
  @override
  @JsonKey()
  List<String> get signatories {
    if (_signatories is EqualUnmodifiableListView) return _signatories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_signatories);
  }

// List of user IDs required to sign.
  final List<String> _signedBy;
// List of user IDs required to sign.
  @override
  @JsonKey()
  List<String> get signedBy {
    if (_signedBy is EqualUnmodifiableListView) return _signedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_signedBy);
  }

// List of user IDs who have signed.
  @override
  final String? pdfUrl;
// URL of the agreement PDF (nullable).
  @override
  final DateTime? validFrom;
// Start date of validity
  @override
  final DateTime? validUntil;

  @override
  String toString() {
    return 'Agreement(id: $id, title: $title, description: $description, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, signatories: $signatories, signedBy: $signedBy, pdfUrl: $pdfUrl, validFrom: $validFrom, validUntil: $validUntil)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgreementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._signatories, _signatories) &&
            const DeepCollectionEquality().equals(other._signedBy, _signedBy) &&
            (identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      createdBy,
      createdAt,
      updatedAt,
      status,
      const DeepCollectionEquality().hash(_signatories),
      const DeepCollectionEquality().hash(_signedBy),
      pdfUrl,
      validFrom,
      validUntil);

  /// Create a copy of Agreement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AgreementImplCopyWith<_$AgreementImpl> get copyWith =>
      __$$AgreementImplCopyWithImpl<_$AgreementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AgreementImplToJson(
      this,
    );
  }
}

abstract class _Agreement extends Agreement {
  const factory _Agreement(
      {required final String id,
      required final String title,
      final String? description,
      required final String createdBy,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final AgreementStatus status,
      final List<String> signatories,
      final List<String> signedBy,
      final String? pdfUrl,
      final DateTime? validFrom,
      final DateTime? validUntil}) = _$AgreementImpl;
  const _Agreement._() : super._();

  factory _Agreement.fromJson(Map<String, dynamic> json) =
      _$AgreementImpl.fromJson;

  @override
  String get id; // Unique identifier for the agreement.
  @override
  String get title; // Title of the agreement.
  @override
  String? get description; // Description of the agreement (nullable).
  @override
  String get createdBy; // User ID of the creator.
  @override
  DateTime get createdAt; // Timestamp when the agreement was created.
  @override
  DateTime? get updatedAt; // Timestamp for the last update (nullable).
  @override
  AgreementStatus get status; // Status of the agreement.
  @override
  List<String> get signatories; // List of user IDs required to sign.
  @override
  List<String> get signedBy; // List of user IDs who have signed.
  @override
  String? get pdfUrl; // URL of the agreement PDF (nullable).
  @override
  DateTime? get validFrom; // Start date of validity
  @override
  DateTime? get validUntil;

  /// Create a copy of Agreement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AgreementImplCopyWith<_$AgreementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
