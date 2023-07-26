// Programmer's Name: Ang Ru Xian
// Program Name: google_maps_provider.dart
// Description: This is a file that contains the provider for GoogleMapsApiClient, which is used to interact with the Google Maps API.
// Last Modified: 22 July 2023

import 'package:geolocator/geolocator.dart';
import 'package:hitchride/src/features/ride/data/model/location_data.dart';
import 'package:hitchride/src/features/shared/data/api/google_maps_api_client.dart';
import 'package:hitchride/src/features/shared/data/model/lat_lng.dart';
import 'package:hitchride/src/features/shared/data/model/nearby_place.dart';
import 'package:hitchride/src/features/shared/data/model/place_details.dart';
import 'package:hitchride/src/features/shared/data/model/place_prediction.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider for GoogleMapsApiClient
final googleMapsApiClientProvider = Provider((ref) => GoogleMapsApiClient());

// Provider for getting the current location
final currentLocationProvider = FutureProvider<LocationData>((ref) async {
  final googleMapsApiClient = ref.watch(googleMapsApiClientProvider);
  return googleMapsApiClient.getCurrentLocationAddress();
});

// Provider for getting the address from a LatLng object
final addressFromLatLngProvider = FutureProvider.family
    .autoDispose<Map<String, String>, LatLng>((ref, latLng) async {
  final googleMapsApiClient = ref.watch(googleMapsApiClientProvider);
  return googleMapsApiClient.getAddressFromLatLng(latLng);
});

// Provider for getting autocomplete results for a search query
final autocompleteResultsProvider = FutureProvider.family
    .autoDispose<List<PlacePrediction>, Map<String, String>>(
        (ref, payload) async {
  String input = payload['input']!;
  String sessionToken = payload['sessionToken']!;
  
  // Get the current location
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
  final locationInput = LatLng(lat: position.latitude, lng: position.longitude);
  
  final googleMapsApiClient = ref.watch(googleMapsApiClientProvider);

  return googleMapsApiClient.getAutocompleteResults(input, locationInput,
      sessionToken: sessionToken);
});

// Provider for getting place details for a place ID
final placeDetailsProvider = FutureProvider.family
    .autoDispose<PlaceDetails, String>((ref, placeId) async {
  final googleMapsApiClient = ref.watch(googleMapsApiClientProvider);

  return googleMapsApiClient.getPlaceDetails(placeId);
});

// Provider for getting nearby places
final nearbyPlacesProvider =
    FutureProvider.family<List<NearbyPlace>, int>((ref, numResults) async {
  final googleMapsApiClient = ref.watch(googleMapsApiClientProvider);

  // Get the current location
  final currentLocationFuture = ref.read(currentLocationProvider.future);
  LocationData? currentLocation;

  try {
    currentLocation = await currentLocationFuture;
    return googleMapsApiClient.getNearbyPlaces(
      currentLocation.addressCoordinates!, numResults);
  } catch (e) {
    rethrow;
  }
});