// Programmer's Name: Ang Ru Xian
// Program Name: review_api.dart
// Description: This is a file that contains the methods to call the API for review related functions.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:hitchride/src/core/api_response.dart';
import 'package:hitchride/src/features/account/data/model/reviews.dart';
import 'package:retrofit/retrofit.dart';

part 'review_api.g.dart';

@RestApi()
abstract class ReviewApiClient {
  factory ReviewApiClient(Dio dio, {String baseUrl}) = _ReviewApiClient;

  @GET('/review/getUserReviews')
  Future<ApiResponse<List<Review>>> getUserReviews();

  @POST('/review/createReview')
  Future<ApiResponse> createReview(@Body() Map<String, dynamic> review);
}