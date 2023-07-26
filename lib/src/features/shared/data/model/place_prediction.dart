class PlacePrediction {
  PlacePrediction({required this.placeId, required this.mainText, required this.secondaryText});

  final String mainText;
  final String placeId;
  final String secondaryText;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlacePrediction &&
          runtimeType == other.runtimeType &&
          placeId == other.placeId &&
          mainText == other.mainText &&
          secondaryText == other.secondaryText;

  @override
  int get hashCode => placeId.hashCode ^ mainText.hashCode ^ secondaryText.hashCode;
}