class LocationInput {
  LocationInput(
      {
      this.pickupAddress,
      this.destinationAddress,
      this.pickupName,
      this.destinationName,
      this.pickupPlaceId,
      this.destinationPlaceId});

  String? destinationAddress;
  String? destinationName;
  String? destinationPlaceId;
  String? pickupAddress;
  String? pickupName;
  String? pickupPlaceId;

  @override
  String toString() {
    return 'LocationInput(pickupAddress: $pickupAddress, destinationAddress: $destinationAddress, pickupName: $pickupName, destinationName: $destinationName, pickupPlaceId: $pickupPlaceId, destinationPlaceId: $destinationPlaceId)';
  }

  LocationInput copyWith({
    String? pickupAddress,
    String? destinationAddress,
    String? pickupName,
    String? destinationName,
    String? pickupPlaceId,
    String? destinationPlaceId,
  }) {
    return LocationInput(
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      pickupName: pickupName ?? this.pickupName,
      destinationName: destinationName ?? this.destinationName,
      pickupPlaceId: pickupPlaceId ?? this.pickupPlaceId,
      destinationPlaceId: destinationPlaceId ?? this.destinationPlaceId,
    );
  }
}
