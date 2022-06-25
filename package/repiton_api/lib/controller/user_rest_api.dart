import 'package:repiton_api/entities/student_dto.dart';
import 'package:repiton_api/entities/teacher_dto.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'user_rest_api.g.dart';

@RestApi()
abstract class UserRestApi {
  String? baseUrl;

  factory UserRestApi(Dio dio, {String baseUrl}) = _UserRestApi;

  @GET("teacher")
  Future<List<TeacherDTO>> getAllTeachers();

  @GET("student")
  Future<List<StudentDTO>> getAllStudents();

  @GET("teacher/{id}")
  Future<TeacherDTO> getTeacherById({@Path("id") required String teacherId});

  @GET("student/{id}")
  Future<StudentDTO> getStudentById({@Path("id") required String studentId});

  @POST("teacher")
  Future<TeacherDTO> addTeacher({@Body() required TeacherDTO teacher});

  @PUT("student/{id}")
  Future<StudentDTO> updateStudent({@Path("id") required String studentId, @Body() required StudentDTO student});

  @PUT("teacher/{id}")
  Future<TeacherDTO> updateTeacher({@Path("id") required String teacherId, @Body() required TeacherDTO teacher});
}
