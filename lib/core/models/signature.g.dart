// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignatureImpl _$$SignatureImplFromJson(Map<String, dynamic> json) =>
    _$SignatureImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      agreementId: json['agreementId'] as String,
      type: $enumDecode(_$SignatureTypeEnumMap, json['type']),
      signedAt: DateTime.parse(json['signedAt'] as String),
      signatureUrl: json['signatureUrl'] as String?,
      textSignature: json['textSignature'] as String?,
      ipAddress: json['ipAddress'] as String,
      deviceInfo: json['deviceInfo'] as String,
    );

Map<String, dynamic> _$$SignatureImplToJson(_$SignatureImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'agreementId': instance.agreementId,
      'type': _$SignatureTypeEnumMap[instance.type]!,
      'signedAt': instance.signedAt.toIso8601String(),
      'signatureUrl': instance.signatureUrl,
      'textSignature': instance.textSignature,
      'ipAddress': instance.ipAddress,
      'deviceInfo': instance.deviceInfo,
    };

const _$SignatureTypeEnumMap = {
  SignatureType.drawn: 'drawn',
  SignatureType.uploaded: 'uploaded',
  SignatureType.text: 'text',
};
