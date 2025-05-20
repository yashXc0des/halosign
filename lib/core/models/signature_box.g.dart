// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signature_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignatureBoxImpl _$$SignatureBoxImplFromJson(Map<String, dynamic> json) =>
    _$SignatureBoxImpl(
      id: json['id'] as String,
      agreementId: json['agreementId'] as String,
      assignedToUserId: json['assignedToUserId'] as String,
      pageNumber: (json['pageNumber'] as num).toDouble(),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      signatureId: json['signatureId'] as String?,
    );

Map<String, dynamic> _$$SignatureBoxImplToJson(_$SignatureBoxImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'agreementId': instance.agreementId,
      'assignedToUserId': instance.assignedToUserId,
      'pageNumber': instance.pageNumber,
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'height': instance.height,
      'signatureId': instance.signatureId,
    };
