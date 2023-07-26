// Programmer's Name: Ang Ru Xian
// Program Name: rewards_detail_screen.dart
// Description: This is a file that contains the RewardsDetailScreen widget that displays the details of a reward.
// Last Modified: 22 July 2023


import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hitchride/src/features/account/data/model/reward.dart';
import 'package:hitchride/src/features/account/data/repository/reward_repository.dart';
import 'package:hitchride/src/features/account/state/reward_provider.dart';
import 'package:hitchride/src/features/shared/widgets/enlarged_elevated_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RewardsDetailScreen extends HookConsumerWidget {
  final Reward reward;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  RewardsDetailScreen({super.key, required this.reward});

  void onRedeem(BuildContext context, RewardRepository rewardRepository) async {
    try {
      _isLoading.value = true;
      await rewardRepository.redeemReward(reward.rewardId);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Reward redeemed')));
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardRepository = ref.watch(rewardRepositoryProvider);
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200,
              flexibleSpace: _RewardsDetailAppBar(
                imageUrl: reward.rewardPhotoUrl,
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              pinned: true,
              floating: true,
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    reward.rewardTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Points Required',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(reward.rewardPointsRequired.toString()),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 2.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Validity Duration',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(reward.rewardDuration.toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        reward.rewardDescription,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ValueListenableBuilder<bool>(
            valueListenable: _isLoading,
            builder: (context, isLoading, child) => EnlargedElevatedButton(
                text: 'Redeem',
                onPressed: () {
                  onRedeem(context, rewardRepository);
                },
                isLoading: isLoading)));
  }
}

class _RewardsDetailAppBar extends StatelessWidget {
  final String imageUrl;

  const _RewardsDetailAppBar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0);
        final fadeStart = max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        return SafeArea(
          child: Stack(
            children: [
              Center(
                  child: Opacity(
                      opacity: 1 - opacity,
                      child: const Text(
                        'Unlock Discount Vouchers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ))),
              Opacity(
                  opacity: opacity,
                  child: Container(
                      decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ))),
            ],
          ),
        );
      },
    );
  }
}
