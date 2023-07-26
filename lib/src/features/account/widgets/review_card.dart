// Programmer's Name: Ang Ru Xian
// Program Name: review_card.dart
// Description: This is a file that contains the widget to display each review.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:hitchride/src/core/utils.dart';

class ReviewCard extends StatelessWidget {
  final String driverName;
  final String driverCar;
  final double starRating;
  final DateTime date;
  final String description;
  final String pickupAddress;
  final String destinationAddress;

  const ReviewCard({
    super.key,
    required this.driverName,
    required this.driverCar,
    required this.starRating,
    required this.date,
    required this.description,
    required this.pickupAddress,
    required this.destinationAddress,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$driverName - $driverCar',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                Text(starRating.toString()),
                const SizedBox(width: 8),
                Text(formatTimestamp(date.millisecondsSinceEpoch),
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 8),
            Text(
              'Ride: $pickupAddress - $destinationAddress',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
