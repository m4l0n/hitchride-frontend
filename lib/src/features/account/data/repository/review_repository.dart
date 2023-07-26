// Programmer's Name: Ang Ru Xian
// Program Name: review_repository.dart
// Description: This is a file that contains the repository class for review related functions.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:hitchride/src/core/api_response.dart';
import 'package:hitchride/src/features/account/data/api/review_api.dart';
import 'package:hitchride/src/features/account/data/model/reviews.dart';

class ReviewRepository {
  final ReviewApiClient reviewApiClient;

  ReviewRepository({required this.reviewApiClient});

  Future<List<Review>> getUserReviews() async {
    try {
      final response = await reviewApiClient.getUserReviews();
      if (response.statusCode == 'OK') {
        final reviewsList = response.result;
        if (reviewsList == null) {
          return [];
        }
        return reviewsList;
      } else {
        throw Exception(response.message);
      }
    } on DioException catch (e) {
      ApiResponse<dynamic> apiResponse = ApiResponse.fromJson(
        e.response!.data,
        (json) => json,
      );
      throw Exception(apiResponse.message);
    }
  }

  Future<void> createReview(Map<String, dynamic> review) async {
    try {
      ApiResponse response = await reviewApiClient.createReview(review);
      if (response.statusCode != 'OK') {
        throw Exception(response.message);
      }
    } on DioException catch (e) {
      ApiResponse<dynamic> apiResponse = ApiResponse.fromJson(
        e.response!.data,
        (json) => json,
      );
      throw Exception(apiResponse.message);
    }
  }
}
