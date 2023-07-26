import 'package:hitchride/src/features/shared/data/model/lat_lng.dart';

class PlaceDetails {
  PlaceDetails({required this.name, required this.formattedAddress, required this.latLng, required this.placeId});

  final String formattedAddress;
  final LatLng latLng;
  final String placeId;
  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceDetails &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          formattedAddress == other.formattedAddress &&
          latLng == other.latLng &&
          placeId == other.placeId;

  @override
  int get hashCode => name.hashCode ^ formattedAddress.hashCode ^ latLng.hashCode ^ placeId.hashCode;
}