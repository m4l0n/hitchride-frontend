// Programmer's Name: Ang Ru Xian
// Program Name: ride_repository.dart
// Description: This is a file that contains the repository that interacts with the API for ride related functions.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:hitchride/src/core/api_response.dart';
import 'package:hitchride/src/features/ride/data/api/ride_api.dart';
import 'package:hitchride/src/features/ride/data/model/ride.dart';

class RideRepository {
  final RideApiClient _rideApiClient;

  RideRepository({required RideApiClient rideApiClient})
      : _rideApiClient = rideApiClient;

  Future<List<Ride>> getRecentRides() async {
    try {
      final response = await _rideApiClient.getRecentRides();
      if (response.statusCode == 'OK') {
        return response.result!;
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

  Future<Ride> bookRide(Ride ride) async {
    try {
      final response = await _rideApiClient.bookRide(ride);
      if (response.statusCode == 'OK') {
        return response.result!;
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

  Future<List<Ride>> getRecentDrives() async {
    try {
      final response = await _rideApiClient.getRecentDrives();
      if (response.statusCode == 'OK') {
        return response.result!;
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

  Future<List<Ride>> getUpcomingRides() async {
    try {
      final response = await _rideApiClient.getUpcomingRides();
      if (response.statusCode == 'OK') {
        return response.result!;
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

  Future<void> cancelRide(String id) async {
    try {
      final response = await _rideApiClient.cancelRide(id);
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

  Future<Ride> completeRide(Ride ride) async {
    try {
      final response = await _rideApiClient.completeRide(ride);
      if (response.statusCode == 'OK') {
        return response.result!;
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

  Future<Ride?> getRideByDriverJourney(String id) async {
    try {
      final response = await _rideApiClient.getRideByDriverJourney(id);
      if (response.statusCode == 'OK') {
        return response.result;
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