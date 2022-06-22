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

  @PUT("lesson/{id}")
  Future<LessonDTO> updateLessonInfo({@Path("id") required String lessonId, @Body() required LessonDTO newLesson});

  @GET("lesson/{id}/startLesson")
  Future startLesson({@Path("id") required String lessonId});

  @GET("lesson/{id}/endLesson")
  Future endLesson({@Path("id") required String lessonId});
}
