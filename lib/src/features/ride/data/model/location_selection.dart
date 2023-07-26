class LocationSelection {
  LocationSelection({
    required this.isCurrentLocationActive,
    required this.isDestinationActive,
    required this.isTypingCurrent,
    required this.isTypingDestination,
  });

  factory LocationSelection.currentLocation() {
    return LocationSelection(
      isCurrentLocationActive: true,
      isDestinationActive: false,
      isTypingCurrent: false,
      isTypingDestination: false,
    );
  }

  final bool isCurrentLocationActive;
  final bool isDestinationActive;
  final bool isTypingCurrent;
  final bool isTypingDestination;

  LocationSelection copyWith({
    bool? isCurrentLocationActive,
    bool? isDestinationActive,
    bool? isTypingCurrent,
    bool? isTypingDestination,
  }) {
    return LocationSelection(
      isCurrentLocationActive: isCurrentLocationActive ?? this.isCurrentLocationActive,
      isDestinationActive: isDestinationActive ?? this.isDestinationActive,
      isTypingCurrent: isTypingCurrent ?? this.isTypingCurrent,
      isTypingDestination: isTypingDestination ?? this.isTypingDestination,
    );
  }
}