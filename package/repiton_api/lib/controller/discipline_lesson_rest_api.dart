import 'package:repiton_api/entities/discipline_dto.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'discipline_lesson_rest_api.g.dart';

@RestApi()
abstract class DisciplineLessonRestApi {
  String? baseUrl;

  factory DisciplineLessonRestApi(Dio dio, {String baseUrl}) = _DisciplineLessonRestApi;

  @POST("timetable/teacher/{id}")
  Future<List<DisciplineDTO>> teacherTimetable({
    @Path("id") required String teacherId,
    @Query("dateFrom") required String dateFrom,
    @Query("dateTo") required String dateTo,
  });
}
