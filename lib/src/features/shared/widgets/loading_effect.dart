// Programmer's Name: Ang Ru Xian
// Program Name: loading_effect.dart
// Description: This is a file that contains the widget for the shimmer loading effect.
// Last Modified: 22 July 2023

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

Widget buildFadeShimmerLoadingEffect(int itemCount) {
  return SizedBox(
    height: 40 * itemCount.toDouble(),
    child: ListView.builder(
      itemCount: itemCount, // number of shimmer items to display
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.location_on, color: Colors.grey[300]),
        title: FadeShimmer(
          millisecondsDelay: 200 * index, // stagger the delay for each item
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          width: double.infinity,
          height: 10,
        ),
        subtitle: FadeShimmer(
          millisecondsDelay: 200 * index + 100, // stagger the delay for each item
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          width: double.infinity,
          height: 10,
        ),
      ),
    ),
  );
}

