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
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  AgreementStatus get status => throw _privateConstructorUsedError;
  List<String> get signatories => throw _privateConstructorUsedError;
  List<String> get signedBy => throw _privateConstructorUsedError;
  String? get pdfUrl => throw _privateConstructorUsedError;
  String? get sendTo => throw _privateConstructorUsedError;

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
      String? sendTo});
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
    Object? sendTo = freezed,
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
      sendTo: freezed == sendTo
          ? _value.sendTo
          : sendTo // ignore: cast_nullable_to_non_nullable
              as String?,
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
      String? sendTo});
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
    Object? sendTo = freezed,
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
      sendTo: freezed == sendTo
          ? _value.sendTo
          : sendTo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AgreementImpl implements _Agreement {
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
      this.sendTo})
      : _signatories = signatories,
        _signedBy = signedBy;

  factory _$AgreementImpl.fromJson(Map<String, dynamic> json) =>
      _$$AgreementImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final AgreementStatus status;
  final List<String> _signatories;
  @override
  @JsonKey()
  List<String> get signatories {
    if (_signatories is EqualUnmodifiableListView) return _signatories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_signatories);
  }

  final List<String> _signedBy;
  @override
  @JsonKey()
  List<String> get signedBy {
    if (_signedBy is EqualUnmodifiableListView) return _signedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_signedBy);
  }

  @override
  final String? pdfUrl;
  @override
  final String? sendTo;

  @override
  String toString() {
    return 'Agreement(id: $id, title: $title, description: $description, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, signatories: $signatories, signedBy: $signedBy, pdfUrl: $pdfUrl, sendTo: $sendTo)';
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
            (identical(other.sendTo, sendTo) || other.sendTo == sendTo));
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
      sendTo);

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

abstract class _Agreement implements Agreement {
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
      final String? sendTo}) = _$AgreementImpl;

  factory _Agreement.fromJson(Map<String, dynamic> json) =
      _$AgreementImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  AgreementStatus get status;
  @override
  List<String> get signatories;
  @override
  List<String> get signedBy;
  @override
  String? get pdfUrl;
  @override
  String? get sendTo;

  /// Create a copy of Agreement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AgreementImplCopyWith<_$AgreementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
