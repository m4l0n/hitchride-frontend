// Programmer's Name: Ang Ru Xian
// Program Name: driver_journey_detail_screen.dart
// Description: This is a file that contains the UI for driver journey detail screen.
// Last Modified: 22 July 2023

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hitchride/src/core/utils.dart';
import 'package:hitchride/src/features/driver/data/model/driver_journey.dart';
import 'package:hitchride/src/features/ride/state/rides_provider.dart';
import 'package:hitchride/src/features/ride/data/model/ride.dart';
import 'package:hitchride/src/features/shared/widgets/custom_icons.dart';
import 'package:hitchride/src/features/shared/widgets/enlarged_elevated_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DriverJourneyDetailScreen extends ConsumerStatefulWidget {
  const DriverJourneyDetailScreen(
      {Key? key, required this.driverJourney, required this.onTapDelete})
      : super(key: key);

  final DriverJourney driverJourney;
  final VoidCallback onTapDelete;

  @override
  ConsumerState<DriverJourneyDetailScreen> createState() =>
      _DriverJourneyDetailScreenState();
}

class _DriverJourneyDetailScreenState
    extends ConsumerState<DriverJourneyDetailScreen> {
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  void _onCompleteRide(Ride ride) async {
    _isLoading.value = true;
    try {
      final rideRepository = ref.read(rideRepositoryProvider);
      await rideRepository.completeRide(ride);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Ride completed')));
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    } finally {
      _isLoading.value = false;
    }
  }

  Widget _buildJourneyDetailsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Journey Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_pin,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Text(widget.driverJourney.djOriginDestination
                          .origin.addressName),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.flag_rounded,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Text(widget.driverJourney.djOriginDestination
                          .destination.addressName),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Price',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('RM ${widget.driverJourney.djPrice}'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Date and Time',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(formatTimestamp(widget.driverJourney.djTimestamp)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerInfoSection(Ride ride) {
    final passenger = ride.ridePassenger!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Passenger Information',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      passenger.userPhotoUrl,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Text(
                    passenger.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      widthFactor: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          openWhatsapp(
                              context: context,
                              number: passenger.userPhoneNumber);
                        },
                        icon: const Icon(CustomIcons.whatsapp,
                            color: Colors.green),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(Icons.location_pin, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pickup Point', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          ride.rideOriginDestination.origin.addressString,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(Icons.flag_rounded, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Destination', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          ride.rideOriginDestination.destination.addressString,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {  
    // Get the ride data for this driver journey
    final rideAsyncValue =
        ref.watch(driverJourneyRideProvider(widget.driverJourney.djId!));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Ride Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: widget.onTapDelete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildJourneyDetailsSection(),
            const SizedBox(height: 20),
            // Show passenger information if there is a ride associated with this driver journey
            rideAsyncValue.when(
              data: (ride) {
                if (ride == null) {
                  // If there is no ride, show a message indicating that there are no passengers yet
                  return const Center(
                    child: Text('No passengers yet',
                        style: TextStyle(fontSize: 20)),
                  );
                }
                // If there is a ride, show the passenger information
                return _buildPassengerInfoSection(ride);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  const Center(child: Text('Error loading ride data')),
            )
          ],
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: _isLoading,
          builder: (context, bool isLoading, child) => EnlargedElevatedButton(
                isLoading: isLoading,
                onPressed: () => rideAsyncValue.maybeWhen(
                  data: (ride) => ride != null ? _onCompleteRide(ride) : null,
                  orElse: () {},
                ),
                text: 'Complete Ride',
              )),
    );
  }
}