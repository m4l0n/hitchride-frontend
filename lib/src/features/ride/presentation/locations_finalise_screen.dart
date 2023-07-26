// ignore_for_file: use_build_context_synchronously

// Programmer's Name: Ang Ru Xian
// Program Name: locations_finalise_screen.dart
// Description: This is a file that contains the screen for the finalisation of the locations.
// Last Modified: 22 July 2023

import 'dart:async';

import 'package:conditional_parent_widget/conditional_parent_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hitchride/src/features/ride/state/location_input_provider.dart';
import 'package:hitchride/src/features/ride/presentation/available_drivers_screen.dart';
import 'package:hitchride/src/features/ride/state/location_selection_notifier.dart';
import 'package:hitchride/src/features/shared/data/model/place_prediction.dart';
import 'package:hitchride/src/features/shared/presentation/loading_screen.dart';
import 'package:hitchride/src/features/shared/state/google_maps_provider.dart';
import 'package:hitchride/src/features/shared/widgets/loading_effect.dart';
import 'package:hitchride/src/core/logger_config/logger.dart';
import 'package:hitchride/src/core/utils.dart';
import 'package:hitchride/src/features/ride/widget/location_suggestions.dart';
import 'package:hitchride/src/features/shared/widgets/slide_page_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PickupSection extends ConsumerStatefulWidget {
  const PickupSection(
      {Key? key,
      required this.onTapCurrentLocation,
      required this.onTapNearbyPlaces})
      : super(key: key);

  final Function(String location, String name, String address)
      onTapCurrentLocation;

  final Function(String location, String name, String address)
      onTapNearbyPlaces;

  @override
  ConsumerState<PickupSection> createState() => _PickupSectionState();
}

class _PickupSectionState extends ConsumerState<PickupSection> {
  @override
  Widget build(BuildContext context) {
    final locationInputPickupAddress = ref.watch(locationInputProvider
        .select((locationInput) => locationInput.pickupAddress));
    final locationInputPickupPlaceId = ref.watch(locationInputProvider
        .select((locationInput) => locationInput.pickupPlaceId));
    final locationInputPickupName = ref.watch(locationInputProvider
        .select((locationInput) => locationInput.pickupName));
    final nearbyPlacesAsyncValue = ref.watch(nearbyPlacesProvider(5));

    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: 15.0, color: Colors.grey[200]), // grey divider
            ListTile(
              leading:
                  const Icon(Icons.gps_fixed_rounded), // leading 'target' icon
              title: const Text('Use my current location',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                locationInputPickupAddress ?? 'Empty address',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => widget.onTapCurrentLocation(
                  locationInputPickupPlaceId!,
                  locationInputPickupName!,
                  locationInputPickupAddress!),
            ),
            // const SavedPlacesSection(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: 15.0, color: Colors.grey[200]), // grey divider
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                  child: Text(
                    'Nearby Places',
                    style: TextStyle(
                      fontSize: 16, // smaller font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                    fit: FlexFit.loose,
                    child: nearbyPlacesAsyncValue.when(
                      data: (nearbyPlaces) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              for (final place in nearbyPlaces)
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => widget.onTapNearbyPlaces(
                                          place.placeId,
                                          place.name,
                                          place.formattedAddress),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const CircleAvatar(
                                            radius: 13.0,
                                            // backgroundColor:
                                            //     Color.fromRGBO(4, 176, 81, 1),
                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  place.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const SizedBox(height: 4.0),
                                                Text(
                                                  place.formattedAddress,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    const Divider(
                                      height: 1.0,
                                      indent: 16.0,
                                      endIndent: 16.0,
                                    ),
                                    const SizedBox(height: 10.0),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                      error: (error, stackTrace) => const Center(
                        child: Text('Error'),
                      ),
                      loading: () => buildFadeShimmerLoadingEffect(3),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LocationsFinaliseScreen extends ConsumerStatefulWidget {
  const LocationsFinaliseScreen(
      {Key? key,
      required this.navigateToRideScreen,
      required this.isCurrentLocationHighlighted})
      : super(key: key);

  final bool isCurrentLocationHighlighted;
  final bool navigateToRideScreen;

  @override
  ConsumerState<LocationsFinaliseScreen> createState() =>
      _LocationsFinaliseScreenState();
}

class _LocationsFinaliseScreenState
    extends ConsumerState<LocationsFinaliseScreen> {
  late TextEditingController _currentLocationController;
  late FocusNode _currentLocationFocusNode;
  Timer? _debounce;
  late TextEditingController _destinationController;
  late FocusNode _destinationFocusNode;
  bool _isLoading = false;
  List<PlacePrediction> _locationPredictions = [];
  final _logger = getLogger('Location Finalise Screen');
  late String _sessionToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logger.i('Location Data: ${ref.watch(locationInputProvider).toString()}');
    _currentLocationController.text =
        ref.watch(locationInputProvider).pickupName ?? '';
    _destinationController.text =
        ref.watch(locationInputProvider).destinationName ?? '';
  }

  @override
  void dispose() {
    _currentLocationController.dispose();
    _destinationController.dispose();
    _currentLocationFocusNode.dispose();
    _destinationFocusNode.dispose();
    ref.invalidate(locationSelectionProvider);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentLocationController = TextEditingController();
    _destinationController = TextEditingController();
    _currentLocationFocusNode = FocusNode();
    _destinationFocusNode = FocusNode();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _sessionToken = getNewSessionToken();
      });
      final locationSelectionNotifier = ref.read(locationSelectionProvider);
      widget.isCurrentLocationHighlighted
          ? locationSelectionNotifier.setCurrentLocationActive()
          : locationSelectionNotifier.setDestinationActive();
    });
  }

  Future<void> fetchPredictions(String input) async {
    _logger.i('Session Token: $_sessionToken');
    Map<String, String> payload = {
      "input": input,
      "sessionToken": _sessionToken,
    };
    final response = ref.watch(autocompleteResultsProvider(payload).future);
    final predictionList = await response;
    setState(() {
      _isLoading = false;
      _locationPredictions = predictionList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationInput = ref.watch(locationInputProvider);
    final locationSelection = ref.watch(locationSelectionProvider);
    final googleMapsApiClient = ref.watch(googleMapsApiClientProvider);

    _currentLocationFocusNode.addListener(() {
      if (!_currentLocationFocusNode.hasFocus) {
        if (_currentLocationController.text.isEmpty) {
          _currentLocationController.text = locationInput.pickupName ?? '';
        }
      }
    });
    _destinationFocusNode.addListener(() {
      if (!_destinationFocusNode.hasFocus) {
        if (_destinationController.text.isEmpty) {
          _destinationController.text = locationInput.destinationName ?? '';
        }
      }
    });

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(SlidePageRoute(
            builder: (context) => const LoadingScreen(), isSlideRight: true));
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          toolbarHeight: 130,
          flexibleSpace: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(SlidePageRoute(
                          builder: (context) => const LoadingScreen(),
                          isSlideRight: true));
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          title: Consumer(builder: (context, ref, child) {
                            return InkWell(
                              onTap: () {
                                locationSelection.setCurrentLocationActive();
                                _destinationFocusNode.unfocus();
                              },
                              //This is used so that when user first taps on an unfocused text field, the text field
                              //would not be focused right away. Instead, the user would have to tap on the text field again,
                              //then the keyboard would show up.
                              child: ConditionalParentWidget(
                                condition: !locationSelection
                                    .locationSelection.isCurrentLocationActive,
                                parentBuilder: (Widget child) => IgnorePointer(
                                  child: child,
                                ),
                                child: TextField(
                                  controller: _currentLocationController,
                                  focusNode: _currentLocationFocusNode,
                                  onChanged: (value) {
                                    if (_debounce?.isActive ?? false) {
                                      _debounce!.cancel();
                                    }
                                    _debounce =
                                        Timer(const Duration(seconds: 1), () {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        locationSelection.setTypingLocation();
                                        fetchPredictions(value);
                                      } else {
                                        setState(() {
                                          _locationPredictions = [];
                                        });
                                      }
                                    });
                                  },
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.location_on),
                                      hintText: 'Current location',
                                      hintStyle: locationSelection
                                              .locationSelection
                                              .isCurrentLocationActive
                                          ? const TextStyle(
                                              fontWeight: FontWeight.bold)
                                          : null,
                                      filled: ref
                                          .watch(locationSelectionProvider)
                                          .locationSelection
                                          .isCurrentLocationActive,
                                      suffixIcon: _currentLocationController
                                                  .text.isNotEmpty &&
                                              locationSelection
                                                  .locationSelection
                                                  .isCurrentLocationActive
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _locationPredictions = [];
                                                  _currentLocationController
                                                      .clear();
                                                });
                                                locationSelection
                                                    .setCurrentLocationActive();
                                                _sessionToken =
                                                    getNewSessionToken();
                                              },
                                              icon: const Icon(
                                                  Icons.clear_outlined),
                                            )
                                          : null),
                                ),
                              ),
                            );
                          }),
                        ),
                        ListTile(
                          title: Consumer(builder: (context, ref, child) {
                            return InkWell(
                              onTap: () {
                                locationSelection.setDestinationActive();
                                _currentLocationFocusNode.unfocus();
                              },
                              child: ConditionalParentWidget(
                                condition: !locationSelection
                                    .locationSelection.isDestinationActive,
                                parentBuilder: (Widget child) => IgnorePointer(
                                  child: child,
                                ),
                                child: TextField(
                                  controller: _destinationController,
                                  focusNode: _destinationFocusNode,
                                  onChanged: (value) {
                                    if (_debounce?.isActive ?? false) {
                                      _debounce!.cancel();
                                    }
                                    _debounce =
                                        Timer(const Duration(seconds: 1), () {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        locationSelection
                                            .setTypingDestination();
                                        fetchPredictions(value);
                                      } else {
                                        setState(() {
                                          _locationPredictions = [];
                                        });
                                      }
                                    });
                                  },
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.flag),
                                      hintText: 'Where to?',
                                      hintStyle: locationSelection
                                              .locationSelection
                                              .isDestinationActive
                                          ? const TextStyle(
                                              fontWeight: FontWeight.bold)
                                          : null,
                                      filled: locationSelection
                                          .locationSelection
                                          .isDestinationActive,
                                      suffixIcon: _destinationController
                                                  .text.isNotEmpty &&
                                              locationSelection
                                                  .locationSelection
                                                  .isDestinationActive
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _locationPredictions = [];
                                                  _destinationController
                                                      .clear();
                                                });
                                                locationSelection
                                                    .setDestinationActive();
                                                _sessionToken =
                                                    getNewSessionToken();
                                              },
                                              icon: const Icon(
                                                  Icons.clear_outlined),
                                            )
                                          : null),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
            color: Colors.white,
            // If the user is typing in the current location or destination text field, display the location suggestions
            child: !locationSelection.locationSelection.isTypingCurrent &&
                    !locationSelection.locationSelection.isTypingDestination
                // If the user is not typing in the current location or destination text field, AND
                // the current location text field is focused, display the pickup section
                ? (locationSelection.locationSelection.isCurrentLocationActive
                    ? PickupSection(
                        onTapCurrentLocation: (location, name, address) {
                          if (_currentLocationController.text.isNotEmpty) {
                            _currentLocationController.text = address;
                          }
                          ref
                              .watch(locationInputProvider.notifier)
                              .setPickupLocationWithAddressString(
                                  location, address, name);
                          widget.isCurrentLocationHighlighted
                              ? (widget.navigateToRideScreen
                                  ? Navigator.of(context).pushReplacement(
                                      createSlideTransition(
                                          (context) =>
                                              const AvailableDriversScreen(),
                                          enter: true))
                                  : Navigator.pop(context))
                              : (_destinationController.text.isEmpty
                                  ? locationSelection.setDestinationActive()
                                  : Navigator.of(context).pushReplacement(
                                      createSlideTransition(
                                          (context) =>
                                              const AvailableDriversScreen(),
                                          enter: true)));
                        },
                        onTapNearbyPlaces: (location, name, address) async {
                          if (_currentLocationController.text.isNotEmpty) {
                            _currentLocationController.text = address;
                          }
                          ref
                              .watch(locationInputProvider.notifier)
                              .setPickupLocationWithAddressString(
                                  location, address, name);
                          widget.isCurrentLocationHighlighted
                              ? (widget.navigateToRideScreen
                                  ? Navigator.of(context).pushReplacement(
                                      createSlideTransition(
                                          (context) =>
                                              const AvailableDriversScreen(),
                                          enter: true))
                                  : Navigator.pop(context))
                              : (_destinationController.text.isEmpty
                                  ? locationSelection.setDestinationActive()
                                  : Navigator.of(context).pushReplacement(
                                      createSlideTransition(
                                          (context) =>
                                              const AvailableDriversScreen(),
                                          enter: true)));
                        },
                      )
                    // If the user is not typing in the current location or destination text field, AND
                    // the destination text field is focused, display the destination section
                    : Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 80),
                          Image.asset(
                            'assets/images/address_illustration.png',
                            width: 200,
                            height: 200,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Enter an Address to Get Started!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )))
                // While waiting for the location suggestions to load, display a loading indicator
                : _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    // After the location suggestions have loaded, display the location suggestions
                    : LocationSuggestions(
                        locationPredictions: _locationPredictions,
                        onTap: (locationName, locationAddress, placeId) async {
                          if (mounted) {
                            if (_currentLocationFocusNode.hasFocus) {
                              _currentLocationController.text =
                                  locationAddress != 'No address'
                                      ? locationAddress
                                      : locationName;
                              setState(() {
                                _locationPredictions = [];
                              });
                              final placeDetails = await googleMapsApiClient
                                  .getPlaceDetails(placeId,
                                      sessionToken: _sessionToken);
                              _sessionToken = getNewSessionToken();
                              ref
                                  .watch(locationInputProvider.notifier)
                                  .setPickupLocationWithAddressString(
                                      placeDetails.placeId,
                                      locationAddress,
                                      locationName);
                              widget.isCurrentLocationHighlighted
                                  ? (widget.navigateToRideScreen
                                      ? Navigator.of(context).pushReplacement(
                                          createSlideTransition(
                                              (context) =>
                                                  const AvailableDriversScreen(),
                                              enter: true))
                                      : Navigator.pop(context))
                                  : (_destinationController.text.isEmpty
                                      ? locationSelection.setDestinationActive()
                                      : Navigator.of(context).pushReplacement(
                                          createSlideTransition(
                                              (context) =>
                                                  const AvailableDriversScreen(),
                                              enter: true)));
                            } else {
                              _destinationController.text = locationAddress;
                              setState(() {
                                _locationPredictions = [];
                              });
                              final placeDetails = await googleMapsApiClient
                                  .getPlaceDetails(placeId,
                                      sessionToken: _sessionToken);
                              _sessionToken = getNewSessionToken();
                              ref
                                  .watch(locationInputProvider.notifier)
                                  .setDestinationWithAddressString(
                                      placeDetails.placeId,
                                      locationAddress,
                                      locationName);
                              !widget.isCurrentLocationHighlighted
                                  ? (widget.navigateToRideScreen
                                      ? Navigator.of(context).pushReplacement(
                                          createSlideTransition(
                                              (context) =>
                                                  const AvailableDriversScreen(),
                                              enter: true))
                                      : Navigator.pop(context))
                                  : (_currentLocationController.text.isEmpty
                                      ? locationSelection
                                          .setCurrentLocationActive()
                                      : Navigator.of(context).pushReplacement(
                                          createSlideTransition(
                                              (context) =>
                                                  const AvailableDriversScreen(),
                                              enter: true)));
                            }
                          }
                        },
                      )),
      ),
    );
  }
}
