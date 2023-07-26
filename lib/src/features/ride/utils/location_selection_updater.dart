// Programmer's Name: Ang Ru Xian
// Program Name: location_selection_updater.dart
// Description: This is a file that contains the methods to update the state of pickup and destination location selection.
// Last Modified: 22 July 2023


import 'package:hitchride/src/features/ride/data/model/location_selection.dart';

class LocationSelectionUpdater {
  LocationSelection updateCurrentLocationActive(LocationSelection selection) {
    return selection.copyWith(
      isCurrentLocationActive: true,
      isDestinationActive: false,
      isTypingCurrent: false,
      isTypingDestination: false,
    );
  }

  LocationSelection updateDestinationActive(LocationSelection selection) {
    return selection.copyWith(
      isCurrentLocationActive: false,
      isDestinationActive: true,
      isTypingCurrent: false,
      isTypingDestination: false,
    );
  }

  LocationSelection updateTypingLocation(LocationSelection selection) {
    if (!selection.isTypingCurrent) {
      return selection.copyWith(
        isTypingCurrent: true,
        isTypingDestination: false,
      );
    }
    return selection;
  }

  LocationSelection updateTypingDestination(LocationSelection selection) {
    if (!selection.isTypingDestination) {
      return selection.copyWith(
        isTypingCurrent: false,
        isTypingDestination: true,
      );
    }
    return selection;
  }
}
