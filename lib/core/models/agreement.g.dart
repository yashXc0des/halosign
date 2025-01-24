// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AgreementImpl _$$AgreementImplFromJson(Map<String, dynamic> json) =>
    _$AgreementImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      status: $enumDecodeNullable(_$AgreementStatusEnumMap, json['status']) ??
          AgreementStatus.draft,
      signatories: (json['signatories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      signedBy: (json['signedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pdfUrl: json['pdfUrl'] as String?,
    );

Map<String, dynamic> _$$AgreementImplToJson(_$AgreementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'status': _$AgreementStatusEnumMap[instance.status]!,
      'signatories': instance.signatories,
      'signedBy': instance.signedBy,
      'pdfUrl': instance.pdfUrl,
    };

const _$AgreementStatusEnumMap = {
  AgreementStatus.draft: 'draft',
  AgreementStatus.pending: 'pending',
  AgreementStatus.signed: 'signed',
  AgreementStatus.rejected: 'rejected',
  AgreementStatus.completed: 'completed',
};
