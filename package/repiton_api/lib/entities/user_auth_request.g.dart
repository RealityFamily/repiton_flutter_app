// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAuthRequest _$UserAuthRequestFromJson(Map<String, dynamic> json) =>
    UserAuthRequest(
      email: json['email'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserAuthRequestToJson(UserAuthRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
    };
