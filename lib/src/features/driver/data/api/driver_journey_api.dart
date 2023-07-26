// Programmer's Name: Ang Ru Xian
// Program Name: driver_journey_api.dart
// Description: This is a file that contains the methods to call the API for driver journey related functions.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:hitchride/src/core/api_response.dart';
import 'package:hitchride/src/features/driver/data/model/driver_journey.dart';
import 'package:hitchride/src/features/ride/data/model/search_ride_criteria.dart';
import 'package:retrofit/retrofit.dart';

part 'driver_journey_api.g.dart';

@RestApi()
abstract class DriverJourneyApiClient {
  factory DriverJourneyApiClient(Dio dio, {String baseUrl}) = _DriverJourneyApiClient;

  @POST('/driverJourney/searchRides')
  Future<ApiResponse<List<DriverJourney>>> searchRides(@Body() SearchRideCriteria searchRideCriteria);

  @POST('/driverJourney/create')
  Future<ApiResponse<DriverJourney>> createDriverJourney(@Body() DriverJourney driverJourney);

  @DELETE('/driverJourney/{id}')
  Future<ApiResponse> deleteDriverJourney(@Path('id') String id);

  @GET('/driverJourney/getUserDj')
  Future<ApiResponse<List<DriverJourney>>> getUserDriverJourneys();
}