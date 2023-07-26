// Programmer's Name: Ang Ru Xian
// Program Name: ride_api.dart
// Description: This is a file that contains the API for ride related functions.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:hitchride/src/core/api_response.dart';
import 'package:hitchride/src/features/ride/data/model/ride.dart';
import 'package:retrofit/retrofit.dart';

part 'ride_api.g.dart';

@RestApi()
abstract class RideApiClient {
  factory RideApiClient(Dio dio, {String baseUrl}) = _RideApiClient;

  @GET('/rides/getRecentRides')
  Future<ApiResponse<List<Ride>>> getRecentRides();

  @POST('/rides/bookRide')
  Future<ApiResponse<Ride>> bookRide(@Body() Ride ride);

  @GET('/rides/getRecentDrives')
  Future<ApiResponse<List<Ride>>> getRecentDrives();

  @GET('/rides/getUpcomingRides')
  Future<ApiResponse<List<Ride>>> getUpcomingRides();

  @POST('/rides/cancelRide')
  Future<ApiResponse> cancelRide(@Body() String rideId);

  @POST('/rides/complete')
  Future<ApiResponse<Ride>> completeRide(@Body() Ride ride);

  @GET('/rides/getRideByDriverJourney')
  Future<ApiResponse<Ride>> getRideByDriverJourney(@Query('driverJourneyId') String driverJourneyId);
}