import 'package:hitchride/src/features/shared/data/model/lat_lng.dart';

class LocationData {
  LocationData({
    required this.placeId,
    required this.addressName,
    required this.addressString,
    this.addressCoordinates
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      placeId: json['placeId'] as String,
      addressName: json['addressName'] as String,
      addressString: json['addressString'] as String,
    );
  }

  final String addressName;
  final String addressString;
  final String placeId;
  final LatLng? addressCoordinates;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationData &&
          runtimeType == other.runtimeType &&
          placeId == other.placeId &&
          addressCoordinates == other.addressCoordinates &&
          addressName == other.addressName &&
          addressString == other.addressString;

  @override
  int get hashCode =>
      placeId.hashCode ^
      addressName.hashCode ^
      addressString.hashCode ^
      addressCoordinates.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'addressName': addressName,
      'addressString': addressString,
      'placeId': placeId,
    };
  }
}
