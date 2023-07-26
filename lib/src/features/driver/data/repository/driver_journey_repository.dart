// Programmer's Name: Ang Ru Xian
// Program Name: driver_journey_repository.dart
// Description: This is a file that contains the repository methods that interact with the API for driver journey related functions.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:hitchride/src/core/api_response.dart';
import 'package:hitchride/src/features/driver/data/api/driver_journey_api.dart';
import 'package:hitchride/src/features/driver/data/model/driver_journey.dart';
import 'package:hitchride/src/features/ride/data/model/search_ride_criteria.dart';

class DriverJourneyRepository {
  final DriverJourneyApiClient _driverJourneyApiClient;

  DriverJourneyRepository({required DriverJourneyApiClient driverJourneyApiClient})
      : _driverJourneyApiClient = driverJourneyApiClient;

  Future<List<DriverJourney>> searchRides(SearchRideCriteria searchRideCriteria) async {
    try {
      final response = await _driverJourneyApiClient.searchRides(searchRideCriteria);
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

  Future<DriverJourney> createDriverJourney(DriverJourney driverJourney) async {
    try {
      final response = await _driverJourneyApiClient.createDriverJourney(driverJourney);
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

  Future<void> deleteDriverJourney(String id) async {
    try {
      final response = await _driverJourneyApiClient.deleteDriverJourney(id);
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

  Future<List<DriverJourney>> getUserDriverJourneys() async {
    try {
      final response = await _driverJourneyApiClient.getUserDriverJourneys();
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
}