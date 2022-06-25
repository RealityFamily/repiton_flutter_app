// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_rest_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _UserRestApi implements UserRestApi {
  _UserRestApi(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<TeacherDTO>> getAllTeachers() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<TeacherDTO>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'teacher',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => TeacherDTO.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<StudentDTO>> getAllStudents() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<StudentDTO>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'student',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => StudentDTO.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<TeacherDTO> getTeacherById({required teacherId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TeacherDTO>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'teacher/${teacherId}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TeacherDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<StudentDTO> getStudentById({required studentId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<StudentDTO>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'student/${studentId}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = StudentDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TeacherDTO> addTeacher({required teacher}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(teacher.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TeacherDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'teacher',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TeacherDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<StudentDTO> updateStudent(
      {required studentId, required student}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(student.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<StudentDTO>(
            Options(method: 'PUT', headers: _headers, extra: _extra)
                .compose(_dio.options, 'student/${studentId}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = StudentDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TeacherDTO> updateTeacher(
      {required teacherId, required teacher}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(teacher.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TeacherDTO>(
            Options(method: 'PUT', headers: _headers, extra: _extra)
                .compose(_dio.options, 'teacher/${teacherId}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TeacherDTO.fromJson(_result.data!);
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
