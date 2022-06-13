import 'package:repiton_api/auth/controller/auth_rest_api.dart';
import 'package:dio/dio.dart';
import 'package:repiton_api/auth/controller/discipline_lesson_rest_api.dart';

class RepitonRestApi {
  final Dio _dio;
  final AuthRestApi _auth;
  final DisciplineLessonRestApi _disciplineLesson;

  AuthRestApi get auth => _auth;
  DisciplineLessonRestApi get disciplineLesson => _disciplineLesson;

  // TODO: Think how I can get inner path from configure Request/File and give it to service

  RepitonRestApi(this._dio, {required String baseUrl})
      : _auth = AuthRestApi(_dio, baseUrl: baseUrl + "user-keycloak-service/"),
        _disciplineLesson = DisciplineLessonRestApi(_dio, baseUrl: baseUrl + "discipline-lesson-service/");

  void setToken(String token) {
    _dio.options.headers = {..._dio.options.headers, "Authorization": "Bearer $token"};
  }

  void invalidateToken() {
    _dio.options.headers = {..._dio.options.headers, "Authorization": null};
  }
}
