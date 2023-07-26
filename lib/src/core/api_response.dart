// Programmer's Name: Ang Ru Xian
// Program Name: api_response.dart
// Description: This is a file that contains the ApiResponse class that is used to parse the response from the API.
// Last Modified: 22 July 2023

import 'package:json_annotation/json_annotation.dart';


part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final String statusCode;
  final String message;
  final T? result;

  ApiResponse({
    required this.statusCode,
    required this.message,
    required this.result,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}
