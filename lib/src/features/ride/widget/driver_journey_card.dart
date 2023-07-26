// Programmer's Name: Ang Ru Xian
// Program Name: driver_journey_card.dart
// Description: This is a file that contains the widget that displays each driver journey in a card.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:hitchride/src/core/utils.dart';
import 'package:hitchride/src/features/driver/data/model/driver_journey.dart';

class DriverJourneyCard extends StatelessWidget {
  final DriverJourney driverJourney;
  final VoidCallback onTap;

  const DriverJourneyCard({Key? key, required this.driverJourney, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 24.0,
                backgroundImage: AssetImage(
                  'assets/images/transport_icon.png',
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverJourney.djDriver!.userName,
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(formatTimestamp(driverJourney.djTimestamp)),
                    const SizedBox(height: 8.0),
                    Text(
                      '${driverJourney.djDriver!.userDriverInfo!.diCarBrand} ${driverJourney.djDriver!.userDriverInfo!.diCarModel}',
                    ),
                    const SizedBox(height: 8.0),
                    Text('RM ${driverJourney.djPrice}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}