// Programmer's Name: Ang Ru Xian
// Program Name: driver_journey_bottomsheet.dart
// Description: This is a file that contains the bottom sheet that is shown when a driver journey is selected.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hitchride/src/features/shared/widgets/custom_icons.dart';
import 'package:hitchride/src/core/utils.dart';
import 'package:hitchride/src/features/driver/data/model/driver_journey.dart';
import 'package:hitchride/src/features/shared/widgets/fade_dialog.dart';

class DriverJourneyBottomSheet extends StatelessWidget {
  final DriverJourney driverJourney;
  final Function onAcceptRide;

  const DriverJourneyBottomSheet(
      {Key? key, required this.driverJourney, required this.onAcceptRide})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage:
                      NetworkImage(driverJourney.djDriver!.userPhotoUrl),
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      driverJourney.djDriver!.userName,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        openWhatsapp(
                            context: context,
                            number: driverJourney.djDriver!.userPhoneNumber);
                      },
                      icon:
                          const Icon(CustomIcons.whatsapp, color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(width: 20.0),
                RatingBarIndicator(
                  rating: driverJourney.djDriver!.userDriverInfo!.diRating
                          ?.toDouble() ??
                      0,
                  itemBuilder: (context, index) =>
                      const Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 24.0,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              '${driverJourney.djDriver!.userDriverInfo!.diCarBrand} ${driverJourney.djDriver!.userDriverInfo!.diCarModel}',
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Text(
                          driverJourney.djOriginDestination.origin.addressName, style: const TextStyle(fontSize: 16.0),),
                    ),
                  ],
                ),
                const SizedBox(height: 13.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.flag,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Text(driverJourney
                          .djOriginDestination.destination.addressName, style: const TextStyle(fontSize: 16.0)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Text(formatTimestamp(driverJourney.djTimestamp),
                style: const TextStyle(fontSize: 16.0)),
            const SizedBox(height: 8.0),
            Text('RM ${driverJourney.djPrice}',
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10.0),
                )),
                onPressed: () {
                  showFadeDialog(
                    context: context,
                    title: 'Confirm Ride Booking',
                    content:
                        const Text('Are you sure you want to book this ride?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onAcceptRide(driverJourney);
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'),
                      ),
                    ],
                  );
                },
                child: const Text('Take this Ride',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
