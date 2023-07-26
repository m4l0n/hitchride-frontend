// Programmer's Name: Ang Ru Xian
// Program Name: user_info_skeleton.dart
// Description: This is a file that contains the skeleton loader for the user info screen.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserInfoScreenSkeleton extends StatelessWidget {
  final double height;

  const UserInfoScreenSkeleton({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            height / 4),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: AppBar(
            backgroundColor: Colors.grey[300],
            flexibleSpace: const SafeArea(
              child: CircleAvatar(), // Representing the profile picture
            ),
          ),
        ),
      ),
      body: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    color: Colors.white,
                  ),
                ), // Representing the Full Name field
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    color: Colors.white,
                  ),
                ), // Representing the Mobile Number field
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    color: Colors.white,
                  ),
                ), // Representing the Email Address field
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    color: Colors.white,
                  ),
                ), // Representing the Save button
              ],
            ),
          ),
        ),
      ),
    );
  }
}
