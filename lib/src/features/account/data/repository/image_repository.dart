// Programmer's Name: Ang Ru Xian
// Program Name: image_repository.dart
// Description: This is a file that contains the method to upload a user profile picture to the server by calling the API.
// Last Modified: 22 July 2023

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hitchride/src/core/api_response.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ImageRepository {
  Future<ApiResponse<String>> uploadImage(File imageFile) async {
    final dio = GetIt.instance<Dio>();

    final mimeType = lookupMimeType(imageFile.path);
    if (mimeType == null ||
        !(mimeType.startsWith('image/jpeg') || mimeType.startsWith('image/png'))) {
      throw UnsupportedError('Unsupported file type');
    }
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      ),
    });
    try {
      final response = await dio.post(
        '/users/profile-picture/upload',
        data: formData,
      );
      return ApiResponse<String>.fromJson(response.data, (json) => json as String);
    } on DioException catch (e) {
      return ApiResponse<String>.fromJson(e.response!.data, (json) => json as String);
    }
  }
}