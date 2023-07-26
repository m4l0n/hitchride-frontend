// Programmer's Name: Ang Ru Xian
// Program Name: rewards_screen.dart
// Description: This is a file that contains the RewardsScreen widget that displays a list of rewards.
// Last Modified: 22 July 2023


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hitchride/src/features/account/state/reward_provider.dart';
import 'package:hitchride/src/features/account/widgets/reward_card.dart';
import 'package:hitchride/src/features/account/widgets/rewards_category.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 140,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('HitchRide Rewards',
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: GoogleFonts.lobsterTwo().fontFamily,
                              fontWeight: FontWeight.bold)),
                      const Text(
                        'Your Points',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Consumer(builder: (context, ref, child) {
          final rewardCategories = ref.watch(rewardCategoriesProvider);
          return rewardCategories.when(
            data: (rewardCategories) => ListView.separated(
              itemCount: rewardCategories.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 32.0),
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final category = rewardCategories[index];
                return RewardsCategory(
                  title: category.rcName,
                  rewards: category.rcRewardsList
                      .map((reward) => RewardCard(
                            reward: reward,
                          ))
                      .toList(),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          );
        }));
  }
}
