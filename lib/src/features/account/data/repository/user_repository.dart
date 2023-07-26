// Programmer's Name: Ang Ru Xian
// Program Name: user_repository.dart
// Description: This is a file that contains the repository class for user related functions.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:hitchride/src/core/api_response.dart';
import 'package:hitchride/src/features/account/data/api/user_api.dart';
import 'package:hitchride/src/features/account/data/model/user.dart';

class UserRepository {
  final UserApiClient userApiClient;

  UserRepository({required this.userApiClient});

  Future<HitchRideUser> getProfileDetails() async {
    try {
      final response = await userApiClient.getProfileDetails();
      if (response.statusCode == 'OK') {
        final userProfile = response.result;
        if (userProfile == null) {
          throw Exception(response.message);
        }
        return userProfile;
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

  Future<HitchRideUser> updateProfileDetails(HitchRideUser user) async {
    try {
      final response = await userApiClient.updateProfileDetails(user);
      if (response.statusCode == 'OK') {
        final updatedUserProfile = response.result;
        if (updatedUserProfile == null) {
          throw Exception(response.message);
        }
        return updatedUserProfile;
      } else {
        throw Exception('Update failed. Please try again.');
      }
    } on DioException catch (e) {
      ApiResponse<dynamic> apiResponse = ApiResponse.fromJson(
        e.response!.data,
        (json) => json,
      );
      throw Exception(apiResponse.message);
    }
  }

  Future<HitchRideUser> createProfile(HitchRideUser user) async {
    try {
      final response = await userApiClient.createProfile(user);
      if (response.statusCode == 'OK') {
        final newUserProfile = response.result;
        if (newUserProfile == null) {
          throw Exception(response.message);
        }
        return newUserProfile;
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

  Future<HitchRideUser> updateDriverInfo(HitchRideUser user) async {
    try {
      final response = await userApiClient.updateDriverInfo(user);
      if (response.statusCode == 'OK') {
        final updatedDriverInfo = response.result;
        if (updatedDriverInfo == null) {
          throw Exception(response.message);
        }
        return updatedDriverInfo;
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

}