import 'package:json_annotation/json_annotation.dart';

part 'user_auth_response.g.dart';

@JsonSerializable()
class UserAuthResponse {
  @JsonKey(name: "access_token")
  String? token;
  @JsonKey(name: "refresh_token")
  String? refreshToken;
  String id;
  @JsonKey(name: "username")
  String userName;
  List<String> roles;

  UserAuthResponse({
    required this.id,
    required this.userName,
    required this.roles,
    required this.token,
    required this.refreshToken,
  });

  factory UserAuthResponse.fromJson(Map<String, dynamic> json) => _$UserAuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserAuthResponseToJson(this);
}
