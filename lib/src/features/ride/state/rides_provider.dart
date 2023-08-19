// Programmer's Name: Ang Ru Xian
// Program Name: rides_provider.dart 
// Description: This is a file that contains the providers for ride related functions.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hitchride/src/features/driver/data/model/driver_journey.dart';
import 'package:hitchride/src/features/driver/state/driver_journey_provider.dart';
import 'package:hitchride/src/features/ride/data/api/ride_api.dart';
import 'package:hitchride/src/features/ride/data/repository/ride_repository.dart';
import 'package:hitchride/src/features/ride/data/model/ride.dart';
import 'package:hitchride/src/features/ride/data/model/search_ride_criteria.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final rideApiClientProvider = Provider<RideApiClient>((ref) {
  final dio = GetIt.I<Dio>();
  return RideApiClient(dio);
});

final rideRepositoryProvider = Provider<RideRepository>((ref) {
  final rideApiClient = ref.read(rideApiClientProvider);
  return RideRepository(rideApiClient: rideApiClient);
});

final availableRidesProvider = FutureProvider.autoDispose
    .family<List<DriverJourney>, SearchRideCriteria>((ref, searchRideCriteria) async {
  final driverJourneyRepository = ref.read(driverJourneyRepositoryProvider);
  final availableRides = await driverJourneyRepository.searchRides(searchRideCriteria);
  return availableRides;
});

final driverJourneyRideProvider =
    FutureProvider.autoDispose.family<Ride?, String>((ref, djId) async {
  final rideRepository = ref.read(rideRepositoryProvider);
  return await rideRepository.getRideByDriverJourney(djId);
});

final userRecentRidesProvider = FutureProvider.autoDispose<List<Ride>>((ref) async {
  final rideRepository = ref.read(rideRepositoryProvider);
  return await rideRepository.getRecentRides();
});

final userRecentDrivesProvider = FutureProvider.autoDispose<List<Ride>>((ref) async {
  final rideRepository = ref.read(rideRepositoryProvider);
  return await rideRepository.getRecentDrives();
});

final userUpcomingRidesProvider = FutureProvider<List<Ride>>((ref) async {
  final rideRepository = ref.read(rideRepositoryProvider);
  return await rideRepository.getUpcomingRides();
});
