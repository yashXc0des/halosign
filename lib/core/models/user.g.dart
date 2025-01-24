// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ??
          UserRole.clientUser,
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role]!,
      'permissions': instance.permissions,
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.clientAdmin: 'clientAdmin',
  UserRole.clientUser: 'clientUser',
  UserRole.viewer: 'viewer',
};
