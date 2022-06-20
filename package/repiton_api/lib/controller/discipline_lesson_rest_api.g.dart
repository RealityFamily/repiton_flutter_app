// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discipline_lesson_rest_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _DisciplineLessonRestApi implements DisciplineLessonRestApi {
  _DisciplineLessonRestApi(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<DisciplineDTO>> teacherTimetable(
      {required teacherId, required dateFrom, required dateTo}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'dateFrom': dateFrom,
      r'dateTo': dateTo
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<DisciplineDTO>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'timetable/teacher/${teacherId}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => DisciplineDTO.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<DisciplineDTO>> studentTimetable(
      {required studentId, required dateFrom, required dateTo}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'dateFrom': dateFrom,
      r'dateTo': dateTo
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<DisciplineDTO>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'timetable/student/${studentId}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => DisciplineDTO.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<LessonDTO> updateLessonInfo(
      {required lessonId, required newLesson}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(newLesson.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LessonDTO>(
            Options(method: 'PUT', headers: _headers, extra: _extra)
                .compose(_dio.options, 'lesson/${lessonId}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LessonDTO.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
