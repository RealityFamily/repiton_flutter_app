import 'package:repiton_api/auth/controller/auth_rest_api.dart';
import 'package:dio/dio.dart';

class RepitonRestApi {
  final Dio _dio;
  final AuthRestApi _auth;

  AuthRestApi get auth => _auth;

  // TODO: Think how I can get inner path from configure Request/File and give it to service

  RepitonRestApi(this._dio, {required String baseUrl})
      : _auth = AuthRestApi(_dio, baseUrl: baseUrl + "user-keycloak-service/");

  void setToken(String? token) {
    _dio.options.headers = {..._dio.options.headers, "Authorization": "Bearer $token"};
  }
}
