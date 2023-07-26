// Programmer's Name: Ang Ru Xian
// Program Name: main_screen.dart
// Description: This is a file that contains the screen that is shown after login
// Last Modified: 22 July 2023

import 'package:animations/animations.dart';
import 'package:hitchride/src/features/ride/state/location_input_provider.dart';
import 'package:hitchride/src/features/ride/presentation/upcoming_rides_screen.dart';
import 'package:hitchride/src/features/ride/state/rides_provider.dart';
import 'package:hitchride/src/features/shared/state/google_maps_provider.dart';
import 'package:hitchride/src/features/shared/widgets/loading_effect.dart';
import 'package:hitchride/src/core/utils.dart';
import 'package:hitchride/src/features/ride/presentation/locations_finalise_screen.dart';
import 'package:hitchride/src/features/ride/presentation/pickup_point_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const MainScreen(),
      );
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  // final _scrollController = ScrollController();

  // void _addScrollListener() {
  //   final navbarNotifier = ref.watch(navbarNotifierProvider);
  //   _scrollController.addListener(() {
  //     if (_scrollController.position.userScrollDirection ==
  //         ScrollDirection.forward) {
  //       if (navbarNotifier.hideBottomNavBar) {
  //         navbarNotifier.hideBottomNavBar = false;
  //       }
  //     } else {
  //       if (!navbarNotifier.hideBottomNavBar) {
  //         navbarNotifier.hideBottomNavBar = true;
  //       }
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // _addScrollListener();
      ref.read(locationInputProvider.notifier).init();
    });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Stack(children: [
        Column(
          children: [
            _buildEnterLocationButton(context, colorScheme),
            Card(
                color: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                margin: const EdgeInsets.all(16),
                child: _buildRecentRides(context)),
            const Padding(padding: EdgeInsets.only(top: 16)),
            Card(
                color: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                margin: const EdgeInsets.all(16),
                child: _buildRideToNearbyPlacesSection(context)),
            const SizedBox(
              height: 30,
            )
          ],
        ),
        Positioned(
          bottom: 10,
          right: 16,
          child: OpenContainer(
            transitionType: ContainerTransitionType.fade,
            closedElevation: 6,
            closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            closedColor: Colors.blue,
            closedBuilder: (_, openContainer) {
              return FloatingActionButton(
                  onPressed: openContainer,
                  child: const Icon(Icons.calendar_month));
            },
            openBuilder: (_, closeContainer) {
              return UpcomingRidesScreen(
                closeContainer: closeContainer,
              );
            },
          ),
        )
      ]),
    );
  }

  Widget _buildEnterLocationButton(
      BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.inverseSurface, // background color
          foregroundColor: colorScheme.onInverseSurface, // text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(createSlideTransition(
              (context) => const LocationsFinaliseScreen(
                  navigateToRideScreen: true,
                  isCurrentLocationHighlighted: false),
              enter: true, settings: const RouteSettings(name: 'FinaliseScreen')));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Where to?',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Icon(Icons.location_on, color: colorScheme.onInverseSurface),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentRides(BuildContext context) {
    final recentRidesAsyncValue = ref.watch(userRecentRidesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Recent Rides',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 150,
                maxHeight: 170,
                minWidth: MediaQuery.of(context).size.width,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: recentRidesAsyncValue.when(
                  data: (recentRides) {
                    if (recentRides.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No recent rides',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    if (recentRides.length > 2) {
                      recentRides = recentRides.sublist(0, 2);
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.only(
                          bottom: 16.0, left: 16.0, right: 16.0),
                      shrinkWrap:
                          true, // to prevent the ListView from expanding infinitely
                      physics:
                          const NeverScrollableScrollPhysics(), // to disable scrolling in this ListView
                      separatorBuilder: (context, index) =>
                          const Divider(color: Colors.grey),
                      itemCount: recentRides.length,
                      itemBuilder: (context, index) {
                        final locationData = recentRides[index]
                            .rideOriginDestination
                            .destination;
                        return GestureDetector(
                          onTap: () {
                            ref
                                .watch(locationInputProvider.notifier)
                                .setDestinationWithAddressString(
                                    locationData.placeId,
                                    locationData.addressString,
                                    locationData.addressName);
                            Navigator.of(context).push(createSlideTransition(
                                (context) => const PickupPointScreen(),
                                enter: true));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.history),
                              const SizedBox(width: 10.0),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      locationData.addressName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      locationData.addressString,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.navigate_next),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) => const Text('Error'),
                  loading: () => buildFadeShimmerLoadingEffect(2)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRideToNearbyPlacesSection(BuildContext context) {
    final nearbyPlacesAsyncValue = ref.watch(nearbyPlacesProvider(3));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ride from Nearby Places',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ],
          ),
        ),
        ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 210,
              maxHeight: 210,
              minWidth: MediaQuery.of(context).size.width,
              maxWidth: MediaQuery.of(context).size.width,
            ),
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
                              onTap: () {
                                ref
                                    .read(locationInputProvider.notifier)
                                    .setPickupLocationWithAddressString(
                                        place.placeId,
                                        place.formattedAddress,
                                        place.name);
                                Navigator.of(context).push(
                                    createSlideTransition(
                                        (context) =>
                                            const LocationsFinaliseScreen(
                                              isCurrentLocationHighlighted:
                                                  false,
                                              navigateToRideScreen: true,
                                            ),
                                        enter: true, settings: const RouteSettings(name: 'FinaliseScreen')));
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          place.formattedAddress,
                                          overflow: TextOverflow.ellipsis,
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
                            if (place != nearbyPlaces.last) ...[
                              const SizedBox(height: 10.0),
                              const Divider(
                                height: 1.0,
                                indent: 16.0,
                                endIndent: 16.0,
                              ),
                              const SizedBox(height: 10.0),
                            ]
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
    );
  }
}
