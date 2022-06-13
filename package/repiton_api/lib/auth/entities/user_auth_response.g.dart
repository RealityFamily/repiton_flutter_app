// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAuthResponse _$UserAuthResponseFromJson(Map<String, dynamic> json) =>
    UserAuthResponse(
      id: json['id'] as String,
      userName: json['username'] as String,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      token: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );

Map<String, dynamic> _$UserAuthResponseToJson(UserAuthResponse instance) =>
    <String, dynamic>{
      'access_token': instance.token,
      'refresh_token': instance.refreshToken,
      'id': instance.id,
      'username': instance.userName,
      'roles': instance.roles,
    };
