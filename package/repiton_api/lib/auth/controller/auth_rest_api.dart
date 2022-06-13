import 'package:repiton_api/auth/entities/user_auth_request.dart';
import 'package:repiton_api/auth/entities/user_auth_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'auth_rest_api.g.dart';

@RestApi()
abstract class AuthRestApi {
  String? baseUrl;

  factory AuthRestApi(Dio dio, {String baseUrl}) = _AuthRestApi;

  @POST("user/signin")
  Future<UserAuthResponse> auth({@Body() required UserAuthRequest body});

  @GET("user/tokenValidate")
  Future<UserAuthResponse> getUserInfo();
}
