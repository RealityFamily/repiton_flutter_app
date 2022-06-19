import 'package:repiton_api/auth/entities/teacher_dto.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'user_rest_api.g.dart';

@RestApi()
abstract class UserRestApi {
  String? baseUrl;

  factory UserRestApi(Dio dio, {String baseUrl}) = _UserRestApi;

  @GET("teacher")
  Future<List<TeacherDTO>> getAllTeachers();

  @GET("teacher/{id}")
  Future<TeacherDTO> getTeacherById({@Path("id") required String teacherId});
}
