// Programmer's Name: Ang Ru Xian
// Program Name: rewards_category.dart
// Description: This is a file that contains the widget that displays each reward category.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:hitchride/src/features/account/widgets/reward_card.dart';

class RewardsCategory extends StatelessWidget {
  final String title;
  final List<RewardCard> rewards;

  const RewardsCategory({
    Key? key,
    required this.title,
    required this.rewards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: rewards.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: rewards[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
