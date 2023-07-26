// Programmer's Name: Ang Ru Xian
// Program Name: activity_tile.dart
// Description: This is a file that contains the widget that displays a tile for each activity history.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:hitchride/src/core/utils.dart';
import 'package:hitchride/src/features/ride/data/model/ride.dart';
import 'package:hitchride/src/features/shared/presentation/leave_reviews_screen.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({super.key, required Ride ride, required bool leaveReview})
      : _leaveReview = leaveReview,
        _ride = ride;

  final bool _leaveReview;
  final Ride _ride;

  void _onLongPress(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(50.0, 50.0, 0.0, 0.0),
      items: [
        const PopupMenuItem<String>(
          value: 'leave_review',
          child: Text('Leave Review'),
        ),
      ],
    ).then((value) {
      if (value == 'leave_review') {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LeaveReviewsScreen(rideId: _ride.rideId!),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onLongPress: () => _leaveReview ? _onLongPress(context) : null,
      leading: const CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 24.0,
        backgroundImage: AssetImage(
          'assets/images/transport_icon.png',
        ),
      ),
      title: Text(
        'Ride to ${_ride.rideOriginDestination.destination.addressName}',
      ),
      subtitle: Text(formatTimestamp(_ride.rideDriverJourney.djTimestamp)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'RM ${_ride.rideDriverJourney.djPrice}',
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
