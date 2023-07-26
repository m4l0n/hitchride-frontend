// Programmer's Name: Ang Ru Xian
// Program Name: ride_tile.dart
// Description: This is a file that contains the widget that displays each ride in a tile. 
// Last Modified: 22 July 2023


import 'package:flutter/material.dart';
import 'package:hitchride/src/core/utils.dart';
import 'package:hitchride/src/features/ride/data/model/ride.dart';
import 'package:hitchride/src/features/ride/data/repository/ride_repository.dart';
import 'package:hitchride/src/features/ride/state/rides_provider.dart';
import 'package:hitchride/src/features/shared/widgets/fade_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RideTile extends HookConsumerWidget {
  final Ride ride;
  final VoidCallback onDelete;

  const RideTile({super.key, required this.ride, required this.onDelete});

  Future<void> _handleDelete(
      BuildContext context, RideRepository rideRepository) async {
    try {
      await rideRepository.cancelRide(ride.rideId!);
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ride.rideDriverJourney.djDriver!;
    final car = driver.userDriverInfo!;
    final origin = ride.rideOriginDestination.origin.addressName;
    final destination = ride.rideOriginDestination.destination.addressName;
    final date = formatTimestamp(ride.rideDriverJourney.djTimestamp);
    final RideRepository rideRepository = ref.read(rideRepositoryProvider);

    Future<void> showDeleteConfirmationDialog() async {
      return showFadeDialog(
        context: context,
        title: 'Delete Ride',
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this ride?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop();
              _handleDelete(context, rideRepository);
              onDelete();
            },
          ),
        ],
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(driver.userPhotoUrl),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: showDeleteConfirmationDialog,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              driver.userName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Date: $date'),
            const SizedBox(height: 4),
            Text('From: $origin'),
            const SizedBox(height: 4),
            Text('To: $destination'),
            const SizedBox(height: 4),
            Text(
                'Car: ${car.diCarBrand} ${car.diCarModel} (${car.diCarLicensePlate})'),
            const SizedBox(height: 4),
            Text(
              'Price: RM ${ride.rideDriverJourney.djPrice}',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
