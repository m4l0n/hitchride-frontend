// Programmer's Name: Ang Ru Xian
// Program Name: fcm_api.dart
// Description: This is a file that contains the FcmApiClient class that is used to register the FCM token to the API.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hitchride/src/constants/api_constants.dart';
import 'package:hitchride/src/core/logger_config/logger.dart';

class FcmApiClient {

  final _dio = GetIt.I.get<Dio>();
  final _BASE_URL = ApiConstants.BASE_URL;
  final _logger = getLogger('FcmApiClient');

  Future<void> registerFCMToken(String token) async {
      final url = '$_BASE_URL/notification/register';
      var response = await _dio.post(url, data: {
        "token": token
      });
      if (response.statusCode != 200) throw Exception('Failed to register FCM token');
      _logger.i('FCM token registered: $token');
  }

}