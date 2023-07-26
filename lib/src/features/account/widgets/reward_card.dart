// Programmer's Name: Ang Ru Xian
// Program Name: reward_card.dart
// Description: This is a file that contains the widget to display each reward.
// Last Modified: 22 July 2023

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hitchride/src/features/account/data/model/reward.dart';
import 'package:hitchride/src/features/account/presentation/rewards_detail_screen.dart';

class RewardCard extends StatelessWidget {
  const RewardCard({
    Key? key,
    required this.reward,
  }) : super(key: key);

  final Reward reward;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedBuilder: (BuildContext context, VoidCallback action) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: reward.rewardPhotoUrl,
                height: 120,
                width: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons
                    .error), // Add an error widget if the image fails to load
              ),
              const SizedBox(height: 8.0),
              Text(
                reward.rewardTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                reward.rewardPointsRequired.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 4.0),
              const Text(
                'Points',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        );
      },
      openBuilder: (BuildContext context, VoidCallback _) {
        return RewardsDetailScreen(reward: reward);
      },
      closedElevation: 0.0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: Colors.grey),
      ),
      openElevation: 0.0,
      openShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: Colors.grey),
      ),
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
