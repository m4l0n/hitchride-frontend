// Programmer's Name: Ang Ru Xian
// Program Name: location_input_provider.dart
// Description: This is a file that contains the provider for LocationInputNotifier, which is used to store the state of pickup and destination location input.
// Last Modified: 22 July 2023

import 'package:hitchride/src/core/logger_config/logger.dart';
import 'package:hitchride/src/features/ride/data/model/location_input.dart';
import 'package:hitchride/src/features/shared/state/google_maps_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final locationInputProvider =
    StateNotifierProvider<LocationInputNotifier, LocationInput>((ref) {
  return LocationInputNotifier(ref);
});

class LocationInputNotifier extends StateNotifier<LocationInput> {
  final _logger = getLogger("Location Input Notifier");
  final StateNotifierProviderRef ref;

  LocationInputNotifier(this.ref)
      : super(LocationInput(
            pickupPlaceId: null,
            destinationPlaceId: null,
            pickupAddress: null,
            destinationAddress: null,
            pickupName: null,
            destinationName: null));

  void reset() {
    state = LocationInput(
        pickupPlaceId: null,
        destinationPlaceId: null,
        pickupAddress: null,
        destinationAddress: null,
        pickupName: null,
        destinationName: null);
    init();
  }

  Future<void> init() async {
    try {
      if (state.pickupPlaceId == null) {
        final currentLocation = await ref.read(currentLocationProvider.future);
        state = state.copyWith(
          pickupPlaceId: currentLocation.placeId,
          pickupAddress: currentLocation.addressString,
          pickupName: currentLocation.addressName,
        );
        _logger.i("Current location not set, setting to: ${state.pickupName}");
      }
      _logger.i("Current location already set to: ${state.pickupName}");
    } catch (e) {
      _logger.i("Location permission disabled, setting to random location");
      state = state.copyWith(
        pickupPlaceId: "",
        pickupAddress: "Ho Chi Minh City",
        pickupName: "Ho Chi Minh City",
      );
      return;
    }
  }

  Future<void> setPickupLocation(String value) async {
    final googleMapsApiClient = ref.read(googleMapsApiClientProvider);
    // Convert LatLng to string representation
    final addressData = await googleMapsApiClient.getPlaceDetails(value);
    // Update state with new LatLng and its string representation
    state = LocationInput(
        pickupPlaceId: value,
        pickupAddress: addressData.formattedAddress,
        pickupName: addressData.name,
        destinationPlaceId: state.destinationPlaceId,
        destinationName: state.destinationName,
        destinationAddress: state.destinationAddress);
  }

  Future<void> setPickupLocationWithAddressString(
      String value, String address, String name) async {
    state = LocationInput(
        pickupPlaceId: value,
        pickupAddress: address,
        pickupName: name,
        destinationPlaceId: state.destinationPlaceId,
        destinationName: state.destinationName,
        destinationAddress: state.destinationAddress);
  }

  Future<void> setDestination(String value) async {
    final googleMapsApiClient = ref.read(googleMapsApiClientProvider);
    // Convert LatLng to string representation
    final addressData = await googleMapsApiClient.getPlaceDetails(value);
    // Update state with new LatLng and its string representation
    state = LocationInput(
        pickupPlaceId: state.pickupPlaceId,
        pickupAddress: state.pickupAddress,
        pickupName: state.pickupName,
        destinationPlaceId: value,
        destinationName: addressData.name,
        destinationAddress: addressData.formattedAddress);
  }

  Future<void> setDestinationWithAddressString(
      String value, String address, String name) async {
    state = LocationInput(
        pickupPlaceId: state.pickupPlaceId,
        pickupAddress: state.pickupAddress,
        pickupName: state.pickupName,
        destinationPlaceId: value,
        destinationName: name,
        destinationAddress: address);
  }
}
