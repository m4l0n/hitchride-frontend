// Programmer's Name: Ang Ru Xian
// Program Name: pickup_point_screen.dart
// Description: This is a file that contains the screen that displays the pickup point with the map.
// Last Modified: 22 July 2023

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hitchride/src/constants/app_constants.dart';
import 'package:hitchride/src/features/ride/state/location_input_provider.dart';
import 'package:hitchride/src/features/shared/presentation/loading_screen.dart';
import 'package:hitchride/src/features/shared/state/google_maps_provider.dart';
import 'package:hitchride/src/features/shared/widgets/circular_back_button.dart';
import 'package:hitchride/src/core/utils.dart';
import 'package:hitchride/src/features/ride/presentation/available_drivers_screen.dart';
import 'package:hitchride/src/features/ride/presentation/locations_finalise_screen.dart';
import 'package:hitchride/src/features/shared/widgets/enlarged_elevated_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:marquee/marquee.dart';

class PickupPointScreen extends ConsumerStatefulWidget {
  const PickupPointScreen({super.key});

  @override
  ConsumerState<PickupPointScreen> createState() => _PickupPointScreenState();
}

class _PickupPointScreenState extends ConsumerState<PickupPointScreen> {
  late GoogleMapController _controller;
  late LatLng _initialLocation;
  bool _isLoading = true;
  final Completer<void> _markerInitialised = Completer<void>();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final googleMapsApiClient = ref.read(googleMapsApiClientProvider);
      final locationInput = ref.read(locationInputProvider);
      var value = await googleMapsApiClient
          .getPlaceDetails(locationInput.pickupPlaceId!);
      setState(() {
        _initialLocation = LatLng(value.latLng.lat, value.latLng.lng);
        _markers = {
          Marker(
            markerId: const MarkerId('initialLocation'),
            position: LatLng(value.latLng.lat, value.latLng.lng),
          ),
        };
        _isLoading = false;
      });
      _markerInitialised.complete();
    }); //This is to ensure that the state is initialised before the build method is called
  }

  double _getTextWidth(String text, TextStyle style, BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.width;
  }

  @override
  Widget build(BuildContext context) {
    final locationInput = ref.read(locationInputProvider);
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: Stack(children: [
              Column(
                children: <Widget>[
                  Expanded(
                    flex: MediaQuery.of(context).viewInsets.bottom == 0
                        ? 3
                        : 1, //auto adjust the height of the map based on keyboard visibility
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _initialLocation,
                        zoom: 15,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                        _controller.setMapStyle(AppConstants.mapStyle);
                      },
                      markers: _markers,
                    ),
                  ),
                  Expanded(
                    flex: MediaQuery.of(context).viewInsets.bottom == 0 ? 1 : 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(createSlideTransition(
                                  (context) => const LocationsFinaliseScreen(
                                        navigateToRideScreen: true,
                                        isCurrentLocationHighlighted: true,
                                      ),
                                  enter: true));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[400],
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.location_on),
                                title: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    final text = locationInput.pickupName ??
                                        'Unknown Address';
                                    const textStyle = TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold);
                                    final textWidth =
                                        _getTextWidth(text, textStyle, context);

                                    if (textWidth > constraints.maxWidth) {
                                      return SizedBox(
                                        height: 30,
                                        child: Marquee(
                                          text: text,
                                          style: textStyle,
                                          scrollAxis: Axis.horizontal,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          blankSpace: 20.0,
                                          velocity: 100.0,
                                          pauseAfterRound:
                                              const Duration(seconds: 1),
                                          startPadding: 5.0,
                                          accelerationDuration:
                                              const Duration(seconds: 1),
                                          accelerationCurve: Curves.linear,
                                          decelerationDuration:
                                              const Duration(milliseconds: 500),
                                          decelerationCurve: Curves.easeOut,
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        text,
                                        style: textStyle,
                                      );
                                    }
                                  },
                                ),
                                subtitle: Text(
                                  locationInput.pickupAddress!,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          indent: 20.0,
                          endIndent: 20.0,
                        ),
                        EnlargedElevatedButton(
                            isLoading: false,
                            text: 'Choose this pickup',
                            onPressed: () {
                              Navigator.of(context).push(createSlideTransition(
                                  (context) => const AvailableDriversScreen(),
                                  enter: true));
                            })
                      ],
                    ),
                  ),
                ],
              ),
              CircularBackButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoadingScreen()));
                },
              ),
            ]),
          );
  }
}
