import 'package:json_annotation/json_annotation.dart';

part 'user_auth_request.g.dart';

@JsonSerializable()
class UserAuthRequest {
  String? email;
  String? username;
  String password;

  UserAuthRequest({
    required this.email,
    required this.username,
    required this.password,
  });

  factory UserAuthRequest.fromJson(Map<String, dynamic> json) => _$UserAuthRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UserAuthRequestToJson(this);
}
