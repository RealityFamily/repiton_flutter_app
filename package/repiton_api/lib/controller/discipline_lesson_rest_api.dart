import 'package:repiton_api/entities/discipline_dto.dart';
import 'package:repiton_api/entities/lesson_dto.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'discipline_lesson_rest_api.g.dart';

@RestApi()
abstract class DisciplineLessonRestApi {
  String? baseUrl;

  factory DisciplineLessonRestApi(Dio dio, {String baseUrl}) = _DisciplineLessonRestApi;

  @GET("timetable/teacher/{id}")
  Future<List<DisciplineDTO>> teacherTimetable(
      {@Path("id") required String teacherId, @Query("dateFrom") required String dateFrom, @Query("dateTo") required String dateTo});

  @GET("timetable/student/{id}")
  Future<List<DisciplineDTO>> studentTimetable(
      {@Path("id") required String studentId, @Query("dateFrom") required String dateFrom, @Query("dateTo") required String dateTo});

  @GET("discipline/teacher/{id}")
  Future<List<DisciplineDTO>> teacherDisciplines({@Path("id") required String teacherId});

  @GET("discipline/student/{id}")
  Future<List<DisciplineDTO>> studentDisciplines({@Path("id") required String studentId});

  @POST("discipline/")
  Future<DisciplineDTO> addDiscipline({@Body() required DisciplineDTO discipline});

  @PUT("discipline/{id}")
  Future<DisciplineDTO> updateDiscipline({@Path("id") required String disciplineId, @Body() required DisciplineDTO discipline});

  @DELETE("discipline/{id}")
  Future deleteDiscipline({@Path("id") required String disciplineId});

  @GET("lesson/{id}")
  Future<LessonDTO> getLessonInfo({@Path("id") required String lessonId});

  @PUT("lesson/{id}")
  Future<LessonDTO> updateLessonInfo({@Path("id") required String lessonId, @Body() required LessonDTO newLesson});

  @GET("lesson/{id}/startLesson")
  Future<LessonDTO?> startLesson({@Path("id") required String lessonId});

  @GET("lesson/{id}/endLesson")
  Future<LessonDTO?> endLesson({@Path("id") required String lessonId});
}
