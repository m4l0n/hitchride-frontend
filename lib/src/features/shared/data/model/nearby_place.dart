import 'package:hitchride/src/features/shared/data/model/lat_lng.dart';

class NearbyPlace {
  NearbyPlace({required this.name, required this.formattedAddress, required this.latLng, required this.placeId});

  final String formattedAddress;
  final String placeId;
  final LatLng latLng;
  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NearbyPlace &&
          runtimeType == other.runtimeType &&
          placeId == other.placeId &&
          name == other.name &&
          formattedAddress == other.formattedAddress &&
          latLng == other.latLng;

  @override
  int get hashCode => name.hashCode ^ formattedAddress.hashCode ^ latLng.hashCode ^ placeId.hashCode;
}