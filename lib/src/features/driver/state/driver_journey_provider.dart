// Programmer's Name: Ang Ru Xian
// Program Name: driver_journey_provider.dart
// Description: This is a file that contains the provider for the driver journey related functions.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hitchride/src/features/driver/data/api/driver_journey_api.dart';
import 'package:hitchride/src/features/driver/data/model/driver_journey.dart';
import 'package:hitchride/src/features/driver/data/repository/driver_journey_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final driverJourneyApiClientProvider = Provider<DriverJourneyApiClient>((ref) {
  final dio = GetIt.I<Dio>();
  return DriverJourneyApiClient(dio);
});

final driverJourneyRepositoryProvider = Provider<DriverJourneyRepository>((ref) {
  final driverJourneyApiClient = ref.read(driverJourneyApiClientProvider);
  return DriverJourneyRepository(driverJourneyApiClient: driverJourneyApiClient);
});

final driverUpcomingDriverJourneyProvider = FutureProvider<List<DriverJourney>>((ref) async {
  final driverJourneyApiClient = ref.read(driverJourneyApiClientProvider);
  final response = await driverJourneyApiClient.getUserDriverJourneys();
  if (response.statusCode == 'OK') {
    return response.result!;
  } else {
    return [];
  }
});
