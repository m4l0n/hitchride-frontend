// Programmer's Name: Ang Ru Xian
// Program Name: location_selection_notifier.dart
// Description: This is a file that contains the provider for LocationSelectionNotifier, which is used to store the state of pickup and destination location selection.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:hitchride/src/features/ride/data/model/location_selection.dart';
import 'package:hitchride/src/features/ride/utils/location_selection_updater.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final locationSelectionProvider =
    ChangeNotifierProvider<LocationSelectionNotifier>(
        (ref) => LocationSelectionNotifier());

class LocationSelectionNotifier extends ChangeNotifier {
  LocationSelectionNotifier()
      : _locationSelection = LocationSelection.currentLocation(),
        _selectionUpdater = LocationSelectionUpdater();

  LocationSelection _locationSelection;
  final LocationSelectionUpdater _selectionUpdater;

  LocationSelection get locationSelection => _locationSelection;

  void setCurrentLocationActive() {
    _locationSelection =
        _selectionUpdater.updateCurrentLocationActive(_locationSelection);
    notifyListeners();
  }

  void setDestinationActive() {
    _locationSelection =
        _selectionUpdater.updateDestinationActive(_locationSelection);
    notifyListeners();
  }

  void setTypingLocation() {
    _locationSelection =
        _selectionUpdater.updateTypingLocation(_locationSelection);
    notifyListeners();
  }

  void setTypingDestination() {
    _locationSelection =
        _selectionUpdater.updateTypingDestination(_locationSelection);
    notifyListeners();
  }
}
