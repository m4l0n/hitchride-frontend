// Programmer's Name: Ang Ru Xian
// Program Name: driver_upcoming_journey_screen.dart
// Description: This is a file that contains the screen that displays the driver's upcoming journeys.
// Last Modified: 22 July 2023

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hitchride/src/core/logger_config/logger.dart';
import 'package:hitchride/src/core/utils.dart';
import 'package:hitchride/src/features/driver/presentation/driver_journey_detail_screen.dart';
import 'package:hitchride/src/features/driver/state/driver_journey_provider.dart';
import 'package:hitchride/src/features/shared/widgets/fade_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DriverUpcomingJourneyScreen extends ConsumerStatefulWidget {
  const DriverUpcomingJourneyScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DriverUpcomingJourneyScreen> createState() =>
      _DriverUpcomingJourneyScreenState();
}

class _DriverUpcomingJourneyScreenState
    extends ConsumerState<DriverUpcomingJourneyScreen> {
  final _logger = getLogger('DriverUpcomingJourney');

  @override
  Widget build(BuildContext context) {
    final driverJourneyAsyncValue =
        ref.watch(driverUpcomingDriverJourneyProvider);
    final driverJourneyRepository = ref.watch(driverJourneyRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Your Upcoming Journeys',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: driverJourneyAsyncValue.when(
          data: (driverUpcomingJourney) {
            if (driverUpcomingJourney.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/no_data.png',
                    width: 250,
                    height: 250,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "No upcoming journey",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                return await ref.refresh(driverUpcomingDriverJourneyProvider);
              },
              child: ListView.builder(
                itemCount: driverUpcomingJourney.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (BuildContext context, int index) {
                  final journey = driverUpcomingJourney[index];
                  return Card(
                      child: OpenContainer(
                          transitionDuration: const Duration(milliseconds: 400),
                          transitionType: ContainerTransitionType.fadeThrough,
                          closedBuilder: (_, VoidCallback openContainer) {
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 24.0,
                                backgroundImage: AssetImage(
                                  'assets/images/transport_icon.png',
                                ),
                              ),
                              title: Text('RM ${journey.djPrice}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(formatTimestamp(journey.djTimestamp)),
                                  Text(
                                    '${journey.djOriginDestination.origin.addressName} to ${journey.djOriginDestination.destination.addressName}',
                                  ),
                                ],
                              ),
                              onTap: openContainer,
                            );
                          },
                          openBuilder: (_, VoidCallback closeContainer) {
                            return DriverJourneyDetailScreen(
                              driverJourney: journey,
                              onTapDelete: () async {
                                _logger.i('Delete journey ${journey.djId}');
                                showFadeDialog(
                                    context: context,
                                    title: 'Delete Confirmation',
                                    content: const Text(
                                        'Are you sure you want to delete this journey?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            await driverJourneyRepository
                                                .deleteDriverJourney(
                                                    journey.djId!);
                                            if (mounted) {
                                              setState(() {
                                                driverUpcomingJourney
                                                    .removeAt(index);
                                              });
                                              Navigator.of(context).popUntil(
                                                  (route) => route.isFirst);
                                            }
                                          } on Exception catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(e.toString()),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text('Yes'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('No'),
                                      ),
                                    ]);
                              },
                            );
                          }));
                },
              ),
            );
          },
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }
}
