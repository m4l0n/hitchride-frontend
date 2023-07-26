// Programmer's Name: Ang Ru Xian
// Program Name: dio_client.dart
// Description: This is a file that returns a Dio singleton instance that is configured with interceptors.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:hitchride/src/constants/api_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:hitchride/src/core/retrofit_config/http_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final sl = GetIt.instance;

Dio buildDioClient() {
  final dio = Dio();
  dio.options.baseUrl = ApiConstants.BASE_URL;

  dio.interceptors.add(HTTPInterceptor());
  dio.interceptors.add(PrettyDioLogger(requestBody: true));

  return dio;
}

Future initLocator() async {
  sl.registerLazySingleton<Dio>(() => buildDioClient());
}