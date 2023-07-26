// Programmer's Name: Ang Ru Xian
// Program Name: activity_tile_skeleton.dart
// Description: This is a file that contains the skeleton loader for the activity tile.
// Last Modified: 22 July 2023


import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ActivityTileSkeletonLoader extends StatelessWidget {
  const ActivityTileSkeletonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[500],
          radius: 24.0,
        ),
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Colors.grey[500],
          ),
          width: double.infinity,
          height: 10.0,
        ),
        subtitle: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Colors.grey[500],
          ),
          width: double.infinity,
          height: 10.0,
          margin: const EdgeInsets.only(top: 5.0),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Colors.grey[500],
          ),
          width: 60.0,
          height: 10.0,
        ),
      ),
    );
  }
}
