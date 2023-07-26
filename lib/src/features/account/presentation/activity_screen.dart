// Programmer's Name: Ang Ru Xian
// Program Name: activity_screen.dart
// Description: This is a file that contains the ActivityHistoryScreen widget that displays the user's activity history.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:hitchride/src/features/account/widgets/activity_tile.dart';
import 'package:hitchride/src/features/account/widgets/activity_tile_skeleton.dart';
import 'package:hitchride/src/features/ride/state/rides_provider.dart';
import 'package:hitchride/src/features/shared/widgets/tab_button.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ActivityHistoryScreen extends HookConsumerWidget {
  const ActivityHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Define a tab controller to switch between "Rides Offered" and "Rides Taken" tabs
    final tabController = useTabController(initialLength: 2);
    // Define a state variable to keep track of the current tab index
    final currentTabIndex = useState(0);

    // Update the currentTabIndex state variable when the tab controller index changes
    tabController.addListener(() {
      currentTabIndex.value = tabController.index;
    });

    // Define a function to build the "Rides Offered" tab content
    Widget buildRidesOffered() {
      // Get the user's recent drives from the rides provider
      final ridesOfferedAsyncValue = ref.watch(userRecentDrivesProvider);
      return RefreshIndicator(
        onRefresh: () async {
          return await ref.refresh(userRecentDrivesProvider);
        },
        child: ridesOfferedAsyncValue.when(
          // If the data is available, display the user's recent drives
          data: (ridesOffered) {
            if (ridesOffered.isEmpty) {
              return const Center(child: Text('No rides offered yet.'));
            }
            return ListView.builder(
              itemCount: ridesOffered.length,
              itemBuilder: (context, index) {
                final ride = ridesOffered[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ActivityTile(ride: ride, leaveReview: false),
                );
              },
            );
          },
          // If the data is still loading, display a skeleton loader
          loading: () => ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ActivityTileSkeletonLoader(),
              );
            },
          ),
          // If there is an error, display an error message
          error: (err, stack) => Center(child: Text(err.toString())),
        ),
      );
    }

    // Define a function to build the "Rides Taken" tab content
    Widget buildRidesTaken() {
      // Get the user's recent rides from the rides provider
      final ridesTakenAsyncValue = ref.watch(userRecentRidesProvider);
      return RefreshIndicator(
        onRefresh: () async {
          return await ref.refresh(userRecentRidesProvider);
        },
        child: ridesTakenAsyncValue.when(
          // If the data is available, display the user's recent rides
          data: (ridesTaken) {
            if (ridesTaken.isEmpty) {
              return const Center(child: Text('No rides taken yet.'));
            }
            return ListView.builder(
              itemCount: ridesTaken.length,
              itemBuilder: (context, index) {
                final ride = ridesTaken[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ActivityTile(ride: ride, leaveReview: true),
                );
              },
            );
          },
          // If the data is still loading, display a skeleton loader
          loading: () => ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ActivityTileSkeletonLoader(),
              );
            },
          ),
          // If there is an error, display an error message
          error: (err, stack) => Center(child: Text(err.toString())),
        ),
      );
    }

    // Build the ActivityHistoryScreen widget
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Activity History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Display the tab buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabButton(
                  text: 'Rides Offered',
                  isSelected: currentTabIndex.value == 0,
                  onTap: () => tabController.animateTo(0),
                ),
                const SizedBox(width: 16.0),
                TabButton(
                  text: 'Rides Taken',
                  isSelected: currentTabIndex.value == 1,
                  onTap: () => tabController.animateTo(1),
                ),
              ],
            ),
          ),
          // Display the tab content
          Expanded(
            child: TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                buildRidesOffered(),
                buildRidesTaken(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}