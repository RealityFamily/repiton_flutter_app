import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:repiton_api/repiton_rest_api.dart';

class RepitonApiContainer extends RepitonRestApi {
  RepitonApiContainer(dio, {required String baseUrl}) : super(dio, baseUrl: baseUrl);

  static Future<RepitonApiContainer> init(String baseUrl) async {
    final dioInstance = Dio();
    final client = RepitonApiContainer(dioInstance, baseUrl: baseUrl);

    dioInstance.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint(
            "[http request]: ${options.method} ${options.uri} headers:${options.headers} query:${options.queryParameters} body:${options.data}");
        handler.next(options);
      },
    ));

    return client;
  }
}
